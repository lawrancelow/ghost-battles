// ===================== 新手引導：冥街夜市、亂葬崗 兩個任務 ＋ 「新地方」紅點 =====================
// 任務插進主線 QUESTS（存檔的 S.qi 是索引，所以舊存檔要搬：Guide.migrate()）。
// 紅點：世界地圖上的去處第一次開放、還沒去過 → 村口牌坊和地圖那個點都有紅點。存檔：S.visit = { street:1, yard:1, ... }
const Guide = (() => {
  // 劇情（粵語）
  SCENES.q_street = { style:'talk', bg:'village', title:'下班後', lines:[
    ['小紙', '少爺，你做到成隻鬼咁殘喇。'],
    ['阿福', '我本來就係鬼。'],
    ['小紙', '咁更加要放工啦！出村口行過去，有條冥街夜市，成晚都開。宵夜、講價、燒紙紮，乜都有。'],
    ['阿福', '……有冇得加班？'],
    ['小紙', '冇！今晚唔准加班。行，我帶你去。'],
  ] };
  SCENES.q_yard = { style:'talk', bg:'village', title:'無名墳', lines:[
    ['小紙', '少爺，打贏餓鬼王之後，村外面多咗啲鬼喺度徘徊。'],
    ['阿福', '又係搶包？'],
    ['小紙', '唔係。佢哋喺亂葬崗搵唔返自己個墳，瞓唔到。'],
    ['阿福', '搵唔返自己個墳……咁點算？'],
    ['小紙', '睇墓碑、聽佢哋講，幫佢哋一個個對返落去。出村口，地圖上嗰個「亂葬崗」。'],
  ] };
  // 插入位置：「出征 1-2」之後；「擊敗餓鬼王（1-3）」之後
  const ADD = [
    { after:'1-2', q:{ t:'visit', place:'street', text:'下班後去冥街夜市逛逛', go:'gate', r:{ exp:40, coins:60 }, onStart:['q_street'] } },
    { after:'1-3', q:{ t:'visit', place:'yard', text:'去亂葬崗找無名墳', go:'gate', r:{ exp:60, coins:80 }, onStart:['q_yard'] } },
  ];
  const at = [];
  for (const a of ADD) { const i = QUESTS.findIndex(q => q.t === 'stage' && q.s === a.after); if (i >= 0) at.push(i + 1); }
  ADD.slice().reverse().forEach((a, n) => { const i = QUESTS.findIndex(q => q.t === 'stage' && q.s === a.after); if (i >= 0) QUESTS.splice(i + 1, 0, a.q); });
  const QV = 2;
  // 舊存檔：插入點之後的任務索引往後挪；已經過了插入點的，當作那個新任務已完成（不倒退）
  function migrate(fresh) {
    if (!S.visit) S.visit = {};
    if (!S.wmSeen) S.wmSeen = {};
    if (fresh) S.qv = QV;
    if ((S.qv || 1) >= QV) return;
    const old = S.qi; let add = 0;
    at.forEach((pos) => { if (old >= pos) add++; }); // pos = 原本清單裡新任務插入的位置
    S.qi = old + add; S.qv = QV;
    // 舊玩家早就開放的地方，不要突然冒一堆紅點：已經去過亂葬崗／夜市的不知道，所以只把「已開放」的當作看過
    if (typeof World !== 'undefined') for (const s of World.SPOTS) if (open(s)) S.wmSeen[s.id] = 1;
  }
  function open(s) { return (!s.ready || s.ready()) && (!s.need || s.need()); }
  // 紅點：開放了、沒去過、也沒在地圖上看過
  function dot(id) { if (!S.visit) return false; const s = World.SPOTS.find(x => x.id === id); return !!s && !!open(s) && !S.visit[id] && !(S.wmSeen || {})[id] && id !== 'battle'; }
  function anyDot() { return typeof World !== 'undefined' && World.SPOTS.some(s => dot(s.id)); }
  function visit(id) { if (!S.visit) S.visit = {}; S.visit[id] = 1; Quest.check(); save(); }
  // 畫在村口牌坊上的紅點
  function drawGateDot(ctx, x, y, t) {
    if (!anyDot()) return; const r = 7 + Math.sin(t * 5) * 1.2;
    ctx.save(); ctx.fillStyle = '#e8303a'; ctx.strokeStyle = '#fff3e0'; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore();
  }
  return { migrate, dot, anyDot, visit, drawGateDot };
})();
