// ===================== 站崗嚇人・陽間街（參照「開個密室館」骨架，全部換成我哋自己嘅嘢）=====================
// 陽間街地圖 → 揀地盤 → 俯視場景：路人沿地磚路線行，鬼企喺崗位按自己嘅嚇法出手；膽量打清＝嚇走（跌冥幣），行到出口＝漏人。
// 傳說名氣：嚇走 +2、漏人 −18；≥24 難度 +1；≤−30 難度 −1（最多比歷史最高低 6 級）；過咗地盤上限要 ×7 名氣、超出部分收益 ×0.3。
// Bryan 一夥（天師、保安、探靈網紅）混喺路人度，會打崗位上嘅鬼，打爆就搶走崗位。
const Street = (() => {
  const has = (o) => typeof o !== 'undefined';
  const R = (a, b) => a + Math.random() * (b - a);
  const pick = (a) => a[Math.floor(Math.random() * a.length)];
  const T = (yue, zh) => { if (has(LANG)) LANG.add({ [yue]:zh }); return has(window.L) ? window.L(yue) : yue; };
  const W = { breath:'吹氣', light:'燈', cold:'凍', sound:'怪聲', paper:'紙', phone:'電話', face:'鬼臉', shadow:'黑影' };
  // 六類嚇法（對應原作六類裝置，但由鬼嘅怪談決定）
  const KIND = {
    sound:{ n:'觸發', zh:'觸發', r:0.18, cd:6, mul:1.1, aoe:true, ground:true },
    face:{ n:'突然出現', zh:'突然出現', r:0.22, cd:8, mul:1.9 },
    shadow:{ n:'突然出現', zh:'突然出現', r:0.22, cd:8, mul:1.9 },
    cold:{ n:'陰風', zh:'陰風', r:0.24, cd:1, mul:0.13, aura:true, high:true },
    breath:{ n:'陰風', zh:'陰風', r:0.24, cd:1, mul:0.13, aura:true, high:true },
    light:{ n:'鬼壓身・減速', zh:'鬼壓身・減速', r:0.22, cd:1, mul:0.07, aura:true, slow:0.45 },
    paper:{ n:'遠程', zh:'遠程', r:0.42, cd:2.5, mul:0.75, shot:true, high:true },
    phone:{ n:'鬼打牆', zh:'鬼打牆', r:0.17, cd:7, mul:0.4, block:2.2, ground:true },
  };
  const TUNE = { dmg:4.2, spd:[0.045, 0.058] };
  const HOT = { add:2, leak:-18, up:24, down:-30, downStart:18, minGap:6, overMul:7, comboStart:24, comboMax:5, overRwd:0.3 };
  // 難度 → 膽量倍數（1→1、10→2.55、24→11.6，之後照斜率繼續）
  function hpMul(lv) {
    const P = [[1, 1], [10, 2.55], [24, 11.6], [50, 198]];
    for (let i = 0; i < P.length - 1; i++) if (lv <= P[i + 1][0]) { const [a, va] = P[i], [b, vb] = P[i + 1]; return va * Math.pow(vb / va, (lv - a) / (b - a)); }
    return 198 * Math.pow(1.12, lv - 50);
  }
  const coinOf = (lv, cap) => Math.round(13 * Math.pow(1.035, (lv > cap ? cap + (lv - cap) * HOT.overRwd : lv) - 1));
  // ---------- 原作公式（代碼核實）----------
  const HPP = [0, 1, 1.096, 1.2, 1.315, 1.441, 1.579, 1.73, 2.128, 2.331, 2.554, 2.799, 3.067, 3.36, 3.681, 4.528, 4.961, 5.436, 5.956, 6.525, 7.149, 7.833, 9.635, 10.557, 11.567, 12.673, 13.885, 15.213, 16.669, 20.502, 22.464, 24.612, 26.967, 29.546, 32.373, 35.469, 43.627, 47.8, 52.373, 57.382];
  const COP = [0, 1, 1.035, 1.071, 1.109, 1.148, 1.188, 1.229, 1.272, 1.317, 1.363, 1.411, 1.46, 1.511, 1.564, 1.619, 1.675, 1.734, 1.795, 1.857, 1.923, 1.99, 2.059, 2.132, 2.206, 2.283, 2.363, 2.446, 2.532, 2.62, 2.712, 2.807, 2.905, 3.007, 3.112, 3.221, 3.334, 3.45, 3.571, 3.696];
  const hpP = (d) => d < HPP.length ? HPP[Math.max(1, d)] : HPP[HPP.length - 1] * Math.pow(1.096, d - HPP.length + 1);
  const coP = (d) => d < COP.length ? COP[Math.max(1, d)] : COP[COP.length - 1] * Math.pow(1.035, d - COP.length + 1);
  const PX = 1 / 1080, CELL = 150 * PX;
  const ROOM_MAXLV = [5, 14, 24];                                   // 收益封頂：最後解鎖嗰間房嘅 MAXLevel
  const UNLOCK = [null, { rep:30, bd:20, coin:1200 }, { rep:120, bd:40, coin:3000 }]; // 開下一間：惡名＋建設度＋冥幣（三重條件）
  // 六類裝置 × 1格／2格（數值 1:1 照原作 Trap / TrapLevel：價錢、耐久、驚嚇值、整備秒、重置秒、減速、LevelSituation）
  const DEV = {
    trap:{ kind:'sound', h:0, k:'xiaogui', n:{ 1:['小鬼伏地', '小鬼伏地'], 2:['鬼仔成群', '鬼仔成群'] }, desc:['踩中就觸發，範圍內每人嚇一次，嚇呆兩秒', '踩上去就觸發，範圍內每人嚇一次，嚇呆兩秒'],
      1:{ check:100, eff:225, dd:20, dl:75, lv:[[90, 120, 91, 7, 40], [90, 180, 115, 6.8, 40], [135, 270, 165, 6.6, 40], [170, 410, 225, 6.4, 40], [350, 620, 345, 6.2, 40]] },
      2:{ check:125, eff:300, dd:20, dl:100, lv:[[165, 300, 200, 8.5, 60], [165, 450, 255, 8.2, 60], [250, 680, 355, 7.9, 60], [310, 1000, 490, 7.6, 60], [650, 1500, 745, 7.3, 60]] } },
    puzzle:{ kind:'phone', h:0, k:'zhiren', n:{ 1:['紙人擋路', '紙人擋路'], 2:['紙紮迷宮', '紙紮迷宮'] }, desc:['未破解之前冇人行得過；人愈多破得愈快，破咗要等重置', '破解前誰都過不去；人越多破越快，破了要等重置'],
      1:{ check:75, eff:75, dd:0, dl:5, lv:[[95, 250, 4, 1.2, 15, 0, 1], [95, 350, 8, 1.2, 15, 0, 4], [150, 500, 12, 1.2, 15, 0, 8], [185, 700, 18, 1.2, 15, 0, 12], [380, 1100, 26, 1.2, 15, 0, 17]] },
      2:{ check:75, eff:150, dd:0, dl:5, lv:[[180, 400, 45, 5, 16.5, 0, 1], [180, 500, 60, 5, 16.5, 0, 4], [275, 750, 86, 5, 16.5, 0, 8], [340, 1100, 125, 5, 16.5, 0, 12], [710, 1700, 195, 5, 16.5, 0, 17]] } },
    scare:{ kind:'face', h:1, k:'pocong', n:{ 1:['殭屍彈出', '殭屍彈出'], 2:['棺材彈出', '棺材彈出'] }, desc:['遠遠見到人就撲出嚟，重擊一下，嚇呆兩秒', '遠遠看到人就撲出來，重擊一下，嚇呆兩秒'],
      1:{ check:250, eff:300, dd:10, dl:55, lv:[[110, 200, 160, 11, 40], [110, 300, 205, 10.6, 40], [170, 450, 285, 10.2, 40], [210, 680, 390, 9.8, 40], [440, 1020, 590, 9.4, 40]] },
      2:{ check:300, eff:350, dd:10, dl:79, lv:[[210, 500, 330, 12.5, 60], [210, 750, 420, 12, 60], [320, 1100, 580, 11.5, 60], [395, 1700, 795, 11, 60], [830, 2500, 1200, 10.5, 60]] } },
    aura:{ kind:'cold', h:1, k:'youhun', n:{ 1:['遊魂飄蕩', '遊魂飄蕩'], 2:['陰魂圍城', '陰魂圍城'] }, desc:['大範圍，每隔一陣嚇一下，唔會令人停低', '大範圍，每隔一陣嚇一下，不會讓人停下'],
      1:{ check:390, eff:390, dd:0, dl:1, lv:[[105, 150, 7, 0.8, 40], [105, 230, 9, 0.75, 40], [160, 350, 12, 0.7, 40], [195, 530, 16, 0.65, 40], [410, 800, 23, 0.6, 40]] },
      2:{ check:440, eff:440, dd:0, dl:1, lv:[[195, 350, 20, 1.3, 80], [195, 620, 25, 1.2, 80], [295, 1000, 33, 1.1, 80], [370, 1500, 43, 1, 80], [770, 2200, 60, 0.9, 80]] } },
    slow:{ kind:'light', h:0, k:'shuigui', n:{ 1:['水鬼拉腳', '水鬼拉腳'], 2:['水鬼成群', '水鬼成群'] }, desc:['地上隻手扯住人，範圍內行慢兩成幾，仲會慢慢嚇', '地上的手抓住人，範圍內走慢兩成多，還會慢慢嚇'],
      1:{ area:[1, 1, 2, 2, 3], lv:[[95, 350, 35, 5, 80, 0.2], [95, 620, 47, 5, 80, 0.208], [145, 1000, 67, 5, 80, 0.216], [180, 1500, 96, 5, 80, 0.224], [370, 2200, 155, 5, 80, 0.232]] },
      2:{ area:[1, 2, 2, 3, 3], lv:[[175, 350, 65, 5, 80, 0.25], [175, 620, 86, 5, 80, 0.259], [265, 1000, 125, 5, 80, 0.268], [330, 1500, 180, 5, 80, 0.278], [690, 2200, 285, 5, 80, 0.287]] } },
    throw:{ kind:'paper', h:1, k:'egui', n:{ 1:['餓鬼擲碗', '餓鬼擲碗'], 2:['餓鬼連環擲', '餓鬼連環擲'] }, desc:['全房範圍揀一個人，預判佢前面落點拋過去，落點細範圍嚇人', '全房範圍挑一個人，預判他前方落點拋過去，落點小範圍驚嚇'],
      1:{ check:2000, eff:135, dd:30, dl:1, lv:[[105, 350, 61, 2.2, 80], [105, 620, 78, 2.15, 80], [165, 1000, 110, 2.1, 80], [200, 1500, 155, 2.05, 80], [420, 2200, 240, 2, 80]] },
      2:{ check:2000, eff:135, dd:0, dl:1, lv:[[200, 350, 110, 2.2, 80], [200, 620, 140, 2.15, 80], [305, 1000, 200, 2.1, 80], [375, 1500, 275, 2.05, 80], [790, 2200, 425, 2, 80]] } },
  };
  const WALL_ROLES = ['scare', 'aura', 'throw'], ROAD_ROLES = ['trap', 'puzzle', 'slow'];
  const ROLE_OF = { sound:'trap', phone:'puzzle', face:'scare', shadow:'scare', cold:'aura', breath:'aura', light:'slow', paper:'throw' }; // 鬼嘅嚇法 → 可以做邊類裝置嘅員工
  // 精英路人（原作 4 款：減傷30%／閃避30%／光環 200px 令身邊人減傷15%／飛毛腿）——換成 Bryan 一夥同外賣仔
  const ELITE = [
    { id:'tianshi', spr:'npc_boss', n:'天師', zh:'天師', hp:115, atk:10, spd:100, award:45, buf:'tough', tag:'#e8a33a', rep:40, tip:['減傷三成', '減傷三成'] },
    { id:'wanghong', spr:'npc_it', n:'探靈網紅', zh:'探靈網紅', hp:80, atk:30, spd:75, award:30, buf:'dodge', tag:'#d64ab8', rep:40, tip:['三成機會閃避', '三成機會閃避'] },
    { id:'baoan', spr:'npc_ken', n:'保安', zh:'保安', hp:95, atk:20, spd:130, award:30, buf:'aura', tag:'#4a7bd6', rep:80, tip:['電筒照住身邊人，減傷一成半', '手電筒照著身邊人，減傷一成半'] },
    { id:'waimai', spr:'npc_mis', n:'外賣仔', zh:'外賣小哥', hp:70, atk:40, spd:200, award:60, buf:'tough', tag:'#5fd38f', rep:80, tip:['跑得飛快，減傷三成', '跑得飛快，減傷三成'] },
  ];
  // 有名鬼（原作 BOSS）：每隻唯一、唔佔格、自動喺第一間房出現，沿成條路線來回巡邏；CD 15 秒，附近有人就停低放招 8 秒，每人每次只中一下
  const BSK = {
    tianhua:{ n:['垂髮纏人', '垂髮纏人'], r:150, last:8, dmg:1, fright:3 },
    pontianak:{ n:['尖笑震波', '尖笑震波'], r:220, last:8, dmg:0.9, push:1 },
    eguiking:{ n:['張口一咬', '張口一咬'], r:150, last:8, dmg:2.5, single:1 },
    egui:{ n:['張口一咬', '張口一咬'], r:150, last:8, dmg:2.5, single:1 },
    laojiang:{ n:['跳屍衝撞', '跳屍衝撞'], r:150, last:3, dmg:1.4, dash:1 },
    toyol:{ n:['偷錢', '偷錢'], r:150, last:8, dmg:0.4, coin:5 },
    xiaozhi:{ n:['紙人圍堵', '紙人圍堵'], r:180, last:8, dmg:0.6, block:2 },
    penanggal:{ n:['飛頭俯衝', '飛頭俯衝'], r:200, last:6, dmg:1.2, single:1 },
    _:{ n:['陰氣爆發', '陰氣爆發'], r:150, last:8, dmg:1 },
  };
  const bsk = (k) => BSK[k] || BSK._;
  const BOSS_CD = 15, BOSS_DMG = 362, BOSS_MAX = 3;

  // ---------- 地盤 ----------
  const LOBBY_PATH = [[0.25, 1.02], [0.25, 0.82], [0.20, 0.72], [0.20, 0.60], [0.30, 0.53], [0.37, 0.45], [0.37, 0.32], [0.45, 0.27], [0.80, 0.27], [1.03, 0.21]];
  const LOBBY_POSTS = [
    { x:0.37, y:0.115, h:1, n:'左邊𨋢門' }, { x:0.65, y:0.115, h:1, n:'右邊𨋢門' }, { x:0.08, y:0.37, h:1, n:'信箱牆' },
    { x:0.64, y:0.385, h:0, n:'單車柱' }, { x:0.86, y:0.53, h:1, n:'晾衫架' }, { x:0.55, y:0.62, h:0, n:'中間柱' },
    { x:0.80, y:0.82, h:0, n:'樓梯口' }, { x:0.08, y:0.585, h:0, n:'盆栽後' },
  ];
  const BUS_PATH = [[0.17, 1.02], [0.17, 0.86], [0.30, 0.73], [0.60, 0.66], [0.68, 0.55], [0.62, 0.48], [0.58, 0.41], [0.56, 0.30], [0.60, 0.25], [1.03, 0.24]];
  const BUS_POSTS = [
    { x:0.28, y:0.44, h:1, n:'候車亭頂' }, { x:0.33, y:0.60, h:0, n:'亭內長凳' }, { x:0.71, y:0.40, h:1, n:'街燈' }, { x:0.12, y:0.37, h:0, n:'垃圾桶' },
    { x:0.18, y:0.14, h:1, n:'蕉樹' }, { x:0.74, y:0.12, h:0, n:'電話亭' }, { x:0.40, y:0.33, h:0, n:'坑渠橋' }, { x:0.58, y:0.78, h:0, n:'坑渠蓋' },
  ];
  const LAYOUT = { lobby:{ bg:'st_flat_lobby', path:LOBBY_PATH, posts:LOBBY_POSTS }, bus:{ bg:'st_busstop', path:BUS_PATH, posts:BUS_POSTS } };
  const P_ = (n, x, y, h) => ({ n, x, y, h });
  LAYOUT.cafe = { bg:'st_kopitiam', path:[[0.18, 1.02], [0.18, 0.80], [0.20, 0.62], [0.32, 0.58], [0.45, 0.55], [0.48, 0.47], [0.62, 0.43], [0.80, 0.40], [0.82, 0.28], [0.86, 0.19], [1.03, 0.15]],
    posts:[P_('貨架', 0.12, 0.29, 1), P_('吊扇', 0.50, 0.15, 1), P_('紅燈籠', 0.07, 0.42, 1), P_('後門', 0.94, 0.30, 1), P_('圓枱', 0.30, 0.44, 0), P_('圓枱', 0.64, 0.34, 0), P_('圓枱', 0.80, 0.55, 0), P_('圓枱', 0.44, 0.74, 0)] };
  LAYOUT.market = { bg:'st_market', path:[[0.22, 1.02], [0.22, 0.76], [0.30, 0.62], [0.44, 0.52], [0.55, 0.43], [0.70, 0.35], [0.80, 0.26], [0.92, 0.22], [1.03, 0.22]],
    posts:[P_('糖水檔', 0.12, 0.30, 1), P_('大傘', 0.42, 0.30, 1), P_('串燒檔', 0.80, 0.64, 1), P_('果檔', 0.55, 0.12, 1), P_('炒粉檔', 0.75, 0.48, 0), P_('雜貨檔', 0.52, 0.64, 0), P_('鹹煎餅檔', 0.12, 0.58, 0), P_('膠凳', 0.66, 0.86, 0)] };
  LAYOUT.office = { bg:'st_office23', path:[[0.20, 1.02], [0.22, 0.90], [0.30, 0.76], [0.52, 0.69], [0.58, 0.56], [0.63, 0.46], [0.76, 0.41], [0.90, 0.35], [1.03, 0.33]],
    posts:[P_('天花燈', 0.66, 0.10, 1), P_('影印機', 0.58, 0.30, 1), P_('窗邊', 0.10, 0.48, 1), P_('茶水櫃', 0.92, 0.62, 1), P_('工位', 0.30, 0.40, 0), P_('工位', 0.75, 0.56, 0), P_('工位', 0.78, 0.76, 0), P_('工位', 0.30, 0.62, 0)] };
  const layGet = (k) => OG[k] ? gridLay(k) : LAYOUT[k];
  const layOf = (def, room) => layGet((def.rooms && def.rooms[room || 0] ? def.rooms[room || 0].lay : def.lay) || 'lobby');
  // ---------- 照搬《開個密室館》醫院1／醫院2：6×10 格（150px）、格子類型 1牆 2牆裝置 3路 4路裝置 ----------
  const OG = {
    g1:{ bg:'st_flat_lobby', data:'111111111211113343114111213111143121331111333111143111131111', start:[1, 9, 0, 1], exit:[5, 2, 1, 0], max:3 },
    g2:{ bg:'st_flat_corr', data:'111111112111133333131111131121133433111113112113133433111111', start:[1, 8, -1, 0], exit:[5, 2, 1, 0], max:5 },
  };
  // 四種裝置（原作 TrapLevel 1～5 級：價錢、血量／謎題難度、驚嚇值、整備、刷新）
  const LV = {"501": [[95, 350, 35, 5.0, 80.0, 0.2], [95, 620, 47, 5.0, 80.0, 0.208], [145, 1000, 67, 5.0, 80.0, 0.216], [180, 1500, 96, 5.0, 80.0, 0.224], [370, 2200, 155, 5.0, 80.0, 0.232]], "601": [[105, 350, 61, 2.2, 80.0], [105, 620, 78, 2.15, 80.0], [165, 1000, 110, 2.1, 80.0], [200, 1500, 155, 2.05, 80.0], [420, 2200, 240, 2.0, 80.0]], "101": [[90, 120, 91, 7.0, 40.0], [90, 180, 115, 6.8, 40.0], [135, 270, 165, 6.6, 40.0], [170, 410, 225, 6.4, 40.0], [350, 620, 345, 6.2, 40.0]], "201": [[95, 250, 4, 1.2, 15.0], [95, 350, 8, 1.2, 15.0], [150, 500, 12, 1.2, 15.0], [185, 700, 18, 1.2, 15.0], [380, 1100, 26, 1.2, 15.0]], "301": [[110, 200, 160, 11.0, 40.0], [110, 300, 205, 10.6, 40.0], [170, 450, 285, 10.2, 40.0], [210, 680, 390, 9.8, 40.0], [440, 1020, 590, 9.4, 40.0]], "401": [[105, 150, 7, 0.8, 40.0], [105, 230, 9, 0.75, 40.0], [160, 350, 12, 0.7, 40.0], [195, 530, 16, 0.65, 40.0], [410, 800, 23, 0.6, 40.0]]};
  const ROLE = {
    trap:{ lv:'101', n:'陷阱・觸發', zh:'陷阱・觸發', kind:'sound', check:100, eff:225, ico:'陷阱', desc:['踩中就觸發，範圍內全部人嚇一次', '踩上去就觸發，範圍內所有人嚇一次'] },
    puzzle:{ lv:'201', n:'解謎・鬼打牆', zh:'解謎・鬼打牆', kind:'phone', check:75, eff:75, puzzle:true, ico:'解謎', desc:['未破解之前冇人行得過，人愈多破得愈快', '破解前誰都過不去，人越多破越快'] },
    scare:{ lv:'301', n:'驚嚇・突然出現', zh:'驚嚇・突然出現', kind:'face', check:250, eff:300, ico:'驚嚇', desc:['入咗範圍就重度驚嚇一次', '進入範圍就重度驚嚇一次'] },
    slow:{ lv:'501', n:'減速・水鬼拉腳', zh:'減速・水鬼拉腳', kind:'light', check:0, eff:110, slowK:true, ico:'減速', desc:['地上嘅手扯住人，行慢兩成', '地上的手抓住人，走慢兩成'] },
    throw:{ lv:'601', n:'投擲・餓鬼擲碗', zh:'投擲・餓鬼擲碗', kind:'paper', check:2000, eff:135, shot:true, ico:'投擲', desc:['遠距離拋嘢，落點細範圍嚇人', '遠距離拋東西，落點小範圍驚嚇'] },
    aura:{ lv:'401', n:'氛圍・陰風', zh:'氛圍・陰風', kind:'cold', check:390, eff:390, aura:true, ico:'氛圍', desc:['大範圍持續少量驚嚇', '大範圍持續少量驚嚇'] },
  };
  function gridLay(key) {
    const G = OG[key]; if (G.lay) return G.lay;
    const cw = 1 / 6, ch = 0.1, x0 = 0, y0 = 0, at = (cx, cy) => [x0 + (cx + 0.5) * cw, y0 + (cy + 0.5) * ch];
    const ty = (cx, cy) => (cx < 0 || cy < 0 || cx > 5 || cy > 9) ? 0 : +G.data[cy * 6 + cx];
    const walk = (cx, cy) => [3, 4].includes(ty(cx, cy));
    // BFS 由入口格去出口格
    const [sx, sy] = G.start, [ex, ey] = G.exit, prev = {}, q = [[sx, sy]], k = (x, y) => x + ',' + y; prev[k(sx, sy)] = null;
    while (q.length) { const [x, y] = q.shift(); if (x === ex && y === ey) break; for (const [dx, dy] of [[0, -1], [1, 0], [0, 1], [-1, 0]]) { const nx = x + dx, ny = y + dy; if (walk(nx, ny) && !(k(nx, ny) in prev)) { prev[k(nx, ny)] = [x, y]; q.push([nx, ny]); } } }
    const cells = []; let c = [ex, ey]; while (c) { cells.unshift(c); c = prev[k(c[0], c[1])]; }
    const path = cells.map(([x, y]) => at(x, y)); const s0 = at(sx + G.start[2] * 0.9, sy + G.start[3] * 0.9), e0 = at(ex + G.exit[2] * 0.9, ey + G.exit[3] * 0.9);
    path.unshift(s0); path.push(e0);
    const posts = []; let ni = 0; for (let y = 0; y < 10; y++) for (let x = 0; x < 6; x++) { const t = ty(x, y); if (t === 2 || t === 4) { const [px, py] = at(x, y); posts.push({ x:px, y:py, h:t === 2 ? 1 : 0, n:(t === 2 ? '牆位' : '路位') + (++ni), cell:[x, y] }); } }
    G.lay = { bg:G.bg, path, posts, grid:{ cw, ch, x0, y0, ty }, max:G.max }; return G.lay;
  }

  // ---------- 連續長地圖（照原作代碼：房間橫向拼接、路點直線連線、NextSet 等概率分叉、格子只定建造槽）----------
  // 座標：房寬 = 1（原作 1080px），y 用房高比例；距離計法 dist() 已將 y×1.5，所以 1 單位 = 1080px。
  const GAP = 0.22; // 兩間房之間嘅樓梯間（客人喺度由上一間出口轉去下一間入口）
  const ROOMG = {"lobby":{"bg":"st_flat_lobby","n":["大堂","大堂"],"nodes":{"E":[0.21,1.0],"a":[0.21,0.87],"b1":[0.16,0.74],"b2":[0.16,0.6],"c1":[0.37,0.82],"c2":[0.345,0.66],"d":[0.29,0.53],"e1":[0.36,0.42],"f1":[0.36,0.28],"e2":[0.55,0.47],"f2":[0.57,0.35],"g1":[0.56,0.255],"g2":[0.66,0.3],"k1":[0.8,0.245],"k2":[0.84,0.3],"X":[1.0,0.22]},"edges":{"E":["a"],"a":["b1","c1"],"b1":["b2"],"c1":["c2"],"b2":["d"],"c2":["d"],"d":["e1","e1","e2"],"e1":["f1"],"e2":["f2"],"f1":["g1"],"f2":["g1","g2"],"g1":["k1","k2"],"g2":["k2"],"k1":["X"],"k2":["X"]},"posts":[{"x":0.09,"y":0.4,"h":1,"s":1,"n":"信箱牆"},{"x":0.43,"y":0.15,"h":1,"s":1,"n":"左𨋢門"},{"x":0.84,"y":0.56,"h":1,"s":1,"n":"晾衫架"},{"x":0.075,"y":0.86,"h":0,"s":1,"n":"入口窄位"},{"x":0.255,"y":0.7,"h":0,"s":1,"n":"兩條路中間"},{"x":0.455,"y":0.38,"h":0,"s":1,"n":"兩行中間"},{"x":0.88,"y":0.4,"h":0,"s":1,"n":"單車旁"}]},"corr":{"bg":"st_flat_corr","n":["走廊","走廊"],"nodes":{"E":[0.0,0.83],"s":[0.13,0.82],"b1":[0.36,0.815],"c1":[0.66,0.815],"k1":[0.83,0.8],"up":[0.835,0.68],"k2":[0.8,0.56],"m1":[0.6,0.54],"m2":[0.6,0.58],"n1":[0.34,0.54],"n2":[0.34,0.58],"k3":[0.205,0.555],"v":[0.205,0.4],"k4":[0.215,0.265],"t1":[0.42,0.24],"t2":[0.42,0.285],"u1":[0.7,0.24],"u2":[0.7,0.285],"v3":[0.77,0.235],"X":[1.0,0.235]},"edges":{"E":["s"],"s":["b1"],"b1":["c1"],"c1":["k1"],"k1":["up"],"up":["k2"],"k2":["m1","m2"],"m1":["n1","n2"],"m2":["n2","n1"],"n1":["k3"],"n2":["k3"],"k3":["v"],"v":["k4"],"k4":["t1","t2"],"t1":["u1","u2"],"t2":["u2","u1"],"u1":["v3"],"u2":["v3"],"v3":["X"]},"posts":[{"x":0.43,"y":0.12,"h":1,"s":2,"n":"頂層兩家鐵閘"},{"x":0.48,"y":0.42,"h":1,"s":2,"n":"中層兩家鐵閘"},{"x":0.28,"y":0.885,"h":0,"s":1,"n":"樓梯口"},{"x":0.535,"y":0.885,"h":0,"s":2,"n":"晾衫架下"},{"x":0.865,"y":0.295,"h":0,"s":1,"n":"出口轉角"}]},"cafe":{"bg":"st_kopitiam","n":["地下茶餐室","樓下茶餐室"],"nodes":{"E":[0.215,1.0],"a":[0.215,0.86],"b1":[0.19,0.7],"b2":[0.255,0.67],"c":[0.255,0.585],"d1":[0.46,0.565],"e1":[0.495,0.46],"f1":[0.7,0.43],"g":[0.86,0.37],"j":[0.725,0.3],"X":[1.0,0.3]},"edges":{"E":["a"],"a":["b1","b2"],"b1":["c"],"b2":["c"],"c":["d1"],"d1":["e1"],"e1":["f1"],"f1":["g","j"],"g":["X"],"j":["X"]},"posts":[{"x":0.2,"y":0.2,"h":1,"s":1,"n":"茶葉架"},{"x":0.06,"y":0.11,"h":1,"s":1,"n":"紅燈籠"},{"x":0.43,"y":0.12,"h":1,"s":2,"n":"吊扇"},{"x":0.33,"y":0.85,"h":1,"s":1,"n":"鐵閘"},{"x":0.175,"y":0.48,"h":0,"s":2,"d":1,"n":"窗邊走廊"},{"x":0.6,"y":0.225,"h":0,"s":1,"n":"廚房門口"}]},"market":{"bg":"st_market","n":["夜市","夜市"],"nodes":{"E":[0.17,1.0],"a":[0.17,0.88],"b1":[0.17,0.72],"b2":[0.31,0.72],"c":[0.3,0.61],"d1":[0.42,0.52],"e1":[0.55,0.44],"e2":[0.66,0.475],"f1":[0.645,0.33],"f2":[0.705,0.4],"g":[0.82,0.29],"X":[1.0,0.275]},"edges":{"E":["a"],"a":["b1"],"b1":["c","b2"],"b2":["c"],"c":["d1"],"d1":["e1","e2"],"e1":["f1"],"e2":["f2"],"f1":["g"],"f2":["g"],"g":["X"]},"posts":[{"x":0.5,"y":0.17,"h":1,"s":1,"n":"榴槤檔"},{"x":0.19,"y":0.36,"h":1,"s":1,"n":"串燒檔"},{"x":0.86,"y":0.48,"h":1,"s":1,"n":"炒粉檔"},{"x":0.075,"y":0.8,"h":0,"s":1,"n":"街燈下"},{"x":0.3,"y":0.48,"h":0,"s":1,"n":"冰櫃旁"},{"x":0.5,"y":0.265,"h":0,"s":2,"n":"大傘下"}]},"office":{"bg":"st_office23","n":["二十三樓寫字樓","二十三樓辦公室"],"nodes":{"E":[0.15,0.97],"a":[0.15,0.82],"b1":[0.25,0.72],"b2":[0.3,0.78],"c":[0.36,0.66],"d1":[0.45,0.56],"e1":[0.53,0.47],"f1":[0.535,0.37],"e2":[0.585,0.55],"f2":[0.585,0.42],"g1":[0.7,0.375],"h":[0.88,0.385],"X":[1.0,0.34]},"edges":{"E":["a"],"a":["b1","b2"],"b1":["c"],"b2":["c"],"c":["d1"],"d1":["e1","e2"],"e1":["f1"],"e2":["f2"],"f1":["g1"],"f2":["g1"],"g1":["h"],"h":["X"]},"posts":[{"x":0.32,"y":0.17,"h":1,"s":1,"n":"雪櫃"},{"x":0.71,"y":0.3,"h":1,"s":1,"n":"影印機"},{"x":0.07,"y":0.58,"h":1,"s":1,"n":"水機"},{"x":0.12,"y":0.7,"h":0,"s":1,"n":"窗邊"},{"x":0.45,"y":0.79,"h":0,"s":1,"n":"影印房外"},{"x":0.92,"y":0.48,"h":0,"s":1,"n":"後樓梯口"}]},"bus":{"bg":"st_busstop","n":["尾班車站","末班車站"],"nodes":{"E":[0.135,1.0],"a":[0.135,0.9],"b1":[0.2,0.8],"b2":[0.3,0.86],"c1":[0.33,0.735],"c2":[0.45,0.79],"d":[0.6,0.7],"e1":[0.66,0.58],"e3":[0.72,0.6],"e4":[0.7,0.48],"f":[0.58,0.45],"s":[0.555,0.33],"t1":[0.62,0.245],"u1":[0.8,0.23],"u2":[0.8,0.27],"X":[1.0,0.245]},"edges":{"E":["a"],"a":["b1","b2"],"b1":["c1"],"b2":["c2"],"c1":["d"],"c2":["d"],"d":["e1","e3"],"e1":["f"],"e3":["e4"],"e4":["f"],"f":["s"],"s":["t1"],"t1":["u1","u2"],"u1":["X"],"u2":["X"]},"posts":[{"x":0.28,"y":0.47,"h":1,"s":1,"n":"候車亭頂"},{"x":0.73,"y":0.13,"h":1,"s":1,"n":"電話亭"},{"x":0.12,"y":0.35,"h":1,"s":1,"n":"垃圾桶"},{"x":0.47,"y":0.88,"h":0,"s":1,"n":"坑渠蓋"},{"x":0.75,"y":0.4,"h":0,"s":1,"n":"街燈後"},{"x":0.46,"y":0.25,"h":0,"s":1,"n":"樓梯口"}]},"kitchen":{"bg":"st_kitchen2","n":["茶餐室後廚","茶餐廳後廚"],"nodes":{"E":[0.0,0.5],"a":[0.12,0.5],"t1":[0.25,0.41],"t2":[0.55,0.41],"t3":[0.8,0.42],"b0":[0.145,0.58],"b1":[0.35,0.645],"b2":[0.65,0.645],"b3":[0.86,0.6],"r":[0.9,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["t1","b0"],"t1":["t2"],"t2":["t3"],"t3":["r"],"b0":["b1"],"b1":["b2"],"b2":["b3"],"b3":["r"],"r":["X"]},"posts":[{"x":0.2,"y":0.18,"h":1,"s":2,"n":"掛鉤砧板"},{"x":0.7,"y":0.78,"h":1,"s":2,"n":"碗碟枱"},{"x":0.72,"y":0.31,"h":0,"s":2,"n":"後門前"},{"x":0.47,"y":0.76,"h":0,"s":2,"d":1,"n":"坑渠口"},{"x":0.06,"y":0.4,"h":0,"s":1,"n":"入口側"}]},"archive":{"bg":"st_office2","n":["檔案室","檔案室"],"nodes":{"E":[0.0,0.5],"a":[0.12,0.5],"m1":[0.3,0.5],"m2":[0.7,0.5],"u1":[0.21,0.36],"u2":[0.24,0.21],"u3":[0.5,0.205],"u4":[0.76,0.21],"u5":[0.79,0.36],"d1":[0.21,0.64],"d2":[0.24,0.8],"d3":[0.5,0.82],"d4":[0.76,0.8],"d5":[0.79,0.64],"r":[0.88,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["m1","u1","d1"],"m1":["m2"],"m2":["r"],"u1":["u2"],"u2":["u3"],"u3":["u4"],"u4":["u5"],"u5":["r"],"d1":["d2"],"d2":["d3"],"d3":["d4"],"d4":["d5"],"d5":["r"],"r":["X"]},"posts":[{"x":0.2,"y":0.11,"h":1,"s":2,"n":"機櫃"},{"x":0.72,"y":0.1,"h":1,"s":2,"n":"主管房玻璃"},{"x":0.08,"y":0.72,"h":0,"s":2,"d":1,"n":"爛椅角"},{"x":0.88,"y":0.75,"h":0,"s":2,"d":1,"n":"文件櫃側"},{"x":0.9,"y":0.32,"h":0,"s":1,"n":"碎紙機旁"}]},"tunnel":{"bg":"st_bus2","n":["行人隧道","行人隧道"],"nodes":{"E":[0.0,0.5],"a":[0.2,0.5],"u1":[0.33,0.4],"u2":[0.55,0.36],"u3":[0.82,0.37],"d1":[0.42,0.62],"d2":[0.62,0.64],"d3":[0.72,0.51],"m":[0.86,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.2,"y":0.25,"h":1,"s":2,"n":"露宿紙皮"},{"x":0.2,"y":0.75,"h":1,"s":2,"n":"汽水機"},{"x":0.6,"y":0.73,"h":0,"s":2,"n":"積水"},{"x":0.55,"y":0.27,"h":0,"s":2,"n":"樓梯腳"},{"x":0.93,"y":0.59,"h":0,"s":1,"n":"出口側"}]},"cold":{"bg":"st_kitchen3","n":["凍房後巷","冷凍庫後巷"],"nodes":{"E":[0.0,0.5],"a":[0.2,0.5],"u1":[0.32,0.415],"u2":[0.55,0.4],"u3":[0.72,0.43],"d1":[0.32,0.6],"d2":[0.55,0.62],"d3":[0.72,0.58],"m":[0.8,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.45,"y":0.18,"h":1,"s":2,"n":"凍房大門"},{"x":0.78,"y":0.2,"h":1,"s":1,"n":"膠簾"},{"x":0.2,"y":0.8,"h":1,"s":2,"n":"米包堆"},{"x":0.14,"y":0.42,"h":0,"s":1,"n":"貨架前"},{"x":0.55,"y":0.7,"h":0,"s":2,"n":"石油氣罐前"},{"x":0.9,"y":0.6,"h":0,"s":1,"n":"手推車旁"}]},"meeting":{"bg":"st_office3","n":["會議室","會議室"],"nodes":{"E":[0.0,0.5],"a":[0.18,0.5],"u1":[0.22,0.36],"u2":[0.5,0.28],"u3":[0.78,0.36],"d1":[0.22,0.64],"d2":[0.5,0.72],"d3":[0.78,0.64],"m":[0.82,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.5,"y":0.13,"h":1,"s":2,"n":"白板"},{"x":0.9,"y":0.15,"h":1,"s":1,"n":"文件櫃"},{"x":0.7,"y":0.79,"h":1,"s":2,"n":"茶水櫃"},{"x":0.1,"y":0.38,"h":0,"s":1,"n":"盆栽旁"},{"x":0.1,"y":0.64,"h":0,"s":1,"n":"影印機前"},{"x":0.92,"y":0.62,"h":0,"s":2,"d":1,"n":"雪櫃側"}]},"depot":{"bg":"st_bus3","n":["廢巴士廠","廢巴士廠"],"nodes":{"E":[0.0,0.5],"a":[0.12,0.5],"u1":[0.15,0.36],"u2":[0.4,0.26],"u3":[0.85,0.3],"d1":[0.15,0.64],"d2":[0.4,0.71],"d3":[0.75,0.69],"d4":[0.86,0.62],"m":[0.88,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["d4"],"d4":["m"],"m":["X"]},"posts":[{"x":0.2,"y":0.14,"h":1,"s":2,"n":"看更亭"},{"x":0.78,"y":0.13,"h":1,"s":2,"n":"告示板"},{"x":0.2,"y":0.8,"h":1,"s":2,"n":"候車棚"},{"x":0.06,"y":0.36,"h":0,"s":1,"n":"廠門側"},{"x":0.85,"y":0.78,"h":0,"s":2,"n":"積水地"},{"x":0.4,"y":0.2,"h":0,"s":1,"n":"巴士頭前"}]},"alley":{"bg":"st_market2","n":["收檔後巷","收攤後巷"],"nodes":{"E":[0.0,0.5],"a":[0.15,0.5],"u1":[0.25,0.38],"u2":[0.5,0.33],"u3":[0.75,0.38],"d1":[0.25,0.61],"d2":[0.5,0.66],"d3":[0.75,0.61],"m":[0.85,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.45,"y":0.18,"h":1,"s":2,"n":"發電機"},{"x":0.82,"y":0.18,"h":1,"s":1,"n":"燒烤爐"},{"x":0.7,"y":0.82,"h":1,"s":2,"n":"收咗嘅檔"},{"x":0.08,"y":0.38,"h":0,"s":1,"n":"積水"},{"x":0.4,"y":0.72,"h":0,"s":2,"n":"坑渠旁"},{"x":0.92,"y":0.36,"h":0,"s":1,"n":"後巷口"}]},"carpark":{"bg":"st_market3","n":["濕巴剎停車場","濕市場停車場"],"nodes":{"E":[0.0,0.5],"a":[0.14,0.5],"u1":[0.23,0.4],"u2":[0.45,0.33],"u3":[0.72,0.36],"d1":[0.23,0.6],"d2":[0.45,0.665],"d3":[0.7,0.62],"m":[0.82,0.5],"X":[1.0,0.5]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.45,"y":0.12,"h":1,"s":2,"n":"鐵閘"},{"x":0.91,"y":0.17,"h":1,"s":1,"n":"街燈"},{"x":0.2,"y":0.74,"h":1,"s":2,"n":"爛帳篷"},{"x":0.6,"y":0.25,"h":0,"s":1,"n":"魚箱前"},{"x":0.85,"y":0.7,"h":0,"s":2,"n":"車位"},{"x":0.93,"y":0.4,"h":0,"s":1,"n":"出口側"}]},"void":{"bg":"st_flat3","n":["地下空地","一樓架空層"],"nodes":{"E":[0.0,0.48],"a":[0.18,0.5],"u1":[0.32,0.36],"u2":[0.5,0.31],"u3":[0.72,0.36],"d1":[0.3,0.57],"d2":[0.5,0.66],"d3":[0.68,0.58],"m":[0.82,0.48],"X":[1.0,0.48]},"edges":{"E":["a"],"a":["u1","d1"],"u1":["u2"],"u2":["u3"],"u3":["m"],"d1":["d2"],"d2":["d3"],"d3":["m"],"m":["X"]},"posts":[{"x":0.2,"y":0.2,"h":1,"s":2,"n":"垃圾槽房"},{"x":0.48,"y":0.2,"h":1,"s":2,"n":"信箱"},{"x":0.92,"y":0.27,"h":1,"s":1,"n":"盆栽"},{"x":0.17,"y":0.76,"h":1,"s":2,"n":"晾衫架"},{"x":0.1,"y":0.36,"h":0,"s":1,"n":"積水"},{"x":0.5,"y":0.75,"h":0,"s":2,"n":"石枱後"},{"x":0.9,"y":0.58,"h":0,"s":1,"n":"單車旁"}]}};
  function longLay(rooms, unlocked, rn) {
    const posts = [], nodes = {}, edges = {}, hide = new Set(), rx = (r) => r * (1 + GAP); let tm = 0;
    rooms.forEach((rk, r) => { const R0 = ROOMG[rk]; tm += R0.posts.length; if (r >= unlocked) return;
      for (const k in R0.nodes) nodes[r + k] = [R0.nodes[k][0] + rx(r), R0.nodes[k][1]];
      for (const k in R0.edges) edges[r + k] = R0.edges[k].map(t => r + t);
      R0.posts.forEach(pp => posts.push(Object.assign({ s:1, d:0 }, pp, { x:pp.x + rx(r), room:r })));
      if (r > 0) { const ax = nodes[(r - 1) + 'X']; nodes[r + '~in'] = [rx(r) - GAP * 0.5, ax[1]]; edges[(r - 1) + 'X'] = [r + '~in']; edges[r + '~in'] = [r + 'E']; hide.add(r + '~in>' + r + 'E'); }
    });
    const last = (Math.min(unlocked, rooms.length) - 1) + 'X'; nodes.OUT = [nodes[last][0] + 0.04, nodes[last][1]]; edges[last] = ['OUT'];
    const preds = {}; for (const a in edges) for (const b of edges[a]) (preds[b] = preds[b] || []).push(a);
    const nv = Math.min(rooms.length, unlocked + 1), names = rooms.map((rk, r) => (rn && rn[r]) || ROOMG[rk].n);
    return { long:true, rooms, unlocked, posts, nodes, edges, preds, hide, start:'0E', last, worldW:nv + (nv - 1) * GAP, nv, rx, tm, names };
  }
  // NextSet 等概率隨機（同一點寫兩次 = 加權），唔睇擠唔擠
  function route(L) { const pts = []; let k = L.start, prev = null, g = 0; while (k && g++ < 160) { pts.push({ p:L.nodes[k], k, hide:!!prev && L.hide.has(prev + '>' + k) }); const nx = L.edges[k]; if (!nx || !nx.length) break; prev = k; k = pick(nx); } return pts; }
  const PEOPLE = [
    { spr:'npc_ken', n:'夜歸上班族', zh:'夜歸上班族', weak:['phone', 'face', 'shadow'], imm:['light', 'cold'], hp:80 },
    { spr:'npc_auntie', n:'倒垃圾阿姨', zh:'倒垃圾阿姨', weak:['face', 'shadow', 'breath'], imm:['sound', 'cold'], hp:95 },
    { spr:'npc_it', n:'打機學生哥', zh:'打電動的大學生', weak:['sound', 'shadow', 'cold'], imm:['phone', 'light'], hp:100 },
    { spr:'npc_mis', n:'送外賣阿哥', zh:'送外賣的小哥', weak:['cold', 'paper', 'breath'], imm:['face', 'sound'], hp:80 },
    { spr:'npc_boss', n:'唔信邪嘅阿伯', zh:'不信邪的阿伯', weak:['paper', 'breath', 'light'], imm:['shadow', 'face'], hp:115 },
  ];
  const CREW = [
    { spr:'npc_boss', n:'天師', zh:'天師', hp:2.6, atk:6, tag:'#e8a33a' },
    { spr:'npc_ken', n:'保安', zh:'保安', hp:2, atk:4.5, tag:'#4a7bd6' },
    { spr:'npc_it', n:'探靈網紅', zh:'探靈網紅', hp:1.5, atk:3, tag:'#d64ab8' },
  ];
  const SITES = [
    { id:'office', n:'舊公司二十三樓', zh:'舊公司二十三樓', x:0.57, y:0.19, cap:24, hue:0, real:true, long:['office', 'archive', 'meeting'] },
    { id:'cafe', n:'老店屋茶室', zh:'老店屋茶餐室', x:0.27, y:0.45, cap:24, hue:0, real:true, long:['cafe', 'kitchen', 'cold'], rn:{ 0:['老店屋茶室', '老店屋茶餐室'] } },
    { id:'bus', n:'尾班車站', zh:'末班車站', x:0.80, y:0.51, cap:24, hue:0, real:true, long:['bus', 'tunnel', 'depot'] },
    { id:'market', n:'夜市', zh:'夜市', x:0.58, y:0.62, cap:24, hue:0, real:true, long:['market', 'alley', 'carpark'] },
    { id:'flat', n:'組屋', zh:'組屋', x:0.27, y:0.86, cap:24, hue:0, real:true, long:['lobby', 'corr', 'void'] },
  ];
  const RESERVED = [[0.17, 0.20], [0.82, 0.30], [0.16, 0.63], [0.83, 0.75]];
  const GATE = [0.48, 0.955];

  function st() { if (!S.stnPosts) { S.stnPosts = (S.street && S.street.sites) ? { sites:S.street.sites, last:S.street.last || Date.now(), rate:S.street.rate || 0 } : { sites:{}, last:Date.now(), rate:0 }; } return S.stnPosts; } // S.street 係 ghoststreet 用緊，唔好撞
  function site(id, room) {
    const key = room ? id + '#' + room : id, s = st(); if (!s.sites[key]) s.sites[key] = { lv:1, maxLv:1, hot:0, combo:0, scared:0, leaked:0, coins:0, posts:[], unlocked:1, lost:0, bosses:[], modCur:0.9 };
    return s.sites[key];
  }
  function siteOld(id) { const s = st();
    return s.sites[id];
  }
  const CHAR_H_OK = (k) => { try { return !!(ART.hasRig && ART.hasRig(k)) || (has(Puppet) && Puppet.has(k)); } catch (e) { return false; } };
  const DEVK = { trap:'xiaogui', puzzle:'zhiren', slow:'shuigui', scare:'pocong', aura:'youhun', throw:'egui' };
  const DEVN = { trap:['小鬼伏地', '小鬼伏地'], puzzle:['紙人擋路', '紙人擋路'], slow:['水鬼拉腳', '水鬼拉腳'], scare:['殭屍彈出', '殭屍彈出'], aura:['遊魂飄蕩', '遊魂飄蕩'], throw:['餓鬼擲碗', '餓鬼擲碗'] };
  const ghost = (id) => { if (typeof id === 'string' && id.startsWith('dev:')) { const r = id.slice(4); return { id, k:DEVK[r], name:T(DEVN[r][0], DEVN[r][1]), dev:r }; } return S.ghosts.find(g => g.id === id); };
  function typesOf(k) { try { if (has(Rework)) { const t = Rework.typesOf(k); if (t && t.length) return t; } } catch (e) {} const g = has(SCARE_GHOSTS) && SCARE_GHOSTS[k]; return g ? (g.types || [g.type]) : [Object.keys(W)[(k.length * 7) % 8]]; }
  const gType = (g) => typesOf(g.k).find(t => KIND[t]) || 'shadow';
  const power = (g) => { let v = NaN; try { v = has(Station) ? Station.power(g) : 40; } catch (e) {} return isFinite(v) && v > 0 ? v : 40; };
  const freeGhosts = () => { const now = Date.now(); return S.ghosts.filter(g => g.k !== 'afu' && !g.post && !(g.tiredUntil > now)); };
  const save_ = () => { try { if (has(save)) save(); } catch (e) {} };

  // 名氣
  function addHot(sd, v, def) {
    if (v > 0) { sd.combo++; if (sd.combo > HOT.comboStart) sd.hot += Math.min((sd.combo - HOT.comboStart) % 3 + 1, HOT.comboMax); } else sd.combo = 0;
    sd.hot += v; const need = HOT.up * (sd.lv >= def.cap ? HOT.overMul : 1); let msg = '';
    if (sd.hot >= need) { sd.lv++; sd.maxLv = Math.max(sd.maxLv, sd.lv); sd.hot = 0; msg = T(`傳說愈傳愈勁！路人難度升到 Lv${sd.lv}`, `傳說越傳越廣！路人難度升到 Lv${sd.lv}`); }
    if (sd.hot <= HOT.down) {
      if (sd.lv > 1 && sd.lv > sd.maxLv - HOT.minGap) { sd.lv--; sd.hot = HOT.downStart; msg = T(`漏人太多，傳說冷咗，難度跌返 Lv${sd.lv}`, `漏掉太多人，傳說冷了，難度降回 Lv${sd.lv}`); }
      else sd.hot = HOT.down;
    }
    return msg;
  }

  // ---------- 陽間街地圖 ----------
  function openStreet() {
    try { if (window.Policy && Policy.firstEnter) Policy.firstEnter('station'); } catch (e) {} // 龐總政策講解（policy.js）
    offline();
    let el = $('#st-street'); if (!el) { el = document.createElement('section'); el.id = 'st-street'; document.body.appendChild(el); }
    const src = has(SPR_SRC) && SPR_SRC.st_street || '';
    let h = `<div class="sts-top"><button class="sts-back" id="sts-back">◀ ${T('返陰間', '回陰間')}</button><b>${T('陽間街・站崗', '陽間街・站崗')}</b><span>${T('冥幣', '冥幣')} ${Math.floor(S.res.coins || 0)}</span></div>`;
    h += `<div class="sts-map" style="background-image:url('${src}')">`;
    for (const d of SITES) {
      const sd = site(d.id), held = sd.posts.filter(p => p && p.g != null).length, lost = sd.posts.filter(p => p && p.b).length;
      const sub = held || sd.scared ? `Lv${sd.lv}・${T('嚇走', '嚇走')}${sd.scared}${lost ? `・<i>${T('Bryan 佔', 'Bryan 佔')}${lost}</i>` : ''}` : T('未有鬼站崗', '還沒有鬼站崗');
      h += `<button class="sts-plate ${d.real ? '' : 'wip'} ${lost ? 'war' : ''}" data-site="${d.id}" style="left:${d.x * 100}%;top:${d.y * 100}%"><b>${T(d.n, d.zh)}</b><small>${sub}</small></button>`;
    }
    for (const [x, y] of RESERVED) h += `<button class="sts-plate res" data-res="1" style="left:${x * 100}%;top:${y * 100}%"><b>${T('保留地', '保留地')}</b><small>${T('敬請期待', '敬請期待')}</small></button>`;
    h += `<button class="sts-plate gate" id="sts-gate" style="left:${GATE[0] * 100}%;top:${GATE[1] * 100}%"><b>${T('返村', '回村')}</b></button></div>`;
    h += `<p class="sts-tip">${T('撳地盤入去派鬼站崗。嚇得愈多，傳說愈響，路人就愈難嚇；頂得住就係穩定收入。', '點地盤進去派鬼站崗。嚇得越多，傳說越響，路人就越難嚇；撐得住就是穩定收入。')}</p>`;
    el.innerHTML = h; el.classList.add('on'); document.body.classList.add('st-on');
    const t0 = performance.now(), ghostClick = () => performance.now() - t0 < 450;
    el.querySelectorAll('.sts-plate[data-site]').forEach(b => b.onclick = () => { if (!ghostClick()) Turf.open(b.dataset.site); });
    el.querySelectorAll('.sts-plate[data-res]').forEach(b => b.onclick = () => Fx.toast(T('呢塊地仲未開發，遲啲再嚟', '這塊地還沒開發，晚點再來')));
    $('#sts-back').onclick = () => { if (ghostClick()) return; closeStreet(); if (has(World)) World.open(); };
    $('#sts-gate').onclick = () => { if (!ghostClick()) closeStreet(); };
  }
  function closeStreet() { const el = $('#st-street'); if (el) { el.classList.remove('on'); el.innerHTML = ''; } document.body.classList.remove('st-on'); save_(); if (has(UI) && UI.refresh) UI.refresh(); }
  // 離線：按最近每分鐘收入嘅一半補，最多 8 小時
  function offline() {
    const s = st(), now = Date.now(), mins = Math.min(480, (now - (s.last || now)) / 60000); s.last = now;
    const anyPost = SITES.some(d => site(d.id).posts.some(p => p && p.g != null));
    if (mins >= 3 && anyPost && s.rate > 0) { const got = Math.round(s.rate * 0.5 * mins); if (got > 0) { S.res.coins = (S.res.coins || 0) + got; Fx.toast(T(`你唔喺度嗰陣，站崗嘅鬼嚇走咗唔少人：冥幣 +${got}`, `你不在的時候，站崗的鬼嚇走了不少人：冥幣 +${got}`)); } }
    save_();
  }

  // ---------- 地盤場景 ----------
  const Turf = {
    on:false, def:null, sd:null, cv:null, c:null, raf:0, last:0, walkers:[], fx:[], shots:[], spawn:0, crewT:0, len:0, segs:[], box:null, cds:[], rateAcc:0, rateT:0,
    open(id, room) {
      const def = SITES.find(d => d.id === id); if (!def) return; this.room = 0;
      if (!st().grant) { st().grant = 1; S.res.coins = (S.res.coins || 0) + 600; setTimeout(() => Fx.toast(T('開張資金：冥幣 +600。撳橙色（路）／紫色（牆）格建造裝置，排隊嗰組人到齊撳「進入」放佢哋入嚟！', '開張資金：冥幣 +600。點橙色（路）／紫色（牆）格建造裝置，排隊那組人到齊點「進入」放他們進來！')), 400); }
      this.def = def; const sd = this.sd = site(id); sd.unlocked = sd.unlocked || 1; if (sd.modCur == null) sd.modCur = 0.9; sd.bosses = sd.bosses || []; if (sd.special != null) { if (!sd.bosses.includes(sd.special)) sd.bosses.push(sd.special); sd.special = null; }
      this.lay = longLay(def.long, sd.unlocked, def.rn); this.fixPosts();
      // 血量補正 max：Σ裝置等級 ÷ 最高裝置等級（原作只喺開局／讀檔計一次）
      const blt = sd.posts.filter(p => p && p.role), mx = blt.reduce((a, p) => Math.max(a, p.lv || 1), 0); this.modMax = blt.length ? blt.reduce((a, p) => a + (p.lv || 1), 0) / mx : 1;
      this.bosses = []; this.walkers = []; this.fx = []; this.shots = []; this.parts = []; this.blown = null; this.shake = 0; this.flash = 0; this.rateAcc = 0; this.rateT = 0; this.moveFrom = null;
      this.q = { st:'gap', t:3, n:0, made:0, list:[] }; this.eliteT = R(75, 125); this.eliteNext = null;
      let el = $('#st-turf'); if (!el) { el = document.createElement('section'); el.id = 'st-turf'; document.body.appendChild(el); }
      el.innerHTML = `<canvas id="stt-cv"></canvas><div class="stt-top"><button id="stt-back">◀ ${T('返街', '回街上')}</button><div class="stt-name"><b>${T(def.n, def.zh)}</b><small id="stt-lv"></small></div><span id="stt-coin"></span></div>`
        + `<button class="stt-enter" id="stt-enter"><b>▲</b>${T('進入', '進入')}<small id="stt-q"></small></button><button class="stt-next" id="stt-next" style="display:none"></button><button class="stt-sp" id="stt-sp"></button><button class="stt-box" id="stt-box"></button><div class="stt-zoom"><button id="stt-zin">＋</button><button id="stt-zout">－</button></div><div class="stt-hot"><i id="stt-hotbar"></i><em></em></div><div class="stt-info" id="stt-info"></div>`;
      el.classList.add('on'); document.body.classList.add('st-on'); this.on = true; this.cv = $('#stt-cv'); this.c = this.cv.getContext('2d');
      $('#stt-back').onclick = () => this.close();
      $('#stt-enter').onclick = () => this.enter(true); $('#stt-sp').onclick = () => this.specialPick(); $('#stt-box').onclick = () => this.useBox();
      this.cam = null; this.camStep(); this.cam.z = 1; this.cam.x = this.cam.tx = 0.5; this.cam.y = this.cam.ty = 0.55; this.bindInput();
      this.resize(); this.buildPath(); this.last = performance.now(); this.raf = requestAnimationFrame((t) => this.frame(t));
      if (has(Sound) && Sound.play) Sound.play('click');
    },
    close() { this.on = false; cancelAnimationFrame(this.raf); const el = $('#st-turf'); if (el) { el.classList.remove('on'); el.innerHTML = ''; } const p = $('#stt-pick'); if (p) p.remove(); save_(); openStreet(); },
    resize() {
      const dpr = Math.min(2, window.devicePixelRatio || 1), Wd = innerWidth, Hd = innerHeight;
      this.cv.width = Wd * dpr; this.cv.height = Hd * dpr; this.cv.style.width = Wd + 'px'; this.cv.style.height = Hd + 'px'; this.c.setTransform(dpr, 0, 0, dpr, 0, 0);
      const w = Math.min(Wd, (Hd - 160) / 1.5), h = w * 1.5, top = Math.max(64, (Hd - h - 96) / 2 + 30); this.box = { x:(Wd - w) / 2, y:top, w, h };
      const hb = document.querySelector('.stt-hot'), inf = $('#stt-info'); if (hb) { hb.style.top = (top + h + 12) + 'px'; hb.style.bottom = 'auto'; } if (inf) { inf.style.top = (top + h + 30) + 'px'; inf.style.bottom = 'auto'; } const en = $('#stt-enter'), nx = $('#stt-next'); if (en) { en.style.top = (top + h - 86) + 'px'; en.style.bottom = 'auto'; } if (nx) { nx.style.top = (top + h - 56) + 'px'; nx.style.bottom = 'auto'; }
    },
    P(x, y) { return [this.box.x + x * this.box.w, this.box.y + y * this.box.h]; },
    buildPath() { this.segs = []; let L = 0; if (this.lay.long) { const L2 = this.lay, pts = []; let k = L2.start, gd = 0; while (k && gd++ < 80) { pts.push(L2.nodes[k]); const nx = L2.edges[k]; k = nx && nx[0]; } this.lay.path = pts; } const PA = this.lay.path; for (let i = 0; i < PA.length - 1; i++) { const [ax, ay] = PA[i], [bx, by] = PA[i + 1], d = Math.hypot(bx - ax, (by - ay) * 1.5); this.segs.push({ ax, ay, bx, by, d, s:L }); L += d; } this.len = L; },
    at(t) { for (const g of this.segs) if (t <= g.s + g.d) { const k = (t - g.s) / g.d; return [g.ax + (g.bx - g.ax) * k, g.ay + (g.by - g.ay) * k]; } const z = this.segs[this.segs.length - 1]; return [z.bx, z.by]; },
    dist(a, b) { return Math.hypot(a[0] - b[0], (a[1] - b[1]) * 1.5); },
    mkRoute(w, pts0) { const pts = pts0 || route(this.lay), j = w.j != null ? w.j : (w.j = R(-0.02, 0.02)); w.segs = []; let L0 = 0;
      const J = (q) => /~in|OUT|@/.test(q.k) ? [q.p[0], q.p[1]] : [q.p[0] + j, q.p[1] + j * 0.6];
      for (let i = 0; i < pts.length - 1; i++) { const [ax, ay] = J(pts[i]), [bx, by] = J(pts[i + 1]), d = Math.hypot(bx - ax, (by - ay) * 1.5) || 1e-6; w.segs.push({ ax, ay, bx, by, d, s:L0, hide:pts[i + 1].hide, k:pts[i + 1].k, nk:pts[i + 2] && pts[i + 2].k }); L0 += d; }
      w.len = L0; return w; },
    wp(w, dt) { if (w.gone === 'run' && w.runPath) return this.runPos(w); const t = w.t + (dt || 0), S2 = w.segs || this.segs; for (const g of S2) if (t <= g.s + g.d) { const k = Math.max(0, (t - g.s) / g.d); return [g.ax + (g.bx - g.ax) * k, g.ay + (g.by - g.ay) * k]; } const z = S2[S2.length - 1]; return [z.bx, z.by]; },
    newWalker(eliteId) {
      const sd = this.sd; let w;
      if (eliteId) { const E = ELITE.find(e => e.id === eliteId), d = sd.lv, hp = Math.round(E.hp * hpP(d) * this.mod() * 1.25); w = { el:E, crew:{ n:T(E.n, E.zh), tag:E.tag }, spr:E.spr, n:T(E.n, E.zh), hp, max:hp, d, spd:E.spd * PX, award:E.award }; }
      else { const p = pick(PEOPLE), r = Math.random() * 80, fl = r < 15 ? -3 : r < 25 ? -2 : r < 32 ? -1 : 0, d = Math.max(1, sd.lv + fl), hp = Math.round(R(75, 100) * hpP(d) * this.mod() * 1.25); w = { p, spr:p.spr, n:T(p.n, p.zh), hp, max:hp, d, spd:R(100, 110) * PX, award:13 }; }
      Object.assign(w, { t:0, stay:0, block:0, fear:0, slowM:1, slowT:0, hist:[], seed:Math.random() * 9 });
      return this.mkRoute(w);
    },
    float(x, y, s, col) { this.fx.push({ x, y, s, col, t:0 }); },
    hit(w, dmg, o) {
      o = o || {}; if (w.gone || w.hp <= 0) return; const [x, y] = this.wp(w);
      if (!o.force && w.el && w.el.buf === 'dodge' && Math.random() < 0.3) { if (!o.aura) this.float(x, y - 0.06, T('閃避', '閃避'), '#9cf'); return; }
      if (!o.force) { if (w.el && w.el.buf === 'tough') dmg *= 0.7; if ((w.el && w.el.buf === 'aura') || this.walkers.some(q => q !== w && q.el && q.el.buf === 'aura' && this.alive(q) && this.dist(this.wp(q), [x, y]) < 200 * PX)) dmg *= 0.85; }
      if (w.target > 0) dmg *= 1.5;
      w.hp -= dmg; if (!o.aura || w.hp <= 0) { w.react = 0.6; this.say(w, false); } if (!o.aura) this.float(x, y - 0.06, `-${Math.round(dmg)}`, o.force ? '#ffd45a' : '#fff');
      if (o.fear) w.fear = 0.5;
      if (o.fright && w.hp > 0 && !(w.stay > 0)) w.stay = o.fright === true ? 2 : o.fright; // 陷阱／驚嚇／有名鬼：原地嚇呆
      if (w.hp <= 0) this.scared(w);
    },
    scared(w) {
      const sd = this.sd, pos = this.wp(w); w.gone = 'run'; w.runT = 0; w.runPath = [pos].concat(w.hist.slice(-5).reverse()); this.say(w, true);
      for (let j = 0; j < 5; j++) this.parts.push({ kind:'coin', x:pos[0] + R(-0.03, 0.03), y:pos[1] - 0.05, life:0.9 + j * 0.08, k:-j * 0.08 });
      const cap = this.incomeCap(), coin = Math.floor(w.award * coP(w.d > cap ? cap : Math.min(sd.lv, cap)) * 1.15);
      sd.scared++; S.res.coins = (S.res.coins || 0) + coin; sd.coins += coin; this.rateAcc += coin;
      this.float(pos[0], pos[1] - 0.09, T(`嚇走！冥幣+${coin}`, `嚇跑！冥幣+${coin}`), '#7dffb0');
      const m = addHot(sd, HOT.add, this.def); if (m) Fx.toast(m);
    },
    leak(w) { const sd = this.sd; sd.leaked++; sd.leakAcc = (sd.leakAcc || 0) + 1; if (sd.leakAcc >= 4) { sd.leakAcc = 0; sd.modCur = Math.max(0.9, (sd.modCur || 0.9) - 0.06); }
      const m = addHot(sd, HOT.leak, this.def), [x, y] = this.lay.nodes[this.lay.last]; this.float(x - 0.08, y - 0.04, T('漏咗一個…名氣 −18', '漏掉一個…名氣 −18'), '#ff8a8a'); if (m) Fx.toast(m); },
    // 排隊：每組 4／5／6 人（排隊區等級），門外最多一組；人齊之後 90 秒自動放行，撳「進入」即刻放
    tick(dt) {
      const sd = this.sd;
      this.queueTick(dt);
      sd.posts.forEach((p, i) => { if (p && p.build > 0) { p.build -= dt; if (Math.random() < dt * 8) { const P0 = this.lay.posts[i]; this.parts.push({ x:P0.x + R(-0.04, 0.04), y:P0.y + R(-0.02, 0.03), vx:R(-0.03, 0.03), vy:R(-0.08, -0.03), life:0.9, kind:'smoke' }); } if (p.build <= 0) { p.build = 0; Fx.toast(T('建造完成！', '建造完成！')); } } });
      this.bossTick(dt); this.traceTick(dt);
      sd.posts.forEach((p, i) => { if (p && p.role && !(p.build > 0) && this.lay.posts[i]) this.devTick(i, p, dt); });
      this.shots = this.shots.filter(s => { s.t += dt / s.dur; if (s.t >= 1) { this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), s.to) <= s.eff).forEach(w => this.hit(w, s.atk)); for (let j = 0; j < 8; j++) this.parts.push({ x:s.to[0], y:s.to[1] - 0.03, vx:R(-0.15, 0.15), vy:R(-0.25, -0.05), life:0.7, kind:'paper' }); return false; } return true; });
      for (const p of sd.posts) if (p && p.fx) { p.fx.t += dt; if (p.fx.t > 1.1) p.fx = null; }
      for (const p of sd.posts) if (p && p.auraOn > 0) p.auraOn -= dt;
      this.parts = this.parts.filter(q => { q.life -= dt; if (q.kind === 'coin') { q.k = Math.min(1, (q.k || 0) + dt * 1.4); } else { q.x += q.vx * dt; q.y += q.vy * dt; q.vy += 0.35 * dt; } return q.life > 0; });
      for (const w of this.walkers) { if (w.react > 0) w.react -= dt; if (w.frost > 0) w.frost -= dt; if (w.fear > 0) w.fear -= dt; if (w.say && (w.say.t -= dt) <= 0) w.say = null; }
      this.shake = Math.max(0, (this.shake || 0) - dt); this.flash = Math.max(0, (this.flash || 0) - dt);
      if (Math.random() < dt * 3) { const q = sd.posts.findIndex(p => p && p.auraOn > 0); if (q >= 0) { const P0 = this.lay.posts[q]; this.parts.push({ x:P0.x + R(-0.1, 0.1), y:P0.y + R(-0.02, 0.1), vx:R(-0.04, 0.04), vy:R(-0.05, -0.01), life:1.4, kind:'mist' }); } }
      // 路人沿路點直線行；嚇呆／被謎題擋住就原地停，好返繼續行去原本目標點
      for (const w of this.walkers) {
        if (w.gone === 'suck') { w.suckT += dt; continue; }
        if (w.gone === 'run') { w.runT += dt; continue; }
        if (this.walkerFx(w, dt)) continue;
        if (w.spin > 0) { w.spin -= dt; continue; }
        if (w.stay > 0) { w.stay -= dt; continue; }
        if (w.block > 0) { w.block -= dt; continue; }
        if (w.back > 0) { const sb = w.spd * 1.3 * dt; w.t = Math.max(0.01, w.t - sb); w.back -= sb; w.rev = 0.3; continue; } if (w.rev > 0) w.rev -= dt;
        const sg = this.wseg(w), sp = w.spd * (sg && sg.hide ? 4 : 1) * (w.slowT > 0 ? w.slowM : 1); w.slowT -= dt; if (w.slowT <= 0) w.slowM = 1;
        w.t += sp * dt;
        if (w.t > 0 && !(sg && sg.hide)) { const pos = this.wp(w), h = w.hist, lp = h[h.length - 1]; if (!lp || this.dist(lp, pos) >= CELL) { h.push(pos); if (h.length > 6) h.shift(); } }
        if (w.t >= w.len) { w.gone = 'out'; this.leak(w); }
      }
      this.walkers = this.walkers.filter(w => !(w.gone === 'out' || (w.gone === 'run' && w.runT > 2.0) || (w.gone === 'suck' && w.suckT > 1.1)));
      this.fx = this.fx.filter(f => (f.t += dt) < 1.2);
      const s0 = st(); if ((s0.box || 0) < 1 && Date.now() - (s0.boxAt || 0) >= 20 * 60000) s0.box = 1;
      if (s0.tapE == null) s0.tapE = 100; if (s0.tapE < 100 && Date.now() - (s0.tapAt || 0) >= 300000) { s0.tapE++; s0.tapAt = Date.now(); }
      this.rateT += dt; if (this.rateT >= 60) { const s = st(); s.rate = s.rate ? s.rate * 0.6 + this.rateAcc * 0.4 : this.rateAcc; this.rateAcc = 0; this.rateT = 0; s.last = Date.now(); save_(); }
    },
    // 裝置通用循環：整備滿 → 檢測範圍有人 → 播攻擊動畫，第 DamageDelay 幀開始判定 → 持續 DamageLast 幀，效果範圍內每人只中一次
    frame(t) {
      if (!this.on) return; this.raf = requestAnimationFrame((x) => this.frame(x));
      const dt = Math.min(0.1, (t - this.last) / 1000); if (dt < 1 / 31) return; this.last = t;
      const U2 = this.ult; if (U2) { U2.t += dt; if (U2.t >= (U2.at || 0.9) && !U2.done) { U2.done = true; this.ultApply(U2); } if (U2.t > (U2.dur || 2.6)) this.ult = null; }
      this.my = Math.min(100, (this.my == null ? 100 : this.my) + 5 * dt);
      this.tick(U2 && U2.t < 0.9 ? dt * 0.2 : dt); this.draw(); if (this.ult) this.drawUlt(); this.drawMy(); this.hud();
    },
    ULT: {
      mengpo:['孟婆湯', '孟婆湯'], n30_yukionna:['冰封', '冰封'], n30_qionggui:['散財', '散財'], n30_guhangui:['一毛不拔', '一毛不拔'], n30_taozhai:['追債', '追債'],
      tianhua:['千絲垂髮', '千絲垂髮'], pontianak:['夜半尖笑', '夜半尖笑'], eguiking:['大胃王', '大胃王'], egui:['大胃王', '大胃王'], toyol:['一掃光', '一掃光'],
      laojiang:['跳屍夜行', '跳屍夜行'], xiaozhi:['紙人大軍', '紙人大軍'], zhiren:['紙人大軍', '紙人大軍'], penanggal:['飛頭索命', '飛頭索命'], pocong:['裹屍跳', '裹屍跳'],
      shuigui:['水鬼拉腳', '水鬼拉腳'], zombie:['屍潮', '屍潮'], xiaogui:['鬼仔捉迷藏', '鬼仔捉迷藏'], niutou:['勾魂鎖', '勾魂鎖'], mamian:['勾魂鎖', '勾魂鎖'],
    },
    startUlt(i) {
      const p = this.sd.posts[i], g = ghost(p.g); if (!g) return; p.en = 0;
      const nm = this.ULT[g.k] || [`${g.name}・怨氣爆發`, `${g.name}・怨氣爆發`];
      this.focusOn(this.lay.posts[i].x, this.lay.posts[i].y); if (this.cam) this.cam.user = 0; this.ult = { t:0, i, k:g.k, name:T(nm[0], nm[1]), gname:g.name, pw:power(g), done:false, fx:[] }; this.shake = 0.5;
      if (has(Sound) && Sound.play) try { Sound.play('scare'); } catch (e) {}
    },
    ultApply(U) {
      const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG, me = U.pos ? { x:U.pos[0], y:U.pos[1] } : this.lay.posts[U.i];
      const hitAll = (list, mul, extra) => list.forEach(w => { this.hit(w, P * mul, null, 'face'); if (extra) extra(w); });
      this.shake = 0.6; this.flash = 0.18;
      if (this.ultNew(U)) return;
      switch (U.k) {
        case 'tianhua': break;
        case 'pontianak': hitAll(live, 10, w => { w.t = Math.max(0.01, w.t - 0.12); }); break;
        case 'eguiking': case 'egui': { const mx = Math.max(0.25, Math.min(0.75, me.x)), my = Math.max(0.35, Math.min(0.8, me.y + 0.15)); U.mouth = [mx, my]; const near = live.filter(w => this.dist(this.wp(w), U.mouth) < 0.55 && !w.crew).slice(0, 6); near.forEach(w => { w.suckFrom = this.wp(w); w.hp = 0; this.scared(w, null); w.gone = 'suck'; w.suckT = 0; w.suckTo = [mx, my - 0.17]; }); for (let j = 0; j < 3; j++) this.addTrace('bowl', mx - 0.12 + j * 0.12, my + 0.05, 110, 6, { by:'eguiking' }); break; }
        case 'toyol': live.forEach(w => { if (!w.crew) { const c2 = this.unit(); S.res.coins = (S.res.coins || 0) + c2; this.sd.coins += c2; const [x, y] = this.wp(w); for (let j = 0; j < 3; j++) this.parts.push({ kind:'coin', x, y:y - 0.05, life:1 + j * 0.1, k:-j * 0.1 }); } if (w.hp < w.max * 0.6) this.hit(w, w.hp + 1, null, 'face'); else w.react = 0.6; }); break;
        case 'laojiang': U.hop = 0; break;
        case 'xiaozhi': case 'zhiren': hitAll(live, 7, w => { w.block = 2.5; w.papers = 2.5; }); break;
        default: hitAll(live, 8);
      }
    },
    drawUltScene() {
      const U = this.ult, c = this.c, Wd = innerWidth, Hd = innerHeight, b = this.box, t = performance.now() / 1000, k = U.t;
      if (this.drawUltNew(U, (k - (U.at || 0.9)) / 1.7)) return;
      if (U.k === 'laojiang' && k >= 0.9) { const e = Math.min(1, (k - 0.9) / 1.4), pos = this.at(e * this.len), [x, y] = this.P(...pos), hop = Math.abs(Math.sin(e * Math.PI * 9));
        for (const w of this.walkers) if (!w.gone && w.t > 0 && this.dist(this.wp(w), pos) < 0.09) this.hit(w, w.max, null, 'face');
        try { ART.drawChar(c, 'laojiang', x, y - hop * 30, b.h * 0.1 / 58, { t, walk:true, pose:'move', alpha:0.95, flip:false, shadow:false }); } catch (e2) {} }
      if (k >= 0.9) { const q = (k - 0.9) / 1.7;
        if (U.k === 'tianhua') { c.strokeStyle = 'rgba(150,140,160,0.55)'; c.lineWidth = 2.5; for (let j = 0; j < 46; j++) { const x = b.x + (j / 45) * b.w, len = b.h * Math.min(1, q * 2.2) * (0.6 + 0.4 * Math.sin(j * 7.3)); c.beginPath(); c.moveTo(x, b.y); c.bezierCurveTo(x + Math.sin(t * 2 + j) * 14, b.y + len * 0.4, x - Math.sin(t * 1.7 + j) * 14, b.y + len * 0.7, x + Math.sin(j) * 8, b.y + len); c.stroke(); } }
        if (U.k === 'pontianak') for (let j = 0; j < 4; j++) { const rr = ((q * 2 + j * 0.25) % 1), [x, y] = this.P(...(U.pos || [this.lay.posts[U.i].x, this.lay.posts[U.i].y])); c.strokeStyle = `rgba(255,170,220,${0.9 * (1 - rr)})`; c.lineWidth = 6; c.beginPath(); c.arc(x, y, rr * b.h, 0, 7); c.stroke(); }
        if (U.mouth) this.drawMouth(U, q, t);
        if (U.k === 'toyol') for (let j = 0; j < 8; j++) { const x = b.x + b.w * (0.5 + 0.45 * Math.sin(t * 3 + j * 1.7)), y = b.y + b.h * (0.5 + 0.4 * Math.cos(t * 2.3 + j * 2.1)); try { ART.drawChar(c, 'toyol', x, y, b.h * 0.05 / 46, { t:t + j, walk:true, pose:'move', alpha:0.9 * (1 - Math.max(0, q - 0.8) * 5), flip:Math.cos(t * 3 + j * 1.7) < 0, shadow:false }); } catch (e2) {} }
        if (U.k === 'xiaozhi' || U.k === 'zhiren') for (const w of this.walkers) if (w.papers > 0 && !w.gone) { w.papers -= 1 / 30; const [x, y] = this.P(...this.wp(w)); for (let j = 0; j < 4; j++) { const a2 = j * 1.57 + t; try { ART.drawChar(c, 'xiaozhi', x + Math.cos(a2) * 26, y + Math.sin(a2) * 10, 0.45, { t:t + j, pose:'idle', alpha:0.85, flip:Math.cos(a2) > 0, shadow:false }); } catch (e2) {} } }
        if (!['tianhua', 'pontianak', 'toyol', 'laojiang', 'xiaozhi', 'zhiren', 'eguiking', 'egui'].includes(U.k)) { const [x, y] = this.P(...(U.pos || [this.lay.posts[U.i].x, this.lay.posts[U.i].y])); c.strokeStyle = `rgba(200,150,255,${1 - q})`; c.lineWidth = 10; c.beginPath(); c.arc(x, y, q * b.h * 1.2, 0, 7); c.stroke(); }
      }
    },
    drawMouth(U, q, t) {
      const c = this.c, b = this.box, [mx, my] = this.P(...U.mouth), H = b.h * 0.5, o = Math.sin(Math.min(1, q * 1.6) * Math.PI), al = Math.min(1, q * 6) * (q > 0.85 ? (1 - q) / 0.15 : 1);
      try { ART.drawChar(c, U.k, mx, my + H * 0.15, H / 66, { t, pose:'strike', pt:Math.min(1, q * 2), atk:true, alpha:al * 0.95, flip:false, shadow:false }); } catch (e) {}
      const hx = mx, hy = my - H * 0.5, rw = H * 0.22 * o, rh = H * 0.17 * o; if (rw < 2) return;
      c.save(); c.globalAlpha = al; const rg = c.createRadialGradient(hx, hy, 2, hx, hy, rw); rg.addColorStop(0, '#000'); rg.addColorStop(0.6, '#2a0306'); rg.addColorStop(1, '#6e0f14');
      c.fillStyle = rg; c.beginPath(); c.ellipse(hx, hy, rw, rh, 0, 0, 7); c.fill(); c.strokeStyle = '#3a0508'; c.lineWidth = 4; c.stroke();
      c.fillStyle = '#efe6cf'; for (let j = 0; j < 9; j++) { const xx = hx - rw * 0.85 + j * rw * 0.21; c.beginPath(); c.moveTo(xx - rw * 0.08, hy - rh * 0.88); c.lineTo(xx + rw * 0.08, hy - rh * 0.88); c.lineTo(xx, hy - rh * 0.55); c.fill(); c.beginPath(); c.moveTo(xx - rw * 0.08, hy + rh * 0.88); c.lineTo(xx + rw * 0.08, hy + rh * 0.88); c.lineTo(xx, hy + rh * 0.55); c.fill(); }
      for (let j = 0; j < 22; j++) { const a2 = j * 0.83 + t * 2, d = ((t * 1.6 + j * 0.13) % 1), rr = rw * 2.6 * (1 - d); c.fillStyle = `rgba(255,190,190,${0.6 * d})`; c.beginPath(); c.arc(hx + Math.cos(a2) * rr, hy + Math.sin(a2) * rr * 0.8, 2.5, 0, 7); c.fill(); }
      c.restore(); U.mouthXY = [hx, hy];
    },
    drawUlt() {
      const U = this.ult, c = this.c, Wd = innerWidth, Hd = innerHeight, b = this.box, t = performance.now() / 1000, k = U.t;
      // 開場：壓暗 + 橫幅特寫
      if (k < 1.3) { const a = k < 0.15 ? k / 0.15 : k > 1.0 ? 1 - (k - 1.0) / 0.3 : 1; c.fillStyle = `rgba(0,0,0,${0.55 * a})`; c.fillRect(0, 0, Wd, Hd);
        const slide = Math.min(1, k / 0.25), y0 = Hd * 0.36, bh = Hd * 0.2, bx = -Wd + Wd * (1 - Math.pow(1 - slide, 3));
        c.save(); c.globalAlpha = a; c.fillStyle = '#12061c'; c.beginPath(); c.moveTo(bx, y0); c.lineTo(bx + Wd, y0 - 16); c.lineTo(bx + Wd, y0 + bh - 16); c.lineTo(bx, y0 + bh); c.fill();
        c.strokeStyle = '#c084ff'; c.lineWidth = 3; c.stroke();
        try { const pc = ART.portrait(U.k, 160); c.drawImage(pc, bx + 8, y0 - 22, bh + 20, bh + 20); } catch (e2) {}
        const tx = bx + bh + 36; let fs = Math.round(bh * 0.3); c.font = `900 ${fs}px serif`; while (fs > 14 && c.measureText(U.name).width > Wd - (tx - bx) - 14) { fs -= 2; c.font = `900 ${fs}px serif`; } c.fillStyle = '#ffe9b0'; c.textAlign = 'left'; c.lineWidth = 5; c.strokeStyle = '#2a0a30';
        c.strokeText(U.name, tx, y0 + bh * 0.5); c.fillText(U.name, tx, y0 + bh * 0.5);
        const sub = U.gname + T('・大招', '・大招'); let fs2 = Math.round(bh * 0.14); c.font = `bold ${fs2}px sans-serif`; while (fs2 > 10 && c.measureText(sub).width > Wd - (tx - bx) - 14) { fs2 -= 1; c.font = `bold ${fs2}px sans-serif`; } c.fillStyle = '#d9c3ff'; c.fillText(sub, tx, y0 + bh * 0.78); c.restore(); }
    },
    drawMy() {
      const c = this.c, b = this.box, U = b.w / 390, e = st().tapE == null ? 100 : st().tapE;
      // 門外排隊（原作排隊區）：顯示等緊嗰組人同 90 秒倒數
      const q = this.q; if (q && q.st !== 'gap' && q.list && q.list.length) { const n = q.n || q.list.length, bw = Math.min(b.w - 130 * U, 26 * U * n + 70 * U), bx0 = b.x + 8 * U, by0 = Math.min(innerHeight - 50 * U, b.y + b.h + 56 * U);
        c.fillStyle = 'rgba(12,10,16,0.82)'; c.strokeStyle = q.st === 'ready' ? '#ffd45a' : '#6a5a40'; c.lineWidth = 2; c.beginPath(); c.roundRect ? c.roundRect(bx0, by0, bw, 44 * U, 10 * U) : c.rect(bx0, by0, bw, 44 * U); c.fill(); c.stroke();
        c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'left'; c.fillStyle = '#e8dcc8'; c.fillText(q.st === 'ready' ? T(`門外排隊・${Math.ceil(q.t)}秒後自動入`, `門外排隊・${Math.ceil(q.t)}秒後自動進`) : T(`門外排隊 ${q.made}/${n}`, `門外排隊 ${q.made}/${n}`), bx0 + 8 * U, by0 + 13 * U);
        if (q.st === 'ready') { c.fillStyle = 'rgba(255,212,90,0.25)'; c.fillRect(bx0 + 4 * U, by0 + 40 * U, (bw - 8 * U) * (1 - q.t / 90), 3 * U); }
        const tt = performance.now() / 1000; q.list.forEach((w, j) => { const fx = bx0 + 16 * U + j * 26 * U, fy = by0 + 41 * U; c.fillStyle = 'rgba(0,0,0,0.4)'; c.beginPath(); c.ellipse(fx, fy, 8 * U, 2.5 * U, 0, 0, 7); c.fill();
          try { if (CHAR_H_OK(w.spr)) ART.drawChar(c, w.spr, fx, fy, 26 * U / (typeof NPC_UNIT !== 'undefined' ? NPC_UNIT : 69), { t:tt + (w.seed || 0), pose:'idle', shadow:false }); } catch (e) {}
          if (w.el) { c.fillStyle = w.el.tag; c.beginPath(); c.arc(fx + 7 * U, fy - 26 * U, 3 * U, 0, 7); c.fill(); } });
        for (let j = q.list.length; j < n; j++) { c.strokeStyle = 'rgba(200,190,170,0.35)'; c.setLineDash([3, 3]); c.beginPath(); c.ellipse(bx0 + 16 * U + j * 26 * U, by0 + 30 * U, 7 * U, 10 * U, 0, 0, 7); c.stroke(); c.setLineDash([]); } }
      const x = b.x + b.w - 150 * U, y = Math.min(innerHeight - 30 * U, b.y + b.h + 82 * U), w = 140 * U; c.fillStyle = 'rgba(0,0,0,0.55)'; c.fillRect(x, y, w, 7 * U); c.fillStyle = '#ff9ad5'; c.fillRect(x, y, w * e / 100, 7 * U);
      c.font = `bold ${10.5 * U}px sans-serif`; c.textAlign = 'left'; c.fillStyle = '#ffe0f2'; c.lineWidth = 3; c.strokeStyle = '#000'; const s = T(`嚇人力 ${e}/100（撳路人）`, `嚇人力 ${e}/100（點路人）`); c.strokeText(s, x, y - 4 * U); c.fillText(s, x, y - 4 * U);
      if (this.tapFx) { const f = this.tapFx; f.t += 1 / 30; const a = Math.max(0, 1 - f.t / 0.5);
        c.fillStyle = `rgba(170,10,30,${a})`; for (let j = 0; j < 5; j++) { const a2 = -0.9 + j * 0.45; c.beginPath(); c.ellipse(f.x + Math.sin(a2) * 16 * U, f.y - Math.cos(a2) * 18 * U, 4 * U, 9 * U, a2, 0, 7); c.fill(); } c.beginPath(); c.ellipse(f.x, f.y + 6 * U, 13 * U, 11 * U, 0, 0, 7); c.fill();
        if (f.t > 0.5) this.tapFx = null; }
      if (this.moveFrom != null) { c.font = `900 ${13 * U}px sans-serif`; c.textAlign = 'center'; c.fillStyle = '#ffe9a0'; c.strokeText(T('移位：撳另一個同類同大小嘅格（互換）', '移位：點另一個同類同大小的格（互換）'), b.x + b.w / 2, b.y + 40 * U); c.fillText(T('移位：撳另一個同類同大小嘅格（互換）', '移位：點另一個同類同大小的格（互換）'), b.x + b.w / 2, b.y + 40 * U); }
    },
    camStep() {
      const C = this.cam || (this.cam = { z:1.5, x:0.5, y:0.6, tx:0.5, ty:0.6, user:0 }), now = performance.now();
      if (now - C.user > 3500 && C.focus) { C.tx = C.focus[0]; C.ty = C.focus[1]; }
      const k = 0.08; C.x += (C.tx - C.x) * k; C.y += (C.ty - C.y) * k; this.camClamp();
    },
    camClamp() { const C = this.cam; C.z = Math.max(1, Math.min(1.5, C.z)); const hx = 0.5 / C.z, hy = 0.5 / C.z, WW = (this.lay && this.lay.worldW) || 1; C.x = Math.max(hx, Math.min(WW - hx, C.x)); C.y = Math.max(hy, Math.min(1 - hy, C.y)); C.tx = Math.max(hx, Math.min(WW - hx, C.tx)); C.ty = Math.max(hy, Math.min(1 - hy, C.ty)); },
    toScreen(px, py) { const C = this.cam || { z:1, x:0.5, y:0.5 }, b = this.box; return [b.x + b.w / 2 + (px - (b.x + C.x * b.w)) * C.z, b.y + b.h / 2 + (py - (b.y + C.y * b.h)) * C.z]; },
    toScene(sx, sy) { const C = this.cam || { z:1, x:0.5, y:0.5 }, b = this.box; return [(sx - b.x - b.w / 2) / C.z + b.x + C.x * b.w, (sy - b.y - b.h / 2) / C.z + b.y + C.y * b.h]; },
    focusOn(x, y) { if (!this.cam) this.camStep(); this.cam.focus = [x, y]; },
    bindInput() {
      const cv = this.cv, pts = new Map(); let moved = false, start = null, pinch0 = 0, z0 = 1;
      cv.onpointerdown = (e) => { cv.setPointerCapture && cv.setPointerCapture(e.pointerId); pts.set(e.pointerId, [e.clientX, e.clientY]); moved = false; start = [e.clientX, e.clientY, this.cam.x, this.cam.y]; if (pts.size === 2) { const [a, b2] = [...pts.values()]; pinch0 = Math.hypot(a[0] - b2[0], a[1] - b2[1]); z0 = this.cam.z; } };
      cv.onpointermove = (e) => { if (!pts.has(e.pointerId)) return; pts.set(e.pointerId, [e.clientX, e.clientY]); const C = this.cam;
        if (pts.size === 2) { const [a, b2] = [...pts.values()], d = Math.hypot(a[0] - b2[0], a[1] - b2[1]); C.z = z0 * d / Math.max(1, pinch0); moved = true; C.user = performance.now(); this.camClamp(); return; }
        const dx = e.clientX - start[0], dy = e.clientY - start[1]; if (Math.hypot(dx, dy) > 8) moved = true;
        if (moved) { C.x = C.tx = start[2] - dx / (this.box.w * C.z); C.y = C.ty = start[3] - dy / (this.box.h * C.z); C.user = performance.now(); this.camClamp(); } };
      const up = (e) => { const was = pts.has(e.pointerId); pts.delete(e.pointerId); if (was && !moved && pts.size === 0) this.tap(e); };
      cv.onpointerup = up; cv.onpointercancel = (e) => pts.delete(e.pointerId);
      const zb = (d) => { this.cam.z += d; this.cam.user = performance.now(); this.camClamp(); };
      const zi = $('#stt-zin'), zo = $('#stt-zout'); if (zi) zi.onclick = () => zb(0.3); if (zo) zo.onclick = () => zb(-0.3);
    },
    drawLongBg() {
      const c = this.c, b = this.box, L2 = this.lay, t = performance.now() / 1000, U = b.w / 390, sd = this.sd; this.gates = [];
      L2.rooms.forEach((rk, r) => { if (r >= L2.nv) return; const R0 = ROOMG[rk], x = b.x + L2.rx(r) * b.w, im = has(SPR) && SPR[R0.bg], nm = L2.names[r];
        if (im && im.naturalWidth) { c.save(); c.filter = 'brightness(0.92) saturate(0.9)'; c.drawImage(im, x, b.y, b.w, b.h); c.restore(); }
        c.font = `bold ${13 * U}px sans-serif`; c.textAlign = 'left'; c.lineWidth = 3; c.strokeStyle = 'rgba(0,0,0,0.8)'; const lab = `${r + 1}${T('號房', '號房')}・${T(nm[0], nm[1])}`; c.strokeText(lab, x + 8, b.y + 18); c.fillStyle = 'rgba(232,220,200,0.92)'; c.fillText(lab, x + 8, b.y + 18);
        if (r > 0) { // 樓梯間：上一間出口 → 呢間入口
          const gx = x - GAP * b.w, gw = GAP * b.w; c.fillStyle = '#101213'; c.fillRect(gx, b.y, gw, b.h);
          const pv = L2.nodes[(r - 1) + 'X'] || [0, ROOMG[L2.rooms[r - 1]].nodes.X[1]], y1 = b.y + pv[1] * b.h;
          c.fillStyle = 'rgba(70,80,80,0.6)'; c.fillRect(gx, y1 - 26 * U, gw, 52 * U); c.strokeStyle = '#3a4040'; c.lineWidth = 2;
          for (let j = 0; j < 9; j++) { const yy = y1 + 30 * U + j * 12 * U; c.beginPath(); c.moveTo(gx + 8 + j * 3, yy); c.lineTo(gx + gw - 8 - j * 3, yy); c.stroke(); }
          c.fillStyle = '#d8cfbf'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('樓梯間', '樓梯間'), gx + gw / 2, y1 - 32 * U);
          c.fillStyle = 'rgba(255,214,120,0.35)'; c.beginPath(); c.arc(gx + gw / 2, y1 - 52 * U, 7 + Math.sin(t * 3) * 1.5, 0, 7); c.fill(); }
        if (r >= L2.unlocked) { // 鎖住：鐵閘＋三重條件
          c.fillStyle = 'rgba(5,6,8,0.8)'; c.fillRect(x - GAP * b.w, b.y, b.w + GAP * b.w, b.h);
          c.strokeStyle = 'rgba(120,125,130,0.75)'; c.lineWidth = 4; for (let xx = x - GAP * b.w + 10; xx < x + b.w; xx += 22) { c.beginPath(); c.moveTo(xx, b.y + b.h * 0.08); c.lineTo(xx, b.y + b.h * 0.92); c.stroke(); }
          for (let yy = 0.15; yy < 0.9; yy += 0.15) { c.beginPath(); c.moveTo(x - GAP * b.w + 6, b.y + b.h * yy); c.lineTo(x + b.w - 6, b.y + b.h * yy); c.stroke(); }
          const need = UNLOCK[r] || UNLOCK[UNLOCK.length - 1], bd = this.build(), okR = sd.scared >= need.rep, okB = bd >= need.bd, okC = (S.res.coins || 0) >= need.coin, ok = okR && okB && okC;
          const bw = b.w * 0.78, bh = 132 * U, bx = x + (b.w - bw) / 2, by = b.y + b.h * 0.36;
          c.fillStyle = ok ? 'rgba(110,20,20,0.96)' : 'rgba(26,28,32,0.96)'; c.fillRect(bx, by, bw, bh); c.strokeStyle = ok ? '#ffd45a' : '#666'; c.lineWidth = 3; c.strokeRect(bx, by, bw, bh);
          c.fillStyle = '#f1e6d6'; c.textAlign = 'center'; c.font = `900 ${16 * U}px sans-serif`; c.fillText(`${r + 1}${T('號房', '號房')}・${T(nm[0], nm[1])}${T('（鐵閘鎖住）', '（鐵閘鎖住）')}`, bx + bw / 2, by + 24 * U);
          c.font = `bold ${12.5 * U}px sans-serif`; const rows = [[okR, T(`惡名（嚇走人數）${sd.scared}/${need.rep}`, `惡名（嚇跑人數）${sd.scared}/${need.rep}`)], [okB, T(`主題建設度 ${bd}%/${need.bd}%`, `主題建設度 ${bd}%/${need.bd}%`)], [okC, T(`升級排隊區：冥幣 ${need.coin}`, `升級排隊區：冥幣 ${need.coin}`)]];
          rows.forEach(([o, s], j) => { c.fillStyle = o ? '#9ef0b0' : '#b9b2a6'; c.fillText(`${o ? '✓' : '✗'} ${s}`, bx + bw / 2, by + (50 + j * 22) * U); });
          c.fillStyle = ok ? '#ffe9a0' : '#888'; c.font = `900 ${13 * U}px sans-serif`; c.fillText(r === L2.unlocked ? (ok ? T('撳呢度開鐵閘！', '點這裡開鐵閘！') : T('三樣齊晒先開到', '三項都達成才能開')) : T('要先開上一間', '需先開上一間'), bx + bw / 2, by + 122 * U);
          if (r === L2.unlocked) this.gates.push({ r, need, ok, x:(bx - b.x) / b.w, y:(by - b.y) / b.h, w:bw / b.w, h:bh / b.h }); }
      });
    },
    tryGate(x, y) {
      const b = this.box; for (const g of this.gates || []) { const gx = b.x + g.x * b.w, gy = b.y + g.y * b.h; if (x >= gx && x <= gx + g.w * b.w && y >= gy && y <= gy + g.h * b.h) {
        if (!g.ok) { Fx.toast(T('惡名、建設度、冥幣三樣都要夠先開到鐵閘', '惡名、建設度、冥幣三項都要達標才能開鐵閘')); return true; }
        S.res.coins -= g.need.coin; this.sd.unlocked = g.r + 1; this.lay = longLay(this.def.long, this.sd.unlocked, this.def.rn); this.fixPosts(); this.buildPath();
        Fx.toast(T('排隊區升級咗！新一間房開放：每組多一個人、裝置等級上限 +2。', '排隊區升級了！新房間開放：每組多一個人、裝置等級上限 +2。')); save_(); return true; } } return false;
    },
    SPECIAL:['tianhua', 'pontianak', 'eguiking', 'laojiang', 'toyol', 'xiaozhi', 'penanggal', 'pocong', 'mengpo', 'n30_yukionna', 'n30_qionggui', 'n30_guhangui', 'n30_taozhai'],
    specialPick() {
      const sd = this.sd, on = (sd.bosses || []).map(ghost).filter(Boolean), list = S.ghosts.filter(g => this.SPECIAL.includes(g.k) && (!g.post || on.some(o => o.id === g.id)));
      let el = $('#stt-pick'); if (!el) { el = document.createElement('div'); el.id = 'stt-pick'; document.body.appendChild(el); }
      el.innerHTML = `<div class="stp-card2"><div class="stp-h">${T('有名鬼（每隻獨一無二）', '有名鬼（每隻獨一無二）')}<small>${on.length ? T(`本圖已上場：${on.map(g => g.name).join('、')}`, `本圖已上場：${on.map(g => g.name).join('、')}`) : T('唔使佔格，會喺1號房出現，沿成條路來回巡邏；附近有人就停低放招。', '不用佔格，會在1號房出現，沿整條路來回巡邏；附近有人就停下放招。')}<br>${T(`每張地圖最多 ${BOSS_MAX} 隻；一隻鬼同一時間只可以喺一個地盤。`, `每張地圖最多 ${BOSS_MAX} 隻；一隻鬼同一時間只能在一個地盤。`)}</small></div><div class="stp-two stp-three">`
        + list.map(g => { const isOn = on.some(o => o.id === g.id), K = Object.assign({}, bsk(g.k), { n:this.lore(g.k).n, r:this.lore(g.k).r, last:6 }); return `<div class="stp-opt ${isOn ? 'on' : ''}"><div class="stp-frame"><canvas data-pk="${g.k}"></canvas></div><b>${g.name}</b><span class="stp-ico">${T(K.n[0], K.n[1])}</span><small>${T(`範圍 ${K.r}・停低 ${K.last} 秒・冷卻 ${BOSS_CD} 秒`, `範圍 ${K.r}・停下 ${K.last} 秒・冷卻 ${BOSS_CD} 秒`)}</small><button class="stp-buy" data-sp="${g.id}" ${!isOn && on.length >= BOSS_MAX ? 'disabled' : ''}>${isOn ? T('收工', '收工') : T('派佢上場', '派牠上場')}</button></div>`; }).join('') + `</div><button id="stp-x" class="stp-x">${T('關閉', '關閉')}</button></div>`;
      el.querySelectorAll('canvas[data-pk]').forEach(cv => { try { const im = ART.portrait(cv.dataset.pk, 80); cv.width = 80; cv.height = 80; cv.getContext('2d').drawImage(im, 0, 0, 80, 80); } catch (e) {} });
      el.querySelectorAll('[data-sp]').forEach(b2 => b2.onclick = () => { const g = ghost(+b2.dataset.sp) || ghost(b2.dataset.sp); if (!g) return;
        if (sd.bosses.includes(g.id)) { sd.bosses = sd.bosses.filter(x => x !== g.id); g.post = null; Fx.toast(T(`${g.name} 收工`, `${g.name} 收工`)); }
        else if (sd.bosses.length < BOSS_MAX) { sd.bosses.push(g.id); g.post = 'boss:' + this.def.id; Fx.toast(T(`本圖已上場：${g.name}`, `本圖已上場：${g.name}`)); }
        el.remove(); save_(); });
      el.querySelector('#stp-x').onclick = () => el.remove(); el.onclick = (e) => { if (e.target === el) el.remove(); };
    },
    SKILL:{ tianhua:['垂髮纏人', '垂髮纏人'], pontianak:['尖笑震波', '尖笑震波'], eguiking:['張口一咬', '張口一咬'], laojiang:['跳屍衝撞', '跳屍衝撞'], toyol:['偷錢', '偷錢'], xiaozhi:['紙人圍堵', '紙人圍堵'], penanggal:['飛頭俯衝', '飛頭俯衝'] },
    specialTick(dt) {
      const sd = this.sd; if (sd.special == null) { this.special = null; return; } const g = ghost(sd.special); if (!g) { sd.special = null; return; }
      const SP = this.special || (this.special = { g, t:this.len * 0.25, dir:1, cd:3, en:sd.spEn || 0, fx:null });
      SP.g = g; const live = this.walkers.filter(w => !w.gone && w.t > 0), me = this.at(SP.t), near = live.map(w => [w, this.dist(this.wp(w), me)]).sort((a, z) => a[1] - z[1]);
      if (!SP.fx) { SP.t += SP.dir * 0.05 * dt * (near.length && near[0][1] < 0.25 ? 0.3 : 1); if (SP.t > this.len * 0.92) SP.dir = -1; if (SP.t < 0.05) SP.dir = 1; }
      SP.cd -= dt; if (SP.fx) { SP.fx.t += dt; if (SP.fx.t > 1.2) SP.fx = null; }
      if (SP.cd > 0 || !near.length || near[0][1] > 0.4) return; SP.cd = 5; const P = power(g) * 3.2, k = g.k;
      const F = SP.fx = { t:0, k, at:me.slice(), tg:this.wp(near[0][0]).slice() }; SP.en = Math.min(100, SP.en + 14); sd.spEn = SP.en; this.focusOn(me[0], me[1]);
      if (k === 'tianhua') { near.filter(x => x[1] < 0.3).slice(0, 3).forEach(([w]) => { w.block = 1.8; w.hair = 1.8; this.hit(w, P * 1.1, g, null); }); }
      else if (k === 'pontianak') { near.filter(x => x[1] < 0.3).forEach(([w]) => { this.hit(w, P * 0.9, g, null); w.t = Math.max(0.01, w.t - 0.06); }); }
      else if (k === 'eguiking' || k === 'egui') { this.hit(near[0][0], P * 2.6, g, null); }
      else if (k === 'laojiang') { const t0 = SP.t; SP.t = Math.min(this.len * 0.92, SP.t + 0.3); F.from = this.at(t0); live.forEach(w => { const pw = this.wp(w); for (let q = 0; q <= 1; q += 0.1) if (this.dist(pw, this.at(t0 + 0.3 * q)) < 0.09) { this.hit(w, P * 1.4, g, null); break; } }); }
      else if (k === 'toyol') { near.filter(x => x[1] < 0.3).forEach(([w]) => { if (!w.crew) { S.res.coins = (S.res.coins || 0) + 5; const [x, y] = this.wp(w); this.parts.push({ kind:'coin', x, y:y - 0.05, life:1, k:0 }); } this.hit(w, P * 0.4, g, null); }); }
      else if (k === 'xiaozhi') { near.filter(x => x[1] < 0.3).slice(0, 4).forEach(([w]) => { w.block = 2; w.papers = 2; this.hit(w, P * 0.6, g, null); }); }
      else { this.hit(near[0][0], P * 1.5, g, null); }
    },
    drawSpecial() {
      const c = this.c, b = this.box, t = performance.now() / 1000, hh = b.h * 0.085 * 1.4;
      for (const B of this.bosses || []) { if (B.hid) continue;
        const F = B.fx, pos = this.bpos(B), [x, y] = this.P(...pos), A = this.lay.nodes[B.a], C = this.lay.nodes[B.b] || A, flip = (C[0] - A[0]) < -0.001, sc = hh * 1.35 / 60;
        c.save(); c.fillStyle = 'rgba(160,110,255,0.25)'; c.beginPath(); c.ellipse(x, y, hh * 0.35, hh * 0.1, 0, 0, 7); c.fill(); c.restore();
        if (B.ph === 'omen') { const rr = this.lore(B.g.k).r * PX * b.w; c.strokeStyle = 'rgba(200,150,255,0.35)'; c.setLineDash([4, 6]); c.lineWidth = 2; c.beginPath(); c.ellipse(x, y, rr, rr / 1.5, 0, 0, 7); c.stroke(); c.setLineDash([]); }
        let pose = 'move', pt = 0, rot = 0, gx = x, gy = y, alpha = 0.92; const LO = this.drawLoreFx(B, x, y, hh); if (LO) { gx = LO.gx; gy = LO.gy; rot = LO.rot || 0; if (LO.alpha) alpha = LO.alpha; }
        if (B.ph === 'omen') { alpha = 0.55 + 0.3 * Math.sin(t * 6); pose = 'idle'; }
        if (F) { const k = Math.min(1, F.t / 0.9), [tx, ty] = this.P(...F.tg); pose = k < 0.3 ? 'windup' : 'strike'; pt = k < 0.3 ? k / 0.3 : Math.min(1, (k - 0.3) * 2);
          if (F.k === 'eguiking' || F.k === 'egui' || F.k === 'penanggal') { const e = Math.sin(Math.min(1, k * 1.5) * Math.PI); gx = x + (tx - x) * e * 0.8; gy = y + (ty - y) * e * 0.8; }
          if (F.k === 'pontianak') for (let j = 0; j < 3; j++) { const rr = (k * 1.5 + j * 0.25) % 1; c.strokeStyle = `rgba(255,170,220,${0.8 * (1 - rr)})`; c.lineWidth = 4; c.beginPath(); c.arc(x, y - hh * 0.5, rr * 220 * PX * b.w, 0, 7); c.stroke(); }
          if (F.k === 'tianhua') { c.strokeStyle = 'rgba(160,150,170,0.7)'; c.lineWidth = 2; for (let j = 0; j < 14; j++) { const xx = tx - 40 + j * 6, len = Math.min(1, k * 2) * (ty - b.y + 10); c.beginPath(); c.moveTo(xx, b.y); c.quadraticCurveTo(xx + Math.sin(t * 3 + j) * 10, b.y + len * 0.6, xx, b.y + len); c.stroke(); } }
          if (F.k === 'laojiang') gy -= Math.abs(Math.sin(k * Math.PI * 4)) * 24;
          if (F.k === 'eguiking' && k > 0.3 && k < 0.7) { c.fillStyle = '#2a0306'; c.beginPath(); c.ellipse(tx, ty - hh * 0.5, 26, 20, 0, 0, 7); c.fill(); c.fillStyle = '#efe6cf'; for (let j = 0; j < 5; j++) { c.beginPath(); c.moveTo(tx - 20 + j * 10, ty - hh * 0.5 - 18); c.lineTo(tx - 15 + j * 10, ty - hh * 0.5 - 6); c.lineTo(tx - 10 + j * 10, ty - hh * 0.5 - 18); c.fill(); } }
          if (F.k === 'xiaozhi') for (let j = 0; j < 4; j++) { const a2 = j * 1.57 + t; try { ART.drawChar(c, 'xiaozhi', tx + Math.cos(a2) * 26, ty + Math.sin(a2) * 10, 0.45 * (b.w / 390), { t:t + j, pose:'idle', alpha:0.8 * (1 - k * 0.6), flip:Math.cos(a2) > 0, shadow:false }); } catch (e) {} }
          if (F.k === 'toyol') { gx = x + (tx - x) * Math.sin(k * Math.PI); gy = y + (ty - y) * Math.sin(k * Math.PI) - Math.abs(Math.sin(k * 12)) * 10; pose = 'move'; } }
        try { ART.drawChar(c, B.g.k, gx, gy, sc, { t, walk:!F && !(B.stay > 0), pose:B.stay > 0 && !F && B.ph !== 'omen' ? 'idle' : pose, pt, atk:!!F, alpha, flip, rot, shadow:false }); } catch (e) {}
        const en = B.en || 0; c.strokeStyle = 'rgba(0,0,0,0.6)'; c.lineWidth = 5; c.beginPath(); c.arc(x, y + 14, 10, 0, 7); c.stroke(); c.strokeStyle = en >= 100 ? '#ffd45a' : '#c084ff'; c.lineWidth = 3; c.beginPath(); c.arc(x, y + 14, 10, -1.57, -1.57 + 6.283 * en / 100); c.stroke();
        c.font = `bold ${11 * b.w / 390}px sans-serif`; c.textAlign = 'center'; c.lineWidth = 3; c.strokeStyle = '#000'; const lab = B.g.name + (en >= 100 ? T('・撳放大招！', '・點放大招！') : B.stay > 0 ? `・${T(this.lore(B.g.k).n[0], this.lore(B.g.k).n[1])}` : ''); c.strokeText(lab, x, y - hh * 1.45); c.fillStyle = en >= 100 ? '#ffe9a0' : '#e6c8ff'; c.fillText(lab, x, y - hh * 1.45);
        B.screen = [x, y - hh * 0.5]; }
    },
    say(w, big) {
      const now = performance.now(); if (w.say || (!big && now - (w.sayAt || 0) < 1800)) return; w.sayAt = now;
      const POOL = w.crew ? [['邪魔外道，退散！', '邪魔外道，退散！'], ['邊個喺度搞鬼？', '誰在這裡搞鬼？'], ['家人們睇下，真係有嘢呀！', '家人們看，真的有東西！']]
        : big ? [['有鬼呀——！', '有鬼啊——！'], ['我唔玩喇！', '我不玩了！'], ['阿媽救命！', '媽媽救命！'], ['走呀走呀！', '快跑快跑！'], ['我以後唔夜返喇！', '我以後不晚歸了！']]
        : [['哇呀！', '哇啊！'], ['咩嚟㗎？', '什麼東西？'], ['唔好嚇我…', '不要嚇我…'], ['頭先係咪有嘢？', '剛剛是不是有東西？'], ['咦？好凍…', '咦？好冷…']];
      const used = new Set(this.walkers.filter(x => x.say).map(x => x.say.s)), opts = POOL.filter(q => !used.has(T(q[0], q[1])));
      if (!opts.length) return; const q = pick(opts); w.say = { s:T(q[0], q[1]), t:big ? 1.4 : 1.1 };
    },
    draw() {
      const c = this.c, b = this.box, Wd = innerWidth, Hd = innerHeight, t = performance.now() / 1000; c.fillStyle = '#0d0a14'; c.fillRect(0, 0, Wd, Hd);
      c.save(); c.beginPath(); c.rect(b.x, b.y, b.w, b.h); c.clip(); if (this.shake > 0) c.translate((Math.random() - 0.5) * 10 * this.shake / 0.28, (Math.random() - 0.5) * 8 * this.shake / 0.28);
      this.camStep(); const cam = this.cam; c.translate(b.x + b.w / 2, b.y + b.h / 2); c.scale(cam.z, cam.z); c.translate(-(b.x + cam.x * b.w), -(b.y + cam.y * b.h));
      if (this.lay.long) this.drawLongBg(); const bg = !this.lay.long && has(SPR) && SPR[this.lay.bg];
      if (bg && bg.naturalWidth) { c.save(); c.filter = `${!this.def.hue ? 'brightness(0.92) saturate(0.9)' : 'brightness(0.62) saturate(0.7) contrast(1.1)'}${this.def.hue ? ` hue-rotate(${this.def.hue}deg)` : ''}`; c.drawImage(bg, b.x, b.y, b.w, b.h); c.restore(); }
      if (!this.lay.long) { c.fillStyle = !this.def.hue ? 'rgba(20,40,40,0.12)' : 'rgba(30,50,110,0.22)'; c.fillRect(b.x, b.y, b.w, b.h);
      const vg = c.createRadialGradient(b.x + b.w / 2, b.y + b.h * 0.5, b.w * 0.25, b.x + b.w / 2, b.y + b.h * 0.5, b.h * 0.62); vg.addColorStop(0, 'rgba(0,0,0,0)'); vg.addColorStop(1, 'rgba(5,0,15,0.78)'); c.fillStyle = vg; c.fillRect(b.x, b.y, b.w, b.h); }
      const sd = this.sd, U = b.w / 390, hasArt = has(ART) && ART.drawChar; this._bub = 0;
      const ghostDraw = (k, x, y, sc, o) => { if (hasArt) try { ART.drawChar(c, k, x, y, sc, Object.assign({ shadow:false }, o)); return; } catch (e) {} };
      // 範圍與氛圍
      this.lay.posts.forEach((s, i) => { const p = sd.posts[i]; if (!p || !p.role || p.build > 0) return; const S0 = DEV[p.role][p.sz || 1], [x, y] = this.P(s.x, s.y);
        const rr = (p.role === 'throw' ? 0 : p.role === 'slow' ? S0.area[(p.lv || 1) - 1] * CELL * 0.85 : (p.role === 'aura' ? S0.eff : S0.check) * PX) + CELL * (p.sz === 2 ? 0.8 : 0.5); if (!rr) return;
        if ((p.role === 'aura' || p.role === 'slow') && p.auraOn > 0) { const rg = c.createRadialGradient(x, y, 4, x, y, rr * b.w); rg.addColorStop(0, p.role === 'slow' ? 'rgba(110,170,255,0.26)' : 'rgba(170,220,255,0.2)'); rg.addColorStop(1, 'rgba(120,160,255,0)'); c.fillStyle = rg; c.beginPath(); c.ellipse(x, y, rr * b.w, rr * b.w / 1.5, 0, 0, 7); c.fill(); }
        if (p.win && p.role !== 'aura') { const re = (S0.eff * PX + CELL * 0.5) * b.w, k = 1 - p.win.t / (Math.max(1, S0.dl) / 60); c.strokeStyle = `rgba(255,120,90,${0.7 * (1 - k)})`; c.lineWidth = 3; c.beginPath(); c.ellipse(x, y, re * (0.6 + 0.4 * k), re * (0.6 + 0.4 * k) / 1.5, 0, 0, 7); c.stroke(); }
        c.strokeStyle = 'rgba(190,160,255,0.16)'; c.setLineDash([3, 6]); c.lineWidth = 1.5; c.beginPath(); c.ellipse(x, y, rr * b.w, rr * b.w / 1.5, 0, t * 0.3, t * 0.3 + 6.283); c.stroke(); c.setLineDash([]); });
      // 建造格（照原作：橙＝地面、紫＝高處，150px 一格）
      const cell = this.lay.grid ? Math.min(this.lay.grid.cw * b.w, this.lay.grid.ch * b.h) * 0.92 : b.w / 7.2;
      if (this.lay.grid) { const G = this.lay.grid; for (let yy = 0; yy < 10; yy++) for (let xx = 0; xx < 6; xx++) { const tt = G.ty(xx, yy), px = b.x + (G.x0 + xx * G.cw) * b.w, py = b.y + (G.y0 + yy * G.ch) * b.h; if (tt === 3 || tt === 4) { c.strokeStyle = 'rgba(200,220,210,0.10)'; c.lineWidth = 1; c.strokeRect(px + 1, py + 1, G.cw * b.w - 2, G.ch * b.h - 2); } } }
      this.lay.posts.forEach((s, i) => { const p = sd.posts[i], [x, y] = this.P(s.x, s.y), q = this.rect(s), x0 = b.x + q[0] * b.w + 2, y0 = b.y + q[1] * b.h + 2, cw = (q[2] - q[0]) * b.w - 4, ch = (q[3] - q[1]) * b.h - 4, col = s.h ? [168, 104, 200] : [214, 138, 58], cs = Math.min(cw, ch);
        if (this.moveFrom != null) { const A = this.lay.posts[this.moveFrom]; if (i !== this.moveFrom && A.h === s.h && (A.s || 1) === (s.s || 1)) { c.strokeStyle = `rgba(255,233,160,${0.5 + 0.5 * Math.sin(t * 6)})`; c.lineWidth = 4; c.strokeRect(x0 - 3, y0 - 3, cw + 6, ch + 6); } }
        if (!p || !p.role) { const pu = 0.8 + 0.2 * Math.sin(t * 2.5 + i); c.fillStyle = `rgba(${col[0]},${col[1]},${col[2]},${0.62 * pu})`; c.fillRect(x0, y0, cw, ch); c.setLineDash([6, 4]); c.strokeStyle = 'rgba(255,240,210,0.9)'; c.lineWidth = 2; c.strokeRect(x0 + 2, y0 + 2, cw - 4, ch - 4); c.setLineDash([]);
          c.fillStyle = '#fff6e6'; c.textAlign = 'center'; c.font = `900 ${cs * 0.42}px sans-serif`; c.lineWidth = 3; c.strokeStyle = 'rgba(60,30,10,0.8)'; c.strokeText('+', x, y + cs * 0.08); c.fillText('+', x, y + cs * 0.08); c.font = `bold ${cs * 0.2}px sans-serif`; const lb = (s.s === 2 ? T('2格・', '2格・') : '') + T('建造', '建造'); c.strokeText(lb, x, y + cs * 0.38); c.fillText(lb, x, y + cs * 0.38); return; }
        c.strokeStyle = `rgba(${col[0]},${col[1]},${col[2]},0.6)`; c.lineWidth = 2; c.strokeRect(x0, y0, cw, ch);
        if (p.build > 0) { const k = 1 - p.build / ((p.lv || 1) > 1 ? 3 : 5); c.fillStyle = 'rgba(0,0,0,0.6)'; c.fillRect(x0, y0 - 14 * U, cw, 9 * U); c.fillStyle = '#7fd38f'; c.fillRect(x0, y0 - 14 * U, cw * Math.max(0, k), 9 * U); c.fillStyle = '#fff'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'left'; c.fillText((p.lv || 1) > 1 ? T('升級中…', '升級中…') : T('建造中…', '建造中…'), x0, y0 - 18 * U); }
        else if (p.role === 'puzzle' && p.ph != null) { const L0 = DEV.puzzle[p.sz || 1].lv[(p.lv || 1) - 1], mx = L0[1] * this.staffMul(p).hp, kk = p.solved > 0 ? 1 - p.solved / L0[4] : Math.max(0, p.ph) / mx; c.fillStyle = 'rgba(0,0,0,0.7)'; c.fillRect(x0, y0 + ch - 9 * U, cw, 7 * U); c.fillStyle = p.solved > 0 ? '#6a6a7a' : '#c084ff'; c.fillRect(x0, y0 + ch - 9 * U, cw * kk, 7 * U);
          c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'center'; c.fillStyle = p.solved > 0 ? '#bbb' : '#f0dcff'; c.lineWidth = 3; c.strokeStyle = '#000'; const tx2 = p.solved > 0 ? T(`重置 ${Math.ceil(p.solved)}秒`, `重置 ${Math.ceil(p.solved)}秒`) : `${Math.max(0, Math.round(p.ph))}/${Math.round(mx)}`; c.strokeText(tx2, x, y0 + ch - 12 * U); c.fillText(tx2, x, y0 + ch - 12 * U); }
        else if (p.role !== 'aura' && p.role !== 'slow' && !p.win && p.anim == null) { const L0 = DEV[p.role][p.sz || 1].lv[(p.lv || 1) - 1], k = Math.min(1, (p.cd || 0) / (L0[3] * this.staffMul(p).cd)); if (k < 1) { c.fillStyle = 'rgba(0,0,0,0.6)'; c.fillRect(x0, y0 + ch - 6 * U, cw, 4 * U); c.fillStyle = '#e8c070'; c.fillRect(x0, y0 + ch - 6 * U, cw * k, 4 * U); } }
        c.fillStyle = 'rgba(20,20,24,0.8)'; c.fillRect(x0, y0 - 2, 30 * U, 14 * U); c.fillStyle = '#ffe9b0'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'left'; c.fillText('Lv' + (p.lv || 1), x0 + 3 * U, y0 + 9 * U);
        if (p.staff != null) { c.fillStyle = '#9ef0b0'; c.fillText('★', x0 + 33 * U, y0 + 9 * U); }
        if ((S.res.coins || 0) >= this.upCost(p) && !(p.build > 0)) { c.fillStyle = '#e8303a'; c.beginPath(); c.arc(x0 + cw - 4 * U, y0 + 2 * U, 5 * U, 0, 7); c.fill(); c.strokeStyle = '#fff'; c.lineWidth = 1.5; c.stroke(); } });
      this.drawTraces();
      // 路人（含 Bryan 一夥）
      const NU = typeof NPC_UNIT !== 'undefined' ? NPC_UNIT : 69, hh = b.h * 0.085 * 1.4;
      const list = this.walkers.filter(w => w.t >= 0 && (w.gone || !this.wseg(w).hide)).map(w => { let [x, y] = this.P(...this.wp(w)); if (w.gone === 'suck') { const e = Math.min(1, w.suckT / 1.0), e2 = e * e, [ax, ay] = this.P(...w.suckFrom), [tx2, ty2] = this.ult && this.ult.mouthXY ? this.ult.mouthXY : this.P(...w.suckTo); x = ax + (tx2 - ax) * e2 + Math.sin(e * 12) * 10 * (1 - e); y = ay + (ty2 - ay) * e2; } if (!w.gone) { const of = this.wOff(w, U); x += of[0]; y += of[1]; w._rot = of[2]; } else w._rot = 0; return [y, w, x]; }).sort((a, z) => a[0] - z[0]);
      for (const [y0, w, x0] of list) {
        let x = x0, y = y0, a = 1; const run = w.gone === 'run', suck = w.gone === 'suck'; if (run) a = w.runT < 1.5 ? 1 : Math.max(0, 1 - (w.runT - 1.5) / 0.5); const ssc = suck ? Math.max(0.05, 1 - w.suckT) : 1;
        const react = w.react > 0 ? w.react / 0.6 : 0, lift = Math.sin(react * Math.PI) * hh * 0.35, spin = w.spin > 0;
        const right = run ? ((w.runPath && w.runPath.length > 1 ? w.runPath[1][0] - w.runPath[0][0] : 0) < 0) : (this.wp(w, 0.01)[0] - this.wp(w)[0]) >= 0;
        c.save(); c.globalAlpha = a;
        c.fillStyle = 'rgba(0,0,0,0.4)'; c.beginPath(); c.ellipse(x, y, hh * 0.24, hh * 0.06, 0, 0, 7); c.fill();
        if (w.frost > 0) { c.strokeStyle = 'rgba(140,200,255,0.9)'; c.lineWidth = 2; for (let j = 0; j < 3; j++) { c.beginPath(); c.ellipse(x, y - hh * (0.2 + j * 0.25), hh * 0.3, hh * 0.07, 0, t * 2 + j, t * 2 + j + 4.5); c.stroke(); } }
        if (spin) { for (let j = 0; j < 4; j++) { const ang = t * 3 + j * 1.57, rx = x + Math.cos(ang) * hh * 0.7, ry = y - hh * 0.4 + Math.sin(ang) * hh * 0.25; c.fillStyle = 'rgba(120,80,170,0.35)'; c.fillRect(rx - hh * 0.12, ry - hh * 0.45, hh * 0.24, hh * 0.7); } }
        c.translate(x + (react ? (Math.random() - 0.5) * 3 : 0), y - lift); if (suck) { c.scale(ssc, ssc); c.rotate(w.suckT * 8); } if (spin) c.scale(Math.cos(t * 9) >= 0 ? 1 : -1, 1); if (w._rot) { c.translate(0, -hh * 0.4); c.rotate(w._rot); c.translate(0, hh * 0.4); }
        if (w.hair > 0) { w.hair -= 1 / 30; }
        if (run && w.fall == null) w.fall = Math.random() < 0.35; const falling = run && w.fall && w.runT < 0.45;
        const pose = suck ? 'startle' : falling ? 'cower' : run ? 'run' : react > 0 ? (w.weak2 = w.weak2 || (Math.random() < 0.4 ? 'tremble' : 'startle')) : (w.act ? w.act.pose : w.lift || w.fly ? 'startle' : w.chase ? 'run' : w.stay > 0 ? 'startle' : w.block > 0 ? 'cower' : w.back > 0 ? 'run' : w.fear > 0 ? 'tremble' : 'move'), face = run || react > 0 ? 't' : (w.gone === 'out' ? 'n' : undefined);
        let ok = false; if (hasArt && CHAR_H_OK(w.spr)) { try { ART.drawChar(c, w.spr, 0, 0, hh / NU, { t:t + (w.seed || (w.seed = Math.random() * 9)), pose, pt:react ? 1 - react : 0, face, walk:!react && !(w.stay > 0) && !(w.block > 0) && !(w.act && w.act.hold), flip:run || w.back > 0 || w.rev > 0 ? right : !right, shadow:false }); ok = true; } catch (e) {} }
        if (!ok) { const im = has(SPR) && SPR[w.spr]; if (im && im.naturalWidth) { const ww = hh * im.naturalWidth / im.naturalHeight, bob = Math.abs(Math.sin(t * 8 + (w.seed || 0))) * 2; c.drawImage(im, -ww / 2, -hh - bob, ww, hh); } }
        c.restore(); c.save(); c.globalAlpha = a;
        if (w.crew) { // 搞事動畫
          c.font = `bold ${11 * U}px sans-serif`; c.textAlign = 'center'; c.lineWidth = 3; c.strokeStyle = '#000'; c.strokeText(w.n, x, y - hh - 16 * U); c.fillStyle = w.crew.tag; c.fillText(w.n, x, y - hh - 16 * U);
          if (w.atkFx) { const P0 = this.lay.posts[w.atkFx.i], [px, py] = this.P(P0.x, P0.y), k = 1 - w.atkFx.t / 0.6;
            if (w.crew.n === '天師') { for (let j = 0; j < 3; j++) { const rr = (k * 1.2 + j * 0.3) % 1; c.strokeStyle = `rgba(255,210,90,${1 - rr})`; c.lineWidth = 3; c.beginPath(); c.arc(x + hh * 0.25, y - hh * 0.8, rr * 40 * U, -1, 1); c.stroke(); } c.fillStyle = '#ffd45a'; c.font = `bold ${12 * U}px sans-serif`; c.fillText('叮鈴！', x + 18 * U, y - hh * 1.05); }
            else { const g2 = c.createLinearGradient(x, y - hh * 0.6, px, py); g2.addColorStop(0, w.crew.n === '保安' ? 'rgba(255,250,200,0.7)' : 'rgba(255,255,255,0.85)'); g2.addColorStop(1, 'rgba(255,255,220,0)'); c.fillStyle = g2; c.beginPath(); c.moveTo(x, y - hh * 0.6); c.lineTo(px - 18 * U, py - 10 * U); c.lineTo(px + 18 * U, py + 10 * U); c.closePath(); c.fill();
              if (w.crew.n !== '保安' && k < 0.3) { c.fillStyle = 'rgba(255,255,255,0.7)'; c.beginPath(); c.arc(x + 10 * U, y - hh * 0.7, 12 * U, 0, 7); c.fill(); c.fillStyle = '#ff4d6a'; c.font = `bold ${10 * U}px sans-serif`; c.fillText('● LIVE', x, y - hh * 1.15); } } } }
        if (!w.gone) { const bw = hh * 0.62; c.fillStyle = 'rgba(0,0,0,0.65)'; c.fillRect(x - bw / 2, y - hh - 9 * U, bw, 5 * U); c.fillStyle = w.crew ? '#ff8a5a' : '#6ec3ff'; c.fillRect(x - bw / 2, y - hh - 9 * U, bw * Math.max(0, w.hp / w.max), 5 * U); }
        if (react <= 0) w.weak2 = null;
        if (w.pulled > 0) { w.pulled -= 1 / 30; c.strokeStyle = `rgba(192,132,255,${w.pulled})`; c.lineWidth = 3; for (let j = 0; j < 2; j++) { c.beginPath(); c.arc(x, y - hh * 0.5, (14 + j * 9) * U, t * 5 + j, t * 5 + j + 4.5); c.stroke(); } }
        if ((react > 0 || w.stay > 0) && !w.crew) { c.fillStyle = '#ffe14a'; c.font = `900 ${18 * U}px sans-serif`; c.textAlign = 'center'; c.lineWidth = 4; c.strokeStyle = '#2a1006'; c.strokeText('!', x + hh * 0.32, y - hh - 14 * U - lift); c.fillText('!', x + hh * 0.32, y - hh - 14 * U - lift); }
        if (w.say && (this._bub = (this._bub || 0) + 1) <= 3) { const s2 = w.say.s; c.font = `bold ${12 * U}px sans-serif`; const tw = c.measureText(s2).width + 12 * U, bx = Math.max(b.x + 4, Math.min(b.x + b.w - tw - 4, x - tw / 2)), by = y - hh - 40 * U - lift;
          c.fillStyle = 'rgba(255,250,235,0.95)'; c.strokeStyle = '#3a2212'; c.lineWidth = 2; c.beginPath(); c.roundRect ? c.roundRect(bx, by, tw, 20 * U, 8 * U) : c.rect(bx, by, tw, 20 * U); c.fill(); c.stroke();
          c.fillStyle = '#3a2212'; c.textAlign = 'left'; c.textBaseline = 'middle'; c.fillText(s2, bx + 6 * U, by + 10 * U); c.textBaseline = 'alphabetic'; }
        c.restore();
      }
      this.drawSpecial();
      // 崗位上的鬼（潛伏 + 出手）
      this.lay.posts.forEach((s, i) => { const p = sd.posts[i]; if (!p || p.g == null) return; let g = ghost(p.g); if (!g) return; if (p.role) g = Object.assign({}, g, { k:this.devK(p) });
        const type = p.role ? DEV[p.role].kind : gType(g), K = KIND[type], [x, y] = this.P(s.x, s.y), base = hh * 1.3 / 60 * (p.sz === 2 ? 1.3 : 1), fx = p.fx; if (p.build > 0) return;
        const tx = fx ? this.P(fx.tx, fx.ty)[0] : x, flip = fx ? tx < x : Math.sin(t * 0.4 + i) < 0;
        let gx = x, gy = y + 10 * U, sc = base, al = 0.62 + 0.14 * Math.sin(t * 1.6 + i), pose = 'idle', pt = 0, rot = Math.sin(t * 1.3 + i) * 0.04;
        if (s.h) gy += Math.sin(t * 1.5 + i) * 3 * U; else sc *= 1 + Math.sin(t * 2 + i) * 0.02;
        if (p.hurt > 0) { p.hurt -= 1 / 30; gx += (Math.random() - 0.5) * 6 * U; }
        if ((p.role === 'aura' || p.role === 'slow') && p.auraOn > 0) { al = 0.75; pose = 'cast'; pt = (t * 0.8) % 1; gx += Math.sin(t * 2.2 + i) * 8 * U; for (let j = 1; j <= 3; j++) ghostDraw(g.k, gx - Math.sin(t * 2.2 + i - j * 0.25) * 8 * U * j * 0.6, gy, sc, { t, pose, pt, alpha:0.12 / j, flip }); }
        if (fx) { const k = Math.min(1, fx.t / 0.9), hit = k < 0.25 ? k / 0.25 : 1 - (k - 0.25) / 0.75; al = 0.95 * (1 - Math.max(0, k - 0.8) * 4); pose = k < 0.25 ? 'windup' : 'strike'; pt = k < 0.25 ? k / 0.25 : Math.min(1, (k - 0.25) * 2);
          const dx = (tx - x), dy = (this.P(fx.tx, fx.ty)[1] - y);
          if (fx.aura) { if (fx.v) { gx += dx * hit * 0.7; gy += dy * hit * 0.7; rot = Math.sin(t * 9) * 0.2; } else { sc *= 1 + hit * 0.35; rot = hit * 0.6 * Math.sin(k * 12); } pose = 'cast'; }
          else if (fx.type === 'sound' && fx.v) { gy -= (1 - Math.min(1, k * 3)) * 70 * U; rot = (1 - Math.min(1, k * 3)) * 3; sc *= 1 + hit * 0.2; c.save(); }
          else if (fx.type === 'sound') { gy += (1 - Math.min(1, k * 3)) * 26 * U; sc *= 1 + hit * 0.25; c.save(); c.beginPath(); c.rect(x - 80 * U, y - 160 * U, 160 * U, 160 * U + 12 * U); c.clip(); }
          else if ((fx.type === 'face' || fx.type === 'shadow') && fx.v) { gx = tx + (flip ? 1 : -1) * 18 * U; gy = this.P(fx.tx, fx.ty)[1] + 4 * U; sc *= 0.4 + hit * 1.1; al *= Math.min(1, k * 5); rot = Math.sin(t * 30) * 0.05 * hit; }
          else if (fx.type === 'face' || fx.type === 'shadow') { gx += dx * hit * 0.55; gy += dy * hit * 0.55; sc *= 1 + hit * 0.9; rot = (flip ? -1 : 1) * hit * 0.15; }
          else if (fx.type === 'phone' && fx.v) { pose = 'cast'; const sp = k < 0.5 ? k * 2 : 1; gx = x + dx * sp; gy = y + 10 * U + dy * sp; rot = sp * 6.28; al *= 0.4 + 0.6 * Math.abs(Math.cos(k * 9)); }
          else if (fx.type === 'phone') { pose = 'cast'; }
          else if (fx.type === 'paper') { pose = k < 0.3 ? 'windup' : 'cast'; }
          if (g.k === 'toyol') { const e3 = Math.sin(k * Math.PI); gx = x + dx * e3; gy = y + 10 * U + dy * e3 - (fx.v ? Math.abs(Math.sin(k * Math.PI * 4)) * 20 * U : 0); pose = 'move'; }
          if (g.k === 'tianhua' && has(SPR) && SPR.tianhua_hang && SPR.tianhua_hang.naturalWidth) { const im = SPR.tianhua_hang, H2 = hh * 2.2, W2 = H2 * im.naturalWidth / im.naturalHeight, drop = Math.sin(Math.min(1, k * 2.5) * Math.PI / 2) * (1 - Math.max(0, k - 0.8) * 5); c.save(); c.globalAlpha = Math.max(0, al); c.translate(tx, y - H2 * 0.4 + drop * (this.P(fx.tx, fx.ty)[1] - y + H2 * 0.15) - H2 * 0.6); c.rotate(Math.sin(t * 7) * 0.08); c.drawImage(im, -W2 / 2, 0, W2, H2); c.restore(); }
          else ghostDraw(g.k, gx, gy, sc, { t, pose, pt, atk:hit > 0.4, alpha:Math.max(0, al), flip, rot });
          if (fx.type === 'sound') c.restore();
          if (fx.type === 'sound' && k > 0.2 && k < 0.8) { const rr = (k - 0.2) / 0.6; c.strokeStyle = `rgba(255,220,120,${1 - rr})`; c.lineWidth = 4; c.beginPath(); c.ellipse(x, y + 6 * U, K.r * b.w * rr, K.r * b.w * rr * 0.45, 0, 0, 7); c.stroke(); }
          if (fx.type === 'phone' && k < 0.9) { c.strokeStyle = `rgba(160,110,220,${0.7 - k * 0.6})`; c.lineWidth = 3; for (let j = 0; j < 5; j++) { const ang = j * 1.256 + t; c.beginPath(); c.moveTo(tx + Math.cos(ang) * 22 * U, this.P(fx.tx, fx.ty)[1] - 30 * U + Math.sin(ang) * 10 * U); c.lineTo(tx + Math.cos(ang) * 30 * U, this.P(fx.tx, fx.ty)[1] - 60 * U + Math.sin(ang) * 12 * U); c.stroke(); } }
          const LINE = { pontianak:'嘻——嘻——', eguiking:'開飯喇！', toyol:'嘻嘻，錢錢～', tianhua:'……', laojiang:'嗚——', xiaozhi:'沙沙沙…' }[g.k];
          if (LINE && k > 0.15 && k < 0.85) { c.font = `900 ${13 * U}px serif`; c.textAlign = 'center'; c.fillStyle = 'rgba(255,215,235,0.95)'; c.lineWidth = 3; c.strokeStyle = '#1a0010'; const lx = Math.max(b.x + 50 * U, Math.min(b.x + b.w - 50 * U, gx)); c.strokeText(T(LINE, LINE), lx, gy - hh * 1.5); c.fillText(T(LINE, LINE), lx, gy - hh * 1.5); }
        } else ghostDraw(g.k, gx, gy, sc, { t, pose, pt, alpha:al, flip, rot });
        const hpK = p.role ? 1 : Math.max(0, p.hp) / p.max; if (hpK < 0.999) { c.fillStyle = 'rgba(0,0,0,0.6)'; c.fillRect(x - 16 * U, y + 14 * U, 32 * U, 4 * U); c.fillStyle = hpK > 0.4 ? '#a8f0a8' : '#ff7a6a'; c.fillRect(x - 16 * U, y + 14 * U, 32 * U * hpK, 4 * U); }
      });
      // 鬼被彈飛
      if (this.blown) { const B = this.blown; B.t += 1 / 30; const [x, y] = this.P(B.x, B.y); if (B.k) ghostDraw(B.k, x + B.t * 120 * U, y - B.t * 160 * U, hh / 60 * (1 - B.t * 0.5), { t, pose:'startle', alpha:Math.max(0, 1 - B.t), rot:B.t * 6, flip:false }); if (B.t > 1) this.blown = null; }
      // 拋物
      for (const s2 of this.shots) { if (s2.t < 0) continue; const [ax, ay] = this.P(...s2.from), [bx, by] = this.P(...s2.to), k = s2.t; c.save(); c.translate(ax + (bx - ax) * k, ay + (by - ay) * k - Math.sin(k * 3.14) * (s2.hi ? 90 : 50) * U); c.rotate(k * 10); c.fillStyle = '#f2ead2'; c.fillRect(-8 * U, -5 * U, 16 * U, 10 * U); c.strokeStyle = '#8a1f1f'; c.lineWidth = 1.5; c.strokeRect(-8 * U, -5 * U, 16 * U, 10 * U); c.fillStyle = '#c0392b'; c.fillRect(-3 * U, -3 * U, 6 * U, 6 * U); c.restore(); c.strokeStyle = 'rgba(242,234,210,0.25)'; c.lineWidth = 2; c.beginPath(); for (let j = 0; j <= 8; j++) { const kk = k * j / 8, px = ax + (bx - ax) * kk, py = ay + (by - ay) * kk - Math.sin(kk * 3.14) * 50 * U; j ? c.lineTo(px, py) : c.moveTo(px, py); } c.stroke(); }
      // 粒子
      const coinEl = $('#stt-coin'), cr = coinEl ? coinEl.getBoundingClientRect() : { left:Wd - 60, top:20, width:40, height:20 }, cx = cr.left + cr.width / 2, cy = cr.top + cr.height / 2;
      for (const q of this.parts) {
        if (q.kind === 'coin') continue; if (false) { const [sx, sy] = this.P(q.x, q.y), e = q.k * q.k, px = sx + (cx - sx) * e, py = sy + (cy - sy) * e - Math.sin(q.k * Math.PI) * 60 * U; c.fillStyle = '#ffd45a'; c.strokeStyle = '#7a4a10'; c.lineWidth = 1.5; c.beginPath(); c.ellipse(px, py, 6 * U * Math.abs(Math.cos(t * 9 + q.x * 50)) + 1, 6 * U, 0, 0, 7); c.fill(); c.stroke(); continue; }
        const [px, py] = this.P(q.x, q.y), al = Math.min(1, q.life);
        if (q.kind === 'mist') { const rg = c.createRadialGradient(px, py, 1, px, py, 18 * U); rg.addColorStop(0, `rgba(200,225,255,${0.25 * al})`); rg.addColorStop(1, 'rgba(200,225,255,0)'); c.fillStyle = rg; c.beginPath(); c.arc(px, py, 18 * U, 0, 7); c.fill(); }
        else if (q.kind === 'smoke') { const rg = c.createRadialGradient(px, py, 1, px, py, 16 * U); rg.addColorStop(0, `rgba(235,235,235,${0.55 * al})`); rg.addColorStop(1, 'rgba(235,235,235,0)'); c.fillStyle = rg; c.beginPath(); c.arc(px, py, 16 * U, 0, 7); c.fill(); }
        else if (q.kind === 'soul') { c.fillStyle = `rgba(190,170,255,${al})`; c.beginPath(); c.arc(px, py, 3 * U, 0, 7); c.fill(); }
        else { c.fillStyle = `rgba(242,234,210,${al})`; c.fillRect(px - 3 * U, py - 2 * U, 6 * U, 4 * U); }
      }
      c.textAlign = 'center';
      for (const f of this.fx) { const [x, y] = this.P(f.x, f.y); c.globalAlpha = Math.max(0, 1 - f.t / 1.2); c.font = `bold ${15 * U}px sans-serif`; c.lineWidth = 4; c.strokeStyle = '#1a0f08'; c.strokeText(f.s, x, y - f.t * 30); c.fillStyle = f.col; c.fillText(f.s, x, y - f.t * 30); }
      if (this.ult) this.drawUltScene();
      this.drawCaps();
      c.globalAlpha = 1; c.restore();
      if (this.tint) { c.fillStyle = this.tint.col; c.globalAlpha = Math.min(1, this.tint.t / 0.4); c.fillRect(0, 0, Wd, Hd); c.globalAlpha = 1; }
      for (const q of this.parts) { if (q.kind !== 'coin' || q.k < 0) continue; const [sx, sy] = this.toScreen(...this.P(q.x, q.y)), e = q.k * q.k, px = sx + (cx - sx) * e, py = sy + (cy - sy) * e - Math.sin(q.k * Math.PI) * 60 * U; c.fillStyle = '#ffd45a'; c.strokeStyle = '#7a4a10'; c.lineWidth = 1.5; c.beginPath(); c.ellipse(px, py, 6 * U * Math.abs(Math.cos(t * 9 + q.x * 50)) + 1, 6 * U, 0, 0, 7); c.fill(); c.stroke(); }
      if (this.flash > 0) { c.fillStyle = `rgba(255,255,255,${this.flash / 0.18 * 0.55})`; c.fillRect(0, 0, Wd, Hd); }
    },
    hud() {
      const sd = this.sd, def = this.def, need = HOT.up * (sd.lv >= def.cap ? HOT.overMul : 1), s0 = st();
      const lv = $('#stt-lv'), coin = $('#stt-coin'), bar = $('#stt-hotbar'), info = $('#stt-info'); if (!lv) return;
      const bd = this.build(); this.bd = bd;
      lv.innerHTML = `${T('主題建設度', '主題建設度')} <b>${bd}%</b>　${T('路人膽量', '路人膽量')} <b>Lv${sd.lv}</b><br>${T('單位收益', '單位收益')} <b>${this.unit()}</b>`;
      const q = this.q, qe = $('#stt-q'), en = $('#stt-enter'); if (qe) qe.textContent = q.st === 'gap' ? T(`下一組 ${Math.ceil(q.t)} 秒`, `下一組 ${Math.ceil(q.t)} 秒`) : q.st === 'form' ? T(`排隊 ${q.made}/${q.n}`, `排隊 ${q.made}/${q.n}`) : T(`${q.n} 人・${Math.ceil(q.t)} 秒自動入`, `${q.n} 人・${Math.ceil(q.t)} 秒自動進`);
      if (en) { en.classList.toggle('autoon', q.st === 'ready'); en.style.setProperty('--qk', q.st === 'ready' ? (1 - q.t / 90).toFixed(3) : 0); }
      const spb = $('#stt-sp'); if (spb) { const on = (sd.bosses || []).map(ghost).filter(Boolean); spb.innerHTML = on.length ? T(`有名鬼<br><b>本圖已上場：${on.map(g => g.name).join('、')}</b>`, `有名鬼<br><b>本圖已上場：${on.map(g => g.name).join('、')}</b>`) : T('有名鬼<br><b>派佢上場</b>', '有名鬼<br><b>派牠上場</b>'); }
      const bx = $('#stt-box'); if (bx) { const n = s0.box == null ? 1 : s0.box; bx.innerHTML = n >= 1 ? T('驚嚇盒<br><b>1/1</b>', '驚嚇盒<br><b>1/1</b>') : T(`驚嚇盒<br><b>${Math.ceil((20 * 60000 - (Date.now() - (s0.boxAt || 0))) / 60000)}分</b>`, `驚嚇盒<br><b>${Math.ceil((20 * 60000 - (Date.now() - (s0.boxAt || 0))) / 60000)}分</b>`); bx.disabled = n < 1; }
      coin.textContent = `${T('冥幣', '冥幣')} ${Math.floor(S.res.coins || 0)}`;
      const k = sd.hot >= 0 ? sd.hot / need : sd.hot / -HOT.down; bar.style.width = Math.abs(k) * 50 + '%'; bar.style.left = k >= 0 ? '50%' : (50 + k * 50) + '%'; bar.className = k >= 0 ? 'up' : 'down';
      info.innerHTML = `<span>${T('傳說名氣', '傳說名氣')} ${Math.round(sd.hot)}/${need}</span><span>${T('惡名', '惡名')} ${sd.scared}</span><span>${T('漏人', '漏人')} ${sd.leaked}</span><span>${T('膽量補正', '膽量補正')} ×${this.mod().toFixed(2)}</span>`;
    },
    tap(e) {
      const r = this.cv.getBoundingClientRect(), [x, y] = this.toScene(e.clientX - r.left, e.clientY - r.top), b = this.box;
      const i = this.lay.posts.findIndex(s => { const q = this.rect(s); return x >= b.x + q[0] * b.w && x <= b.x + q[2] * b.w && y >= b.y + q[1] * b.h && y <= b.y + q[3] * b.h; });
      if (this.moveFrom != null) { const a = this.moveFrom; this.moveFrom = null; if (i < 0 || i === a) { Fx.toast(T('取消移位', '取消移位')); return; } const A = this.lay.posts[a], B = this.lay.posts[i];
        if (A.h !== B.h || (A.s || 1) !== (B.s || 1)) { Fx.toast(T('要同類（牆／路）同大小嘅格先可以互換', '要同類（牆／路）同大小的格才能互換')); return; }
        const t0 = this.sd.posts[a]; this.sd.posts[a] = this.sd.posts[i]; this.sd.posts[i] = t0; [a, i].forEach(k => { const p = this.sd.posts[k]; if (p) { p.win = null; p.anim = null; p.ph = null; p.solved = 0; } }); Fx.toast(T('互換咗位置', '已互換位置')); save_(); return; }
      if (this.tryGate(x, y)) return;
      for (const B of this.bosses || []) if (B.screen && Math.hypot(B.screen[0] - x, B.screen[1] - y) < b.w * 0.09) { if (B.en >= 100 && !this.ult) { B.en = 0; this.sd.bEn[B.g.id] = 0; const g = B.g, pos = this.bpos(B), nm = this.ULT[g.k] || [`${g.name}・怨氣爆發`, `${g.name}・怨氣爆發`]; this.focusOn(pos[0], pos[1]); this.ult = Object.assign({ t:0, i:-1, pos, k:g.k, name:T(nm[0], nm[1]), gname:g.name, pw:power(g), done:false, fx:[] }, this.ULTT[g.k] || {}); this.shake = 0.5; } else Fx.toast(T(`${B.g.name}：能量 ${Math.round(B.en)}%（出招一次 +14）`, `${B.g.name}：能量 ${Math.round(B.en)}%（出招一次 +14）`)); return; }
      if (i >= 0) { this.pickRole(i); return; }
      // 撳路人：每次 1% 膽量（無視減傷），嚇人力 100，每 300 秒回 1
      const hh = this.box.h * 0.072; let best = null, bd = 1e9;
      for (const w of this.walkers) { if (!this.alive(w)) continue; const [wx, wy] = this.P(...this.wp(w)), d = Math.hypot(wx - x, wy - hh * 0.5 - y); if (d < bd) { bd = d; best = w; } }
      if (best && bd < hh * 0.9) { const s0 = st(); if (s0.tapE == null) s0.tapE = 100; if (s0.tapE < 1) { this.float(...this.wp(best), T('嚇人力用晒', '嚇人力用完了'), '#aaa'); return; } if (s0.tapE >= 100) s0.tapAt = Date.now(); s0.tapE--; const sc2 = this.toScreen(x, y); this.tapFx = { x:sc2[0], y:sc2[1], t:0 };
        this.hit(best, Math.ceil(best.max * 0.01), { force:true }); if (has(Sound) && Sound.play) Sound.play('click'); }
    },
    roleTick(i, p, g, dt) {
      const R0 = ROLE[p.role], L0 = LV[R0.lv][(p.lv || 1) - 1], G = this.lay.grid || { cw:this.lay.long ? 150 / 1080 : 0.94 / 7.2 }, u = G.cw / 150, spot = this.lay.posts[i], pos = [spot.x, spot.y];
      const live = this.walkers.filter(w => !w.gone && w.t > 0), d = (w) => this.dist(this.wp(w), pos);
      if (p.hp < p.max) p.hp = Math.min(p.max, p.hp + 2.5 * dt);
      if (R0.puzzle) {
        if (p.ph == null) p.ph = L0[1]; if (p.solved > 0) { p.solved -= dt; if (p.solved <= 0) p.ph = L0[1]; return; }
        const on = live.filter(w => d(w) < G.cw * 0.75); p.idle = on.length ? 0 : (p.idle || 0) + dt; if (p.idle > 12) p.ph = L0[1];
        on.forEach(w => { w.block = 0.25; w.puz = true; p.ph -= 10 * dt; });
        this.cds[i] -= dt; if (on.length && this.cds[i] <= 0) { this.cds[i] = L0[3]; on.forEach(w => this.hit(w, L0[2], g, null, true)); p.en = Math.min(100, (p.en || 0) + 6); if (!p.fx) p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'phone', k:g.k, tx:this.wp(on[0])[0], ty:this.wp(on[0])[1] }; }
        if (p.ph <= 0) { p.solved = L0[4]; on.forEach(w => { w.block = 0; w.puz = false; }); this.float(spot.x, spot.y - 0.05, T('謎題破咗！', '謎題被破解！'), '#9cf'); }
        return;
      }
      if (R0.slowK) { const on = live.filter(w => d(w) < R0.eff * u); on.forEach(w => { w.slow = 0.3; w.slowK = 1 - L0[5]; w.frost = 0.4; }); this.cds[i] -= dt; if (on.length && this.cds[i] <= 0) { this.cds[i] = L0[3]; on.forEach(w => this.hit(w, L0[2], g, null)); p.en = Math.min(100, (p.en || 0) + 8); if (!p.fx) p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'light', k:g.k, tx:this.wp(on[0])[0], ty:this.wp(on[0])[1], aura:true }; } return; }
      this.cds[i] -= dt; if (this.cds[i] > 0) return;
      const inCheck = live.filter(w => d(w) < R0.check * u); if (!inCheck.length) return;
      if (R0.shot) { const tg = pick(inCheck); this.cds[i] = L0[3]; p.en = Math.min(100, (p.en || 0) + 10); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'paper', k:g.k, tx:this.wp(tg)[0], ty:this.wp(tg)[1] }; this.shots.push({ from:[pos[0], pos[1] - 0.05], w:tg, g, type:null, P:L0[2], t:-0.3, aoe:R0.eff * u }); return; }
      const tgts = live.filter(w => d(w) < R0.eff * u); this.cds[i] = L0[3];
      if (R0.aura) { tgts.forEach(w => this.hit(w, L0[2], g, null, true)); p.auraOn = 0.6; p.en = Math.min(100, (p.en || 0) + 1.2); p.flo = (p.flo || 0) - L0[3]; if (p.flo <= 0 && !p.fx) { p.flo = R(3.5, 5.5); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'cold', k:g.k, tx:this.wp(tgts[0])[0], ty:this.wp(tgts[0])[1], aura:true }; } return; }
      this.focusOn(pos[0], pos[1]); p.en = Math.min(100, (p.en || 0) + 14);
      const tg = inCheck.sort((a, b) => b.t - a.t)[0]; p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:R0.kind, k:g.k, tx:this.wp(tg)[0], ty:this.wp(tg)[1] };
      if (R0.kind === 'face') { this.shake = 0.28; this.flash = 0.18; }
      tgts.forEach(w => this.hit(w, L0[2], g, null));
    },
    enter(manual) { if (!this.release(true)) Fx.toast(this.q.st === 'gap' ? T('下一組仲未嚟排隊', '下一組還沒來排隊') : T('排隊嗰組未到齊', '排隊那組還沒到齊')); },
    upCost(p) { const nx = DEV[p.role][p.sz || 1].lv[p.lv || 1]; return nx && (p.lv || 1) < this.lvCap() ? nx[0] : Infinity; },
    stats(g, spot, lv) { const ty = gType(g), K = KIND[ty], fit = (K.ground && !spot.h) || (K.high && spot.h) ? 1.2 : 1, v = power(g) * K.mul * fit * TUNE.dmg * (1 + 0.25 * (lv - 1)); return { ty, K, scare:Math.round(K.aura ? v : v), cd:(K.cd * Math.pow(0.92, lv - 1)).toFixed(2) }; },
    pickRole(i) {
      const sd = this.sd, p = sd.posts[i], spot = this.lay.posts[i], sz = spot.s || 1, cap = this.lvCap();
      let el = $('#stt-pick'); if (!el) { el = document.createElement('div'); el.id = 'stt-pick'; document.body.appendChild(el); }
      const close = () => el.remove(), coins = Math.floor(S.res.coins || 0), szT = sz === 2 ? T('2格', '2格') : T('1格', '1格');
      if (p && p.role) {
        const D = DEV[p.role], lv = p.lv || 1, a = this.statTxt(p.role, sz, lv), nx = lv < cap ? this.statTxt(p.role, sz, lv + 1) : null, cost = this.upCost(p), stf = p.staff != null ? ghost(p.staff) : null;
        const cand = freeGhosts().filter(g => typesOf(g.k).some(t => ROLE_OF[t] === p.role)).slice(0, 6);
        el.innerHTML = `<div class="stp-card1"><div class="stp-top"><canvas data-pk="${this.devK(p)}"></canvas><div><b>${T(D.n[sz][0], D.n[sz][1])}</b><small>${spot.n}・${szT}・Lv${lv}${lv >= cap ? T('（已到上限）', '（已達上限）') : ''}</small><i>${T(D.desc[0], D.desc[1])}</i></div></div>`
          + a.map((r, j) => `<p>${r[0]}：${r[1]}${nx ? ` → <em>${nx[j][1]}</em>` : ''}</p>`).join('')
          + `<p>${T('員工', '員工')}：${stf ? `${stf.name}（${T('驚嚇 ×1.3・整備 ×0.9', '驚嚇 ×1.3・整備 ×0.9')}）` : T('未有（同類型嘅鬼先可以做）', '未有（同類型的鬼才能做）')}</p>`
          + `<div class="stp-row"><button class="stp-buy" id="stp-up" ${!nx || coins < cost || p.build > 0 ? 'disabled' : ''}>${nx ? `${T('升級', '升級')}　💴 ${cost}` : (lv >= 5 ? T('已滿級', '已滿級') : T(`上限 Lv${cap}（開下一間房 +2）`, `上限 Lv${cap}（開下一間房 +2）`))}</button></div>`
          + `<div class="stp-row"><button id="stp-mv">${T('移位', '移位')}</button><button id="stp-del">${T(`拆走（退返 ${p.spent}）`, `拆除（退回 ${p.spent}）`)}</button></div>`
          + `<div class="stp-row stp-staff">${stf ? `<button data-st="off">${T(`叫 ${stf.name} 收工`, `讓 ${stf.name} 收工`)}</button>` : cand.map(g => `<button data-st="${g.id}">${T('請', '請')} ${g.name}</button>`).join('') || `<small>${T('冇得閒又啱類型嘅鬼', '沒有空閒又對口的鬼')}</small>`}</div>`
          + `<div class="stp-row"><button id="stp-x">${T('關閉', '關閉')}</button></div></div>`;
        el.querySelector('#stp-up').onclick = () => { if (!nx || (S.res.coins || 0) < cost) return; S.res.coins -= cost; p.lv = lv + 1; p.spent = (p.spent || 0) + cost; p.ph = null; p.build = 3; close(); save_(); Fx.toast(T('升級中…', '升級中…')); };
        el.querySelector('#stp-del').onclick = () => { S.res.coins = (S.res.coins || 0) + (p.spent || 0); if (stf) stf.post = null; sd.posts[i] = null; close(); save_(); Fx.toast(T(`拆咗，退返冥幣 ${p.spent}`, `已拆除，退回冥幣 ${p.spent}`)); };
        el.querySelector('#stp-mv').onclick = () => { this.moveFrom = i; close(); };
        el.querySelectorAll('[data-st]').forEach(bt => bt.onclick = () => { if (bt.dataset.st === 'off') { if (stf) stf.post = null; p.staff = null; } else { const g = ghost(+bt.dataset.st) || ghost(bt.dataset.st); if (!g) return; if (stf) stf.post = null; p.staff = g.id; g.post = 'street'; Fx.toast(T(`${g.name} 返工：${T(D.n[sz][0], D.n[sz][1])}`, `${g.name} 上班：${D.n[sz][1]}`)); } close(); save_(); });
      } else {
        const roles = spot.h ? WALL_ROLES : ROAD_ROLES;
        el.innerHTML = `<div class="stp-card2"><div class="stp-h">${spot.n}・${szT}<small>${spot.h ? T('牆崗：只可以放 驚嚇／氛圍／投擲', '牆崗：只能放 驚嚇／氛圍／投擲') : T('路崗：只可以放 陷阱／解謎／減速', '路崗：只能放 陷阱／解謎／減速')}${sz === 2 ? T('・2格槽只放得落2格裝置', '・2格槽只放得下2格裝置') : ''}</small></div><div class="stp-two stp-three">` + roles.map(r => { const D = DEV[r], pr = D[sz].lv[0][0], st2 = this.statTxt(r, sz, 1);
            return `<div class="stp-opt"><div class="stp-frame"><canvas data-pk="${D.k}"></canvas></div><b>${T(D.n[sz][0], D.n[sz][1])}</b><span class="stp-ico">${{ trap:T('陷阱', '陷阱'), puzzle:T('解謎', '解謎'), slow:T('減速', '減速'), scare:T('驚嚇', '驚嚇'), aura:T('氛圍', '氛圍'), throw:T('投擲', '投擲') }[r]}</span>`
              + st2.map(q => `<small>${q[0]}：${q[1]}</small>`).join('') + `<button class="stp-buy" data-r="${r}" data-pr="${pr}" ${coins < pr ? 'disabled' : ''}>💴 ${pr}</button></div>`; }).join('')
          + `</div><button id="stp-x" class="stp-x">${T('關閉', '關閉')}</button></div>`;
        el.querySelectorAll('[data-r]').forEach(btn => btn.onclick = () => { const r = btn.dataset.r, pr = +btn.dataset.pr; if ((S.res.coins || 0) < pr) return; S.res.coins -= pr;
          sd.posts[i] = { g:'dev:' + r, role:r, sz, lv:1, build:5, spent:pr, cd:0 }; close(); save_(); Fx.toast(T(`開工建造：${T(DEV[r].n[sz][0], DEV[r].n[sz][1])}（5秒）`, `開始建造：${DEV[r].n[sz][1]}（5秒）`)); });
      }
      el.querySelectorAll('canvas[data-pk]').forEach(cv => { try { const im = ART.portrait(cv.dataset.pk, 80); cv.width = 80; cv.height = 80; cv.getContext('2d').drawImage(im, 0, 0, 80, 80); } catch (e) {} });
      const x = el.querySelector('#stp-x'); if (x) x.onclick = close; el.onclick = (e) => { if (e.target === el) close(); };
    },
    fixPosts() { const sd = this.sd; while (sd.posts.length < this.lay.posts.length) sd.posts.push(null); sd.posts = sd.posts.map((p, i) => p && p.role && this.lay.posts[i] ? Object.assign(p, { sz:this.lay.posts[i].s || 1, spent:p.spent || DEV[p.role][this.lay.posts[i].s || 1].lv[0][0] }) : (p && p.role ? p : null)); },
    lvCap() { return 3 + (this.sd.unlocked >= 2 ? 2 : 0); }, // 主題 MAXLevel 3，開第二間房（排隊區升級）+2
    incomeCap() { return ROOM_MAXLV[Math.min(ROOM_MAXLV.length, this.sd.unlocked) - 1]; },
    mod() { return Math.max(0.9, Math.min(1.05, this.sd.modCur || 0.9)) * (this.modMax || 1); },
    unit() { return Math.floor(13 * coP(Math.min(this.sd.lv, this.incomeCap())) * 1.15); },
    // 建設度＝(台數×1.5＋升級次數×0.875)/(5×槽數)×0.6 ＋ 員工/槽數×0.4 ＋ 有名鬼 0.1 起
    build() { const sd = this.sd, TM = this.lay.tm, blt = sd.posts.filter(p => p && p.role && !(p.build > 0 && (p.lv || 1) === 1));
      let v = (blt.length * 1.5 + blt.reduce((a, p) => a + ((p.lv || 1) - 1) * 0.875, 0)) / (5 * TM) * 0.6 + blt.filter(p => p.staff != null).length / TM * 0.4;
      if ((sd.bosses || []).length) { const g = ghost(sd.bosses[0]); v += 0.1 + (Math.min(6, (g && (g.lv || g.level)) || 1) - 1) * 0.02; }
      return Math.round(v * 1000) / 10; },
    rect(spot) { const w = CELL * (spot.s === 2 && !spot.d ? 2 : 1), h = CELL * (spot.s === 2 && spot.d ? 2 : 1) / 1.5; return [spot.x - w / 2, spot.y - h / 2, spot.x + w / 2, spot.y + h / 2]; },
    rdist(pt, spot) { const r = this.rect(spot), dx = Math.max(r[0] - pt[0], 0, pt[0] - r[2]), dy = Math.max(r[1] - pt[1], 0, pt[1] - r[3]); return Math.hypot(dx, dy * 1.5); },
    wseg(w) { const t = Math.max(0, w.t); for (const g of w.segs) if (t <= g.s + g.d) return g; return w.segs[w.segs.length - 1]; },
    runPos(w) { const P0 = w.runPath; let left = Math.min(w.runT, 1.5) * w.spd * 1.8; for (let i = 0; i < P0.length - 1; i++) { const d = this.dist(P0[i], P0[i + 1]); if (left <= d) { const k = left / d; return [P0[i][0] + (P0[i + 1][0] - P0[i][0]) * k, P0[i][1] + (P0[i + 1][1] - P0[i][1]) * k]; } left -= d; } return P0[P0.length - 1].slice(); },
    alive(w) { return !w.gone && w.t > 0 && !this.wseg(w).hide; },
    queueTick(dt) {
      const q = this.q, n = 3 + Math.min(3, this.sd.unlocked);
      if (q.st === 'gap') { q.t -= dt; if (q.t <= 0) { q.st = 'form'; q.n = n; q.made = 0; q.t = 0; q.list = []; } }
      else if (q.st === 'form') { q.t -= dt; if (q.t <= 0 && q.made < q.n) { q.t = 0.5; q.made++; let el = null; if (this.eliteT <= 0) { const ok = ELITE.filter(e => this.sd.scared >= e.rep); if (ok.length) { el = pick(ok).id; this.eliteT = R(75, 125); } } q.list.push(this.newWalker(el)); } if (q.made >= q.n && q.t <= 0) { q.st = 'ready'; q.t = 90; } }
      else if (q.st === 'ready') { q.t -= dt; if (q.t <= 0) this.release(false); }
      this.eliteT -= dt;
    },
    release(manual) {
      const q = this.q; if (q.st !== 'ready' && !(manual && q.st === 'form' && q.made > 0)) return false;
      q.list.forEach((w, i) => { w.t = -i * 0.07; this.walkers.push(w); });
      const n = q.list.length; this.sd.modCur = Math.min(1.05, (this.sd.modCur || 0.9) + 0.01);
      this.float(this.lay.nodes['0E'][0] + 0.15, 0.8, manual ? T(`放咗 ${n} 個人入嚟！`, `放了 ${n} 個人進來！`) : T(`等足 90 秒，${n} 個人自己行入嚟`, `等滿 90 秒，${n} 個人自己走進來`), '#ffe9b0');
      q.st = 'gap'; q.t = 8; q.list = []; q.made = 0; this.focusOn(this.lay.nodes['0E'][0], 0.8); return true;
    },
    staffMul(p) { return p.staff != null && ghost(p.staff) ? { atk:1.3, cd:0.9, hp:1.3 } : { atk:1, cd:1, hp:1 }; },
    devK(p) { const g = p.staff != null && ghost(p.staff); return g ? g.k : DEV[p.role].k; },
    devTick(i, p, dt) {
      const D = DEV[p.role], S0 = D[p.sz || 1], L0 = S0.lv[(p.lv || 1) - 1], M = this.staffMul(p), spot = this.lay.posts[i];
      const rd = (w) => this.rdist(this.wp(w), spot), live = this.walkers.filter(w => this.alive(w)), atk = L0[2] * M.atk, reload = L0[3] * M.cd;
      if (p.role === 'puzzle') return this.puzzleTick(i, p, L0, S0, live, rd, atk, M, dt);
      if (p.role === 'slow') { const R1 = S0.area[(p.lv || 1) - 1] * CELL * 0.85, on = live.filter(w => rd(w) <= R1);
        on.forEach(w => { w.slowM = Math.min(w.slowT > 0 ? w.slowM : 1, 1 - L0[5]); w.slowT = 0.5; w.frost = 0.4; }); p.auraOn = on.length ? 0.6 : p.auraOn;
        p.cd = (p.cd || 0) + dt; if (on.length && p.cd >= reload) { p.cd = 0; on.forEach(w => this.hit(w, atk, { fear:1 })); if (!p.fx) { const tp = this.wp(on[0]); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'light', k:this.devK(p), tx:tp[0], ty:tp[1], aura:true }; } } return; }
      if (p.win) { p.win.t -= dt; const eff = S0.eff * PX;
        live.forEach(w => { if (!p.win.hit.has(w) && rd(w) <= eff) { p.win.hit.add(w); this.hit(w, atk, p.role === 'aura' ? { fear:1, aura:1 } : { fright:true }); } });
        if (p.win.t <= 0) { p.win = null; p.cd = 0; } return; }
      if (p.anim != null) { p.anim -= dt; if (p.anim <= 0) { p.anim = null; if (p.role === 'throw') { this.fire(i, p, atk, S0, live); p.cd = 0; } else p.win = { t:Math.max(1, S0.dl) / 60, hit:new Set() }; } return; }
      p.cd = (p.cd || 0) + dt; if (p.cd < reload) return;
      const inC = live.filter(w => rd(w) <= S0.check * PX); if (!inC.length) return;
      p.anim = S0.dd / 60; const tg = inC.sort((a, b) => b.t - a.t)[0], tp = this.wp(tg);
      if (p.role === 'aura') { p.auraOn = 1; p.flo = (p.flo || 0) - reload; if (p.flo <= 0 && !p.fx) { p.flo = R(3.5, 5.5); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'cold', k:this.devK(p), tx:tp[0], ty:tp[1], aura:true }; } return; }
      p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:D.kind, k:this.devK(p), tx:tp[0], ty:tp[1] };
      if (p.role !== 'throw') this.focusOn(spot.x, spot.y); if (p.role === 'scare') { this.shake = 0.28; this.flash = 0.18; }
    },
    fire(i, p, atk, S0, live) {
      const spot = this.lay.posts[i], walking = live.filter(w => !(w.stay > 0) && !(w.block > 0)), tg = pick(walking.length ? walking : live); if (!tg) return;
      const to = this.wp(tg, 100 * PX); // 預判前面 100px
      this.shots.push({ from:[spot.x, spot.y - 0.05], to, t:0, dur:0.55, eff:S0.eff * PX, atk });
      const tp = this.wp(tg); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'paper', k:this.devK(p), tx:tp[0], ty:tp[1] };
    },
    // 解謎：擋住所有人；被困嘅人合力破解（每秒 = 平均攻擊 × √人數）；破咗經 RefreshCD 秒重置，重置期間行入格嘅人會被拉返入格嗰個位
    puzzleTick(i, p, L0, S0, live, rd, atk, M, dt) {
      const spot = this.lay.posts[i], max = L0[1] * M.hp; if (p.ph == null) p.ph = max;
      const inR = live.filter(w => rd(w) <= S0.check * PX);
      if (p.solved > 0) { p.solved -= dt;
        inR.forEach(w => { if (w.pzSkip !== i && (!w.pzIn || w.pzIn.i !== i)) w.pzIn = { i, t:w.t }; });
        live.forEach(w => { if (w.pzSkip === i && rd(w) > S0.check * PX) w.pzSkip = null; });
        if (p.solved <= 0) { p.solved = 0; p.ph = max; let n = 0; live.forEach(w => { if (w.pzIn && w.pzIn.i === i) { if (rd(w) <= S0.check * PX) { w.t = w.pzIn.t; w.block = 0.3; w.pulled = 1.2; n++; } w.pzIn = null; } });
          this.float(spot.x, spot.y - 0.07, n ? T(`謎題重置！${n} 個人被拉返`, `謎題重置！${n} 個人被拉回`) : T('謎題重置！', '謎題重置！'), '#c084ff'); }
        return; }
      if (!inR.length) return;
      inR.forEach(w => { w.block = 0.15; w.puz = i; w.fear = 0.5; });
      const LS = L0[6] || 1, a = inR.map(w => { const d = w.d, d2 = d <= LS ? d : LS + Math.ceil((d - LS) * 0.45); return (w.el ? w.el.atk : 10) * hpP(d2); }), avg = a.reduce((x, y) => x + y, 0) / a.length;
      p.ph -= avg * Math.sqrt(inR.length) * dt; p.crack = 0.2;
      p.cd = (p.cd || 0) + dt; if (p.cd >= L0[3] * M.cd) { p.cd = 0; inR.forEach(w => this.hit(w, atk, { fear:1, aura:1 })); if (!p.fx) { const tp = this.wp(inR[0]); p.fx = { t:0, v:Math.random() < 0.5 ? 0 : 1, type:'phone', k:this.devK(p), tx:tp[0], ty:tp[1] }; } }
      if (p.ph <= 0) { p.ph = 0; p.solved = L0[4]; inR.forEach(w => { w.block = 0; w.puz = null; w.pzSkip = i; }); this.float(spot.x, spot.y - 0.07, T(`謎題破咗！${inR.length} 個人合力`, `謎題被破解！${inR.length} 個人合力`), '#9cf'); }
    },
    // ---------- 有名鬼（BOSS）----------
    bpos(B) { const A = this.lay.nodes[B.a], C = this.lay.nodes[B.b] || A; return [A[0] + (C[0] - A[0]) * B.k, A[1] + (C[1] - A[1]) * B.k]; },
    bossTick(dt) {
      const sd = this.sd, L = this.lay; sd.bosses = (sd.bosses || []).filter(id => ghost(id)); sd.bEn = sd.bEn || {};
      for (const id of sd.bosses) if (!this.bosses.some(b => b.g.id === id)) { const g = ghost(id); this.bosses.push({ g, a:'0E', b:pick(L.edges['0E']), k:0, dir:1, cd:R(2, 4), stay:0, en:sd.bEn[id] || 0, fx:null, hitSet:null }); }
      this.bosses = this.bosses.filter(b => sd.bosses.includes(b.g.id));
      for (const B of this.bosses) {
        const K = bsk(B.g.k), hid = L.hide.has(B.a + '>' + B.b) || L.hide.has(B.b + '>' + B.a); B.hid = hid;
        if (B.stay > 0) { B.stay -= dt; B.pt += dt; if (B.ph === 'omen' && B.pt >= 1.3) { B.ph = 'strike'; B.pt = 0; this.loreStrike(B); B.fx = { t:0, k:'_', at:this.bpos(B), tg:B.sx.tp }; } else if (B.ph === 'strike' && B.pt >= 1.2) { B.ph = 'rest'; B.pt = 0; }
          if (B.fx) { B.fx.t += dt; if (B.fx.t > 1.1) B.fx = null; } if (B.stay <= 0) { B.stay = 0; B.cd = BOSS_CD; B.ph = null; B.fx = null; } continue; }
        this.bstep(B, 100 * PX * (hid ? 4 : 1) * dt);
        B.cd -= dt; if (B.cd > 0 || B.hid) continue;
        const pos = this.bpos(B), near = this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), pos) <= this.lore(B.g.k).r * PX); if (!near.length) continue;
        B.stay = 6; B.ph = 'omen'; B.pt = 0; B.tg = near[0]; this.loreOmen(B); B.en = Math.min(100, B.en + 14); sd.bEn[B.g.id] = B.en; this.focusOn(pos[0], pos[1]);
        const LN = this.lore(B.g.k); this.float(pos[0], pos[1] - 0.13, `${B.g.name}・${T(LN.n[0], LN.n[1])}`, '#e6c8ff');
      }
    },
    bstep(B, step) { const L = this.lay; let guard = 0; while (step > 0 && guard++ < 8) { const A = L.nodes[B.a], C = L.nodes[B.b], len = this.dist(A, C) || 1e-6, left = (1 - B.k) * len;
        if (step < left) { B.k += step / len; return; } step -= left; B.k = 0; const cur = B.b; let nx;
        if (B.dir > 0) { nx = (L.edges[cur] || []).filter(n => n !== 'OUT'); if (!nx.length) { B.dir = -1; nx = L.preds[cur] || []; } }
        else { nx = L.preds[cur] || []; if (!nx.length) { B.dir = 1; nx = (L.edges[cur] || []).filter(n => n !== 'OUT'); } }
        B.a = cur; B.b = pick(nx) || cur; } },
    bossSkill(B, K, dt) {
      const g = B.g, lv = Math.min(6, g.lv || g.level || 1), base = BOSS_DMG + (lv >= 2 ? 180 : 0) + (lv >= 5 ? 361 : 0);
      if (K.dash) this.bstep(B, 300 * PX / K.last * dt);
      const pos = this.bpos(B), R0 = (K.dash ? 80 : K.r) * PX;
      for (const w of this.walkers) { if (!this.alive(w) || B.hitSet.has(w) || this.dist(this.wp(w), pos) > R0) continue; if (K.single && B.hitSet.size >= 1) break;
        B.hitSet.add(w); if (B.fx) B.fx.tg = this.wp(w).slice();
        if (K.push) w.t = Math.max(0.01, w.t - CELL);
        if (K.coin && !w.el) { S.res.coins = (S.res.coins || 0) + K.coin; this.sd.coins += K.coin; const [x, y] = this.wp(w); this.parts.push({ kind:'coin', x, y:y - 0.05, life:1, k:0 }); this.float(x, y - 0.1, T(`偷到 ${K.coin}`, `偷到 ${K.coin}`), '#ffd45a'); }
        if (K.block) { w.block = K.block; w.papers = K.block; }
        this.hit(w, base * K.dmg, { force:true, fright:K.block ? 0 : (K.fright || 2) }); }
    },
    useBox() { const s = st(); if ((s.box == null ? 1 : s.box) < 1) { const m = Math.ceil((20 * 60000 - (Date.now() - (s.boxAt || 0))) / 60000); Fx.toast(T(`驚嚇盒用咗，${m} 分鐘後回復`, `驚嚇盒已用，${m} 分鐘後回復`)); return; }
      const C = this.cam, vis = this.walkers.filter(w => this.alive(w)).filter(w => { const [x, y] = this.wp(w); return Math.abs(x - C.x) <= 0.5 / C.z && Math.abs(y - C.y) <= 0.5 / C.z; });
      s.box = 0; s.boxAt = Date.now(); this.flash = 0.18; this.shake = 0.5; vis.forEach(w => this.hit(w, w.max, { force:true })); Fx.toast(T(`驚嚇盒！畫面入面 ${vis.length} 個人全部嚇走`, `驚嚇盒！畫面裡 ${vis.length} 個人全部嚇跑`)); save_(); },
    statTxt(role, sz, lv) { const S0 = DEV[role][sz], L0 = S0.lv[lv - 1], s = (v) => v + T('秒', '秒');
      if (role === 'slow') return [[T('減速', '減速'), Math.round(L0[5] * 100) + '%'], [T('範圍', '範圍'), S0.area[lv - 1] + T('格', '格')], [T('驚嚇值', '驚嚇值'), L0[2]]];
      if (role === 'puzzle') return [[T('謎題難度', '謎題難度'), L0[1]], [T('重置', '重置'), s(L0[4])], [T('驚嚇值', '驚嚇值'), L0[2]]];
      if (role === 'aura') return [[T('驚嚇值', '驚嚇值'), L0[2]], [T('驚嚇頻率', '驚嚇頻率'), s(L0[3])], [T('範圍', '範圍'), S0.eff]];
      return [[T('驚嚇值', '驚嚇值'), L0[2]], [T('整備速度', '整備速度'), s(L0[3])], [T('範圍', '範圍'), role === 'throw' ? T('全房', '全房') : `${S0.check}/${S0.eff}`]]; },
    // ======== 有名鬼招式（按民間傳說設計：預兆 → 出手 → 餘痕；餘痕會同其他鬼聯動）========
    LORE:{
      tianhua:{ n:['倒吊纏髮', '倒吊纏髮'], col:'rgba(70,110,140,0.22)', font:'serif', snd:['heartbeat', 'whoosh'], r:170, dmg:1, cap:['滴……答……', '捲住你喇……'], tr:{ k:'hair', life:6, r:110 } },
      pontianak:{ n:['夜半俯衝', '夜半俯衝'], col:'rgba(255,190,220,0.18)', font:'serif', snd:['crow', 'whoosh'], r:230, dmg:0.9, cap:['嘻……', '嘻嘻嘻——！'], tr:{ k:'shadow', life:5, r:120 } },
      eguiking:{ n:['細喉搶食', '細喉搶食'], col:'rgba(200,80,40,0.18)', font:'sans-serif', snd:['chop', 'coin'], r:190, dmg:1.1, cap:['咕嚕……咕嚕……', '俾我食！'], tr:{ k:'bowl', life:6, r:110 } },
      egui:{ same:'eguiking' },
      laojiang:{ n:['聞氣跳撞', '聞氣跳撞'], col:'rgba(40,90,60,0.22)', font:'serif', snd:['gong', 'hit'], r:240, dmg:1.5, cap:['叮噹……叮噹……', '嗚——！'], tr:{ k:'claw', life:6, r:100 } },
      toyol:{ n:['偷錢亂竄', '偷錢亂竄'], col:'rgba(220,180,60,0.16)', font:'sans-serif', snd:['coin', 'coin'], r:190, dmg:0.5, cap:['嘻嘻……', '錢錢係我嘅！'], tr:{ k:'coins', life:6, r:100 } },
      xiaozhi:{ n:['紙人圍堵', '紙人圍堵'], col:'rgba(240,235,215,0.16)', font:'serif', snd:['paper', 'paper'], r:190, dmg:0.7, cap:['沙……沙……', '企起身……'], tr:{ k:'paper', life:7, r:120 } },
      pocong:{ n:['裹屍橫擋', '裹屍橫擋'], col:'rgba(235,235,235,0.18)', font:'serif', snd:['whoosh', 'hit'], r:200, dmg:1, cap:['（路口有嘢白色一閃）', '嘭！嘭！嘭！'], tr:{ k:'cloth', life:5, r:110 } },
      penanggal:{ n:['飛頭繞圈', '飛頭繞圈'], col:'rgba(120,200,90,0.18)', font:'serif', snd:['heartbeat', 'whoosh'], r:200, dmg:1.1, cap:['（一陣酸醋味……）', '嘶——'], tr:{ k:'ring', life:4, r:120 } },
      mengpo:{ n:['一碗孟婆湯', '一碗孟婆湯'], col:'rgba(230,170,80,0.16)', font:'serif', snd:['skill', 'whoosh'], r:180, dmg:0.6, cap:['（湯好香……）', '飲啖湯，乜都唔記得'], tr:{ k:'soup', life:6, r:150 } },
      n30_yukionna:{ n:['冰息', '冰息'], col:'rgba(150,210,255,0.22)', font:'serif', snd:['whoosh', 'whoosh'], r:210, dmg:1, cap:['（地下結霜……）', '呼——'], tr:{ k:'ice', life:7, r:120 } },
      n30_qionggui:{ n:['執錢陷阱', '執錢陷阱'], col:'rgba(150,170,80,0.18)', font:'sans-serif', snd:['coin', 'hit'], r:190, dmg:1, cap:['（地下有張銀紙）', '執到就係你嘅……'], tr:{ k:'notes', life:7, r:100 } },
      n30_guhangui:{ n:['借銀包數錢', '借銀包數錢'], col:'rgba(160,150,110,0.18)', font:'sans-serif', snd:['coin', 'coin'], r:170, dmg:0.9, cap:['（叮……叮……）', '一蚊、兩蚊、三蚊……'], tr:{ k:'clink', life:5, r:110 } },
      n30_taozhai:{ n:['窄口追債', '窄口追債'], col:'rgba(170,30,40,0.2)', font:'sans-serif', snd:['gong', 'hit'], r:190, dmg:0.9, cap:['（有人喺度貼追債紙）', '還錢呀！！'], tr:{ k:'debt', life:7, r:150 } },
      _:{ n:['陰氣爆發', '陰氣爆發'], col:'rgba(160,110,255,0.16)', font:'serif', snd:['whoosh', 'hit'], r:170, dmg:1, cap:['……', '嘩——'], tr:{ k:'shadow', life:4, r:90 } },
    },
    lore(k) { const L = this.LORE[k] || this.LORE._; return L.same ? this.LORE[L.same] : L; },
    snd(n) { try { if (has(Sound) && Sound.play) Sound.play(n); } catch (e) {} },
    cap(text, x, y, o) { (this.caps = this.caps || []).push(Object.assign({ text, x, y, t:0, life:1.4, size:15, col:'#f4e8ff', font:'serif', style:'pop' }, o || {})); },
    act(w, pose, t, o) { w.act = Object.assign({ pose, t, hold:true, rot:0 }, o || {}); },
    react(w, kind) { // 路人反應多樣化：尖叫／跪低／抱頭／跌低／回頭走
      const [x, y] = this.wp(w), K = kind || pick(['scream', 'kneel', 'head', 'fall', 'flee']);
      if (K === 'scream') { this.act(w, 'startle', 1.2); w.say = { s:pick([T('呀————！', '啊————！'), T('有鬼呀！！', '有鬼啊！！'), T('救命！！', '救命！！')]), t:1.3 }; }
      else if (K === 'kneel') { this.act(w, 'cower', 1.6); w.say = { s:pick([T('唔好搞我……', '不要搞我……'), T('對唔住對唔住……', '對不起對不起……')]), t:1.4 }; }
      else if (K === 'head') { this.act(w, 'tremble', 1.5); w.say = { s:pick([T('我乜都睇唔到……', '我什麼都看不到……'), T('唔好望唔好望……', '別看別看……')]), t:1.3 }; }
      else if (K === 'fall') { this.act(w, 'cower', 1.4, { rot:(Math.random() < 0.5 ? -1 : 1) * 1.2 }); w.say = { s:T('哎呀！', '哎呀！'), t:1 }; }
      else { w.back = CELL * 1.5; w.say = { s:pick([T('走呀！！', '快跑！！'), T('我唔行喇！', '我不走了！')]), t:1.2 }; }
    },
    bump(w0, rad) { for (const o of this.walkers) if (o !== w0 && this.alive(o) && !o.act && this.dist(this.wp(o), this.wp(w0)) < (rad || 50) * PX) { this.act(o, 'startle', 0.6, { rot:0.35 }); o.say = { s:pick([T('咪推呀！', '別推啊！'), T('做咩撞我！', '幹嘛撞我！')]), t:0.9 }; } },
    // 改行另一條分叉（Pocong 嚇到人／路口白布）
    reroute(w) { const L = this.lay, sg = this.wseg(w); if (!sg || !sg.k || !L.edges[sg.k]) return false; const pos = this.wp(w), nx = L.edges[sg.k], cur = sg.nk, alt = nx.filter(n => n !== cur), K2 = alt.length ? pick(alt) : null; if (!K2) return false;
      const pts = [{ p:pos, k:'@' }, { p:L.nodes[sg.k], k:sg.k }]; let k = K2, g = 0, prev = sg.k; while (k && g++ < 160) { pts.push({ p:L.nodes[k], k, hide:L.hide.has(prev + '>' + k) }); const n2 = L.edges[k]; if (!n2 || !n2.length) break; prev = k; k = pick(n2); }
      this.mkRoute(w, pts); w.t = 0.001; return true; },
    addTrace(kind, x, y, r, life, o) { (this.traces = this.traces || []).push(Object.assign({ kind, x, y, r:r * PX, life, t:0, seen:new Set() }, o || {})); },
    // 預兆
    loreOmen(B) {
      const k = B.g.k, L = this.lore(k), pos = this.bpos(B), tg = B.tg, tp = tg ? this.wp(tg) : pos; B.om = { t:0, tp:tp.slice() };
      this.snd(L.snd[0]); this.cap(T(L.cap[0], L.cap[0]), (pos[0] + tp[0]) / 2, Math.min(pos[1], tp[1]) - 0.1, { font:L.font, col:'#d8e4ff', style:k === 'pontianak' ? 'grow' : k === 'tianhua' ? 'drip' : 'wobble', life:1.4 });
      const near = this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), pos) < L.r * PX * 1.3);
      if (k === 'laojiang') near.forEach(w => { if (Math.random() < 0.4) { w.breath = 3.2; this.act(w, 'tremble', 3.2); w.say = { s:T('屏住呼吸……', '屏住呼吸……'), t:2 }; } });
      else near.slice(0, 2).forEach(w => { w.say = { s:pick([T('咩聲嚟㗎？', '什麼聲音？'), T('好似有啲嘢……', '好像有東西……'), T('你有冇聞到？', '你有沒有聞到？')]), t:1.2 }; });
      if (k === 'n30_qionggui') B.om.note = [tp[0] + 0.06, tp[1] + 0.02];
    },
    // 出手
    loreStrike(B) {
      const g = B.g, k = g.k, L = this.lore(k), lv = Math.min(6, g.lv || g.level || 1), base = (BOSS_DMG + (lv >= 2 ? 180 : 0) + (lv >= 5 ? 361 : 0)) * L.dmg, pos = this.bpos(B);
      const near = this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), pos) < L.r * PX).sort((a, z) => this.dist(this.wp(a), pos) - this.dist(this.wp(z), pos));
      const hit = (w, m, o) => this.hit(w, base * (m || 1), Object.assign({ force:true }, o || {}));
      this.snd(L.snd[1]); this.tint = { col:L.col, t:1.2 }; this.shake = 0.3; const tg = near[0], tp = tg ? this.wp(tg) : B.om ? B.om.tp : pos; B.sx = { t:0, tp:tp.slice(), from:pos.slice(), list:[] };
      this.cap(T(L.cap[1], L.cap[1]), tp[0], tp[1] - 0.16, { font:L.font, col:'#fff0f6', style:'shake', size:18 }); let trAt = tp;
      switch (L === this.LORE.eguiking ? 'eguiking' : k) {
        case 'tianhua': if (tg) { tg.lift = { t:0, dur:2.0, h:95 }; hit(tg, 1, { fright:0 }); B.sx.list = [tg]; } near.slice(1, 3).forEach(w => this.react(w, 'head')); break;
        case 'pontianak': { const line = near.slice(0, 5).sort((a, z) => this.wp(a)[0] - this.wp(z)[0]); B.sx.list = line; B.sx.a = line.length ? this.wp(line[0]) : tp; B.sx.b = line.length ? this.wp(line[line.length - 1]) : tp; line.forEach((w, j) => { hit(w, 1, { fright:1.5 }); setTimeout(() => this.react(w, j % 2 ? 'scream' : 'fall'), 200 + j * 90); }); trAt = [(B.sx.a[0] + B.sx.b[0]) / 2, (B.sx.a[1] + B.sx.b[1]) / 2]; break; }
        case 'eguiking': near.slice(0, 3).forEach(w => { hit(w, 1, { fright:2 }); this.act(w, 'startle', 2.2); w.say = { s:T('我嘅叉燒包呢？！', '我的叉燒包呢？！'), t:1.6 }; if (!w.el) { S.res.coins = (S.res.coins || 0) + 3; this.sd.coins += 3; } }); B.sx.list = near.slice(0, 3); break;
        case 'laojiang': { const cand = near.filter(w => !(w.breath > 0)), tgt = cand.sort((a, z) => z.spd - a.spd)[0]; if (tgt) { const p2 = this.wp(tgt); B.sx.tp = p2; B.sx.list = [tgt]; near.forEach(w => { if (w.breath > 0) { w.say = { s:T('（唔敢唞氣）', '（不敢喘氣）'), t:1.5 }; return; } const d = this.segDist(this.wp(w), pos, p2); if (d < 70 * PX) { hit(w, w === tgt ? 1 : 0.6, { fright:0 }); w.fly = { t:0, dur:0.8, dx:(p2[0] > pos[0] ? 1 : -1) * 0.06 }; } }); trAt = p2; } break; }
        case 'toyol': near.slice(0, 2).forEach((w, j) => { hit(w, 1, { fright:0 }); if (!w.el) { S.res.coins = (S.res.coins || 0) + 6; this.sd.coins += 6; } w.chase = { t:0, dur:2.6, ph:j * 2 }; w.say = { s:T('喂！我個銀包！', '喂！我的錢包！'), t:1.5 }; }); B.sx.list = near.slice(0, 2); break;
        case 'xiaozhi': { const c0 = tg ? this.wp(tg) : pos, cage = this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), c0) < 90 * PX); cage.forEach(w => { w.block = 2.6; hit(w, 1, { fright:0 }); this.act(w, pick(['tremble', 'cower']), 2.6); }); B.sx.c = c0; B.sx.list = cage; break; }
        case 'pocong': { const y0 = tp[1], row = near.filter(w => Math.abs(this.wp(w)[1] - y0) * 1.5 < 80 * PX); B.sx.y0 = y0; B.sx.list = row; row.forEach(w => { hit(w, 1, { fright:1.2 }); this.reroute(w) ? (w.say = { s:T('呢邊唔行得！行第二條路！', '這邊不能走！走另一條！'), t:1.6 }) : this.react(w, 'flee'); }); break; }
        case 'penanggal': { const c0 = tg ? this.wp(tg) : pos; B.sx.c = c0; const ring = this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), c0) < 120 * PX); ring.forEach(w => { hit(w, 1, { fright:1.5 }); this.react(w); }); B.sx.list = ring; trAt = c0; break; }
        case 'mengpo': near.slice(0, 3).forEach(w => { hit(w, 1, { fright:0 }); w.spin = 1.3; this.act(w, 'idle', 1.3); w.amnesia = 9; setTimeout(() => { w.back = CELL * 2; w.say = { s:T('我去邊度㗎？', '我要去哪裡？'), t:1.6 }; }, 1300); }); B.sx.list = near.slice(0, 3); break;
        case 'n30_yukionna': { const dir = Math.atan2((tp[1] - pos[1]) * 1.5, tp[0] - pos[0]); B.sx.dir = dir; const cone = this.walkers.filter(w => { if (!this.alive(w)) return false; const p2 = this.wp(w), d = this.dist(p2, pos), a = Math.atan2((p2[1] - pos[1]) * 1.5, p2[0] - pos[0]); return d < 210 * PX && Math.abs(((a - dir + 9.42) % 6.283) - 3.14) < 0.6; }); cone.forEach(w => { hit(w, 1, { fright:0 }); w.frost = 2.5; this.act(w, 'tremble', 2.2); }); B.sx.list = cone; trAt = [pos[0] + Math.cos(dir) * 120 * PX, pos[1] + Math.sin(dir) * 120 * PX / 1.5]; break; }
        case 'n30_qionggui': if (tg) { this.act(tg, 'cower', 2.4); hit(tg, 1, { fright:0 }); tg.say = { s:T('咦？張銀紙變咗冥鏹！', '咦？鈔票變成冥紙了！'), t:1.8 }; B.sx.list = [tg]; } trAt = B.om && B.om.note || tp; break;
        case 'n30_guhangui': if (tg) { hit(tg, 1, { fright:0 }); this.act(tg, 'tremble', 3); tg.say = { s:T('我……我個銀包……', '我……我的錢包……'), t:2.4 }; B.sx.list = [tg]; } break;
        case 'n30_taozhai': if (tg) { hit(tg, 1, { fright:0 }); tg.back = CELL * 3; tg.say = { s:T('我冇錢呀！！', '我沒錢啊！！'), t:1.6 }; B.sx.list = [tg]; } break;
        default: near.slice(0, 3).forEach(w => { hit(w, 1, { fright:2 }); this.react(w); }); B.sx.list = near.slice(0, 3);
      }
      const tr = L.tr; this.addTrace(tr.k, trAt[0], trAt[1], tr.r, tr.life, { by:k });
    },
    segDist(p, a, b) { const ax = a[0], ay = a[1] * 1.5, bx = b[0], by = b[1] * 1.5, px = p[0], py = p[1] * 1.5, dx = bx - ax, dy = by - ay, l = dx * dx + dy * dy || 1e-9, t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / l)); return Math.hypot(px - ax - dx * t, py - ay - dy * t); },
    // 餘痕＋聯動
    // 被趕回頭嘅人撞落後面人群：每撞一個再推下一個，最多 4 個連環跌
    chainFall(w0) { let cur = w0; const done = new Set([w0]); let n = 0;
      for (let i = 0; i < 4; i++) { const p0 = this.wp(cur), nx = this.walkers.filter(o => this.alive(o) && !done.has(o)).map(o => [o, this.dist(this.wp(o), p0)]).filter(a => a[1] < 90 * PX).sort((a, z) => a[1] - z[1])[0]; if (!nx) break; const o = nx[0]; done.add(o); n++;
        o.cb3c = 1; this.act(o, 'cower', 1.6 + i * 0.2, { rot:(i % 2 ? -1 : 1) * 1.25 }); this.hit(o, BOSS_DMG * 0.2, { force:true, aura:1 }); o.say = { s:pick([T('哎呀！', '哎呀！'), T('咪推呀！', '別推啊！'), T('撞到我喇！', '撞到我了！')]), t:1.2 }; cur = o; }
      if (n >= 2) { const [x, y] = this.wp(w0); this.cap(T(`連環跌 ×${n}！`, `連環跌倒 ×${n}！`), x, y - 0.16, { col:'#ffb0b0', style:'pop', size:16 }); } },
    traceTick(dt) {
      const TR = this.traces = (this.traces || []).filter(r => (r.t += dt) < r.life);
      for (const w of this.walkers) { if (!this.alive(w)) continue; const p = this.wp(w), on = TR.filter(r => this.dist(p, [r.x, r.y]) < r.r), ks = new Set(on.concat(on.length ? TR.filter(r => this.dist(p, [r.x, r.y]) < r.r + 0.12) : []).map(r => r.kind)); /* 聯動：兩種餘痕相鄰就算疊埋 */ if (!on.length) continue; const [x, y] = p;
        // 聯動①：濕髮＋冰息 = 冰髮，全部跣低
        if (ks.has('hair') && ks.has('ice') && !w.cb1) { w.cb1 = 1; this.act(w, 'cower', 2.6, { rot:1.3 }); this.hit(w, BOSS_DMG * 0.6, { force:true }); this.cap(T('冰髮！跣到四腳朝天！', '冰髮！滑倒在地！'), x, y - 0.1, { col:'#bfe8ff', style:'shake', size:17, font:'serif' }); this.tint = { col:'rgba(150,210,255,0.25)', t:0.8 }; continue; }
        // 聯動②：Toyol 灑錢＋窮鬼假鈔 = 成班人蹲低執錢，變成靶
        if (ks.has('coins') && ks.has('notes') && !w.cb2) { w.cb2 = 1; this.act(w, 'cower', 3.5); w.target = 5; w.say = { s:T('有錢執呀！', '有錢撿啊！'), t:1.5 }; this.cap(T('成班人蹲低執錢！（受嚇 ×1.5）', '一群人蹲下撿錢！（受驚 ×1.5）'), x, y - 0.12, { col:'#ffe08a', style:'pop', size:15 }); continue; }
        // 聯動③：孟婆失憶＋討債窄口 = 喺窄口嚟回撞
        if (ks.has('debt') && w.amnesia > 0 && !(w.back > 0) && !(w.dbCd > 0)) { w.dbCd = 1.6; w.cb3 = (w.cb3 || 0) + 1; w.back = CELL * 1.6; this.bump(w, 55); w.say = { s:pick([T('咦？我行過嚟咩？', '咦？我走過來了嗎？'), T('又係你！', '又是你！')]), t:1.2 }; this.hit(w, BOSS_DMG * 0.25, { force:true, aura:1 }); this.chainFall(w); this.cap(T('窄口嚟回撞！', '窄口來回撞！'), x, y - 0.1, { col:'#ff9a9a', style:'shake', size:15 }); continue; }
        for (const r of on) { if (r.seen.has(w)) { if (r.kind === 'hair' || r.kind === 'ice' || r.kind === 'paper' || r.kind === 'clink') { w.slowM = Math.min(w.slowT > 0 ? w.slowM : 1, r.kind === 'paper' ? 0.6 : 0.5); w.slowT = 0.3; if (r.kind === 'clink') w.fear = 0.5; } continue; } r.seen.add(w);
          if (r.kind === 'hair') { if (Math.random() < 0.45) { this.act(w, 'cower', 1.3, { rot:1.1 }); w.say = { s:T('啲頭髮好滑！', '頭髮好滑！'), t:1 }; } }
          else if (r.kind === 'ice') { if (Math.random() < 0.45) { this.act(w, 'cower', 1.3, { rot:-1.1 }); w.frost = 1.2; } }
          else if (r.kind === 'shadow') { w.back = CELL * 1.2; w.say = { s:pick([T('頭先嗰個白影係咩？', '剛剛那個白影是什麼？'), T('我唔過去喇……', '我不過去了……')]), t:1.4 }; }
          else if (r.kind === 'bowl') { this.act(w, 'idle', 1.6); w.say = { s:T('邊個個碗喺度轆？', '誰的碗在滾？'), t:1.3 }; }
          else if (r.kind === 'claw') { w.fear = 1.5; this.hit(w, BOSS_DMG * 0.15, { force:true, aura:1 }); }
          else if (r.kind === 'coins' || r.kind === 'notes') { this.act(w, 'cower', 1.6); w.say = { s:r.kind === 'coins' ? T('跌咗啲散紙！', '掉了零錢！') : T('有張銀紙！', '有張鈔票！'), t:1.2 }; }
          else if (r.kind === 'cloth') { if (this.reroute(w)) w.say = { s:T('嗰邊有白布……行第二條路', '那邊有白布……走另一條'), t:1.4 }; }
          else if (r.kind === 'ring') { this.hit(w, BOSS_DMG * 0.35, { force:true, fright:1 }); this.react(w, 'scream'); }
          else if (r.kind === 'soup') { w.amnesia = 6; w.back = CELL; w.say = { s:T('我頭先想去邊？', '我剛剛要去哪？'), t:1.3 }; }
          else if (r.kind === 'debt') { w.back = CELL * 1.2; this.bump(w, 50); w.say = { s:T('唔好搵我！', '別找我！'), t:1.2 }; }
          else if (r.kind === 'clink') { w.fear = 1; w.say = { s:T('邊個喺度數錢？', '誰在數錢？'), t:1.2 }; } } }
      this.caps = (this.caps || []).filter(q => (q.t += dt) < q.life); if (this.tint) { this.tint.t -= dt; if (this.tint.t <= 0) this.tint = null; }
    },
    // 路人特殊狀態（吊起／撞飛／追 Toyol／轉圈）
    walkerFx(w, dt) {
      for (const f of ['amnesia', 'target', 'breath', 'dbCd']) if (w[f] > 0) w[f] -= dt;
      if (w.lift) { w.lift.t += dt; if (w.lift.t >= w.lift.dur) { w.lift = null; this.act(w, 'cower', 1.2, { rot:1.2 }); this.hit(w, BOSS_DMG * 0.3, { force:true, fright:1 }); w.say = { s:T('呀——！', '啊——！'), t:1 }; } return true; }
      if (w.fly) { w.fly.t += dt; if (w.fly.t >= w.fly.dur) { w.fly = null; this.act(w, 'cower', 1.3, { rot:1.3 }); w.say = { s:T('痛呀……', '好痛……'), t:1 }; } return true; }
      if (w.chase) { w.chase.t += dt; if (Math.random() < dt * 3) this.bump(w, 45); if (w.chase.t >= w.chase.dur) w.chase = null; return true; }
      if (w.act) { w.act.t -= dt; if (w.act.t <= 0) w.act = null; else if (w.act.hold) return true; }
      return false;
    },
    wOff(w, U) { let ox = 0, oy = 0, rot = 0; const t = performance.now() / 1000;
      if (w.lift) { const k = w.lift.t / w.lift.dur, up = k < 0.25 ? k / 0.25 : k > 0.9 ? Math.max(0, 1 - (k - 0.9) / 0.1) : 1; oy = -w.lift.h * U * up; ox = Math.sin(t * 9) * 4 * U * up; rot = Math.sin(t * 7) * 0.25 * up + Math.PI * up * 0.9; }
      if (w.fly) { const k = w.fly.t / w.fly.dur; ox = w.fly.dx * this.box.w * k; oy = -Math.sin(k * Math.PI) * 60 * U; rot = k * 4; }
      if (w.chase) { const k = w.chase.t / w.chase.dur, e = Math.sin(k * Math.PI); ox = Math.sin(t * 2.6 + w.chase.ph) * 70 * U * e; oy = Math.cos(t * 3.1 + w.chase.ph) * 30 * U * e; }
      if (w.act && w.act.rot) rot += w.act.rot;
      return [ox, oy, rot]; },
    // 餘痕（畫喺路人下面）
    drawTraces() {
      const c = this.c, b = this.box, U = b.w / 390, t = performance.now() / 1000;
      for (const r of this.traces || []) { const [x, y] = this.P(r.x, r.y), R0 = r.r * b.w, a = Math.min(1, (r.life - r.t) / 1.2) * Math.min(1, r.t * 3); c.save(); c.globalAlpha = a;
        if (r.kind === 'hair') { c.strokeStyle = 'rgba(20,20,26,0.85)'; c.lineWidth = 1.6; for (let j = 0; j < 26; j++) { const a0 = j * 2.4, rr = R0 * (0.3 + 0.7 * ((j * 37) % 10) / 10), x0 = x + Math.cos(a0) * rr, y0 = y + Math.sin(a0) * rr / 1.5; c.beginPath(); c.moveTo(x0, y0); c.bezierCurveTo(x0 + 10 * U, y0 + Math.sin(t + j) * 4 * U, x0 + 18 * U, y0 - 6 * U, x0 + 28 * U, y0 + 3 * U); c.stroke(); } c.fillStyle = 'rgba(90,130,160,0.25)'; c.beginPath(); c.ellipse(x, y, R0, R0 / 1.5, 0, 0, 7); c.fill(); }
        else if (r.kind === 'ice') { const g = c.createRadialGradient(x, y, 2, x, y, R0); g.addColorStop(0, 'rgba(220,245,255,0.55)'); g.addColorStop(1, 'rgba(150,210,255,0.08)'); c.fillStyle = g; c.beginPath(); c.ellipse(x, y, R0, R0 / 1.5, 0, 0, 7); c.fill(); c.strokeStyle = 'rgba(255,255,255,0.7)'; c.lineWidth = 1; for (let j = 0; j < 10; j++) { const a0 = j * 0.63; c.beginPath(); c.moveTo(x, y); c.lineTo(x + Math.cos(a0) * R0 * 0.9, y + Math.sin(a0) * R0 * 0.6); c.stroke(); } }
        else if (r.kind === 'shadow') { try { ART.drawChar(c, r.by || 'pontianak', x + Math.sin(t * 1.3) * 8 * U, y - 40 * U, b.h * 0.1 / 60, { t, pose:'idle', alpha:0.25 + 0.15 * Math.sin(t * 5), shadow:false }); } catch (e) {} }
        else if (r.kind === 'bowl') { const rx = x + Math.sin(t * 2.2) * 26 * U; c.fillStyle = '#d9d2c2'; c.beginPath(); c.ellipse(rx, y, 11 * U, 6 * U, Math.sin(t * 6) * 0.5, 0, 3.14); c.fill(); c.strokeStyle = '#6a5a40'; c.lineWidth = 1.5; c.stroke(); c.fillStyle = 'rgba(255,255,255,0.4)'; c.font = `${9 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('（空碗轆緊）', '（空碗在滾）'), rx, y - 12 * U); }
        else if (r.kind === 'claw') { c.strokeStyle = 'rgba(30,10,10,0.8)'; c.lineWidth = 3; for (let j = 0; j < 4; j++) { c.beginPath(); c.moveTo(x - 24 * U + j * 12 * U, y - 10 * U); c.lineTo(x - 14 * U + j * 12 * U, y + 12 * U); c.stroke(); } for (let j = 0; j < 4; j++) { const rr = ((t * 0.6 + j * 0.25) % 1); c.fillStyle = `rgba(10,30,15,${0.45 * (1 - rr)})`; c.beginPath(); c.arc(x + Math.sin(j * 2 + t) * 14 * U, y - rr * 50 * U, (8 + rr * 10) * U, 0, 7); c.fill(); } }
        else if (r.kind === 'coins' || r.kind === 'notes') { for (let j = 0; j < 9; j++) { const xx = x + Math.cos(j * 2.1) * R0 * 0.7, yy = y + Math.sin(j * 2.1) * R0 * 0.45; if (r.kind === 'coins') { c.fillStyle = '#ffd45a'; c.strokeStyle = '#7a4a10'; c.lineWidth = 1; c.beginPath(); c.ellipse(xx, yy, 5 * U * Math.abs(Math.cos(t * 3 + j)) + 1.5, 4 * U, 0, 0, 7); c.fill(); c.stroke(); } else { c.save(); c.translate(xx, yy); c.rotate(j); c.fillStyle = j % 2 ? '#7fae6a' : '#c9b26a'; c.fillRect(-9 * U, -4 * U, 18 * U, 8 * U); c.strokeStyle = '#3a4a20'; c.strokeRect(-9 * U, -4 * U, 18 * U, 8 * U); c.restore(); } } }
        else if (r.kind === 'paper') { for (let j = 0; j < 14; j++) { const xx = x + Math.cos(j * 1.7) * R0 * 0.8, yy = y + Math.sin(j * 1.7) * R0 * 0.5; c.save(); c.translate(xx, yy); c.rotate(j * 0.9); c.fillStyle = j % 3 ? '#efe7cf' : '#d8b450'; c.fillRect(-6 * U, -4 * U, 12 * U, 8 * U); c.fillStyle = '#b02020'; c.fillRect(-2 * U, -2 * U, 4 * U, 4 * U); c.restore(); } }
        else if (r.kind === 'cloth') { c.fillStyle = `rgba(245,245,240,${0.25 + 0.25 * Math.abs(Math.sin(t * 7))})`; c.beginPath(); c.ellipse(x, y - 24 * U, 10 * U, 26 * U, 0, 0, 7); c.fill(); }
        else if (r.kind === 'ring') { c.strokeStyle = `rgba(140,255,120,${0.5 + 0.3 * Math.sin(t * 8)})`; c.lineWidth = 3; c.shadowColor = '#7f6'; c.shadowBlur = 10; c.beginPath(); c.ellipse(x, y, R0, R0 / 1.5, 0, 0, 7); c.stroke(); c.shadowBlur = 0; }
        else if (r.kind === 'soup') { c.fillStyle = 'rgba(200,140,60,0.35)'; c.beginPath(); c.ellipse(x, y, R0 * 0.6, R0 * 0.35, 0, 0, 7); c.fill(); for (let j = 0; j < 4; j++) { const rr = (t * 0.5 + j * 0.25) % 1; c.strokeStyle = `rgba(255,240,220,${0.5 * (1 - rr)})`; c.lineWidth = 2; c.beginPath(); c.moveTo(x - 10 * U + j * 7 * U, y - rr * 40 * U); c.quadraticCurveTo(x + Math.sin(t * 3 + j) * 8 * U, y - rr * 40 * U - 10 * U, x - 6 * U + j * 7 * U, y - rr * 40 * U - 20 * U); c.stroke(); } }
        else if (r.kind === 'debt') { c.save(); c.translate(x, y - 30 * U); c.rotate(Math.sin(t * 4) * 0.15); c.fillStyle = '#f1e4c8'; c.fillRect(-16 * U, -20 * U, 32 * U, 40 * U); c.fillStyle = '#b01010'; c.font = `900 ${12 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('還錢', '還錢'), 0, -2 * U); c.fillText('！', 0, 13 * U); c.restore(); }
        else if (r.kind === 'clink') { c.fillStyle = 'rgba(255,230,140,0.85)'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('叮……叮……', '叮……叮……'), x + Math.sin(t * 2) * 10 * U, y - 30 * U - (t * 20 % 20) * U); }
        c.restore(); }
    },
    // 預兆＋出手特效；回傳鬼嘅位置覆寫
    drawLoreFx(B, x, y, hh) {
      const c = this.c, b = this.box, U = b.w / 390, t = performance.now() / 1000, k = B.g.k, kk = this.LORE[k] && this.LORE[k].same ? this.LORE[k].same : k; let o = null;
      if (B.ph === 'omen' && B.om) { const q = Math.min(1, B.pt / 1.3), [tx, ty] = this.P(...B.om.tp);
        if (kk === 'tianhua') { for (let j = 0; j < 5; j++) { const d = ((t * 1.3 + j * 0.2) % 1); c.fillStyle = 'rgba(160,200,230,0.85)'; c.beginPath(); c.ellipse(tx - 20 * U + j * 10 * U, b.y + (ty - b.y) * d, 2 * U, 4 * U, 0, 0, 7); c.fill(); } c.fillStyle = `rgba(70,100,130,${0.35 * q})`; c.beginPath(); c.ellipse(tx, ty, 40 * U * q, 14 * U * q, 0, 0, 7); c.fill(); }
        else if (kk === 'pontianak') { for (let j = 0; j < 8; j++) { const d = (t * 0.4 + j * 0.13) % 1; c.save(); c.translate(b.x + b.w * d, ty - 60 * U + Math.sin(t * 2 + j) * 40 * U); c.rotate(t * 2 + j); c.fillStyle = 'rgba(255,248,230,0.85)'; for (let p = 0; p < 5; p++) { c.rotate(1.256); c.beginPath(); c.ellipse(0, 4 * U, 2.5 * U, 5 * U, 0, 0, 7); c.fill(); } c.fillStyle = '#f6d36b'; c.beginPath(); c.arc(0, 0, 1.6 * U, 0, 7); c.fill(); c.restore(); } }
        else if (kk === 'eguiking') { this.walkers.filter(w => this.alive(w) && this.dist(this.wp(w), this.bpos(B)) < 0.3).forEach(w => { const [wx, wy] = this.P(...this.wp(w)); c.fillStyle = 'rgba(255,230,200,0.9)'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('咕嚕', '咕嚕'), wx, wy - hh * 1.2 - Math.sin(t * 5) * 4 * U); c.strokeStyle = 'rgba(255,200,140,0.5)'; c.lineWidth = 2; c.beginPath(); c.moveTo(wx, wy - hh * 0.6); c.quadraticCurveTo((wx + x) / 2, wy - hh * 1.5 + Math.sin(t * 3) * 10 * U, x, y - hh * 0.8); c.stroke(); }); }
        else if (kk === 'laojiang') { c.save(); c.translate(x + 20 * U, y - hh * 1.2); c.rotate(Math.sin(t * 9) * 0.5); c.fillStyle = '#e8c840'; c.fillRect(-7 * U, -16 * U, 14 * U, 30 * U); c.strokeStyle = '#a01010'; c.lineWidth = 1.5; for (let j = 0; j < 4; j++) { c.beginPath(); c.moveTo(-4 * U, -12 * U + j * 7 * U); c.lineTo(4 * U, -9 * U + j * 7 * U); c.stroke(); } c.restore(); }
        else if (kk === 'toyol') { for (let j = 0; j < Math.floor(q * 10); j++) { const fx = x + (tx - x) * j / 10 + (j % 2 ? 5 : -5) * U, fy = y + (ty - y) * j / 10; c.fillStyle = 'rgba(40,30,20,0.7)'; c.beginPath(); c.ellipse(fx, fy, 3 * U, 4.5 * U, 0, 0, 7); c.fill(); } }
        else if (kk === 'xiaozhi') { for (let j = 0; j < 16; j++) { const a0 = t * 3 + j * 0.39, rr = (20 + j * 3) * U; c.save(); c.translate(tx + Math.cos(a0) * rr, ty - 20 * U + Math.sin(a0) * rr * 0.4 - j * 2 * U); c.rotate(a0); c.fillStyle = j % 2 ? 'rgba(80,70,60,0.7)' : 'rgba(230,210,150,0.85)'; c.fillRect(-4 * U, -3 * U, 8 * U, 6 * U); c.restore(); } }
        else if (kk === 'pocong') { if (Math.sin(t * 17) > 0.3) { c.fillStyle = 'rgba(250,250,245,0.8)'; c.beginPath(); c.ellipse(tx + 40 * U, ty - 26 * U, 10 * U, 28 * U, 0, 0, 7); c.fill(); } }
        else if (kk === 'penanggal') { for (let j = 0; j < 6; j++) { const g = c.createRadialGradient(tx + Math.sin(t + j) * 40 * U, ty - 20 * U, 2, tx + Math.sin(t + j) * 40 * U, ty - 20 * U, 40 * U); g.addColorStop(0, `rgba(150,220,90,${0.25 * q})`); g.addColorStop(1, 'rgba(150,220,90,0)'); c.fillStyle = g; c.fillRect(tx - 90 * U, ty - 70 * U, 180 * U, 100 * U); } }
        else if (kk === 'mengpo') { c.fillStyle = '#7a4a2a'; c.beginPath(); c.ellipse(x + 18 * U, y - hh * 0.6, 9 * U, 4 * U, 0, 0, 7); c.fill(); for (let j = 0; j < 3; j++) { const rr = (t * 0.7 + j * 0.33) % 1; c.strokeStyle = `rgba(255,240,220,${0.7 * (1 - rr)})`; c.lineWidth = 2; c.beginPath(); c.moveTo(x + 15 * U + j * 3 * U, y - hh * 0.7 - rr * 30 * U); c.quadraticCurveTo(x + 22 * U + Math.sin(t * 4 + j) * 6 * U, y - hh * 0.7 - rr * 30 * U - 8 * U, x + 15 * U, y - hh * 0.7 - rr * 30 * U - 16 * U); c.stroke(); } }
        else if (kk === 'n30_yukionna') { c.fillStyle = `rgba(220,240,255,${0.4 * q})`; c.beginPath(); c.ellipse(x, y, 90 * U * q, 34 * U * q, 0, 0, 7); c.fill(); c.strokeStyle = `rgba(255,255,255,${0.7 * q})`; c.lineWidth = 1; for (let j = 0; j < 12; j++) { const a0 = j * 0.52; c.beginPath(); c.moveTo(x, y); c.lineTo(x + Math.cos(a0) * 90 * U * q, y + Math.sin(a0) * 34 * U * q); c.stroke(); } }
        else if (kk === 'n30_qionggui' && B.om.note) { const [nx, ny] = this.P(...B.om.note); c.save(); c.translate(nx, ny); c.rotate(0.3); c.fillStyle = '#7fae6a'; c.fillRect(-12 * U, -5 * U, 24 * U, 10 * U); c.strokeStyle = '#2a3a10'; c.strokeRect(-12 * U, -5 * U, 24 * U, 10 * U); c.restore(); const s = 0.5 + 0.5 * Math.sin(t * 8); c.fillStyle = `rgba(255,255,220,${s})`; c.beginPath(); c.arc(nx + 8 * U, ny - 4 * U, 3 * U, 0, 7); c.fill(); }
        else if (kk === 'n30_guhangui') { c.fillStyle = 'rgba(255,220,120,0.9)'; c.font = `bold ${11 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('叮……', '叮……'), x + 24 * U, y - hh * 1.1 - (t * 30 % 18) * U); }
        else if (kk === 'n30_taozhai') { c.save(); c.translate(tx, ty - 50 * U - (1 - q) * 40 * U); c.rotate(Math.sin(t * 6) * 0.3); c.fillStyle = '#f1e4c8'; c.fillRect(-14 * U, -18 * U, 28 * U, 36 * U); c.fillStyle = '#b01010'; c.font = `900 ${11 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('追債', '追債'), 0, 2 * U); c.restore(); }
      }
      if (B.ph === 'strike' && B.sx) { const q = Math.min(1, B.pt / 1.1), [tx, ty] = this.P(...B.sx.tp), [fx, fy] = this.P(...B.sx.from);
        if (kk === 'tianhua') { for (const w of B.sx.list) { const [wx, wy] = this.P(...this.wp(w)), lf = w.lift ? this.wOff(w, U)[1] : 0; c.strokeStyle = 'rgba(15,15,20,0.9)'; c.lineWidth = 2; for (let j = 0; j < 9; j++) { c.beginPath(); c.moveTo(wx - 16 * U + j * 4 * U, b.y); c.quadraticCurveTo(wx + Math.sin(t * 5 + j) * 14 * U, (b.y + wy + lf) / 2, wx - 6 * U + j * 1.5 * U, wy + lf - hh * 0.8); c.stroke(); } } const im = has(SPR) && SPR.tianhua_hang; if (im && im.naturalWidth) { const H2 = hh * 2.4, W2 = H2 * im.naturalWidth / im.naturalHeight, drop = Math.sin(Math.min(1, q * 2.5) * Math.PI / 2); c.save(); c.translate(tx, b.y - H2 + drop * (ty - hh * 1.9 - b.y + H2 * 0.4)); c.rotate(Math.sin(t * 6) * 0.06); c.drawImage(im, -W2 / 2, 0, W2, H2); c.restore(); o = { gx:x, gy:y, alpha:0.01 }; } else o = { gx:tx, gy:ty - hh * 1.6, rot:Math.PI, alpha:0.95 }; }
        else if (kk === 'pontianak' && B.sx.a) { const [ax, ay] = this.P(...B.sx.a), [bx2, by2] = this.P(...B.sx.b), e = Math.min(1, q * 1.4), gx = ax + (bx2 - ax) * e, gy = ay + (by2 - ay) * e - Math.sin(e * Math.PI) * 30 * U - (1 - e) * 80 * U; c.strokeStyle = 'rgba(255,240,250,0.8)'; c.lineWidth = 2; for (let j = 0; j < 3; j++) { c.beginPath(); c.moveTo(ax, ay - hh * 0.5 + j * 6 * U); c.lineTo(gx, gy - hh * 0.4 + j * 6 * U); c.stroke(); } o = { gx, gy, rot:-0.5 }; }
        else if (kk === 'eguiking') { for (const w of B.sx.list) { const [wx, wy] = this.P(...this.wp(w)), e = Math.sin(Math.min(1, q * 1.6) * Math.PI); const hx = x + (wx - x) * e, hy = y - hh * 0.9 + (wy - hh * 0.5 - (y - hh * 0.9)) * e; c.strokeStyle = '#5a2010'; c.lineWidth = 5 * U; c.beginPath(); c.moveTo(x, y - hh * 0.9); c.quadraticCurveTo((x + hx) / 2, Math.min(y, hy) - 40 * U, hx, hy); c.stroke(); c.strokeStyle = '#a04a30'; c.lineWidth = 2 * U; c.stroke(); c.fillStyle = '#e8c070'; c.beginPath(); c.arc(hx, hy, 5 * U, 0, 7); c.fill(); } }
        else if (kk === 'laojiang') { const e = q < 0.6 ? q / 0.6 : 1 - (q - 0.6) / 0.4; o = { gx:fx + (tx - fx) * e, gy:fy + (ty - fy) * e - Math.abs(Math.sin(e * Math.PI * 3)) * 34 * U }; for (const w of this.walkers) if (w.breath > 0 && this.alive(w)) { const [wx, wy] = this.P(...this.wp(w)); c.strokeStyle = 'rgba(255,255,255,0.6)'; c.lineWidth = 2; c.strokeRect(wx - 14 * U, wy - hh - 4 * U, 28 * U, hh + 8 * U); c.fillStyle = '#fff'; c.font = `bold ${9 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('定格', '定格'), wx, wy - hh - 8 * U); } }
        else if (kk === 'toyol') { const w = B.sx.list[0]; if (w) { const [wx, wy] = this.P(...this.wp(w)), of = this.wOff(w, U); o = { gx:wx + of[0] + Math.sin(t * 6) * 30 * U, gy:wy + of[1] + Math.cos(t * 5) * 14 * U }; } }
        else if (kk === 'xiaozhi' && B.sx.c) { const [cx, cy] = this.P(...B.sx.c); for (let j = 0; j < 6; j++) { const a0 = j * 1.047, px = cx + Math.cos(a0) * 46 * U, py = cy + Math.sin(a0) * 20 * U, up = Math.min(1, q * 2 - j * 0.1); if (up <= 0) continue; c.save(); c.translate(px, py); c.scale(1, up); try { ART.drawChar(c, 'xiaozhi', 0, 0, 0.45 * U, { t:t + j, pose:'idle', alpha:0.9, flip:Math.cos(a0) > 0, shadow:false }); } catch (e) {} c.restore(); } }
        else if (kk === 'pocong') { const ys = this.P(0, B.sx.y0)[1], e = q; o = { gx:fx + (tx + 90 * U - fx) * e, gy:ys - Math.abs(Math.sin(e * Math.PI * 4)) * 20 * U, rot:e * 6.28 }; c.fillStyle = 'rgba(250,250,245,0.18)'; c.fillRect(Math.min(fx, o.gx), ys - 30 * U, Math.abs(o.gx - fx), 36 * U); }
        else if (kk === 'penanggal' && B.sx.c) { const [cx, cy] = this.P(...B.sx.c), a0 = q * 6.283 * 1.2, R1 = 120 * PX * b.w; c.strokeStyle = 'rgba(160,255,120,0.75)'; c.lineWidth = 3; c.shadowColor = '#8f6'; c.shadowBlur = 12; c.beginPath(); for (let j = 0; j <= 30; j++) { const aa = a0 * j / 30; j ? c.lineTo(cx + Math.cos(aa) * R1, cy - 30 * U + Math.sin(aa) * R1 / 1.5) : c.moveTo(cx + R1, cy - 30 * U); } c.stroke(); c.shadowBlur = 0; o = { gx:cx + Math.cos(a0) * R1, gy:cy - 30 * U + Math.sin(a0) * R1 / 1.5 + hh * 0.5, rot:a0 }; }
        else if (kk === 'mengpo') { for (const w of B.sx.list) { const [wx, wy] = this.P(...this.wp(w)); c.fillStyle = '#7a4a2a'; c.beginPath(); c.ellipse(wx + 10 * U, wy - hh * 0.55, 8 * U, 3.5 * U, 0, 0, 7); c.fill(); c.fillStyle = 'rgba(255,220,150,0.9)'; c.font = `bold ${10 * U}px serif`; c.textAlign = 'center'; c.fillText('？', wx + Math.sin(t * 6) * 8 * U, wy - hh * 1.3); } }
        else if (kk === 'n30_yukionna' && B.sx.dir != null) { const d = B.sx.dir, R1 = 210 * PX * b.w * Math.min(1, q * 2); c.fillStyle = 'rgba(200,235,255,0.35)'; c.beginPath(); c.moveTo(x, y - hh * 0.5); c.arc(x, y - hh * 0.5, R1, d - 0.6, d + 0.6); c.closePath(); c.fill(); for (let j = 0; j < 14; j++) { const a0 = d - 0.6 + j * 0.09, rr = R1 * ((t * 2 + j * 0.13) % 1); c.fillStyle = 'rgba(255,255,255,0.8)'; c.beginPath(); c.arc(x + Math.cos(a0) * rr, y - hh * 0.5 + Math.sin(a0) * rr, 2 * U, 0, 7); c.fill(); } }
        else if (kk === 'n30_qionggui') { for (const w of B.sx.list) { const [wx, wy] = this.P(...this.wp(w)), e = Math.min(1, q * 2); c.strokeStyle = 'rgba(40,30,30,0.9)'; c.lineWidth = 4 * U; c.beginPath(); c.moveTo(wx + 30 * U, wy + 4 * U); c.lineTo(wx + 30 * U - 22 * U * e, wy - hh * 0.3); c.stroke(); c.save(); c.translate(wx + 6 * U, wy - 2 * U); c.rotate(0.2); c.fillStyle = q > 0.5 ? '#d8b450' : '#7fae6a'; c.fillRect(-12 * U, -5 * U, 24 * U, 10 * U); c.fillStyle = '#b02020'; if (q > 0.5) c.fillRect(-3 * U, -3 * U, 6 * U, 6 * U); c.restore(); } }
        else if (kk === 'n30_guhangui') { for (const w of B.sx.list) { const [wx, wy] = this.P(...this.wp(w)), e = Math.min(1, q * 1.5); c.fillStyle = '#5a3a20'; c.fillRect(wx + (x - wx) * e - 8 * U, wy - hh * 0.6 + (y - hh * 0.6 - (wy - hh * 0.6)) * e - 5 * U, 16 * U, 10 * U); c.fillStyle = '#ffe9a0'; c.font = `bold ${10 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T(['一蚊', '兩蚊', '三蚊', '四蚊'][Math.floor(t * 3) % 4], ['一塊', '兩塊', '三塊', '四塊'][Math.floor(t * 3) % 4]), wx + 18 * U, wy - hh * 1.05); } }
        else if (kk === 'n30_taozhai') { const w = B.sx.list[0]; if (w) { const [wx, wy] = this.P(...this.wp(w)); o = { gx:wx + (fx - wx) * 0.3 + 26 * U, gy:wy, rot:Math.sin(t * 10) * 0.08 }; c.fillStyle = '#ff6a6a'; c.font = `900 ${14 * U}px sans-serif`; c.textAlign = 'center'; c.fillText(T('還錢！', '還錢！'), wx + 30 * U, wy - hh * 1.2); } }
      }
      return o;
    },
    drawCaps() {
      const c = this.c, b = this.box, U = b.w / 390;
      for (const q of this.caps || []) { const [x, y] = this.P(q.x, q.y), k = q.t / q.life, a = k < 0.15 ? k / 0.15 : k > 0.8 ? (1 - k) / 0.2 : 1; let s = q.size * U, dx = 0, dy = 0;
        if (q.style === 'grow') s *= 0.5 + k * 1.4; else if (q.style === 'shake') { dx = (Math.random() - 0.5) * 5 * U; dy = (Math.random() - 0.5) * 4 * U; s *= 1 + (k < 0.15 ? (0.15 - k) * 4 : 0); } else if (q.style === 'drip') dy = k * 16 * U; else if (q.style === 'wobble') dx = Math.sin(k * 20) * 4 * U; else dy = -k * 20 * U;
        c.save(); c.globalAlpha = Math.max(0, a); c.font = `900 ${s}px ${q.font}`; c.textAlign = 'center'; c.lineWidth = 4; c.strokeStyle = 'rgba(10,0,15,0.9)'; const xx = x; c.strokeText(q.text, xx + dx, y + dy); c.fillStyle = q.col; c.fillText(q.text, xx + dx, y + dy); c.restore(); }
    },
    ULTT:{ pontianak:{ dur:3.8, at:3.0 }, tianhua:{ dur:3.3 }, laojiang:{ dur:3.2 }, n30_yukionna:{ dur:3 }, mengpo:{ dur:3.6 }, pocong:{ dur:3.4 }, penanggal:{ dur:3.6 }, toyol:{ dur:3.6 } },
    // 新增大招（同普通招嘅餘痕呼應）；返回 true 代表已處理
    ultNew(U) {
      const live = this.walkers.filter(w => this.alive(w)), P = BOSS_DMG, all = (m, f) => live.forEach(w => { if (f) f(w); this.hit(w, P * m, { force:true }); });
      const tr = (kind, r, life) => live.forEach(w => { const p = this.wp(w); this.addTrace(kind, p[0], p[1], r, life, { by:U.k }); });
      switch (U.k) {
        case 'tianhua': live.forEach(w => { w.lift = { t:0, dur:2.0, h:80 + Math.random() * 40 }; }); setTimeout(() => { live.forEach(w => { if (this.alive(w)) this.hit(w, P * 6, { force:true, fright:2.5 }); }); }, 2100); tr('hair', 90, 7); return true;
        case 'pontianak': all(10, w => this.react(w, pick(['scream', 'kneel', 'fall', 'flee']))); tr('shadow', 80, 5); return true;
        case 'eguiking': case 'egui': return false;
        case 'toyol': U.vic = live.slice(); U.gust = 0; return true; // 一陣風捲走手上嘢 → 撒錢引人蹲低（喺 drawUltNew 按時間觸發）
        case 'pocong': U.vic = live.slice(); live.forEach(w => { w.block = 2.6; this.act(w, pick(['startle', 'cower', 'tremble']), 2.4); this.hit(w, P * 6, { force:true }); }); setTimeout(() => live.forEach(w => { if (this.alive(w) && !this.reroute(w)) w.back = CELL * 2; }), 2400); tr('cloth', 80, 5); return true;
        case 'penanggal': { const ps = this.bpos ? U.pos : null; U.vic = live.slice().sort((a, z) => this.wp(a)[0] - this.wp(z)[0]); U.hitI = 0; return true; }
        case 'mengpo': U.vic = live.slice(); U.river = 0; return true;
        case 'n30_yukionna': all(8, w => { w.frost = 3; this.act(w, 'tremble', 3); }); tr('ice', 100, 8); return true;
        case 'n30_qionggui': all(6, w => { this.act(w, 'cower', 3.2); w.target = 6; }); tr('notes', 90, 7); return true;
        case 'n30_guhangui': all(7, w => { this.act(w, 'tremble', 3); if (!w.el) { S.res.coins = (S.res.coins || 0) + 2; } }); tr('clink', 90, 5); return true;
        case 'n30_taozhai': all(7, w => { w.back = CELL * 3; this.bump(w, 60); }); tr('debt', 80, 6); return true;
      }
      return false;
    },
    drawUltNew(U, q) {
      const c = this.c, b = this.box, U2 = b.w / 390, t = performance.now() / 1000, k = U.k, at = U.at || 0.9;
      if (k === 'pontianak') { const s = U.t; c.fillStyle = `rgba(0,0,0,${Math.min(0.6, (s - 0.9) * 0.8)})`; c.fillRect(b.x - b.w * 4, b.y - b.h, b.w * 12, b.h * 3);
        const stage = s < 1.7 ? 0 : s < 2.4 ? 1 : 2, txt = ['嘻……', '嘻嘻嘻……', '嘻嘻嘻嘻！！'][stage], sz = [12, 26, 54][stage], cx = this.cam ? b.x + this.cam.x * b.w : b.x + b.w / 2, cy = this.cam ? b.y + this.cam.y * b.h : b.y + b.h / 2;
        if (s < 3.0) { c.save(); c.font = `900 ${sz * U2}px serif`; c.textAlign = 'center'; c.fillStyle = `rgba(255,200,230,${0.5 + stage * 0.25})`; c.lineWidth = 5; c.strokeStyle = '#1a0010'; const jx = stage === 2 ? (Math.random() - 0.5) * 10 : 0; c.strokeText(T(txt, txt), cx + jx, cy - 40 * U2 + (2 - stage) * -60 * U2); c.fillText(T(txt, txt), cx + jx, cy - 40 * U2 + (2 - stage) * -60 * U2); c.restore(); }
        if (s >= 3.0) { const rr = (s - 3.0) / 0.8; for (let j = 0; j < 3; j++) { c.strokeStyle = `rgba(255,170,220,${(1 - rr) * 0.9})`; c.lineWidth = 8 - j * 2; c.beginPath(); c.arc(cx, cy, (rr + j * 0.1) * b.h, 0, 7); c.stroke(); } }
        return true; }
      if (U.t < at) return true;
      const cx = this.cam ? b.x + this.cam.x * b.w : b.x + b.w / 2, cy = this.cam ? b.y + this.cam.y * b.h : b.y + b.h / 2, vw = b.w / (this.cam ? this.cam.z : 1), vh = b.h / (this.cam ? this.cam.z : 1);
      if (k === 'pocong') { // 白布人一排排跳出嚟封路：三排由兩邊跳入，企定喺路人前面原地彈
        const k2 = U.t - at, vic = U.vic || [], rows = [0.3, 0.5, 0.7];
        rows.forEach((ry, r) => { const yy = cy - vh / 2 + ry * vh, side = r % 2 ? 1 : -1; for (let j = 0; j < 6; j++) { const e = Math.min(1, Math.max(0, (k2 - r * 0.25 - j * 0.05) / 0.6)), tx = cx - vw * 0.42 + j * vw * 0.168, sx = side < 0 ? cx - vw / 2 - 40 : cx + vw / 2 + 40, x = sx + (tx - sx) * e, hop = Math.abs(Math.sin((k2 * 5 + j * 0.7 + r) * Math.PI)) * (e < 1 ? 26 : 10) * U2;
          try { ART.drawChar(c, 'pocong', x, yy - hop, b.h * 0.075 / 60, { t:t + j + r, pose:'idle', alpha:0.95, shadow:false, rot:(e < 1 ? side * 0.25 : 0) }); } catch (e2) {} }
          if (k2 > r * 0.25 + 0.7) { c.fillStyle = 'rgba(245,245,238,0.12)'; c.fillRect(cx - vw / 2, yy - 50 * U2, vw, 56 * U2); c.font = `900 ${12 * U2}px serif`; c.textAlign = 'center'; c.fillStyle = 'rgba(255,255,250,0.8)'; c.fillText(T('（封路）', '（封路）'), cx + vw * 0.45 - 30 * U2, yy - 52 * U2); } });
        if (k2 > 0.8 && !U.say1) { U.say1 = 1; vic.slice(0, 4).forEach((w, j) => { w.say = { s:[T('前面封咗路！', '前面封路了！'), T('又係白布……', '又是白布……'), T('點過去呀？', '怎麼過去？'), T('行返轉頭！', '往回走！')][j], t:2 }; }); }
        return true; }
      if (k === 'penanggal') { // 飛頭拖住內臟繞場一圈，逐個掠過路人
        const vic = (U.vic || []).filter(w => !w.gone), k2 = Math.min(1, (U.t - at) / 2.4), pts = [[cx - vw * 0.48, cy - vh * 0.3]].concat(vic.map(w => { const [x, y] = this.P(...this.wp(w)); return [x, y - b.h * 0.07]; })).concat([[cx + vw * 0.48, cy - vh * 0.35], [cx, cy - vh * 0.45], [cx - vw * 0.48, cy - vh * 0.3]]);
        const seg = (pts.length - 1) * k2, i0 = Math.min(pts.length - 2, Math.floor(seg)), f = seg - i0, hx = pts[i0][0] + (pts[i0 + 1][0] - pts[i0][0]) * f, hy = pts[i0][1] + (pts[i0 + 1][1] - pts[i0][1]) * f;
        U.trail = (U.trail || []).concat([[hx, hy]]).slice(-26);
        c.save(); c.lineCap = 'round'; for (let j = 1; j < U.trail.length; j++) { const a2 = j / U.trail.length; c.strokeStyle = `rgba(120,10,20,${0.8 * a2})`; c.lineWidth = (2 + 7 * a2) * U2; c.beginPath(); c.moveTo(U.trail[j - 1][0], U.trail[j - 1][1] + Math.sin(t * 9 + j) * 4); c.lineTo(U.trail[j][0], U.trail[j][1] + Math.sin(t * 9 + j + 1) * 4); c.stroke(); c.strokeStyle = `rgba(170,255,130,${0.35 * a2})`; c.lineWidth = 2 * U2; c.stroke(); } c.restore();
        try { ART.drawChar(c, 'penanggal', hx, hy + b.h * 0.06, b.h * 0.09 / 60, { t, pose:'strike', pt:1, atk:true, alpha:0.97, flip:(pts[i0 + 1][0] < pts[i0][0]), shadow:false }); } catch (e2) {}
        for (let j = 0; j < vic.length; j++) if (j + 1 <= seg && (U.hitI || 0) <= j) { U.hitI = j + 1; const w = vic[j]; if (this.alive(w)) { this.hit(w, BOSS_DMG * 8, { force:true, fright:1.5 }); this.react(w, pick(['scream', 'fall', 'head'])); const p2 = this.wp(w); this.addTrace('ring', p2[0], p2[1], 70, 3, { by:'penanggal' }); this.cap(T('嘶——', '嘶——'), p2[0], p2[1] - 0.12, { style:'shake', col:'#c8ffb0', size:14, life:0.8 }); } }
        return true; }
      if (k === 'mengpo') { // 一碗湯傾落地，沿條路變成一條湯河；行入去嘅人唔記得方向原地兜圈
        const k2 = U.t - at, tilt = Math.min(1, k2 / 0.5), bx = cx - vw * 0.3, by = cy - vh * 0.42;
        c.save(); c.translate(bx, by); c.rotate(tilt * 1.2); c.fillStyle = '#6a3a1e'; c.beginPath(); c.ellipse(0, 0, 34 * U2, 14 * U2, 0, 0, 3.14); c.fill(); c.fillStyle = '#d89a4a'; c.beginPath(); c.ellipse(0, 0, 34 * U2, 8 * U2, 0, 0, 7); c.fill(); c.restore();
        const rv = Math.max(0, Math.min(1, (k2 - 0.3) / 1.4)); U.river = rv;
        if (rv > 0) { c.save(); c.lineCap = 'round'; c.lineJoin = 'round'; const n = 60; c.beginPath(); c.moveTo(bx + 20 * U2, by + 10 * U2); for (let j = 0; j <= n * rv; j++) { const [x, y] = this.P(...this.at(this.len * j / n)); c.lineTo(x + Math.sin(j * 0.7 + t * 2) * 6 * U2, y); } c.strokeStyle = 'rgba(200,130,50,0.55)'; c.lineWidth = 46 * U2; c.stroke(); c.strokeStyle = 'rgba(255,220,160,0.35)'; c.lineWidth = 14 * U2; c.stroke(); c.restore();
          for (let j = 0; j < 14; j++) { const [x, y] = this.P(...this.at(this.len * ((j / 14) * rv))); const rr = (t * 0.6 + j * 0.13) % 1; c.strokeStyle = `rgba(255,240,220,${0.5 * (1 - rr)})`; c.lineWidth = 2; c.beginPath(); c.moveTo(x, y - rr * 40 * U2); c.quadraticCurveTo(x + 8 * U2, y - rr * 40 * U2 - 10 * U2, x, y - rr * 40 * U2 - 20 * U2); c.stroke(); } }
        for (const w of U.vic || []) { if (!this.alive(w) || w._river) continue; let near = false; const p2 = this.wp(w); for (let j = 0; j <= 60 * rv; j += 2) if (this.dist(this.at(this.len * j / 60), p2) < 70 * PX) { near = true; break; } if (near) { w._river = 1; w.spin = 2.2; w.amnesia = 10; this.act(w, 'idle', 2.2); this.hit(w, BOSS_DMG * 5, { force:true }); w.say = { s:pick([T('我……我係邊個？', '我……我是誰？'), T('我要去邊度？', '我要去哪？'), T('呢度係邊？', '這是哪裡？')]), t:2 }; setTimeout(() => { w.back = CELL * 2.5; }, 2200); } }
        return true; }
      if (k === 'toyol') { // 一陣風捲走全場路人手上嘢，再撒錢引人蹲低
        const k2 = U.t - at, vic = U.vic || [], gx = cx - vw / 2 + vw * Math.min(1.2, k2 / 1.0);
        if (k2 < 1.2) { c.strokeStyle = 'rgba(230,230,210,0.5)'; c.lineWidth = 2; for (let j = 0; j < 22; j++) { const yy = cy - vh / 2 + (j / 22) * vh, len = 60 + (j * 37 % 80); c.beginPath(); c.moveTo(gx - len * U2 - (j * 23 % 50), yy); c.quadraticCurveTo(gx - len * U2 * 0.5, yy - 8, gx - (j * 23 % 50), yy); c.stroke(); } }
        vic.forEach((w, j) => { if (w.gone) return; const [wx, wy] = this.P(...this.wp(w)); if (gx >= wx && !w._gust) { w._gust = 1; this.act(w, 'startle', 1.2); w.say = { s:pick([T('我部電話呢？', '我的手機呢？'), T('個袋飛咗！', '包包飛走了！'), T('我串魚蛋！', '我的魚蛋！')]), t:1.4 }; if (!w.el) { S.res.coins = (S.res.coins || 0) + 4; } }
          if (w._gust) { const e = Math.min(1, (k2 - (wx - (cx - vw / 2)) / vw) / 0.8); if (e < 1) { const ix = wx + e * vw * 0.4, iy = wy - b.h * 0.08 - Math.sin(e * Math.PI) * 50 * U2, kd = j % 4; c.save(); c.translate(ix, iy); c.rotate(e * 8); if (kd === 0) { c.fillStyle = '#222'; c.fillRect(-4 * U2, -7 * U2, 8 * U2, 14 * U2); c.fillStyle = '#7cc8ff'; c.fillRect(-3 * U2, -5 * U2, 6 * U2, 9 * U2); } else if (kd === 1) { c.fillStyle = '#a0522d'; c.fillRect(-8 * U2, -5 * U2, 16 * U2, 11 * U2); c.strokeStyle = '#5a2a10'; c.lineWidth = 2; c.beginPath(); c.arc(0, -5 * U2, 5 * U2, 3.14, 0); c.stroke(); } else if (kd === 2) { c.strokeStyle = '#8a6a3a'; c.lineWidth = 1.5; c.beginPath(); c.moveTo(-9 * U2, 0); c.lineTo(9 * U2, 0); c.stroke(); c.fillStyle = '#f0d070'; for (let q2 = 0; q2 < 3; q2++) { c.beginPath(); c.arc(-5 * U2 + q2 * 5 * U2, 0, 3 * U2, 0, 7); c.fill(); } } else { c.fillStyle = '#7fae6a'; c.fillRect(-9 * U2, -4 * U2, 18 * U2, 8 * U2); } c.restore(); } } });
        for (let j = 0; j < 3; j++) { const e = Math.min(1, k2 / 1.2), x = cx - vw / 2 + vw * e + (j - 1) * 30 * U2, y = cy + (j - 1) * vh * 0.2; try { ART.drawChar(c, 'toyol', x, y, b.h * 0.06 / 46, { t:t + j, walk:true, pose:'move', alpha:0.9, shadow:false }); } catch (e2) {} }
        if (k2 > 1.4) { const e = Math.min(1, (k2 - 1.4) / 0.6); for (let j = 0; j < 30; j++) { const a0 = j * 0.7, rr = e * vh * 0.4 * ((j * 13 % 10) / 10 + 0.3), x = cx + Math.cos(a0) * rr, y = cy + Math.sin(a0) * rr * 0.7 - Math.sin(e * Math.PI) * 40 * U2; c.fillStyle = '#ffd45a'; c.strokeStyle = '#7a4a10'; c.lineWidth = 1; c.beginPath(); c.ellipse(x, y, 5 * U2 * Math.abs(Math.cos(t * 6 + j)) + 1.5, 5 * U2, 0, 0, 7); c.fill(); c.stroke(); }
          if (!U.coinDone) { U.coinDone = 1; this.cap(T('撒錢喇！', '撒錢啦！'), (cx - b.x) / b.w, (cy - b.y) / b.h - 0.2, { style:'shake', col:'#ffe08a', size:20, font:'sans-serif' }); vic.forEach(w => { if (!this.alive(w)) return; const p2 = this.wp(w); this.addTrace('coins', p2[0], p2[1], 90, 6, { by:'toyol' }); this.act(w, 'cower', 3); w.target = 6; this.hit(w, BOSS_DMG * 4, { force:true }); w.say = null; }); } }
        return true; }
      if (k === 'n30_yukionna') { const g = c.createRadialGradient(cx, cy, vh * 0.1, cx, cy, vh * 0.8); g.addColorStop(0, 'rgba(200,235,255,0.1)'); g.addColorStop(1, `rgba(220,245,255,${0.55 * Math.min(1, q * 2)})`); c.fillStyle = g; c.fillRect(cx - vw / 2, cy - vh / 2, vw, vh); for (let j = 0; j < 40; j++) { const xx = cx - vw / 2 + ((j * 53) % 100) / 100 * vw, yy = cy - vh / 2 + ((t * 0.2 + j * 0.037) % 1) * vh; c.fillStyle = 'rgba(255,255,255,0.85)'; c.beginPath(); c.arc(xx, yy, 2.2, 0, 7); c.fill(); } return true; }
      if (k === 'n30_qionggui' || k === 'n30_taozhai' || k === 'n30_guhangui') { for (let j = 0; j < 26; j++) { const xx = cx - vw / 2 + ((j * 37) % 100) / 100 * vw, yy = cy - vh / 2 + ((q * 1.2 + j * 0.041) % 1.1) * vh; c.save(); c.translate(xx, yy); c.rotate(t * 3 + j); if (k === 'n30_taozhai') { c.fillStyle = '#f1e4c8'; c.fillRect(-9, -12, 18, 24); c.fillStyle = '#b01010'; c.font = '900 10px sans-serif'; c.textAlign = 'center'; c.fillText('債', 0, 4); } else if (k === 'n30_qionggui') { c.fillStyle = j % 2 ? '#7fae6a' : '#d8b450'; c.fillRect(-12, -5, 24, 10); } else { c.fillStyle = '#ffd45a'; c.beginPath(); c.ellipse(0, 0, 6 * Math.abs(Math.cos(t * 5 + j)) + 1, 6, 0, 0, 7); c.fill(); } c.restore(); } return true; }
      if (k === 'laojiang') { const e0 = Math.min(1, (U.t - at) / 2.0); for (let j = 0; j < 6; j++) { const e = e0 - j * 0.05; if (e <= 0 || e >= 1) continue; const pos = this.at(e * this.len), [x, y] = this.P(...pos), hop = Math.abs(Math.sin(e * Math.PI * 12)); for (const w of this.walkers) if (this.alive(w) && this.dist(this.wp(w), pos) < 0.09) { if (w.breath > 0) continue; this.hit(w, w.max, { force:true }); } try { ART.drawChar(c, 'laojiang', x, y - hop * 30, b.h * 0.1 / 58, { t:t + j * 0.1, walk:true, pose:'move', alpha:0.95 - j * 0.08, flip:false, shadow:false }); } catch (e2) {} } return true; }
      return false;
    },
    pickFor(i) {
      return this.pickRole(i);
      const sd = this.sd, p = sd.posts[i], spot = this.lay.posts[i];
      let el = $('#stt-pick'); if (!el) { el = document.createElement('div'); el.id = 'stt-pick'; document.body.appendChild(el); }
      const close = () => el.remove(), coins = Math.floor(S.res.coins || 0);
      if (p && p.g != null) { // 已建：升級
        const g = ghost(p.g); if (!g) return; const lv = p.lv || 1, a = this.stats(g, spot, lv), b2 = this.stats(g, spot, lv + 1), cost = this.upCost(p);
        el.innerHTML = `<div class="stp-card1"><div class="stp-top"><canvas data-pk="${g.k}"></canvas><div><b>${g.name}</b><small>${spot.n}・Lv${lv}</small><i>${T(a.K.n, a.K.zh)}</i></div></div>
          <p>${a.K.aura ? T('驚嚇值/秒', '驚嚇值/秒') : T('驚嚇值', '驚嚇值')}：${a.scare} → <em>${b2.scare}</em></p><p>${a.K.aura ? T('驚嚇頻率', '驚嚇頻率') : T('整備速度', '整備速度')}：${a.cd} 秒 → <em>${b2.cd} 秒</em></p>
          <div class="stp-row"><button class="stp-buy" id="stp-up" ${coins < cost || p.build > 0 ? 'disabled' : ''}>${T('升級', '升級')}　💴 ${cost}</button></div><div class="stp-row"><button id="stp-off">${T('收工（拆走）', '收工（拆走）')}</button><button id="stp-x">${T('關閉', '關閉')}</button></div></div>`;
        el.querySelector('#stp-up').onclick = () => { if ((S.res.coins || 0) < cost) return; S.res.coins -= cost; p.lv = lv + 1; p.max = Math.round(p.max * 1.2); p.hp = p.max; close(); save_(); Fx.toast(T(`${g.name} 升到 Lv${p.lv}！`, `${g.name} 升到 Lv${p.lv}！`)); };
        el.querySelector('#stp-off').onclick = () => { g.post = null; sd.posts[i] = null; close(); save_(); };
      } else { // 空格：二選一
        const list = freeGhosts().map(g => { const st2 = this.stats(g, spot, 1); return { g, st2, fit:(st2.K.ground && !spot.h) || (st2.K.high && spot.h) ? 2 : st2.K.aura ? 1 : 0 }; }).sort((x, y) => y.fit - x.fit || y.st2.scare - x.st2.scare).slice(0, 2);
        const price = (j) => (spot.h ? 105 : 90) + j * 5;
        el.innerHTML = `<div class="stp-card2"><div class="stp-h">${spot.n}<small>${spot.h ? T('高處崗', '高處崗') : T('地面崗', '地面崗')}${p && p.b ? T('・被 Bryan 佔咗，建造即奪返', '・被 Bryan 佔了，建造即奪回') : ''}</small></div><div class="stp-two">`
          + (list.length ? list.map((o, j) => `<div class="stp-opt"><div class="stp-frame"><canvas data-pk="${o.g.k}"></canvas></div><b>${o.g.name}</b><span class="stp-ico">${T(o.st2.K.n, o.st2.K.zh)}</span>
            <small>${o.st2.K.aura ? T('驚嚇值/秒', '驚嚇值/秒') : T('驚嚇值', '驚嚇值')}：${o.st2.scare}</small><small>${o.st2.K.aura ? T('驚嚇頻率', '驚嚇頻率') : T('整備速度', '整備速度')}：${o.st2.K.cd.toFixed(2)}秒</small>
            <button class="stp-buy" data-g="${o.g.id}" data-pr="${price(j)}" ${coins < price(j) ? 'disabled' : ''}>💴 ${price(j)}</button></div>`).join('') : `<p>${T('冇得閒嘅鬼。返村叫佢哋收工先。', '沒有空閒的鬼。先回村叫牠們收工。')}</p>`)
          + `</div><button id="stp-x" class="stp-x">${T('關閉', '關閉')}</button></div>`;
        el.querySelectorAll('[data-g]').forEach(btn => btn.onclick = () => {
          const g = ghost(+btn.dataset.g) || ghost(btn.dataset.g), pr = +btn.dataset.pr; if (!g || (S.res.coins || 0) < pr) return; S.res.coins -= pr;
          g.post = 'street'; const mx = Math.round(60 + power(g)); if (p && p.b) sd.lost = Math.max(0, sd.lost - 1);
          sd.posts[i] = { g:g.id, hp:mx, max:mx, lv:1, build:5, en:0 }; close(); save_(); Fx.toast(T(`開工建造：${g.name}・${spot.n}`, `開始建造：${g.name}・${spot.n}`));
        });
      }
      el.querySelectorAll('canvas[data-pk]').forEach(cv => { try { const im = ART.portrait(cv.dataset.pk, 80); cv.width = 80; cv.height = 80; cv.getContext('2d').drawImage(im, 0, 0, 80, 80); } catch (e) {} });
      const x = el.querySelector('#stp-x'); if (x) x.onclick = close; el.onclick = (e) => { if (e.target === el) close(); };
    },
  };
  return { TUNE, open:openStreet, close:closeStreet, Turf, site, st, hpMul, coinOf, addHot, HOT, SITES, KIND };
})();
