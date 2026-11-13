// ===================== 夜班巡陰（取代舊「搶地盤」）=====================
// 阿福半夜帶住自己個「部門」喺陰間野地巡邏：打倒嘅遊魂可以「送去投胎」（掉冥幣＋執念材料）或者「遞合約」收編入部門。
// 同村子綑綁：
//   部門 = 村入面冇派工嘅雜鬼（派咗工嘅留喺村做嘢）；編制 = 民宅嘅雜鬼名額；陰兵每 25 個跟一隊（最多 4 隊）
//   遞合約要付壽包（工資）；裝備用棺材板＋冥幣＋執念打造（gear.js 喺下面 Gear）；名鬼用村入面嘅鬼力（GP），升級即刻變強
//   主線關卡 = 每區嘅部門主管／區域總監：打贏就係通關（S.cleared），主線劇情、加入、任務照舊
// 地圖：每章一個區域，3 行 × 4 格 = 12 個區（之字形）；第 4、8 區出口有主管閘口，第 12 區盡頭係總監
const Patrol = (() => {
  const T = (yue, zh) => (typeof GP !== 'undefined' ? GP.T(yue, zh) : zh);
  const CW = 800, CH = 700, WW = CW * 4, WH = CH * 3, VIEW = 400, FOG = 100;
  const FAC = {
    yuan:{ name:'怨靈系', mat:'怨念', col:'#c890ff', d:'高輸出、脆' },
    chan:{ name:'餓鬼系', mat:'饞念', col:'#ffb85a', d:'吸血、越打越勇' },
    lan: { name:'躺平系', mat:'懶念', col:'#8fd0ff', d:'肉厚、拖慢敵人' },
  };
  const FAC_OF = { youhun:'lan', zhiren:'yuan', egui:'chan', xiaogui:'yuan', zombie:'lan', shuigui:'yuan', niutou:'lan', mamian:'chan', eguiking:'chan', toyol:'chan', laojiang:'lan', pontianak:'yuan', pocong:'lan', penanggal:'yuan', baiwu:'yuan', heiwu:'lan', huang:'chan', xiaozhi:'yuan', mengpo:'chan', tianhua:'yuan', afu:'lan' };
  function facOf(k) { if (FAC_OF[k]) return FAC_OF[k]; const sk = (typeof SKILLS !== 'undefined' && SKILLS[k]) || {}; if (sk.drain || sk.steal) return 'chan'; if (sk.kind === 'heal' || sk.apply === 'down' || sk.apply === 'push' || sk.sap) return 'lan'; return 'yuan'; }
  // 每章：出沒嘅新鬼來源（n30 出沒地）、地面顏色、擺設
  const REG = [
    { site:'field',   g0:'#1e2219', g1:'#2b3021', props:['tomb', 'tomb', 'tree', 'lantern', 'rock', 'grass', 'grass'] },
    { site:'kampung', g0:'#1c2318', g1:'#28331f', props:['stilt', 'palm', 'palm', 'well', 'bush', 'bush2', 'grass'] },
    { site:'road',    g0:'#231f1b', g1:'#312a22', props:['lamp', 'cart', 'stone', 'rock2', 'tomb', 'grass', 'tree'] },
    { site:'banana',  g0:'#18241c', g1:'#223325', props:['banana', 'banana', 'pond', 'hut', 'fern', 'grass', 'lantern'] },
    { site:'death',   g0:'#211b1e', g1:'#2e2328', props:['slamp', 'cone', 'bus', 'scooter', 'rock', 'grass'] },
    { site:'night',   g0:'#1b1a24', g1:'#262433', props:['pillar', 'cabinet', 'plant', 'cooler', 'pillar', 'grass'] },
  ];
  const CH_FOD = [['youhun', 'egui'], ['xiaogui'], ['zombie'], ['shuigui'], ['zhiren'], ['niutou', 'mamian']];
  // 區域設施（區號 0~11）：地鐵站、茶水間、扣押室、通宵加班房
  const FACI = [
    { t:'station', z:0, ox:-250, oy:-70 }, { t:'tea', z:2, ox:220, oy:-60 }, { t:'station', z:4, ox:250, oy:-170 },
    { t:'prison', z:5, ox:0, oy:200 }, { t:'tea', z:6, ox:-220, oy:190 }, { t:'station', z:8, ox:-250, oy:-150 },
    { t:'overtime', z:9, ox:0, oy:190 }, { t:'tea', z:10, ox:220, oy:-170 },
  ];
  const TEA_CD = 60, DOWN_T = 4.5;
  const MEET = [
    ['龐總：「阿福，臨時開會。你部門今晚嘅表現，我哋逐張 slide 傾。」', '龐總：「阿福，臨時開會。你部門今晚的表現，我們一張張投影片來談。」'],
    ['龐總：「倒低唔緊要，最緊要寫低原因，聽朝交檢討報告。」', '龐總：「倒下不要緊，最要緊是寫下原因，明早交檢討報告。」'],
    ['龐總：「我唔係話你唔努力，我係話你努力得唔夠有效率。」', '龐總：「我不是說你不努力，我是說你努力得不夠有效率。」'],
    ['龐總：「你知唔知你倒低嗰陣，Bryan 喺度打緊卡？」', '龐總：「你知不知道你倒下的時候，Bryan 在打卡？」'],
    ['龐總：「下次記得，倒低之前先 cc 埋我。」', '龐總：「下次記得，倒下之前先 cc 我。」'],
    ['龐總：「部門唔係你一個人嘅，係公司嘅。返去休息，聽日再嚟。」', '龐總：「部門不是你一個人的，是公司的。回去休息，明天再來。」'],
    ['龐總：「呢個會好短，十五分鐘。」（開咗兩個鐘）', '龐總：「這個會很短，十五分鐘。」（開了兩小時）'],
    ['龐總：「你今晚收咗幾多隻？唔緊要，數字唔會呃人，我會。」', '龐總：「你今晚收了幾隻？沒關係，數字不會騙人，我會。」'],
    ['冼小姐：「阿福，你嘅病假紙要喺陰司系統度補返，唔該。」', '冼小姐：「阿福，你的病假單要在陰司系統裡補上，謝謝。」'],
    ['龐總：「我哋係一個大家庭。家庭成員倒低咗，就要扣錢。」', '龐總：「我們是一個大家庭。家庭成員倒下了，就要扣錢。」'],
    ['龐總：「我欣賞你嘅衝勁。下次衝之前，先睇下地圖。」', '龐總：「我欣賞你的衝勁。下次衝之前，先看一下地圖。」'],
    ['龐總：「阿福，你嘅 KPI 好似你嘅心跳，平咗。」', '龐總：「阿福，你的 KPI 跟你的心跳一樣，平了。」'],
    ['冼小姐：「依公司規定，巡邏倒低唔計工傷，計自願加班。」', '冼小姐：「依公司規定，巡邏倒下不算工傷，算自願加班。」'],
    ['龐總：「你唔使驚，我唔會炒你。死咗嘅人炒唔到。」', '龐總：「你不用怕，我不會開除你。死了的人開除不了。」'],
    ['龐總：「我年輕嗰陣巡夜，一個人打一條街。」（佢冇巡過）', '龐總：「我年輕的時候巡夜，一個人打一條街。」（他沒巡過）'],
    ['龐總：「失敗係成功之母。你個媽燒咗咁多嘢落嚟，你都要爭啖氣。」', '龐總：「失敗是成功之母。你媽燒了那麼多東西下來，你也要爭口氣。」'],
    ['龐總：「下次帶多啲人。唔夠人？自己諗辦法，呢個叫 ownership。」', '龐總：「下次帶多點人。人不夠？自己想辦法，這叫 ownership。」'],
    ['冼小姐：「部門士氣調查：你個部門 0 分。唔係，係負分。」', '冼小姐：「部門士氣調查：你的部門 0 分。不對，是負分。」'],
    ['龐總：「今晚當交學費。學費邊個俾？你。」', '龐總：「今晚就當交學費。學費誰付？你。」'],
    ['龐總：「散會。阿福留低，我哋私下再傾下你嘅前途。」', '龐總：「散會。阿福留下，我們私下再談談你的前途。」'],
  ];
  const D = (a) => T(a[0], a[1]);
  const has = (x) => typeof x !== 'undefined';

  // ---------- 存檔 ----------
  function st() {
    if (!S.pt) S.pt = {};
    const p = S.pt;
    p.reg = p.reg || {}; p.mats = p.mats || { yuan:0, chan:0, lan:0 }; p.pity = p.pity || {}; p.lead = p.lead || null;
    if (p.min == null) p.min = 18 * 60; p.kills = p.kills || 0; p.rec = p.rec || 0; p.poach = p.poach || [];
    return p;
  }
  function regSt(ci) { const p = st(); if (!p.reg[ci]) p.reg[ci] = { fog:'', sta:{ 0:1 }, ot:-1, pr:-1 }; const r = p.reg[ci]; r.sta = r.sta || { 0:1 }; return r; }
  const sidOf = (ci, si) => `${ci + 1}-${si + 1}`;
  function regionOpen(ci) { return ci === 0 || !!S.cleared[sidOf(ci - 1, 2)]; }
  function zoneCell(z) { const r = Math.floor(z / 4), c = r % 2 ? 3 - (z % 4) : z % 4; return { r, c, x:c * CW + CW / 2, y:r * CH + CH / 2 }; }
  function zoneAt(x, y) { const r = Math.max(0, Math.min(2, Math.floor(y / CH))), c = Math.max(0, Math.min(3, Math.floor(x / CW))); return r * 4 + (r % 2 ? 3 - c : c); }
  function zoneP(ci, z) {
    const sts = CHAPTERS[ci].stages, si = Math.floor(z / 4), hi = sts[si].p;
    const lo = si > 0 ? sts[si - 1].p : ci > 0 ? CHAPTERS[ci - 1].stages[2].p : 0;
    return lo + (hi - lo) * ((z % 4) + 1) / 4;
  }
  function zoneName(ci, z) { const s = CHAPTERS[ci].stages[Math.floor(z / 4)]; return `${s.name}・${'一二三四'[z % 4]}`; }
  // 閘口：0 = 第 4→5 區（右上落去），1 = 第 8→9 區（左中落去）；守住佢嘅係該段主線關卡
  const GATES = [{ x:CW * 3.5, y:CH, si:0 }, { x:CW * 0.5, y:CH * 2, si:1 }];
  const GW = 220;
  function guardPos(si) { return si === 0 ? { x:CW * 3.5, y:CH - 110 } : si === 1 ? { x:CW * 0.5, y:CH * 2 - 110 } : { x:CW * 3.5 + 90, y:CH * 2.5 }; }
  function faciPos(f) { const c = zoneCell(f.z); return { x:c.x + f.ox, y:c.y + f.oy }; }
  function elitesOf(ci) { return has(N30W) ? N30W.ids().filter(k => N30_G[k].at === REG[ci].site) : []; }
  function eliteOfZone(ci, z) { const l = elitesOf(ci); if (!l.length) return null; const k = l[z % l.length]; return (z < l.length || z % 2 === 0) && N30W.open(k) ? k : null; }
  function fodOf(ci) { let a = []; for (let i = 0; i <= ci; i++) a = a.concat(CH_FOD[i]); return a; }
  // 陰間時鐘：一日 = 現實 12 分鐘
  function phase(min) { const h = Math.floor(min / 60); return h < 4 ? 'zi' : h < 8 ? 'off' : h < 18 ? 'work' : 'ot'; }
  const PH = { zi:{ n:'子時', d:'凶鬼出沒・掉落×2・收編 -10%' }, off:{ n:'收工', d:'遊魂變少變慢・收編 +10%' }, work:{ n:'上班時間', d:'遊魂在摸魚，不惹牠就不動' }, ot:{ n:'加班時間', d:'遊魂正常巡邏' } };

  // ---------- 部門 ----------
  const crewCap = () => Math.min(12, 3 + (S.bld.home || 0));
  const troopTeams = () => Math.min(4, Math.floor((S.res.troops || 0) / 25));
  function crewList() { // 冇派工、未過勞、未俾人挖走嘅雜鬼，等級高先
    return S.ghosts.filter(g => (g.q === '藍' || g.q === '紫') && !g.post && !g.poached && (g.fat || 0) < 100).sort((a, b) => F.glv(b) - F.glv(a)).slice(0, crewCap());
  }
  function leads() { const p = st(); let ids = p.lead; if (!ids) ids = S.team.filter(id => id && id !== 'afu'); return ids.map(ghostById).filter(g => g && g.k !== 'afu').slice(0, 3); }
  function restRecover() { const p = st(), now = Date.now(); if (p.restAt) { const m = (now - p.restAt) / 60000; if (m > 0) S.ghosts.forEach(g => { if (g.fat) g.fat = Math.max(0, g.fat - m * 2); }); } p.restAt = now; }

  // ---------- 單位 ----------
  let R = null; // 今次巡邏
  function unitFromGhost(g, role) {
    const P = F.stat(g, 0), A = F.stat(g, 2), dm = GP.drillMul(g.k), d = gdef(g), gm = has(Gear) ? Gear.unitMul(g) : { atk:1, hp:1 };
    const crew = role === 'crew', fac = facOf(g.k), cm = crew && R ? R.crewBuff[fac] || { atk:1, hp:1 } : { atk:1, hp:1 };
    const hp = (crew ? 220 + P * 6 + A * 3 : 300 + P * 8 + A * 4) * dm * gm.hp * cm.hp, atk = (crew ? 15 + A * 1.1 : 20 + A * 1.4) * dm * gm.atk * cm.atk;
    const rng = d.range === 'ranged' ? 150 : 46;
    return { side:0, role, g, gid:g.id, k:g.k, name:g.name, fac, hp, maxhp:hp, atk, rng, aspd:rng > 60 ? 1.2 : 1.0, spd:role === 'lead' ? 160 : 175, cd:Math.random() * 0.6, energy:role === 'crew' ? 0 : 30, sk:role === 'crew' ? null : SKILLS[g.k], s:role === 'afu' ? 0.6 : role === 'lead' ? 0.6 : 0.48, x:0, y:0, ox:0, oy:0, flip:false, anim:0, hurt:0 };
  }
  function troopUnit(i) {
    const tb = 1 + 0.08 * Math.max(0, S.bld.home - 1), hp = (90 + 14 * S.lv) * tb;
    return { side:0, role:'troop', k:'youhun', name:'陰兵', hp, maxhp:hp, atk:(9 + 2.2 * S.lv) * tb, rng:40, aspd:1, spd:175, cd:Math.random(), energy:0, s:0.4, x:0, y:0, ox:0, oy:0, ti:i, anim:0, hurt:0 };
  }
  function foe(k, p, mul, extra) {
    const t = ENEMY_T[k] || [1, 1, k], zi = R && phase(st().min) === 'zi' ? 1.3 : 1;
    const hp = (260 + 90 * p) * t[0] * 0.55 * (mul ? mul.hp : 1) * zi, atk = (16 + 7.5 * p) * t[1] * 0.6 * (mul ? mul.atk : 1) * zi;
    const d = GHOSTS[k] || FODDER[k] || {}, rng = d.range === 'ranged' || ['zhiren', 'penanggal'].includes(k) ? 140 : 44;
    return Object.assign({ side:1, k, name:t[2], fac:facOf(k), p, hp, maxhp:hp, atk, rng, aspd:rng > 60 ? 1.3 : 1.1, spd:k === 'xiaogui' ? 120 : 100, cd:Math.random(), energy:0, sk:SKILLS[k] && extra && (extra.elite || extra.guard != null || extra.otBoss) ? SKILLS[k] : null, s:0.5, x:0, y:0, ox:0, oy:0, anim:0, hurt:0, flip:true }, extra || {});
  }

  // ---------- 地面、擺設 ----------
  function seeded(n) { let s = n * 9301 + 49297; return () => (s = (s * 9301 + 49297) % 233280) / 233280; }
  function mkPattern(ci) {
    const c = document.createElement('canvas'); c.width = c.height = 256; const x = c.getContext('2d'), rg = REG[ci], rnd = seeded(ci + 7);
    x.fillStyle = rg.g0; x.fillRect(0, 0, 256, 256);
    for (let i = 0; i < 260; i++) { // 蠟筆短筆觸
      const px = rnd() * 256, py = rnd() * 256, l = 4 + rnd() * 12, a = rnd() * Math.PI;
      x.strokeStyle = i % 3 ? rg.g1 : 'rgba(0,0,0,.35)'; x.globalAlpha = 0.25 + rnd() * 0.4; x.lineWidth = 1 + rnd() * 1.6; x.lineCap = 'round';
      x.beginPath(); x.moveTo(px, py); x.lineTo(px + Math.cos(a) * l, py + Math.sin(a) * l); x.stroke();
    }
    x.globalAlpha = 1; return c;
  }
  // 擋路嘅擺設（半徑，世界單位）
  const SOLID = { tomb:20, tree:18, stilt:46, palm:12, well:28, lamp:8, cart:30, stone:20, rock2:30, banana:14, pond:44, hut:42, slamp:8, bus:46, scooter:26, pillar:22, cabinet:22, cooler:16, rock:24 };
  let PGRID = {};
  function mkProps(ci) {
    PGRID = {};
    const rnd = seeded(ci * 31 + 3), out = [], rg = REG[ci];
    const avoid = [...FACI.map(faciPos), ...FACI.filter(f => f.t === 'station').map(f => { const q = faciPos(f); return { x:q.x + 60, y:q.y + 60 }; }), ...GATES.map(g => ({ x:g.x, y:g.y })), guardPos(0), guardPos(1), guardPos(2)];
    for (let i = 0; i < 420 && out.length < 230; i++) {
      const x = 40 + rnd() * (WW - 80), y = 40 + rnd() * (WH - 80), t = rg.props[Math.floor(rnd() * rg.props.length)], sc = 0.75 + rnd() * 0.5, big = SOLID[t] ? 1 : 0;
      if (avoid.some(a => Math.hypot(a.x - x, a.y - y) < (big ? 190 : 150))) continue;
      if (Math.abs(y % CH) < 90 || Math.abs(y % CH) > CH - 60) continue;
      if (out.some(o => Math.hypot(o.x - x, (o.y - y) * 1.4) < (SOLID[o.t] || big ? 120 : 70))) continue;
      out.push({ x, y, t, s:sc, v:rnd(), r:SOLID[t] ? SOLID[t] * sc : 0 });
    }
    out.forEach(o => { if (!o.r) return; const k = Math.floor(o.x / 200) + ',' + Math.floor(o.y / 200); (PGRID[k] = PGRID[k] || []).push(o); });
    return out;
  }
  function drawProp(c, p) {
    const s = p.s, x = p.x, y = p.y; c.save(); c.lineCap = 'round'; c.lineJoin = 'round';
    const ink = 'rgba(10,8,12,.85)';
    const shadow = (w) => { c.fillStyle = 'rgba(0,0,0,.35)'; c.beginPath(); c.ellipse(x, y + 2, w * s, w * 0.32 * s, 0, 0, 7); c.fill(); };
    switch (p.t) {
      case 'tomb': shadow(20); c.fillStyle = '#5a5650'; c.strokeStyle = ink; c.lineWidth = 2.2; c.beginPath(); c.moveTo(x - 14 * s, y); c.lineTo(x - 14 * s, y - 26 * s); c.quadraticCurveTo(x, y - 40 * s, x + 14 * s, y - 26 * s); c.lineTo(x + 14 * s, y); c.closePath(); c.fill(); c.stroke();
        c.strokeStyle = 'rgba(200,190,170,.4)'; c.lineWidth = 1.3; c.beginPath(); c.moveTo(x - 5 * s, y - 24 * s); c.lineTo(x + 5 * s, y - 24 * s); c.moveTo(x, y - 30 * s); c.lineTo(x, y - 10 * s); c.stroke(); break;
      case 'tree': shadow(26); c.strokeStyle = '#2a211b'; c.lineWidth = 5 * s; c.beginPath(); c.moveTo(x, y); c.lineTo(x + 2 * s, y - 40 * s); c.moveTo(x + 1 * s, y - 26 * s); c.lineTo(x - 16 * s, y - 50 * s); c.moveTo(x + 2 * s, y - 36 * s); c.lineTo(x + 18 * s, y - 56 * s); c.stroke();
        c.lineWidth = 2.4 * s; c.beginPath(); c.moveTo(x - 10 * s, y - 42 * s); c.lineTo(x - 20 * s, y - 44 * s); c.moveTo(x + 12 * s, y - 48 * s); c.lineTo(x + 24 * s, y - 50 * s); c.stroke(); break;
      case 'grass': c.strokeStyle = p.v > 0.5 ? '#3c4a2c' : '#4a4430'; c.lineWidth = 1.6; c.beginPath(); for (let i = -3; i <= 3; i++) { c.moveTo(x + i * 3 * s, y); c.lineTo(x + i * 4.5 * s + (p.v - 0.5) * 6, y - (8 + Math.abs(i) * -1 + 6) * s); } c.stroke(); break;
      case 'rock': shadow(16); c.fillStyle = '#3e3b3a'; c.strokeStyle = ink; c.lineWidth = 2; c.beginPath(); c.moveTo(x - 15 * s, y); c.lineTo(x - 10 * s, y - 12 * s); c.lineTo(x + 4 * s, y - 15 * s); c.lineTo(x + 15 * s, y - 4 * s); c.lineTo(x + 12 * s, y); c.closePath(); c.fill(); c.stroke(); break;
      case 'lantern': shadow(8); c.strokeStyle = '#2a211b'; c.lineWidth = 2.5; c.beginPath(); c.moveTo(x, y); c.lineTo(x, y - 40 * s); c.lineTo(x + 10 * s, y - 40 * s); c.stroke();
        { const g = c.createRadialGradient(x + 10 * s, y - 32 * s, 2, x + 10 * s, y - 32 * s, 34 * s); g.addColorStop(0, 'rgba(255,90,60,.4)'); g.addColorStop(1, 'rgba(255,90,60,0)'); c.fillStyle = g; c.fillRect(x - 30 * s, y - 70 * s, 80 * s, 76 * s); }
        c.fillStyle = '#c8402c'; c.beginPath(); c.ellipse(x + 10 * s, y - 32 * s, 6 * s, 8 * s, 0, 0, 7); c.fill(); c.strokeStyle = ink; c.lineWidth = 1.5; c.stroke(); break;
      case 'palm': case 'banana': shadow(24); c.strokeStyle = '#3a2c1c'; c.lineWidth = 4 * s; c.beginPath(); c.moveTo(x, y); c.quadraticCurveTo(x + 6 * s, y - 30 * s, x + 2 * s, y - 52 * s); c.stroke();
        c.strokeStyle = p.t === 'banana' ? '#2d4a26' : '#33402a'; c.lineWidth = (p.t === 'banana' ? 7 : 3.5) * s; c.beginPath(); for (let i = 0; i < 5; i++) { const a = -Math.PI / 2 + (i - 2) * 0.7; c.moveTo(x + 2 * s, y - 52 * s); c.quadraticCurveTo(x + 2 * s + Math.cos(a) * 18 * s, y - 52 * s + Math.sin(a) * 18 * s - 6 * s, x + 2 * s + Math.cos(a) * 30 * s, y - 50 * s + Math.sin(a) * 26 * s + 14 * s); } c.stroke(); break;
      case 'stilt': shadow(34); c.strokeStyle = ink; c.lineWidth = 2.2; c.fillStyle = '#3a2e24'; c.fillRect(x - 26 * s, y - 44 * s, 52 * s, 22 * s); c.strokeRect(x - 26 * s, y - 44 * s, 52 * s, 22 * s);
        c.fillStyle = '#2a201a'; c.beginPath(); c.moveTo(x - 32 * s, y - 44 * s); c.lineTo(x, y - 62 * s); c.lineTo(x + 32 * s, y - 44 * s); c.closePath(); c.fill(); c.stroke();
        c.beginPath(); for (const dx of [-22, -8, 8, 22]) { c.moveTo(x + dx * s, y - 22 * s); c.lineTo(x + dx * s, y); } c.stroke(); c.fillStyle = 'rgba(255,200,110,.5)'; c.fillRect(x - 6 * s, y - 40 * s, 10 * s, 10 * s); break;
      case 'lamp': shadow(8); c.strokeStyle = '#1a1818'; c.lineWidth = 3; c.beginPath(); c.moveTo(x, y); c.lineTo(x, y - 54 * s); c.quadraticCurveTo(x, y - 62 * s, x + 12 * s, y - 60 * s); c.stroke();
        { const g = c.createRadialGradient(x + 12 * s, y - 56 * s, 2, x + 12 * s, y - 40 * s, 50 * s); g.addColorStop(0, p.v > 0.3 ? 'rgba(200,230,170,.35)' : 'rgba(0,0,0,0)'); g.addColorStop(1, 'rgba(0,0,0,0)'); c.fillStyle = g; c.fillRect(x - 40 * s, y - 100 * s, 104 * s, 104 * s); } break;
      case 'cart': shadow(22); c.fillStyle = '#3b2f25'; c.strokeStyle = ink; c.lineWidth = 2; c.fillRect(x - 18 * s, y - 20 * s, 36 * s, 12 * s); c.strokeRect(x - 18 * s, y - 20 * s, 36 * s, 12 * s); c.beginPath(); c.arc(x - 10 * s, y - 5 * s, 6 * s, 0, 7); c.arc(x + 12 * s, y - 5 * s, 6 * s, 0, 7); c.stroke(); break;
      case 'cone': shadow(10); c.fillStyle = '#c4572c'; c.strokeStyle = ink; c.lineWidth = 1.8; c.beginPath(); c.moveTo(x - 9 * s, y); c.lineTo(x, y - 24 * s); c.lineTo(x + 9 * s, y); c.closePath(); c.fill(); c.stroke(); c.fillStyle = '#ddd'; c.fillRect(x - 5 * s, y - 13 * s, 10 * s, 3 * s); break;
      case 'pillar': shadow(18); c.fillStyle = '#2b2733'; c.strokeStyle = ink; c.lineWidth = 2; c.fillRect(x - 12 * s, y - 70 * s, 24 * s, 70 * s); c.strokeRect(x - 12 * s, y - 70 * s, 24 * s, 70 * s); c.strokeStyle = 'rgba(160,140,190,.25)'; c.beginPath(); c.moveTo(x - 4 * s, y - 66 * s); c.lineTo(x - 4 * s, y - 4 * s); c.stroke(); break;
      default: if (p.t !== 'desk') { p.t = 'rock'; drawProp(c, p); break; }
      case 'desk': shadow(24); c.fillStyle = '#3a3136'; c.strokeStyle = ink; c.lineWidth = 2; c.fillRect(x - 22 * s, y - 22 * s, 44 * s, 8 * s); c.strokeRect(x - 22 * s, y - 22 * s, 44 * s, 8 * s); c.beginPath(); c.moveTo(x - 18 * s, y - 14 * s); c.lineTo(x - 18 * s, y); c.moveTo(x + 18 * s, y - 14 * s); c.lineTo(x + 18 * s, y); c.stroke(); c.fillStyle = 'rgba(140,200,255,.4)'; c.fillRect(x - 8 * s, y - 36 * s, 16 * s, 12 * s); break;
    }
    c.restore();
  }

  // ---------- 開始／結束 ----------
  function intro(then) {
    const p = st(); if (p.introSeen) { then && then(); return; }
    p.introSeen = 1; save();
    Story.queue({ style:'narr', lines:[
      ['龐總', T('各位同事，宣佈新政策：「夜班巡陰計劃」。由今晚開始，搶地盤取消，改為巡邏。', '各位同事，宣佈新政策：「夜班巡陰計劃」。從今晚開始，取消搶地盤，改為巡邏。')],
      ['龐總', T('每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。', '每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。')],
      ['冼小姐', T('提提大家：收編要有編制，編制睇民宅。合約工資係壽包，自己準備。', '提醒大家：收編要有編制，編制看民宅。合約工資是壽包，自己準備。')],
      ['龐總', T('仲有，部門唔好做到過勞。過勞咗……都係你哋自己嘅事。', '還有，部門不要做到過勞。過勞了……也是你們自己的事。')],
      ['阿福', T('……即係同以前一樣。', '……就是跟以前一樣。')],
    ] }, then);
  }
  function openPrep() {
    restRecover(); UI.close();
    const show = () => { UI.sheet('夜班巡陰', prepHTML()); bindPrep(); };
    if (!st().introSeen) intro(show); else show();
  }
  function prepHTML() {
    const p = st(), crew = crewList(), ld = leads(), all = S.ghosts.filter(g => g.q === '藍' || g.q === '紫');
    const busy = all.filter(g => g.post).length, tired = all.filter(g => !g.post && (g.fat || 0) >= 100).length, poached = all.filter(g => g.poached).length;
    let h = `<p class="desc">${T('帶部門出去巡邏。打倒嘅遊魂：<b>送去投胎</b>（冥幣＋執念）或者<b>遞合約</b>收編（要編制同壽包）。部門主管同區域總監就係主線關卡。', '帶部門出去巡邏。打倒的遊魂：<b>送去投胎</b>（冥幣＋執念）或<b>遞合約</b>收編（要編制和壽包）。部門主管和區域總監就是主線關卡。')}</p>`;
    h += `<div class="pt-mats">${Object.keys(FAC).map(f => `<span style="color:${FAC[f].col}"><b>${FAC[f].mat}</b> ${fmt(p.mats[f])}</span>`).join('')}<span><b>壽包</b> ${fmt(S.res.buns)}</span></div>`;
    // 部門
    h += `<div class="pt-box"><div class="pt-bh"><b>我的部門</b><button class="btn sm" id="pt-gear">裝備房</button></div>`;
    h += `<div class="pt-lead">${[0, 1, 2].map(i => { const g = ld[i]; return `<div class="pt-ls" data-ls="${i}">${g ? `<canvas data-por="${g.k}"></canvas><b>${g.name}</b><small>${GP.T('鬼力', '鬼力')} ${GP.pow(g)}</small>` : '<span>＋<br>帶隊主管</span>'}</div>`; }).join('')}</div>`;
    h += `<p class="desc">組員 <b>${crew.length}</b>／編制 ${crewCap()}（民宅越高級編制越多）　陰兵 ${troopTeams()} 隊（每 25 個一隊，最多 4 隊）</p>`;
    h += `<div class="pt-crew">${crew.map(g => `<span class="pt-cm" title="${g.name}"><canvas data-por="${g.k}"></canvas><i style="background:${FAC[facOf(g.k)].col}"></i><s style="width:${Math.min(100, g.fat || 0)}%"></s><em>Lv${F.glv(g)}</em></span>`).join('') || '<small>（村裡沒有閒置的雜鬼。先去招魂台招，或在巡邏中收編。）</small>'}</div>`;
    if (busy || tired || poached) h += `<p class="desc pt-note">${busy ? `${busy} 隻派了工，留在村裡做事。` : ''}${tired ? `${tired} 隻過勞請病假（在村裡休息會慢慢恢復）。` : ''}${poached ? `<b class="pt-red">${poached} 隻被 Bryan 挖角</b>：在巡邏中打贏 Bryan 部門就能搶回來。` : ''}</p>`;
    h += `</div>`;
    // 區域
    const p0 = st();
    h += `<div class="pt-regs">`;
    CHAPTERS.forEach((ch, ci) => {
      const open = regionOpen(ci), r = regSt(ci), n = ch.stages.filter((s, si) => S.cleared[sidOf(ci, si)]).length;
      const cur = open && n < 3, stas = FACI.filter(f => f.t === 'station' && r.sta[f.z]);
      h += `<div class="pt-reg ${open ? '' : 'locked'} ${cur ? 'cur' : ''}"><div><b>第${'一二三四五六'[ci]}區・${ch.name}</b><small>${open ? `主線 ${n}/3　${GP.T('建議鬼力', '建議鬼力')} ${GP.stageNeed(ch.stages[Math.min(2, n)], sidOf(ci, Math.min(2, n)))}　需主公 Lv${ch.stages[0].req}` : '打完上一區總監才開放'}</small></div>${open ? `<div class="pt-go">${stas.map(f => `<button class="btn sm ${cur && f.z === 0 ? 'gold' : ''}" data-go="${ci},${f.z}">${f.z === 0 ? '出發' : `${f.z + 1}區站`}</button>`).join('')}</div>` : '<span class="lk">🔒</span>'}</div>`;
    });
    if (S.seen.ch1_end && typeof Sports !== 'undefined') h += `</div><div class="sc-entry sp-entry"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class="btn gold" id="sp-open">參加</button>`;
    h += `</div><label class="pt-auto"><input type="checkbox" id="pt-autoc" ${p0.auto ? 'checked' : ''}> 自動送去投胎（不用逐隻選；遞合約要手動）</label>`;
    return h;
  }
  function bindPrep() {
    const root = $('#sheet'); paintPortraits(root);
    root.querySelectorAll('[data-go]').forEach(b => b.onclick = () => { const [ci, z] = b.dataset.go.split(',').map(Number); start(ci, z); });
    root.querySelectorAll('[data-ls]').forEach(b => b.onclick = () => pickLead(+b.dataset.ls));
    const gb = $('#pt-gear'); if (gb) gb.onclick = () => Gear.open(() => openPrep());
    const spo = $('#sp-open'); if (spo) spo.onclick = () => { UI.close(); Sports.open(); };
    const ac = $('#pt-autoc'); if (ac) ac.onchange = () => { st().auto = ac.checked; save(); };
  }
  function pickLead(i) {
    const p = st(), cur = leads().map(g => g.id); const now = cur[i];
    const list = S.ghosts.filter(g => g.q === '名').sort((a, b) => GP.pow(b) - GP.pow(a));
    let h = `<p class="desc">選帶隊主管（最多 3 隻）。主管不佔編制，倒下 25 秒後自動歸隊。</p><div class="glist">`;
    if (now) h += `<div class="gi" data-g=""><div><b>— 空著 —</b></div></div>`;
    for (const g of list) h += `<div class="gi ${g.id === now ? 'sel' : ''}" data-g="${g.id}"><canvas data-por="${g.k}"></canvas><div><b>${g.name}</b> ${cur.includes(g.id) ? '<i class="tag">帶隊中</i>' : ''}<small>Lv${F.glv(g)}　<b class="gp-pw">${GP.T('鬼力', '鬼力')} ${GP.pow(g)}</b>　<span style="color:${FAC[facOf(g.k)].col}">${FAC[facOf(g.k)].name}</span></small><small class="sk">【${SKILLS[g.k].name}】${SKILLS[g.k].desc}</small></div></div>`;
    h += `</div><button class="btn wide" id="pkback">返回</button>`;
    UI.sheet('帶隊主管', h); paintPortraits($('#sheet'));
    $('#pkback').onclick = () => openPrep();
    $('#sheet').querySelectorAll('.gi').forEach(el => el.onclick = () => {
      const id = el.dataset.g || null, arr = cur.slice(); while (arr.length < 3) arr.push(null);
      const j = id ? arr.indexOf(id) : -1; if (j >= 0) arr[j] = arr[i]; arr[i] = id;
      p.lead = arr.filter(Boolean); save(); openPrep();
    });
  }

  function start(ci, z) {
    UI.close(); restRecover();
    const ch = CHAPTERS[ci], any = ch.intro.some(id => !S.seen[id]);
    ch.intro.forEach(id => { if (!S.seen[id]) Story.queue(id); });
    const go = () => begin(ci, z);
    if (any) Story.queue({ style:'narr', lines:[['旁白', `第${'一二三四五六'[ci]}區・${ch.name}`]] }, go); else go();
  }
  function begin(ci, z0) {
    const p = st(), rs = regSt(ci);
    R = { ci, units:[], foes:[], fx:[], proj:[], downs:[], t:0, joy:null, keys:{}, cam:{ x:0, y:0 }, packs:{}, nextSp:{}, zoneSeen:{}, tea:{}, act:null,
      loot:{ coins:0, exp:0, yuan:0, chan:0, lan:0, rec:0, kills:0, buns:0 }, streak:0, bryan:null, bryanDone:false, ended:false, gearMsg:'',
      pat:null, props:mkProps(ci), fog:(rs.fog || '').padEnd(Math.ceil(WW / FOG) * Math.ceil(WH / FOG), '0').split(''), crewBuff:has(Gear) ? Gear.crewBuff() : {} };
    const sp = faciPos(FACI.find(f => f.t === 'station' && f.z === z0) || FACI[0]);
    const lx = sp.x + 60, ly = sp.y + 60;
    const afu = ghostById('afu'); const L0 = unitFromGhost(afu, 'afu'); L0.x = lx; L0.y = ly; L0.leader = true; R.units.push(L0); R.L = L0;
    leads().forEach((g, i) => { const u = unitFromGhost(g, 'lead'); u.slot = i; R.units.push(u); });
    crewList().forEach((g, i) => { const u = unitFromGhost(g, 'crew'); u.slot = 3 + i; if ((g.fat || 0) >= 70) u.atk *= 0.7; R.units.push(u); });
    for (let i = 0; i < troopTeams(); i++) { const u = troopUnit(i); u.slot = 20 + i; R.units.push(u); }
    R.units.forEach((u, i) => { if (!u.leader) { const o = formation(u.slot || i); u.x = lx + o.x; u.y = ly + o.y; } });
    R.cam.x = lx; R.cam.y = ly;
    // 有人俾 Bryan 挖咗：今晚 Bryan 一定出現
    R.bryanWant = S.ghosts.some(g => g.poached) || Math.random() < 0.4;
    mount(); active = true; Sound.setMode && Sound.setMode('battle');
    revealAround(lx, ly);
    if (has(Guide)) try { Guide.visit('battle'); } catch (e) {}
  }
  function formation(i) { // 圍住阿福嘅位置：主管近、組員一圈、陰兵最外
    if (i < 3) { const a = -Math.PI / 2 + (i - 1) * 1.1 + Math.PI; return { x:Math.cos(a) * 66, y:Math.sin(a) * 40 + 8 }; }
    if (i < 20) { const j = i - 3, ring = j < 6 ? 0 : 1, n = ring ? 7 : 6, a = (j % n) / n * Math.PI * 2 + ring * 0.4; const r = ring ? 150 : 108; return { x:Math.cos(a) * r, y:Math.sin(a) * r * 0.65 + 10 }; }
    const a = (i - 20) / 4 * Math.PI * 2 + 0.8; return { x:Math.cos(a) * 185, y:Math.sin(a) * 118 + 10 };
  }

  let active = false, el = null, cv = null, ctx = null, mini = null, raf = 0, last = 0;
  function mount() {
    el = $('#patrol'); if (!el) { el = document.createElement('section'); el.id = 'patrol'; document.body.appendChild(el); }
    el.innerHTML = `<canvas id="pt-cv"></canvas>
      <div id="pt-top"><button id="pt-quit" class="btn sm ghost">收工</button><div class="pt-ttl"><b id="pt-reg"></b><small id="pt-zone"></small></div><div class="pt-clk"><b id="pt-clock"></b><small id="pt-ph"></small></div></div>
      <div id="pt-res"></div><canvas id="pt-mini" width="132" height="88"></canvas>
      <div id="pt-msg"></div><div id="pt-act"></div><div id="pt-down"></div>
      <div id="pt-bar"><div id="pt-leads"></div><button id="pt-sk-auto" class="pt-tog"></button><button id="pt-pie" class="pt-rb"><b>畫大餅</b><i></i></button><button id="pt-dash" class="pt-rb big"><b>衝刺</b><i></i></button></div><div id="pt-end"></div>`;
    el.classList.add('on'); cv = $('#pt-cv'); ctx = cv.getContext('2d'); mini = $('#pt-mini');
    $('#pt-quit').onclick = (e) => { if (R && !R.ended) { if (!confirmInline(e.target, '確定收工？')) return; end(false); } };
    resize(); window.addEventListener('resize', resize);
    const bar = (id, fn) => { const b = $(id); b.onpointerdown = (e) => { e.stopPropagation(); e.preventDefault(); fn(); }; };
    bar('#pt-dash', dash); bar('#pt-pie', pie); bar('#pt-sk-auto', () => { st().autoSk = st().autoSk === false; save(); hud(true); });
    $('#pt-leads').innerHTML = R.units.filter(u => u.role === 'lead').map(u => `<button class="pt-lc" data-lu="${u.gid}"><canvas data-por="${u.k}"></canvas><i></i></button>`).join(''); paintPortraits($('#pt-leads'));
    $('#pt-leads').querySelectorAll('[data-lu]').forEach(b => b.onpointerdown = (e) => { e.stopPropagation(); e.preventDefault(); const u = R.units.find(x => x.gid === b.dataset.lu); if (!u || u.hp <= 0) return; if (u.energy >= 100) { u.wantCast = true; const tg = nearest(u, R.foes.filter(f => f.hp > 0), 300); if (tg && !u.act) startAttack(u, tg, true); } else Fx.toast(`${u.name}：符未滿`); });
    window.onkeydown = null;
    // 搖桿：手指喺畫面任何位置撳住拖
    cv.onpointerdown = (e) => { cv.setPointerCapture(e.pointerId); R.joy = { id:e.pointerId, x0:e.offsetX, y0:e.offsetY, x:e.offsetX, y:e.offsetY }; };
    cv.onpointermove = (e) => { if (R && R.joy && R.joy.id === e.pointerId) { R.joy.x = e.offsetX; R.joy.y = e.offsetY; } };
    const up = (e) => { if (R && R.joy && R.joy.id === e.pointerId) R.joy = null; };
    cv.onpointerup = up; cv.onpointercancel = up;
    window.onkeydown = (e) => { if (!R) return; const k = e.key.toLowerCase(); R.keys[k] = 1; if (k === ' ' || k === 'j') dash(); if (k === 'k') pie(); };
    window.onkeyup = (e) => { if (R) R.keys[e.key.toLowerCase()] = 0; };
    last = performance.now(); cancelAnimationFrame(raf); raf = requestAnimationFrame(frame);
  }
  function resize() { if (!cv) return; const r = cv.getBoundingClientRect(), dpr = Math.min(2, window.devicePixelRatio || 1); cv.width = r.width * dpr; cv.height = r.height * dpr; R && (R.dpr = dpr, R.w = r.width, R.h = r.height, R.sc = r.width / VIEW); }
  function frame(now) {
    if (!active) return; raf = requestAnimationFrame(frame);
    if (now - last < 1000 / 30 - 2) return;
    const dt = Math.min(0.08, (now - last) / 1000); last = now;
    if (!R) return; if (!R.sc) resize();
    if (!R.ended && !Story.busy()) update(dt);
    draw(); if ((R.t * 4 | 0) !== (R.hudT | 0)) { R.hudT = R.t * 4 | 0; hud(); }
  }

  // ---------- 移動、碰撞 ----------
  function gateOpen(i) { return !!S.cleared[sidOf(R.ci, GATES[i].si)]; }
  function moveTo(u, nx, ny) {
    nx = Math.max(20, Math.min(WW - 20, nx)); ny = Math.max(30, Math.min(WH - 20, ny));
    for (let i = 0; i < 2; i++) { const by = CH * (i + 1); const g = GATES.find(G => G.y === by);
      const cross = (u.y < by - 14) !== (ny < by - 14) || Math.abs(ny - by) < 14;
      if (cross) { const inGap = g && Math.abs(nx - g.x) < GW / 2 - 12 && (u.side === 1 || gateOpen(GATES.indexOf(g))); if (!inGap) ny = u.y < by ? Math.min(ny, by - 15) : Math.max(ny, by + 15); }
    }
    const gx = Math.floor(nx / 200), gy = Math.floor(ny / 200);
    for (let i = -1; i <= 1; i++) for (let j = -1; j <= 1; j++) { const l = PGRID[(gx + i) + ',' + (gy + j)]; if (!l) continue;
      for (const o of l) { const dx = nx - o.x, dy = (ny - o.y) * 1.7, d = Math.hypot(dx, dy); if (d < o.r && d > 0.01) { const k = o.r / d; nx = o.x + dx * k; ny = o.y + dy * k / 1.7; } } }
    u.x = nx; u.y = ny;
  }
  function revealAround(x, y) {
    const cw = Math.ceil(WW / FOG), r = 3; const cx = Math.floor(x / FOG), cy = Math.floor(y / FOG);
    for (let j = -r; j <= r; j++) for (let i = -r; i <= r; i++) { if (i * i + j * j > r * r + 1) continue; const X = cx + i, Y = cy + j; if (X < 0 || Y < 0 || X >= cw || Y * FOG >= WH) continue; R.fog[Y * cw + X] = '1'; }
  }

  // ---------- 出鬼 ----------
  function spawnZone(z) {
    const ci = R.ci, p = zoneP(ci, z), pool = fodOf(ci), cell = zoneCell(z), ph = phase(st().min);
    if (!R.packs[z]) R.packs[z] = [];
    const want = ph === 'off' ? 3 : 4;
    const alive = R.packs[z].filter(pk => pk.some(e => e.hp > 0 || e.down > 0));
    R.packs[z] = alive;
    if (alive.length >= want || R.t < (R.nextSp[z] || 0)) return;
    R.nextSp[z] = R.t + 2;
    // 位置：區內隨機，離阿福遠啲、避開設施閘口
    let x = 0, y = 0, ok = false;
    for (let k = 0; k < 12 && !ok; k++) {
      x = cell.x + (Math.random() - 0.5) * (CW - 160); y = cell.y + (Math.random() - 0.5) * (CH - 160);
      ok = Math.hypot(x - R.L.x, y - R.L.y) > 380 && !FACI.some(f => { const q = faciPos(f); return Math.hypot(q.x - x, q.y - y) < 170; }) && ![0, 1, 2].some(si => { const q = guardPos(si); return Math.hypot(q.x - x, q.y - y) < 220; });
    }
    if (!ok) return;
    const n = 1 + Math.floor(Math.random() * Math.min(ci === 0 ? 4 : 5, 1 + Math.floor(z / 3) + Math.min(ci, 2)));
    // 每區新面孔：佢嘅種類只喺呢區之後先出（累積式）
    const unlocked = pool.slice(0, Math.max(1, Math.min(pool.length, CH_FOD.slice(0, ci).reduce((s, a) => s + a.length, 0) + 1 + Math.floor(z / 3))));
    const pk = [];
    for (let i = 0; i < n; i++) {
      const k = unlocked[Math.random() < 0.55 ? unlocked.length - 1 : Math.floor(Math.random() * unlocked.length)];
      const e = foe(k, p); e.x = x + (Math.random() - 0.5) * 70; e.y = y + (Math.random() - 0.5) * 50; e.hx = x; e.hy = y; e.z = z; pk.push(e);
    }
    // 釘子戶（精英）：每區一隻，子時多啲
    const ek = eliteOfZone(ci, z);
    if (ek && !alive.some(a => a.some(e => e.elite)) && R.t > (R.eliteT || 0) && Math.random() < (ph === 'zi' ? 0.6 : 0.3)) {
      R.eliteT = R.t + 40;
      const t = N30_TIER[N30_G[ek].t], e = foe(ek, Math.max(p, t.p), { hp:3.2, atk:1.5 }, { elite:true }); e.s = 0.58; e.x = x; e.y = y; e.hx = x; e.hy = y; e.z = z; pk.push(e);
    }
    pk.forEach(e => R.foes.push(e)); R.packs[z].push(pk);
  }
  function spawnGuards(si) {
    const sid = sidOf(R.ci, si); if (S.cleared[sid] || R.guards && R.guards[si]) return;
    R.guards = R.guards || {};
    const stg = CHAPTERS[R.ci].stages[si], gp = guardPos(si), arr = [];
    stg.en.forEach((k, i) => {
      const boss = k === stg.boss, e = foe(k, stg.p, { hp:boss ? 3.6 : 2.2, atk:boss ? 1.3 : 1.1 }, { guard:si, boss });
      const a = (i - (stg.en.length - 1) / 2) * 0.9; e.x = gp.x + Math.sin(a) * 70; e.y = gp.y - Math.cos(a) * 20 + (boss ? -10 : 0); e.hx = e.x; e.hy = e.y; e.s = boss ? 0.78 : 0.55; e.name = (ENEMY_T[k] || [])[2] || k; arr.push(e); R.foes.push(e);
    });
    R.guards[si] = arr;
  }
  function spawnBryan(z) {
    if (R.bryan || R.bryanDone || !R.bryanWant || z < 4) return;
    const cell = zoneCell(z), x = cell.x + (Math.random() - 0.5) * 300, y = cell.y + (Math.random() - 0.5) * 240;
    if (Math.hypot(x - R.L.x, y - R.L.y) < 420) return;
    const p = zoneP(R.ci, z) + 0.6, pool = fodOf(R.ci), arr = [];
    const b = foe('npc_rival', p, { hp:2.6, atk:1.2 }, { bryan:true, name:'Bryan' }); b.k = 'npc_rival'; b.name = 'Bryan'; b.fac = 'yuan'; b.rng = 44; b.s = 0.62; b.x = x; b.y = y; b.hx = x; b.hy = y; arr.push(b);
    for (let i = 0; i < 4; i++) { const k = pool[Math.floor(Math.random() * pool.length)], e = foe(k, p, { hp:1.3, atk:1.1 }, { bryan:true }); e.name = '夜冷村' + e.name; e.x = x + Math.cos(i * 1.6) * 60; e.y = y + Math.sin(i * 1.6) * 40; e.hx = e.x; e.hy = e.y; arr.push(e); }
    arr.forEach(e => R.foes.push(e)); R.bryan = arr;
    msg(T('Bryan：「哦？阿福部門都有出嚟巡？你啲人睇落好攰喎，不如過嚟我度？」', 'Bryan：「哦？阿福部門也出來巡？你的人看起來很累，不如過來我這邊？」'), 4);
  }

  // ---------- 主更新 ----------
  // 手感：全部單位用速度＋加速度（唔會一下停一下郁）；跟隨嘅鬼喺阿福身邊一個圈入面自由行，唔企固定位
  const ACC = 1500, RING = { lead:[55, 130], crew:[80, 185], troop:[100, 215] };
  const ATK = { windup:0.15, strike:0.1, recover:0.22, cast:0.45 };
  function approachV(u, dvx, dvy, dt, acc) {
    const ax = dvx - u.vx, ay = dvy - u.vy, a = Math.hypot(ax, ay), m = (acc || ACC) * dt;
    if (a > m) { u.vx += ax / a * m; u.vy += ay / a * m; } else { u.vx = dvx; u.vy = dvy; }
  }
  function steer(u, tx, ty, spd, dt, arrive) {
    const dx = tx - u.x, dy = ty - u.y, d = Math.hypot(dx, dy);
    if (d < 2) { approachV(u, 0, 0, dt); return; }
    const s = arrive ? Math.min(spd, spd * d / arrive) : spd; approachV(u, dx / d * s, dy / d * s, dt);
  }
  function integrate(u, dt) {
    const sp = Math.hypot(u.vx, u.vy); u.moving = sp > 16;
    if (Math.abs(u.vx) > 14 && !u.act) u.flip = u.vx < 0;
    let nx = u.x + u.vx * dt, ny = u.y + u.vy * dt;
    if (u.kb) { nx += u.kb.x * dt; ny += u.kb.y * dt; const f = Math.pow(0.002, dt); u.kb.x *= f; u.kb.y *= f; if (Math.hypot(u.kb.x, u.kb.y) < 6) u.kb = null; }
    moveTo(u, nx, ny);
    if (u.moving && (u.leader || u.role === 'lead' || u.boss)) { u.stepT = (u.stepT || 0) + dt * sp / 55; if (u.stepT > 1) { u.stepT = 0; dust(u.x + (Math.random() - 0.5) * 8, u.y, u.boss ? 0.9 : 0.5); } }
  }
  function wander(u, L, dt) { // 喺阿福身邊自由行：揀一點 → 行過去 → 企一陣、四圍望 → 再揀；阿福行緊就跟喺後面／兩邊
    const rg = RING[u.role] || RING.crew, lv = Math.hypot(L.vx, L.vy), lm = lv > 40;
    u.wtT = (u.wtT || 0) - dt;
    if (!u.wt || u.wtT <= 0 || (lm && !u.wt.mv)) {
      let a = Math.random() * Math.PI * 2;
      if (lm) a = Math.atan2(-L.vy, -L.vx) + (Math.random() - 0.5) * 2.6;
      const r = rg[0] + Math.random() * (rg[1] - rg[0]);
      u.wt = { x:Math.cos(a) * r, y:Math.sin(a) * r * 0.6, mv:lm }; u.wtT = lm ? 0.7 + Math.random() * 1.1 : 1.8 + Math.random() * 3.8;
    }
    const tx = L.x + u.wt.x, ty = L.y + u.wt.y, d = Math.hypot(tx - u.x, ty - u.y), dl = Math.hypot(L.x - u.x, L.y - u.y);
    if (dl > 900) { u.x = tx; u.y = ty; u.vx = u.vy = 0; return; }
    if (d < 9) { approachV(u, 0, 0, dt); if (!lm && Math.random() < dt * 0.35) u.flip = !u.flip; return; }
    const far = dl > rg[1] + 50, spd = far ? u.spd * 1.6 : lm ? Math.max(u.spd * 0.7, lv * 1.08) : u.spd * (0.35 + 0.25 * ((u.ti || u.slot || 1) % 3) / 2);
    steer(u, tx, ty, spd, dt, lm ? 30 : 50);
  }
  function update(dt) {
    if (R.stop > 0) { R.stop -= dt; R.fx.forEach(f => { if (f.kind === 'num') f.t += dt * 0.2; }); return; } // 頓幀
    R.t += dt; const p = st(), L = R.L;
    for (const u of R.units) { if (u.vx == null) { u.vx = 0; u.vy = 0; } }
    for (const e of R.foes) { if (e.vx == null) { e.vx = 0; e.vy = 0; } }
    p.min = (p.min + dt * 2) % 1440; const ph = phase(p.min);
    R.shake = Math.max(0, (R.shake || 0) - dt * 30); R.flash = Math.max(0, (R.flash || 0) - dt * 3);
    if (R.buff > 0) R.buff -= dt; R.dashCd = Math.max(0, (R.dashCd || 0) - dt); R.pieCd = Math.max(0, (R.pieCd || 0) - dt);
    // 輸入
    let mx = 0, my = 0;
    if (R.joy) { const dx = R.joy.x - R.joy.x0, dy = R.joy.y - R.joy.y0, d = Math.hypot(dx, dy); if (d > 6) { const k = Math.min(1, (d - 6) / 44); mx = dx / d * k; my = dy / d * k; } }
    const K = R.keys; if (K.a || K.arrowleft) mx -= 1; if (K.d || K.arrowright) mx += 1; if (K.w || K.arrowup) my -= 1; if (K.s || K.arrowdown) my += 1;
    const ml = Math.hypot(mx, my); if (ml > 1) { mx /= ml; my /= ml; }
    if (ml > 0.05) R.face = { x:mx / Math.max(ml, 0.01), y:my / Math.max(ml, 0.01) };
    if (L.hp > 0) {
      if (L.dash > 0) { L.dash -= dt; L.inv = L.dash > 0; if (Math.random() < 0.7) R.fx.push({ kind:'after', k:L.k, x:L.x, y:L.y, s:L.s, flip:L.flip, t:0, life:0.28 });
        for (const e of R.foes) if (e.hp > 0 && !e.fled && !(e.down > 0) && !L.dashHit.has(e) && Math.hypot(e.x - L.x, (e.y - L.y) * 1.3) < 40) { L.dashHit.add(e); hit(L, e, 0.8, { kb:300 }); } }
      else { const spd = L.spd * (R.buff > 0 ? 1.12 : 1); approachV(L, mx * spd, my * spd, dt, ml > 0.05 ? 1800 : 2400); }
      integrate(L, dt);
    }
    revealAround(L.x, L.y);
    const z = zoneAt(L.x, L.y);
    if (!R.zoneSeen[z]) { R.zoneSeen[z] = 1; const ek = eliteOfZone(R.ci, z); msg(`${zoneName(R.ci, z)}${ek && !N30W.owned(ek) ? `　新面孔出沒：<b>${GHOSTS[ek].name}</b>（${GHOSTS[ek].title}）` : ''}`, 3); }
    for (const zz of [z - 1, z, z + 1]) if (zz >= 0 && zz < 12) spawnZone(zz);
    for (let si = 0; si < 3; si++) { const gp = guardPos(si); if (Math.hypot(gp.x - L.x, gp.y - L.y) < 900) spawnGuards(si); }
    spawnBryan(z);
    R.foes = R.foes.filter(e => { if (e.guard != null || e.bryan || e.ot) return true; if (Math.abs(e.z - z) > 1 && Math.hypot(e.x - L.x, e.y - L.y) > 1200) { e.gone = 1; return false; } return true; });
    for (const zz in R.packs) R.packs[zz] = R.packs[zz].map(pk => pk.filter(e => !e.gone && !e.fled && !e.done)).filter(pk => pk.length);
    for (let si = 0; si < 3; si++) {
      const sid = sidOf(R.ci, si), stg = CHAPTERS[R.ci].stages[si], gp = guardPos(si), d = Math.hypot(gp.x - L.x, gp.y - L.y);
      if (S.cleared[sid] || d > 300) continue;
      if (S.lv < stg.req) { if (!R.reqMsg || R.t - R.reqMsg > 6) { R.reqMsg = R.t; msg(`<b>${stg.name}</b>：需主公 Lv${stg.req}（${GP.T('建議鬼力', '建議鬼力')} ${GP.stageNeed(stg, sid)}）。先回村升級再來。`, 4); } continue; }
      if (stg.before && !S.seen[stg.before] && !R.beforeQ) { R.beforeQ = 1; Story.queue(stg.before, () => { R.beforeQ = 0; }); return; }
      if (R.guards && R.guards[si] && !R.guards[si][0].awake) { R.guards[si].forEach(e => e.awake = true); msg(`<b>${stg.name}</b>：「${si === 2 ? '總監親自當值。' : '主管當值，閒人勿進。'}」`, 2.5); R.shake = 6; }
    }
    const party = R.units.filter(u => u.hp > 0 && !u.gone), foes = R.foes.filter(e => e.hp > 0 && !e.fled && (ph !== 'work' || e.provoked || e.guard != null || e.bryan || Math.hypot(e.x - L.x, e.y - L.y) < 110));
    const calm = !R.foes.some(e => e.hp > 0 && !e.fled && !(e.down > 0) && (e.provoked || e.awake) && Math.hypot(e.x - L.x, e.y - L.y) < 420);
    if (calm) for (const u of party) u.hp = Math.min(u.maxhp, u.hp + u.maxhp * 0.03 * dt);
    // 我方
    for (const u of R.units) {
      u.flash = Math.max(0, (u.flash || 0) - dt * 5); u.hurt = Math.max(0, (u.hurt || 0) - dt);
      if (u.hp <= 0) { u.deadT = (u.deadT || 0) + dt; if (u.role === 'lead' && u.deadT > 25) { u.hp = u.maxhp * 0.6; u.deadT = 0; u.x = L.x; u.y = L.y; u.vx = u.vy = 0; fxText(u.x, u.y - 50, '歸隊！', '#9ff'); spr('fx_beam', u.x, u.y + 6, { s0:0.3, s1:0.4, sx:0.7, life:0.8, anchor:0.95 }); R.fx.push({ kind:'ring', x:u.x, y:u.y, t:0, life:0.5, col:'#9ff', r:60 }); } continue; }
      if (u.leader) { // 阿福：自己行，敵人入咗攻擊範圍就自動打
        if (u.act) tickAct(u, dt); else { u.cd -= dt; const tg = nearest(u, foes, u.rng + 10); if (tg && u.cd <= 0 && !(u.dash > 0)) startAttack(u, tg); }
        continue;
      }
      u.cd -= dt;
      if (u.role === 'crew' && u.inFight) { u.g.fat = Math.min(100, (u.g.fat || 0) + dt * 0.5); if (u.g.fat >= 100 && !u.sick) { u.sick = 1; u.hp = 0; u.deadT = 0; fxText(u.x, u.y - 40, '請病假', '#fca'); msg(`${u.name} 過勞，請病假回村。`, 2.5); continue; } if (u.g.fat >= 70 && !u.tired) { u.tired = 1; u.atk *= 0.7; } }
      if (u.act) { tickAct(u, dt); approachV(u, 0, 0, dt); integrate(u, dt); continue; }
      const tg = nearest(u, foes, 240);
      u.inFight = !!tg && Math.hypot(tg.x - L.x, tg.y - L.y) < 340;
      const tele = R.tele && R.tele.find(t => Math.hypot((u.x - t.x) / t.r, (u.y - t.y) / (t.r * 0.6)) < 1.05);
      if (tele) { const dx = u.x - tele.x, dy = u.y - tele.y, d = Math.hypot(dx, dy) || 1; approachV(u, dx / d * u.spd * 1.3, dy / d * u.spd * 1.3, dt); } // 識閃預警
      else if (u.inFight) {
        const d = Math.hypot(tg.x - u.x, (tg.y - u.y) * 1.2), want = u.rng * (u.rng > 60 ? 0.85 : 0.8);
        if (u.sk && u.energy >= 100 && (st().autoSk !== false || u.wantCast)) { startAttack(u, tg, true); u.wantCast = false; }
        else if (d > u.rng) { const side = ((u.ti || u.slot || 0) % 2 ? 1 : -1) * 18; steer(u, tg.x + (u.x < tg.x ? -want : want), tg.y + side, u.spd, dt, 24); }
        else { approachV(u, 0, 0, dt); if (u.cd <= 0) startAttack(u, tg); }
      } else wander(u, L, dt);
      integrate(u, dt);
    }
    // 敵方
    for (const e of R.foes) {
      e.flash = Math.max(0, (e.flash || 0) - dt * 5); e.hurt = Math.max(0, (e.hurt || 0) - dt);
      if (e.down > 0) { e.down -= dt; approachV(e, 0, 0, dt); integrate(e, dt); if (e.down <= 0 && !e.done) resolveDown(e, 'soul', true); continue; }
      if (e.hp <= 0 || e.fled) { e.deadT = (e.deadT || 0) + dt; if (e.fled) { e.x += (e.flip ? -1 : 1) * 160 * dt; e.y -= 20 * dt; } continue; }
      e.cd -= dt; e.slamCd = (e.slamCd == null ? 3 + Math.random() * 3 : e.slamCd) - dt;
      if (e.act) { tickAct(e, dt); approachV(e, 0, 0, dt); integrate(e, dt); continue; }
      const passive = e.guard != null ? !e.awake : (ph === 'work' && !e.provoked && !e.bryan);
      const tg = passive ? null : nearest(e, party, e.guard != null ? 280 : e.provoked ? 420 : 190);
      const home = Math.hypot(e.x - e.hx, e.y - e.hy), spd = e.spd * (ph === 'off' ? 0.7 : 1);
      if (tg && home < (e.guard != null ? 340 : 480)) {
        e.provoked = true; const d = Math.hypot(tg.x - e.x, (tg.y - e.y) * 1.2);
        const big = e.elite || e.boss || e.otBoss || (e.bryan && e.k === 'npc_rival');
        if (big && e.slamCd <= 0 && d < 200) { e.slamCd = 5.5 + Math.random() * 2.5; telegraph(e, tg); continue; }
        if (e.sk && e.energy >= 100 && d < 220) { startAttack(e, tg, true); continue; }
        if (e.rng > 60 && d < 70) { const dx = e.x - tg.x, dy = e.y - tg.y, dd = Math.hypot(dx, dy) || 1; approachV(e, dx / dd * spd, dy / dd * spd, dt); } // 遠程鬼：保持距離
        else if (d > e.rng) steer(e, tg.x + (e.x < tg.x ? -e.rng * 0.8 : e.rng * 0.8), tg.y, spd * (e.k === 'xiaogui' && d > 120 ? 1.5 : 1), dt, 20);
        else { approachV(e, 0, 0, dt); if (e.cd <= 0) startAttack(e, tg); }
      } else if (home > 30) { steer(e, e.hx, e.hy, spd * 0.7, dt, 40); if (home > 300) e.hp = Math.min(e.maxhp, e.hp + e.maxhp * dt * 0.3); }
      else { approachV(e, 0, 0, dt, 600); if (Math.random() < dt * 0.35 && e.z != null && e.guard == null && !e.ot) { const c0 = zoneCell(e.z); e.hx = Math.max(c0.x - CW / 2 + 70, Math.min(c0.x + CW / 2 - 70, e.hx + (Math.random() - 0.5) * 110)); e.hy = Math.max(c0.y - CH / 2 + 70, Math.min(c0.y + CH / 2 - 70, e.hy + (Math.random() - 0.5) * 80)); } }
      integrate(e, dt);
    }
    // 預警圈落地
    if (R.tele) R.tele = R.tele.filter(t => { t.t += dt; if (t.t < t.dur) return true;
      const src = t.src; if (src.hp > 0 && !(src.down > 0)) { R.shake = 9; dust(t.x - 20, t.y, 1.6); dust(t.x + 20, t.y, 1.4); if (img('fx_shock')) spr('fx_shock', t.x, t.y, { ground:true, s0:t.r * 1.4 / 256, s1:t.r * 2.3 / 256, life:0.5 }); else R.fx.push({ kind:'ring', x:t.x, y:t.y, t:0, life:0.4, col:'#ff6a4a', r:t.r });
        for (const u of R.units) if (u.hp > 0 && !u.inv && Math.hypot((u.x - t.x) / t.r, (u.y - t.y) / (t.r * 0.6)) < 1) hit(src, u, 2.2, { kb:260, from:t }); try { Sound.play('skill'); } catch (e) {} }
      return false; });
    // 分開（軟推）
    const all = party.concat(R.foes.filter(e => e.hp > 0 && !e.fled && !(e.down > 0)));
    for (let i = 0; i < all.length; i++) for (let j = i + 1; j < all.length; j++) {
      const a = all[i], b = all[j], R0 = (a.s + b.s) * 30, dx = b.x - a.x, dy = (b.y - a.y) * 1.5, d = Math.hypot(dx, dy);
      if (d > 0.1 && d < R0) { const k = (R0 - d) / d * 4; if (!a.leader) { a.vx -= dx * k * dt * 10; a.vy -= dy * k * dt * 6; } if (!b.leader) { b.vx += dx * k * dt * 10; b.vy += dy * k * dt * 6; } }
    }
    // 子彈：追住目標飛
    R.proj = R.proj.filter(q => {
      const v = q.tg; if (!v || v.hp <= 0 || v.down > 0) { q.dead = (q.dead || 0) + dt; return q.dead < 0.15; }
      const ty = v.y - 34 * v.s * 1.65, dx = v.x - q.x, dy = ty - q.y, d = Math.hypot(dx, dy), stp = q.spd * dt;
      q.trail.push([q.x, q.y]); if (q.trail.length > 7) q.trail.shift();
      if (d <= stp + 6) { hit(q.src, v, q.mult || 1); spr('fx_fire', q.x, q.y, { s0:0.12, s1:0.26, life:0.18, hue:q.hue, rot:Math.atan2(q.vy || 0, q.vx || 1) + Math.PI }); return false; }
      q.vx = dx; q.vy = dy; q.x += dx / d * stp; q.y += dy / d * stp + Math.sin(R.t * 18 + q.ph) * 0.8; return true;
    });
    // Bryan 挖角
    if (R.bryan) {
      const b = R.bryan[0];
      if (b.hp > 0) for (const u of R.units) if (u.role === 'crew' && u.hp > 0 && (u.g.fat || 0) >= 75 && Math.hypot(u.x - b.x, u.y - b.y) < 220) { u.g.poached = 1; u.hp = 0; u.deadT = 9; u.gone = 1; fxText(u.x, u.y - 40, '跳槽！', '#f88'); msg(T(`Bryan：「${u.name}，嚟我度，我哋冇 KPI 㗎。」${u.name}跟咗 Bryan 走。`, `Bryan：「${u.name}，來我這邊，我們沒有 KPI 的。」${u.name}跟 Bryan 走了。`), 4); }
      if (R.bryan.every(e => e.hp <= 0 && !(e.down > 0))) { R.bryanDone = true; R.bryan = null; const back = S.ghosts.filter(g => g.poached); back.forEach(g => delete g.poached); msg(T(`打贏 Bryan 部門！${back.length ? `${back.map(g => g.name).join('、')} 返嚟咗：「其實佢嗰邊都有 KPI……」` : 'Bryan：「今次唔計，我啱啱熱緊身。」'}`, `打贏 Bryan 部門！${back.length ? `${back.map(g => g.name).join('、')} 回來了：「其實他那邊也有 KPI……」` : 'Bryan：「這次不算，我剛在熱身。」'}`), 5); gain({ coins:Math.round(40 + 30 * zoneP(R.ci, z)), exp:20 }); }
    }
    R.foes = R.foes.filter(e => !((e.hp <= 0 || e.fled) && !(e.down > 0) && (e.deadT || 0) > 1.5));
    if (R.ot && R.ot.every(e => (e.hp <= 0 || e.fled) && !(e.down > 0))) { R.ot = null; S.chests.p++; gain({ coins:Math.round(80 + 60 * zoneP(R.ci, 9)), exp:30 }); Fx.toast('通宵加班房搞定！紫箱 ×1'); msg(T('加班鬼：「多謝你哋……我終於可以收工。」佢瞓咗。', '加班鬼：「謝謝你們……我終於可以下班了。」他睡著了。'), 3); }
    if (R.guards) for (const si in R.guards) { const g = R.guards[si]; if (g && g.length && g.every(e => e.hp <= 0)) { R.guards[si] = null; stageWin(+si); } }
    R.fx = R.fx.filter(f => { f.t += dt; return f.t < f.life; });
    ambient(dt);
    facilities(dt);
    // 鏡頭：跟阿福，望多少少前面
    const lx = L.x + (L.vx || 0) * 0.25, ly = L.y - 30 + (L.vy || 0) * 0.2;
    R.cam.x += (lx - R.cam.x) * Math.min(1, dt * 4.5); R.cam.y += (ly - R.cam.y) * Math.min(1, dt * 4.5);
    if (L.hp <= 0 && !R.ended) end(true);
    if (R.t - (R.saveT || 0) > 10) { R.saveT = R.t; persist(); }
  }
  function nearest(u, list, r) { let b = null, bd = r; for (const v of list) { if (v.hp <= 0 || v.down > 0 || v.fled || v.gone || (v.guard != null && !v.awake)) continue; const d = Math.hypot(v.x - u.x, (v.y - u.y) * 1.2); if (d < bd) { bd = d; b = v; } } return b; }
  function provoke(v) { if (!v.provoked && v.hp > 0) R.fx.push({ kind:'txt', x:v.x, y:v.y - 100 * v.s, text:'！', col:'#ff8a6a', t:0, life:0.7, big:true }); v.provoked = true; const z = v.z; if (z != null && R.packs[z]) R.packs[z].forEach(pk => { if (pk.includes(v)) pk.forEach(e => e.provoked = true); }); }
  // 出手三段：蓄（windup）→ 出（strike，近戰會衝前）→ 收（recover）；技能先蓄力 0.45 秒
  function startAttack(u, v, cast) {
    u.act = { ph:'windup', t:0, tg:v, cast:!!cast, dur:cast ? ATK.cast : ATK.windup * (u.boss ? 1.6 : 1) };
    u.cd = u.aspd * (0.85 + Math.random() * 0.3); if (Math.abs(v.x - u.x) > 2) u.flip = v.x < u.x;
    if (u.side === 0 && v.side === 1) provoke(v);
    if (cast) { u.energy = 0; try { Sound.play('click'); } catch (e) {} }
  }
  function tickAct(u, dt) {
    const a = u.act; a.t += dt;
    if (a.ph === 'windup' && a.t >= a.dur) { a.ph = 'strike'; a.t = 0; if (u.hp > 0) fire(u, a); }
    else if (a.ph === 'strike' && a.t >= ATK.strike) { a.ph = 'recover'; a.t = 0; }
    else if (a.ph === 'recover' && a.t >= ATK.recover) u.act = null;
  }
  function projCol(u) { return { yuan:'#d6a8ff', chan:'#ffc27a', lan:'#9fdcff' }[u.fac] || '#bff'; }
  function fire(u, a) {
    if (a.cast) { skill(u); return; }
    if (a.slam) return;
    const v = a.tg; if (!v || v.hp <= 0 || v.down > 0) return;
    if (u.rng > 60) { R.proj.push({ x:u.x + (u.flip ? -14 : 14), y:u.y - 44 * u.s * 1.65, tg:v, src:u, spd:560, col:u.side ? '#ff9ac0' : projCol(u), hue:u.side ? HUE.foe : HUE[u.fac] || 0, big:u.role === 'lead' || u.elite || u.boss ? 1.3 : 1, trail:[], ph:Math.random() * 6 }); return; }
    const dir = Math.sign(v.x - u.x) || 1;
    u.vx += dir * 120; // 衝前少少
    if (img('fx_slash')) { const big = u.boss ? 1.5 : u.leader || u.role === 'lead' || u.elite ? 1.15 : u.role === 'troop' ? 0.6 : 0.8; spr('fx_slash', v.x - dir * 6, v.y - 34 * v.s * 1.65, { s0:0.16 * big, s1:0.3 * big, life:0.2, flip:dir < 0, rot:(Math.random() - 0.5) * 0.6, hue:u.side ? -155 : u.leader ? 0 : HUE[u.fac] || 0 }); }
    else R.fx.push({ kind:'slash', x:v.x, y:v.y - 34 * v.s * 1.65, dir, t:0, life:0.2, r:22 + (u.boss ? 14 : u.leader ? 6 : 0), col:u.side ? '#ff9ac0' : u.leader ? '#ffe9a0' : '#bff' });
    hit(u, v, 1);
  }
  function hit(u, v, mult, o) {
    if (v.hp <= 0 || v.down > 0 || v.inv) return;
    o = o || {};
    const crit = u.side === 0 && Math.random() < (u.leader ? 0.16 : 0.1), buff = u.side === 0 && R.buff > 0 ? 1.3 : 1;
    const dmg = Math.max(1, Math.round(u.atk * mult * buff * (crit ? 1.8 : 1) * (0.9 + Math.random() * 0.2)));
    v.hp -= dmg; v.hurt = 0.24; v.flash = 1; v.lastBy = u;
    if (v.act && v.act.ph === 'windup' && !v.boss && (crit || mult > 1.5)) v.act = null; // 打斷
    const sx = o.from ? o.from.x : u.x, sy = o.from ? o.from.y : u.y, dx = v.x - sx, dy = v.y - sy, dl = Math.hypot(dx, dy) || 1;
    const kb = (o.kb || (crit ? 170 : mult > 1 ? 150 : 70)) * (v.boss ? 0.25 : v.elite || v.guard != null ? 0.5 : 1);
    v.kb = { x:dx / dl * kb, y:dy / dl * kb * 0.6 };
    if (u.sk) u.energy = Math.min(100, (u.energy || 0) + (mult > 1 ? 4 : 10));
    if (v.sk && v.side === 1) v.energy = Math.min(100, (v.energy || 0) + 6);
    if (u.sk && u.sk.drain && mult > 1) u.hp = Math.min(u.maxhp, u.hp + dmg * u.sk.drain);
    if (u.fac === 'chan' && u.side === 0 && u.role === 'crew') u.hp = Math.min(u.maxhp, u.hp + dmg * 0.08);
    if (u.fac === 'lan' && u.side === 0 && Math.random() < 0.12) { v.cd += 0.6; fxText(v.x, v.y - 70 * v.s, '卡到陰', '#9fdcff'); }
    const hy = v.y - 34 * v.s * 1.65;
    spark(v.x - dx / dl * 6, hy, crit || mult > 1 ? 1.3 : v.side === 0 ? 0.7 : 0.9, v.side === 0 ? '#ff9a7a' : crit ? '#ffd84a' : '#fff4c0');
    if (crit || mult > 1 || v.side === 0 || u.leader || u.role === 'lead' || v.boss || v.elite) R.fx.push({ kind:'num', x:v.x + (Math.random() - 0.5) * 14, y:hy - 30 * v.s, vx:(dx / dl) * (14 + Math.random() * 18), text:crit ? `${dmg}!` : '' + dmg, col:crit ? '#ffd84a' : v.side ? '#fff' : '#ff8a8a', big:crit || mult > 1.4, t:0, life:0.95 });
    if (crit || mult > 1.4) { R.shake = Math.max(R.shake, crit ? 4 : 6); R.stop = Math.max(R.stop || 0, 0.05); }
    if (Date.now() - (R.sndAt || 0) > 80) { R.sndAt = Date.now(); try { Sound.play('hit'); } catch (e) {} }
    if (v.hp <= 0) { v.hp = 0; R.shake = Math.max(R.shake, v.side === 1 ? 5 : 3); spark(v.x, hy, 1.6, '#fff'); if (v.side === 1) R.stop = Math.max(R.stop || 0, 0.06); onDown(v, u); }
  }
  function telegraph(e, tg) { // 大隻鬼：地上出紅圈，0.9 秒後砸落嚟——行開就避到
    R.tele = R.tele || []; const r = e.boss ? 120 : 92;
    R.tele.push({ x:tg.x, y:tg.y, r, t:0, dur:e.boss ? 1.1 : 0.9, src:e });
    e.act = { ph:'windup', t:0, tg, cast:false, dur:e.boss ? 1.1 : 0.9, slam:true }; e.flip = tg.x < e.x;
  }
  function skill(u) {
    const sk = u.sk; if (!sk) return;
    const foes = R.foes.filter(e => e.hp > 0 && !(e.down > 0) && !e.fled), allies = R.units.filter(x => x.hp > 0 && !x.gone);
    const enemies = u.side === 0 ? foes : allies, mine = u.side === 0 ? allies : foes;
    const col = u.side ? '#ff9ac0' : '#9ff3ff';
    if (sk.kind === 'heal') mine.filter(v => Math.hypot(v.x - u.x, v.y - u.y) < 280).forEach(v => { const h = v.maxhp * sk.mult; v.hp = Math.min(v.maxhp, v.hp + h); spr('fx_heal', v.x, v.y - 30, { s0:0.15, s1:0.35, life:0.8, vy:30, spin:1.5 }); fxText(v.x, v.y - 60, '+' + Math.round(h), '#8affb0'); R.fx.push({ kind:'ring', x:v.x, y:v.y, t:0, life:0.5, col:'#8affb0', r:40 }); });
    else if (sk.kind === 'aoe') { enemies.filter(v => Math.hypot(v.x - u.x, (v.y - u.y) * 1.3) < 210).forEach(v => hit(u, v, sk.mult, { kb:240 })); if (img('fx_wind')) { spr('fx_wind', u.x, u.y, { s0:0.4, s1:1.1, life:0.6, anchor:0.85, hue:u.side ? -155 : 0 }); spr('fx_scream', u.x, u.y - 40, { s0:0.3, s1:1.6, life:0.5, alpha:0.8, hue:u.side ? -155 : 0 }); spr('fx_shock', u.x, u.y, { ground:true, s0:0.8, s1:1.8, life:0.5, hue:u.side ? -155 : 0 }); } else R.fx.push({ kind:'ring', x:u.x, y:u.y, t:0, life:0.5, col, r:210 }); R.flash = 0.35; R.shake = 8; }
    else { const v = nearest(u, enemies, 280); if (v) { const n = sk.hits || 1; for (let i = 0; i < n; i++) hit(u, v, sk.mult / n, { kb:i === n - 1 ? 260 : 60 }); if (img('fx_slash')) { const d = Math.sign(v.x - u.x) || 1; spr('fx_slash', v.x, v.y - 34 * v.s * 1.65, { s0:0.35, s1:0.6, life:0.3, flip:d < 0, hue:u.side ? -155 : HUE[u.fac] || 0 }); spr('fx_hit', v.x, v.y - 34 * v.s * 1.65, { s0:0.2, s1:0.45, life:0.25 }); spr('fx_bolt', v.x, v.y - 50, { s0:0.25, s1:0.4, life:0.2 }); } else R.fx.push({ kind:'slash', x:v.x, y:v.y - 34 * v.s * 1.65, dir:Math.sign(v.x - u.x) || 1, t:0, life:0.3, r:40, col }); if (sk.steal && u.side === 0) gain({ coins:sk.steal }); } }
    R.fx.push({ kind:'num', x:u.x, y:u.y - 95 * u.s * 1.65, text:sk.name, col, skill:true, t:0, life:1.1 });
    try { Sound.play('skill'); } catch (e) {}
  }
  // 阿福兩招：衝刺（穿過去撞開敵人、無敵）；畫大餅（全隊攻擊 +30%、8 秒；組員過勞 +4）
  function dash() {
    const L = R && R.L; if (!L || L.hp <= 0 || R.dashCd > 0 || R.ended) return;
    const f = R.face || { x:L.flip ? -1 : 1, y:0 }; L.vx = f.x * 640; L.vy = f.y * 640; L.dash = 0.24; L.dashHit = new Set(); L.act = null;
    R.dashCd = 3.5; dust(L.x, L.y, 1.1); if (img('fx_dash')) spr('fx_dash', L.x + f.x * 50, L.y - 34, { s0:0.35, s1:0.55, life:0.3, rot:Math.atan2(f.y, f.x) }); try { Sound.play('click'); } catch (e) {}
  }
  function pie() {
    if (!R || R.pieCd > 0 || R.ended || R.L.hp <= 0) return;
    R.buff = 8; R.pieCd = 30; R.flash = 0.25;
    for (const u of R.units) if (u.hp > 0) { if (img('fx_aura')) spr('fx_aura', u.x, u.y + 4, { s0:0.15, s1:0.3, life:0.8, anchor:0.95 }); else R.fx.push({ kind:'ring', x:u.x, y:u.y, t:0, life:0.6, col:'#ffd84a', r:36 }); if (u.g && u.role === 'crew') u.g.fat = Math.min(100, (u.g.fat || 0) + 4); }
    const lines = [['阿福', T('各位！做完今晚，年尾分紅一定有！（應該）', '各位！做完今晚，年底分紅一定有！（應該）')], ['阿福', T('公司好睇好你哋㗎！（我估）', '公司很看好你們的！（我猜）')], ['阿福', T('呢個 project 做完，大家升職！（未批）', '這個 project 做完，大家升職！（還沒批）')]];
    const l = lines[Math.floor(Math.random() * lines.length)]; msg(`<b>${l[0]}</b>：${l[1]}　全隊攻擊 +30%`, 2.5); try { Sound.play('gong'); } catch (e) {}
  }
  function spark(x, y, k, col) {
    if (img('fx_hit')) { spr('fx_hit', x, y, { s0:0.08 * k, s1:0.22 * k, life:0.18, rot:Math.random() * 6.28, hue:col === '#ff9a7a' ? -155 : 0 }); if (k >= 1.3 && img('fx_bolt')) spr('fx_bolt', x, y - 6, { s0:0.18, s1:0.3, life:0.16, rot:(Math.random() - 0.5) * 1.2 }); return; } const n = 7 + Math.floor(Math.random() * 4), rays = []; for (let i = 0; i < n; i++) rays.push({ a:(i / n) * Math.PI * 2 + (Math.random() - 0.5) * 0.5, len:(12 + Math.random() * 14) * k, j:Math.random() * 1000 }); R.fx.push({ kind:'spark', x, y, t:0, life:0.24, rays, col, k, rot:Math.random() * Math.PI }); }
  // ===== 特效圖（老闆 ChatGPT 生成、黑底發光，用 lighter 疊）=====
  // spr(名, x, y, {s0,s1 由細變大, life, rot, alpha, add 疊光, ground 畫喺地面層, sx/sy 拉扁, vy 上升, tint 色相})
  const TINT = {};
  function fxImg(n, hue) {
    const im = img(n); if (!im) return null; if (!hue) return im;
    const k = n + '@' + hue; if (TINT[k]) return TINT[k];
    const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; const x = c.getContext('2d');
    x.filter = `hue-rotate(${hue}deg) saturate(1.2)`; x.drawImage(im, 0, 0); return (TINT[k] = c);
  }
  function spr(n, x, y, o) { o = o || {}; R.fx.push(Object.assign({ kind:'spr', n, x, y, t:0, life:0.3, s0:0.3, s1:0.5, rot:0, alpha:1, add:true, sx:1, sy:1, vy:0, hue:0 }, o)); }
  function drawSpr(c, f) {
    const im = fxImg(f.n, f.hue); if (!im) return;
    const p = f.t / f.life, e = 1 - Math.pow(1 - p, 2.2), sc = f.s0 + (f.s1 - f.s0) * e;
    const a = f.alpha * (f.fadeIn && p < 0.2 ? p / 0.2 : 1) * (p < 0.55 ? 1 : 1 - (p - 0.55) / 0.45);
    const w = (im.naturalWidth || im.width) * sc * f.sx, h = (im.naturalHeight || im.height) * sc * f.sy;
    c.save(); c.globalAlpha = Math.max(0, a); if (f.add) c.globalCompositeOperation = 'lighter';
    c.translate(f.x, f.y - f.vy * p); if (f.rot) c.rotate(f.rot + (f.spin || 0) * p); if (f.flip) c.scale(-1, 1);
    c.drawImage(im, -w / 2, -h * (f.anchor != null ? f.anchor : 0.5), w, h); c.restore();
  }
  const HUE = { yuan:110, chan:-150, lan:35, foe:-155, gold:0 }; // 特效底色係鬼火青綠：+110 ≈ 幽紫（怨）、-150 ≈ 暗血紅（饞／敵）、+35 ≈ 冷藍（懶）
  function dust(x, y, k) {
    if (img('fx_dust')) { spr('fx_dust', x + (Math.random() - 0.5) * 10, y, { add:true, alpha:0.45, s0:0.06 * k, s1:0.16 * k, life:0.5, vy:10, anchor:0.8, flip:Math.random() < 0.5 }); return; } const puffs = []; for (let i = 0; i < 5; i++) puffs.push({ dx:(Math.random() - 0.5) * 18 * k, vx:(Math.random() - 0.5) * 60 * k, r:(4 + Math.random() * 4) * k }); R.fx.push({ kind:'dust', x, y, t:0, life:0.45, puffs }); }
  // 環境：鬼火、霧
  function ambient(dt) {
    R.wisps = R.wisps || []; const L = R.L;
    while (R.wisps.length < 26) R.wisps.push({ x:L.x + (Math.random() - 0.5) * 700, y:L.y + (Math.random() - 0.5) * 1000, vx:(Math.random() - 0.5) * 14, vy:-6 - Math.random() * 12, ph:Math.random() * 6, r:1.2 + Math.random() * 1.8, hue:Math.random() < 0.7 ? 0 : 1 });
    for (const w of R.wisps) { w.x += (w.vx + Math.sin(R.t + w.ph) * 8) * dt; w.y += w.vy * dt; if (Math.abs(w.x - L.x) > 420 || Math.abs(w.y - L.y) > 620) { w.x = L.x + (Math.random() - 0.5) * 700; w.y = L.y + 300 + Math.random() * 300; } }
  }
  function fxText(x, y, text, col, big) { R.fx.push({ kind:'num', x, y, text, col, big, t:0, life:0.95, vx:(Math.random() - 0.5) * 30 }); }
  function msg(h, sec) { const m = $('#pt-msg'); if (!m) return; m.innerHTML = h; m.classList.add('on'); clearTimeout(msg._t); msg._t = setTimeout(() => m.classList.remove('on'), (sec || 3) * 1000); }

  // ---------- 打倒：靈體不穩 → 送去投胎／遞合約 ----------
  function onDown(v, by) {
    if (v.side === 0) { v.deadT = 0; if (v.role === 'crew') { v.g.fat = 100; fxText(v.x, v.y - 40, '倒下', '#fca'); } if (v.role === 'troop') { S.res.troops = Math.max(0, S.res.troops - 25); } return; }
    R.streak++; R.loot.kills++; st().kills++;
    for (const u of R.units) if (u.role === 'crew' && u.hp > 0 && u.inFight) u.g.fat = Math.min(100, (u.g.fat || 0) + 1.5);
    if (v.guard != null || v.bryan || v.otBoss) { v.deadT = 0; soulDrop(v, 0.6); return; }
    v.down = DOWN_T; v.downMax = DOWN_T; R.downs.push(v);
    if (st().auto) { resolveDown(v, 'soul'); return; }
    downUI();
  }
  function signInfo(v) {
    const p = st(), ph = phase(p.min), isN = !!N30_G[v.k];
    if (isN && N30W.owned(v.k)) return { ok:false, why:'已經收服了' };
    if (isN && S.lv < N30_TIER[N30_G[v.k].t].req) return { ok:false, why:`需主公 Lv${N30_TIER[N30_G[v.k].t].req}` };
    if (!isN && !FODDER[v.k]) return { ok:false, why:'不肯簽' };
    if (!isN && fodderCount() >= F.rosterCap()) return { ok:false, why:'編制滿了（升級民宅）' };
    let ch = isN ? 30 : 60;
    const regClr = CHAPTERS[R.ci].stages.filter((s, si) => S.cleared[sidOf(R.ci, si)]).length;
    ch *= 0.8 + 0.4 * regClr / 3;
    ch += p.pity[v.k] || 0;
    let fear = false;
    try { const by = v.lastBy, f = Rework.fearOf(v.k), ts = by && Rework.typesOf(by.k); if (ts && f && ts.some(t => f.w.includes(t))) { ch += 20; fear = true; } } catch (e) {}
    if (ph === 'zi') ch -= 10; if (ph === 'off') ch += 10;
    ch = Math.max(5, Math.min(95, Math.round(ch)));
    const cost = Math.round(isN ? 30 + 8 * v.p : 8 + 3 * v.p);
    return { ok:S.res.buns >= cost, why:S.res.buns >= cost ? '' : '壽包不夠', ch, cost, fear, isN };
  }
  function soulDrop(v, mul) {
    const ph = phase(st().min), m = (mul || 1) * (ph === 'zi' ? 2 : 1) * (1 + Math.min(1, R.streak * 0.01)) * (v.elite ? 5 : 1);
    const coins = Math.max(1, Math.round((3 + 2.2 * v.p) * m)), mat = Math.max(1, Math.round((1 + v.p / 5) * m * (0.7 + Math.random() * 0.6))), exp = Math.max(1, Math.round((1 + v.p * 0.8) * (v.elite ? 4 : 1)));
    const f = v.fac in FAC ? v.fac : 'lan', g = { coins, exp }; g[f] = mat; gain(g);
    if (v.elite && Math.random() < 0.5) { S.chests.g++; fxText(v.x, v.y - 90, '綠箱 ×1', '#9f9', true); }
    fxText(v.x, v.y - 70, `+${coins} 冥幣　+${mat} ${FAC[f].mat}`, '#ffe08a'); if (img('fx_beam')) { spr('fx_beam', v.x, v.y + 6, { s0:0.35, s1:0.5, sx:0.7, life:1.1, anchor:0.95, fadeIn:true }); spr('fx_gold', v.x, v.y - 40, { s0:0.15, s1:0.35, life:0.7, vy:40 }); } else R.fx.push({ kind:'soul', x:v.x, y:v.y, t:0, life:1.3 });
  }
  function gain(g) {
    for (const k in g) {
      if (k === 'coins') { S.res.coins += g.coins; R.loot.coins += g.coins; }
      else if (k === 'exp') { gainExp(g.exp); R.loot.exp += g.exp; }
      else if (k in FAC) { st().mats[k] += g[k]; R.loot[k] += g[k]; }
    }
  }
  function resolveDown(v, how, timeout) {
    if (v.done) return; v.done = true; v.down = 0; v.deadT = 0; R.downs = R.downs.filter(x => x !== v);
    if (how === 'soul') { soulDrop(v); v.soul = 1; }
    else {
      const I = signInfo(v); if (!I.ok) { v.done = false; v.down = Math.max(0.5, v.down); R.downs.push(v); Fx.toast(I.why); return; }
      S.res.buns -= I.cost; R.loot.buns += I.cost;
      if (Math.random() * 100 < I.ch) {
        st().pity[v.k] = 0; R.loot.rec++; st().rec++; v.signed = 1;
        if (I.isN) { const k = v.k; Story.queue({ style:'narr', lines:[[GHOSTS[k].name, GHOSTS[k].say], ['旁白', T(`${GHOSTS[k].name}簽咗合約，跟你返落魄村。`, `${GHOSTS[k].name}簽了合約，跟你回落魄村。`)]] }, () => { joinGhost(k); persist(); }); }
        else {
          const g = addCrew(v.k, v.p, v.elite, v.x, v.y);
          msg(`<b>收編成功！</b>${g.name}（${g.q}・Lv${g.lv}）加入部門。${I.fear ? '（對症收編 +20%）' : ''}`, 3);
        }
        fxText(v.x, v.y - 80, '簽約！', '#9fffb0', true); spr('fx_ring', v.x, v.y, { ground:true, s0:0.2, s1:0.55, life:0.8 }); spr('fx_gold', v.x, v.y - 50, { s0:0.2, s1:0.5, life:0.8, vy:30 }); try { Sound.play('gong'); } catch (e) {}
      } else {
        st().pity[v.k] = (st().pity[v.k] || 0) + 15; v.fled = 1; spr('fx_smoke', v.x, v.y - 30, { s0:0.2, s1:0.5, life:0.7, add:false, alpha:0.9 });
        fxText(v.x, v.y - 80, '跑掉了！', '#fca', true); msg(T(`${v.name}睇完合約，走咗。（下次收同種 +15%）`, `${v.name}看完合約，跑了。（下次收同種 +15%）`), 2.5);
      }
    }
    downUI(); save();
  }
  function addCrew(k, p, rare, x, y) {
    const lv = Math.max(1, Math.min(F.ghostCap(), Math.round(1 + p * 1.6)));
    const purple = rare || Math.random() < 0.12, m = purple ? 1.45 : 1, s3 = [0, 0, 0].map(() => Math.round((15 + Math.random() * 32) * m));
    const used = new Set(S.ghosts.map(g => g.name)); let name = FODDER[k].name;
    for (let i = 0; i < 40; i++) { name = FODDER[k].name + '・' + NICKS[Math.floor(Math.random() * NICKS.length)]; if (!used.has(name)) break; }
    const g = { id:'g' + (S.uid++), k, name, q:purple ? '紫' : '藍', lv, st:s3, post:null, spent:0, fat:0 };
    S.ghosts.push(g); S.cnt.recruit = (S.cnt.recruit || 0) + 1;
    const nCrew = R.units.filter(u => u.role === 'crew' && !u.gone).length;
    if (nCrew < crewCap()) { const u = unitFromGhost(g, 'crew'); u.slot = 3 + nCrew; u.x = x; u.y = y; R.units.push(u); }
    if (has(Chatter) && Chatter.onRecruit) try { Chatter.onRecruit(g); } catch (e) {}
    return g;
  }
  function downUI() {
    const box = $('#pt-down'); if (!box) return;
    const v = R.downs[R.downs.length - 1];
    if (!v) { box.classList.remove('on'); box.innerHTML = ''; R.downV = null; return; }
    if (R.downV === v) return; R.downV = v;
    const I = signInfo(v), f = FAC[v.fac] || FAC.lan;
    box.innerHTML = `<div class="pd-h"><canvas data-por="${v.k}"></canvas><div><b>${v.name}</b>${v.elite ? '<i class="pd-el">釘子戶</i>' : ''}<small style="color:${f.col}">${f.name}・靈體不穩</small></div><i class="pd-t"><s></s></i></div>
      <div class="pd-b"><button class="btn" id="pd-soul">送去投胎<small>冥幣＋${f.mat}</small></button><button class="btn gold" id="pd-sign" ${I.ok ? '' : 'disabled'}>遞合約 ${I.ch != null ? I.ch + '%' : ''}<small>${I.ok ? `壽包 ${I.cost}${I.fear ? '・對症' : ''}` : I.why}</small></button></div>`;
    box.classList.add('on'); paintPortraits(box);
    $('#pd-soul').onclick = () => resolveDown(v, 'soul');
    $('#pd-sign').onclick = () => resolveDown(v, 'sign');
  }

  // ---------- 設施：地鐵站、茶水間、扣押室、通宵加班房 ----------
  function stationCost(z) { const c = R.ci + 1; return z === 0 ? 0 : Math.round((z === 4 ? 10 : 20) * Math.pow(c, 1.5)); }
  function matTotal() { const m = st().mats; return m.yuan + m.chan + m.lan; }
  function payMat(n) { const m = st().mats; let left = n; for (const k of Object.keys(m).sort((a, b) => m[b] - m[a])) { const d = Math.min(m[k], left); m[k] -= d; left -= d; if (!left) break; } }
  function facilities(dt) {
    const L = R.L, rs = regSt(R.ci), day = Math.floor(Date.now() / 864e5);
    let near = null;
    for (const f of FACI) { const q = faciPos(f); if (Math.hypot(q.x - L.x, q.y - L.y) < 90) { near = f; break; } }
    const box = $('#pt-act'); if (!box) return;
    const key = near ? near.t + near.z + ':' + (rs.sta[near.z] ? 1 : 0) + (R.tea[near.z] > R.t ? 1 : 0) + (rs.ot === day) + (rs.pr === day) : '';
    if (key === R.actKey) return; R.actKey = key;
    if (!near) { box.classList.remove('on'); box.innerHTML = ''; return; }
    let h = '';
    if (near.t === 'station') {
      if (!rs.sta[near.z]) { const c = stationCost(near.z); h = `<b>陰間地鐵站（未開通）</b><small>開通後可從準備畫面直接在這裡出發，巡邏中也能互相轉站。</small><button class="btn gold" id="pa-go" ${matTotal() >= c ? '' : 'disabled'}>開通（執念 ${c}，任何派系）</button>`; }
      else { const others = FACI.filter(f => f.t === 'station' && f.z !== near.z && rs.sta[f.z]); h = `<b>陰間地鐵站・${near.z + 1}區</b><small>${others.length ? '搭到：' : '其他站未開通'}</small>${others.map(f => `<button class="btn" data-tp="${f.z}">${f.z + 1}區站</button>`).join('')}`; }
    } else if (near.t === 'tea') {
      const cd = (R.tea[near.z] || 0) - R.t;
      h = `<b>陰間茶水間</b><small>全部門回血，過勞 -40。</small><button class="btn gold" id="pa-go" ${cd > 0 ? 'disabled' : ''}>${cd > 0 ? `在沖咖啡（${Math.ceil(cd)} 秒）` : '進去歇一下'}</button>`;
    } else if (near.t === 'prison') {
      h = rs.pr === day ? `<b>扣押室</b><small>今天已經救過人，明天再來。</small>` : `<b>扣押室</b><small>關著一隻欠交報告的實習鬼。救牠出來，牠會自願加入部門（要有編制）。</small><button class="btn gold" id="pa-go" ${fodderCount() < F.rosterCap() ? '' : 'disabled'}>${fodderCount() < F.rosterCap() ? '救人' : '編制滿了'}</button>`;
    } else if (near.t === 'overtime') {
      h = rs.ot === day ? `<b>通宵加班房</b><small>今晚已經加過班，明晚再來。</small>` : `<b>通宵加班房</b><small>裡面有隻連加三晚班的鬼（攻擊 ×3、血 ×6），帶著 4 個實習鬼。打贏有大獎（紫箱）。</small><button class="btn gold" id="pa-go">開門</button>`;
    }
    box.innerHTML = h; box.classList.add('on');
    const go = $('#pa-go'); if (go) go.onclick = () => useFaci(near);
    box.querySelectorAll('[data-tp]').forEach(b => b.onclick = () => { const q = faciPos(FACI.find(f => f.t === 'station' && f.z === +b.dataset.tp)); teleport(q.x + 60, q.y + 60); });
  }
  function teleport(x, y) { R.L.x = x; R.L.y = y; R.units.forEach(u => { u.vx = u.vy = 0; if (!u.leader) { const o = formation(u.slot || 0); u.x = x + o.x; u.y = y + o.y; } }); R.cam.x = x; R.cam.y = y; R.actKey = null; revealAround(x, y); msg('到站。', 1.2); }
  function useFaci(f) {
    const rs = regSt(R.ci), day = Math.floor(Date.now() / 864e5), q = faciPos(f); R.actKey = null;
    if (f.t === 'station') { const c = stationCost(f.z); if (matTotal() < c) return; payMat(c); rs.sta[f.z] = 1; msg(`開通了 ${f.z + 1} 區地鐵站。`, 2); save(); }
    else if (f.t === 'tea') { R.tea[f.z] = R.t + TEA_CD; R.units.forEach(u => { if (u.hp > 0) u.hp = u.maxhp; if (u.g && u.g.fat) { u.g.fat = Math.max(0, u.g.fat - 40); if (u.g.fat < 70 && u.tired) { u.tired = 0; u.atk /= 0.7; } } }); msg(T('茶水間：「咖啡機又壞咗。」大家飲住熱水休息咗一陣。全部門回血，過勞 -40。', '茶水間：「咖啡機又壞了。」大家喝熱水休息了一下。全部門回血，過勞 -40。'), 3); try { Sound.play('click'); } catch (e) {} }
    else if (f.t === 'prison') { if (fodderCount() >= F.rosterCap()) return; rs.pr = day; const pool = fodOf(R.ci), k = pool[Math.floor(Math.random() * pool.length)]; const g = addCrew(k, zoneP(R.ci, f.z), false, q.x, q.y + 30); R.loot.rec++; fxText(q.x, q.y - 60, g.name + ' 入部門', '#9fffb0', true); msg(T('實習鬼：「多謝前輩！報告我聽日一定交！」（佢唔會交）', '實習鬼：「謝謝前輩！報告我明天一定交！」（他不會交）'), 3); }
    else if (f.t === 'overtime') { rs.ot = day; const z = f.z, p = zoneP(R.ci, z) + 0.5, pool = fodOf(R.ci), arr = [];
      const bk = pool[pool.length - 1], b = foe(bk, p, { hp:6, atk:3 }, { ot:true }); b.name = '通宵' + b.name; b.otBoss = true; b.sk = SKILLS[bk] || null; b.s = 0.75; b.x = q.x; b.y = q.y - 40; b.hx = b.x; b.hy = b.y; b.provoked = true; b.z = z; arr.push(b);
      for (let i = 0; i < 4; i++) { const e = foe(pool[i % pool.length], p, { hp:1.2, atk:1.1 }, { ot:true }); e.name = '實習' + e.name; e.x = q.x + Math.cos(i * 1.57) * 70; e.y = q.y - 40 + Math.sin(i * 1.57) * 45; e.hx = e.x; e.hy = e.y; e.provoked = true; e.z = z; arr.push(e); }
      arr.forEach(e => R.foes.push(e)); R.ot = arr; msg(T('加班房道門打開：「你哋又係嚟陪我加班？」', '加班房的門打開了：「你們也是來陪我加班的？」'), 3); }
    persist();
  }

  // ---------- 主線：主管／總監打贏 ----------
  function stageWin(si) {
    const ci = R.ci, ch = CHAPTERS[ci], stg = ch.stages[si], sid = sidOf(ci, si), first = !S.cleared[sid];
    const rew = first ? { coins:60 * stg.p + 40, exp:30 * stg.p + 40, chest:['g', 'b', 'p'][si] } : { coins:20 * stg.p, exp:8 * stg.p };
    S.cleared[sid] = true; const txt = give(rew); R.loot.coins += rew.coins || 0; R.loot.exp += rew.exp || 0;
    try { Sound.play('win'); spr('fx_scream', R.L.x, R.L.y - 40, { s0:0.4, s1:2.2, life:0.8 }); spr('fx_gold', R.L.x, R.L.y - 60, { s0:0.4, s1:0.9, life:1 }); R.flash = 0.4; } catch (e) {}
    Fx.banner(si === 2 ? `區域總監 ${stg.name} 擊破！` : `部門主管擊破！${si === 0 ? '第 4 區閘口開放' : '第 8 區閘口開放'}`);
    Fx.toast(`${sid}　${stg.name}　${txt}`);
    if (first) {
      const afters = (stg.after || []).slice();
      if (sid === '6-2') { Story.queue('ch6_wuchang', () => { joinGhost('baiwu'); joinGhost('heiwu'); }); Story.queue('ch6_mengpo', () => joinGhost('mengpo')); }
      else if (sid === '6-3') { Story.queue('ch6_end'); Story.queue('ch6_reboot', () => { S.ended = true; }); Story.queue('epilogue'); }
      else afters.forEach((id, i) => Story.queue(id, () => { if (i === 0) (stg.join || []).forEach(joinGhost); if (typeof GIFT_REWARD !== 'undefined' && GIFT_REWARD[id]) Fx.toast('媽媽燒來的禮物：' + give(GIFT_REWARD[id])); }));
      if (si === 2 && ci < 5) Story.queue({ style:'narr', lines:[['旁白', `第${'一二三四五六'[ci + 1]}區・${CHAPTERS[ci + 1].name} 開放了。收工返村，準備好就可以出發。`]] });
    }
    Quest.check(); persist(); save(); UI.refresh();
  }

  // ---------- 結束 ----------
  function persist() { if (!R) return; regSt(R.ci).fog = R.fog.join('').replace(/0+$/, ''); save(); }
  function end(died) {
    if (!R || R.ended) return; R.ended = true; persist();
    st().restAt = Date.now();
    if (died) R.streak = 0;
    const l = R.loot, box = $('#pt-end'), q = D(MEET[Math.floor(Math.random() * MEET.length)]);
    box.innerHTML = `<div class="pe-card"><h2>${died ? '阿福倒下了' : '收工'}</h2>${died ? `<p class="quip">${q}</p>` : ''}
      <p>擊倒 ${l.kills}　收編 ${l.rec}</p><p>冥幣 +${fmt(l.coins)}　好評 +${fmt(l.exp)}</p><p>${Object.keys(FAC).map(f => `<span style="color:${FAC[f].col}">${FAC[f].mat} +${l[f]}</span>`).join('　')}</p>${l.buns ? `<p>合約工資：壽包 -${l.buns}</p>` : ''}
      <p class="desc">${died ? '材料和冥幣全部保留。' : ''}部門回村休息，過勞會慢慢恢復。</p>
      <button class="btn gold wide" id="pe-ok">返村</button></div>`;
    box.classList.add('on');
    $('#pe-ok').onclick = () => close();
    try { Sound.play(died ? 'lose' : 'win'); } catch (e) {}
    save();
  }
  function close() {
    active = false; cancelAnimationFrame(raf); window.removeEventListener('resize', resize); window.onkeydown = null; window.onkeyup = null;
    if (el) { el.classList.remove('on'); el.innerHTML = ''; }
    R = null; try { Sound.setMode('village'); } catch (e) {} Quest.check(); save(); UI.refresh();
  }

  // ---------- 畫 ----------
  // 擺設：有老闆 ChatGPT 生嘅蠟筆圖就用圖（PT_IMG_SRC.pr_*），冇就用程式畫
  const PROP = {
    tomb:{ img:'pr_tomb', h:62 }, tree:{ img:'pr_deadtree', h:120 }, lantern:{ img:'pr_lantern', h:92, light:'255,120,70' }, rock:{ img:'pr_rocks', h:44 },
    stilt:{ img:'pr_stilt', h:120, light:'255,190,110' }, palm:{ img:'pr_palm', h:140 }, well:{ img:'pr_well', h:62 }, bush:{ img:'pr_bush', h:56 }, bush2:{ img:'pr_bush2', h:54 },
    lamp:{ img:'pr_lamp', h:110, light:'200,230,170' }, cart:{ img:'pr_cart', h:56 }, stone:{ img:'pr_milestone', h:58 }, rock2:{ img:'pr_rocks2', h:48 },
    banana:{ img:'pr_banana', h:120 }, pond:{ img:'pr_pond', h:46 }, hut:{ img:'pr_hut', h:96, light:'255,190,110' }, fern:{ img:'pr_fern', h:44 },
    slamp:{ img:'pr_slamp', h:120, light:'255,214,140' }, cone:{ img:'pr_barrier', h:46 }, bus:{ img:'pr_busstop', h:92 }, scooter:{ img:'pr_scooter', h:52 },
    pillar:{ img:'pr_pillar', h:108 }, cabinet:{ img:'pr_cabinet', h:68 }, plant:{ img:'pr_plant', h:66 }, cooler:{ img:'pr_cooler', h:72, light:'140,200,255' },
  };
  const PAT = {};
  function groundPat(c) {
    const im = img('ground' + R.ci);
    if (im) { if (!PAT['g' + R.ci]) PAT['g' + R.ci] = c.createPattern(im, 'repeat'); return PAT['g' + R.ci]; }
    if (!PAT['p' + R.ci]) PAT['p' + R.ci] = c.createPattern(mkPattern(R.ci), 'repeat'); return PAT['p' + R.ci];
  }
  // 小路：沿住 12 個區嘅中心行一條之字路，等玩家知道去邊
  function pathPts() {
    if (R.path) return R.path; const rnd = seeded(R.ci * 13 + 5), pts = [];
    for (let z = 0; z < 12; z++) { const c = zoneCell(z); pts.push([c.x + (rnd() - 0.5) * 160, c.y + (rnd() - 0.5) * 140]); if (z === 3) pts.push([GATES[0].x, GATES[0].y]); if (z === 7) pts.push([GATES[1].x, GATES[1].y]); }
    const g2 = guardPos(2); pts.push([g2.x + 60, g2.y]); return (R.path = pts);
  }
  function drawPath(c) {
    const pts = pathPts(); c.save(); c.lineCap = 'round'; c.lineJoin = 'round';
    const line = () => { c.beginPath(); c.moveTo(pts[0][0], pts[0][1]); for (let i = 1; i < pts.length; i++) { const [x0, y0] = pts[i - 1], [x1, y1] = pts[i]; c.quadraticCurveTo(x0, y0, (x0 + x1) / 2, (y0 + y1) / 2); } c.lineTo(pts[pts.length - 1][0], pts[pts.length - 1][1]); c.stroke(); };
    c.strokeStyle = 'rgba(20,14,10,.28)'; c.lineWidth = 120; line();
    c.strokeStyle = 'rgba(120,104,80,.16)'; c.lineWidth = 80; line();
    c.setLineDash([3, 14]); c.strokeStyle = 'rgba(200,180,140,.12)'; c.lineWidth = 3; line(); c.setLineDash([]);
    c.restore();
  }
  function drawChasm(c, y, g, open, cx, vw) { // 兩行之間係深坑，只可以經閘口過
    const x0 = Math.max(0, cx - 60), x1 = Math.min(WW, cx + vw + 60), H2 = 46;
    const band = (a, b) => { if (b <= a) return;
      const gr = c.createLinearGradient(0, y - H2, 0, y + H2); gr.addColorStop(0, 'rgba(0,0,0,0)'); gr.addColorStop(0.3, 'rgba(4,3,8,.95)'); gr.addColorStop(0.7, 'rgba(4,3,8,.95)'); gr.addColorStop(1, 'rgba(0,0,0,0)');
      c.fillStyle = gr; c.fillRect(a, y - H2, b - a, H2 * 2);
      c.strokeStyle = 'rgba(70,58,50,.75)'; c.lineWidth = 3; c.lineJoin = 'round';
      for (const s of [-1, 1]) { c.beginPath(); for (let x = a; x <= b; x += 16) { const j = Math.sin(x * 0.07 + s) * 4 + ((x * 7919) % 11) * 0.5; c.lineTo(x, y + s * (H2 * 0.36) + j * s); } c.stroke(); }
      c.fillStyle = 'rgba(120,140,170,.05)'; for (let x = a - (a % 90); x < b; x += 90) { c.beginPath(); c.ellipse(x + Math.sin(R.t * 0.4 + x) * 20, y, 70, 12, 0, 0, 7); c.fill(); } };
    band(x0, Math.min(x1, g.x - GW / 2)); band(Math.max(x0, g.x + GW / 2), x1);
    if (g.x + GW / 2 < x0 || g.x - GW / 2 > x1) return;
    c.save(); // 木橋
    c.fillStyle = '#3a2c20'; c.strokeStyle = '#120c08'; c.lineWidth = 2;
    for (let yy = y - H2 + 4; yy < y + H2 - 4; yy += 12) { c.fillRect(g.x - GW / 2 + 22, yy, GW - 44, 9); c.strokeRect(g.x - GW / 2 + 22, yy, GW - 44, 9); }
    c.strokeStyle = '#2a1c12'; c.lineWidth = 4; c.beginPath(); c.moveTo(g.x - GW / 2 + 18, y - H2); c.lineTo(g.x - GW / 2 + 18, y + H2); c.moveTo(g.x + GW / 2 - 18, y - H2); c.lineTo(g.x + GW / 2 - 18, y + H2); c.stroke();
    if (!open) { for (let i = 0; i < 5; i++) { const x = g.x - GW / 2 + 30 + i * (GW - 60) / 4; c.fillStyle = '#1a1414'; c.fillRect(x - 3, y - 50, 6, 32); }
      c.fillStyle = '#c8402c'; c.fillRect(g.x - GW / 2 + 24, y - 46, GW - 48, 10); c.fillStyle = '#eee'; for (let i = 0; i < 7; i++) c.fillRect(g.x - GW / 2 + 32 + i * 24, y - 46, 11, 10);
      c.fillStyle = '#e8dcc0'; c.fillRect(g.x - 44, y - 76, 88, 22); c.strokeStyle = '#2a1a10'; c.lineWidth = 2; c.strokeRect(g.x - 44, y - 76, 88, 22);
      c.fillStyle = '#7a1a10'; c.font = '900 13px "PingFang TC","Noto Sans TC",sans-serif'; c.textAlign = 'center'; c.fillText('主管當值', g.x, y - 60); }
    c.restore();
  }
  function drawPropImg(c, p) {
    const d = PROP[p.t], im = d && img(d.img); if (!im) { drawProp(c, p); return; }
    const h = d.h * p.s, w = h * im.naturalWidth / im.naturalHeight;
    c.save(); c.fillStyle = 'rgba(0,0,0,.32)'; c.beginPath(); c.ellipse(p.x, p.y + 2, w * 0.38, w * 0.11, 0, 0, 7); c.fill();
    if (p.v > 0.5) { c.translate(p.x, 0); c.scale(-1, 1); c.translate(-p.x, 0); }
    c.drawImage(im, p.x - w / 2, p.y - h + 6, w, h); c.restore();
  }
  let LC = null;
  function draw() {
    const c = ctx, k = R.sc * R.dpr, vw = VIEW, vh = R.h / R.sc;
    const cx = Math.max(0, Math.min(WW - vw, R.cam.x - vw / 2)), cy = vh >= WH ? (WH - vh) / 2 : Math.max(-60, Math.min(WH - vh + 40, R.cam.y - vh / 2));
    const sh = R.shake || 0, shx = sh ? (Math.random() - 0.5) * sh : 0, shy = sh ? (Math.random() - 0.5) * sh * 0.7 : 0;
    c.setTransform(1, 0, 0, 1, 0, 0); c.fillStyle = '#060508'; c.fillRect(0, 0, cv.width, cv.height);
    c.setTransform(k, 0, 0, k, (-cx + shx) * k, (-cy + shy) * k);
    const gx0 = Math.max(0, cx), gy0 = Math.max(0, cy), gx1 = Math.min(WW, cx + vw), gy1 = Math.min(WH, cy + vh);
    c.fillStyle = groundPat(c); c.fillRect(gx0, gy0, gx1 - gx0, gy1 - gy0);
    drawPath(c);
    // 地上嘅預警紅圈
    for (const f of R.fx) if (f.kind === 'spr' && f.ground) drawSpr(c, f);
    if (R.tele) for (const t of R.tele) { const p = t.t / t.dur; const wi = fxImg('fx_warn'); if (wi) { c.save(); const pul = 0.7 + 0.25 * Math.sin(R.t * 18); c.globalAlpha = pul; const W = t.r * 2.2, H = W * wi.naturalHeight / wi.naturalWidth; c.drawImage(wi, t.x - W / 2, t.y - H / 2, W, H); c.globalAlpha = 0.5 + 0.4 * p; const W2 = W * p, H2 = H * p; c.drawImage(wi, t.x - W2 / 2, t.y - H2 / 2, W2, H2); c.restore(); continue; } c.save(); c.globalAlpha = 0.35 + 0.25 * Math.sin(R.t * 20); c.fillStyle = 'rgba(200,30,20,.35)'; c.strokeStyle = '#ff5a3a'; c.lineWidth = 3; c.beginPath(); c.ellipse(t.x, t.y, t.r, t.r * 0.6, 0, 0, 7); c.fill(); c.stroke(); c.globalAlpha = 0.6; c.fillStyle = 'rgba(255,90,60,.5)'; c.beginPath(); c.ellipse(t.x, t.y, t.r * p, t.r * 0.6 * p, 0, 0, 7); c.fill(); c.restore(); }
    // 阿福腳下光圈
    const L = R.L; c.save(); c.strokeStyle = 'rgba(255,220,120,.55)'; c.lineWidth = 2; c.setLineDash([6, 5]); c.lineDashOffset = -R.t * 20; c.beginPath(); c.ellipse(L.x, L.y + 2, 26, 9, 0, 0, 7); c.stroke(); c.restore();
    for (const f of R.fx) if (f.kind === 'dust') Battle.drawDust(c, f);
    const items = [], lights = [];
    for (const p of R.props) if (p.x > cx - 90 && p.x < cx + vw + 90 && p.y > cy - 20 && p.y < cy + vh + 160) { items.push({ y:p.y, f:() => drawPropImg(c, p) }); const d = PROP[p.t]; if (d && d.light) lights.push({ x:p.x, y:p.y - d.h * p.s * 0.6, r:150, col:d.light }); }
    for (const f of FACI) { const q = faciPos(f); if (q.x > cx - 140 && q.x < cx + vw + 140 && q.y > cy - 60 && q.y < cy + vh + 160) { items.push({ y:q.y, f:() => drawFaci(c, f, q) }); lights.push({ x:q.x, y:q.y - 40, r:170, col:f.t === 'station' ? '120,255,160' : f.t === 'tea' ? '255,200,120' : f.t === 'overtime' ? '140,200,255' : null }); } }
    for (const u of R.units) if ((u.hp > 0 || (u.deadT || 0) < 0.8) && !u.gone && vis(u, cx, cy, vw, vh)) { items.push({ y:u.y, f:() => drawUnit(c, u) }); if (u.hp > 0 && !u.leader) lights.push({ x:u.x, y:u.y - 30, r:60 }); }
    for (const e of R.foes) if (((e.hp > 0 && !e.fled) || e.down > 0 || (e.deadT || 0) < 0.8 || (e.fled && (e.deadT || 0) < 1.2)) && vis(e, cx, cy, vw, vh)) items.push({ y:e.y, f:() => drawUnit(c, e) });
    for (const f of R.fx) if (f.kind === 'after') items.push({ y:f.y - 0.1, f:() => { c.save(); c.globalAlpha = 0.35 * (1 - f.t / f.life); c.globalCompositeOperation = 'lighter'; try { ART.drawChar(c, f.k, f.x, f.y, f.s * 1.65, { flip:f.flip, shadow:false, tamed:true, untied:true, pose:'move', walk:true, t:R.t }); } catch (e) {} c.restore(); } });
    items.sort((a, b) => a.y - b.y).forEach(i => i.f());
    // 兩行之間嘅深坑（畫喺人前面，因為佢係地形嘅「前景邊」）
    for (let i = 0; i < 2; i++) if (CH * (i + 1) > cy - 60 && CH * (i + 1) < cy + vh + 60) drawChasm(c, CH * (i + 1), GATES[i], gateOpen(i), cx, vw);
    for (const q of R.proj) { drawProj(c, q); lights.push({ x:q.x, y:q.y, r:50 }); }
    for (const f of R.fx) {
      if (f.kind === 'spr') { if (!f.ground) { drawSpr(c, f); if (f.add && f.t < f.life * 0.5) lights.push({ x:f.x, y:f.y, r:60 }); } }
      else if (f.kind === 'spark') Battle.drawSpark(c, f); else if (f.kind === 'slash') Battle.drawSlash(c, f);
      else if (f.kind === 'ring') { const p = f.t / f.life; c.save(); c.strokeStyle = f.col; c.globalAlpha = 1 - p; c.lineWidth = 4 * (1 - p) + 1; c.beginPath(); c.ellipse(f.x, f.y, f.r * (0.3 + 0.7 * p), f.r * 0.6 * (0.3 + 0.7 * p), 0, 0, 7); c.stroke(); c.restore(); lights.push({ x:f.x, y:f.y, r:f.r * 0.8 }); }
      else if (f.kind === 'soul') { const p = f.t / f.life; c.save(); c.globalCompositeOperation = 'lighter'; const y = f.y - 40 - p * 90, g = c.createRadialGradient(f.x, y, 0, f.x, y, 16); g.addColorStop(0, `rgba(220,240,255,${0.9 * (1 - p)})`); g.addColorStop(1, 'rgba(120,180,255,0)'); c.fillStyle = g; c.beginPath(); c.arc(f.x, y, 16, 0, 7); c.fill();
        c.fillStyle = `rgba(160,200,255,${0.18 * (1 - p)})`; c.fillRect(f.x - 7, f.y - 160, 14, 160); c.restore(); lights.push({ x:f.x, y, r:70 }); }
    }
    for (const f of R.fx) if (f.kind === 'num' || f.kind === 'txt') Battle.drawText(c, f);
    // 霧
    c.save(); for (let i = 0; i < 3; i++) { const fx = cx + ((i * 173 + R.t * (8 + i * 2)) % (vw + 400)) - 200, fy = cy + vh * (0.15 + i * 0.15) + Math.sin(R.t * 0.3 + i) * 30, g = c.createRadialGradient(fx, fy, 0, fx, fy, 220); g.addColorStop(0, 'rgba(150,160,190,.07)'); g.addColorStop(1, 'rgba(150,160,190,0)'); c.fillStyle = g; c.fillRect(fx - 220, fy - 220, 440, 440); } c.restore();
    // 光照：整片黑，挖返啲光出嚟（阿福、燈籠、設施、技能）
    c.setTransform(1, 0, 0, 1, 0, 0);
    const LQ = 4; if (!LC || LC.width !== Math.ceil(cv.width / LQ) || LC.height !== Math.ceil(cv.height / LQ)) { LC = document.createElement('canvas'); LC.width = Math.ceil(cv.width / LQ); LC.height = Math.ceil(cv.height / LQ); }
    const l = LC.getContext('2d'), ph = phase(st().min);
    l.globalCompositeOperation = 'source-over'; l.clearRect(0, 0, LC.width, LC.height);
    l.fillStyle = ph === 'zi' ? 'rgba(22,0,10,.8)' : ph === 'work' ? 'rgba(8,12,24,.5)' : ph === 'off' ? 'rgba(10,10,26,.62)' : 'rgba(4,4,14,.7)'; l.fillRect(0, 0, LC.width, LC.height);
    l.globalCompositeOperation = 'destination-out';
    const S2 = (x, y) => [(x - cx + shx) * k, (y - cy + shy) * k];
    const hole = (x, y, r, a) => { const [sx0, sy0] = S2(x, y), sx = sx0 / LQ, sy = sy0 / LQ, rr = r * k / LQ, g = l.createRadialGradient(sx, sy, 0, sx, sy, rr); g.addColorStop(0, `rgba(0,0,0,${a})`); g.addColorStop(1, 'rgba(0,0,0,0)'); l.fillStyle = g; l.fillRect(sx - rr, sy - rr, rr * 2, rr * 2); };
    hole(L.x, L.y - 30, 330, 1);
    for (const q of lights) if (q.x > cx - 200 && q.x < cx + vw + 200 && q.y > cy - 200 && q.y < cy + vh + 200) hole(q.x, q.y, q.r, 0.85);
    c.imageSmoothingEnabled = true; c.drawImage(LC, 0, 0, cv.width, cv.height);
    // 有色光暈（加亮）
    c.save(); c.globalCompositeOperation = 'lighter';
    for (const q of lights) if (q.col) { const [sx, sy] = S2(q.x, q.y), rr = q.r * 0.7 * k, g = c.createRadialGradient(sx, sy, 0, sx, sy, rr); g.addColorStop(0, `rgba(${q.col},.22)`); g.addColorStop(1, `rgba(${q.col},0)`); c.fillStyle = g; c.fillRect(sx - rr, sy - rr, rr * 2, rr * 2); }
    for (const w of R.wisps || []) { const [sx, sy] = S2(w.x, w.y), a = 0.45 + 0.4 * Math.sin(R.t * 3 + w.ph), rr = w.r * 3 * k, g = c.createRadialGradient(sx, sy, 0, sx, sy, rr); const col = w.hue ? '255,180,120' : '150,255,190'; g.addColorStop(0, `rgba(${col},${a})`); g.addColorStop(1, `rgba(${col},0)`); c.fillStyle = g; c.fillRect(sx - rr, sy - rr, rr * 2, rr * 2); }
    c.restore();
    if (R.buff > 0) { c.save(); c.globalAlpha = 0.08 + 0.04 * Math.sin(R.t * 6); c.fillStyle = '#ffcf5a'; c.fillRect(0, 0, cv.width, cv.height); c.restore(); }
    if (R.flash > 0) { c.fillStyle = `rgba(255,255,255,${R.flash * 0.5})`; c.fillRect(0, 0, cv.width, cv.height); }
    // 搖桿
    if (R.joy) { const d = R.dpr; c.strokeStyle = 'rgba(255,255,255,.35)'; c.lineWidth = 2 * d; c.beginPath(); c.arc(R.joy.x0 * d, R.joy.y0 * d, 46 * d, 0, 7); c.stroke(); const dx = R.joy.x - R.joy.x0, dy = R.joy.y - R.joy.y0, dl = Math.hypot(dx, dy), m = Math.min(46, dl) / (dl || 1); c.fillStyle = 'rgba(255,255,255,.35)'; c.beginPath(); c.arc((R.joy.x0 + dx * m) * d, (R.joy.y0 + dy * m) * d, 20 * d, 0, 7); c.fill(); }
    drawMini();
  }
  function drawProj(c, p) {
    const fi = fxImg('fx_fire', p.hue); if (fi) { const v = p.tg, ang = Math.atan2(p.vy || 0, p.vx || 1), W = 46 * (p.big || 1), H = W * (fi.naturalHeight || fi.height) / (fi.naturalWidth || fi.width); c.save(); c.globalCompositeOperation = 'lighter'; c.translate(p.x, p.y); c.rotate(ang); c.drawImage(fi, -W * 0.8, -H / 2, W, H); c.restore(); return; }
    c.save(); c.lineCap = 'round';
    for (let i = 1; i < p.trail.length; i++) { const [x0, y0] = p.trail[i - 1], [x1, y1] = p.trail[i], f = i / p.trail.length; c.globalAlpha = f * 0.7; c.strokeStyle = p.col; c.lineWidth = 1 + f * 5; c.beginPath(); c.moveTo(x0, y0); c.lineTo(x1, y1); c.stroke(); }
    c.globalAlpha = 1; c.globalCompositeOperation = 'lighter'; const g = c.createRadialGradient(p.x, p.y, 0, p.x, p.y, 11); g.addColorStop(0, '#fff'); g.addColorStop(0.35, p.col); g.addColorStop(1, 'rgba(0,0,0,0)'); c.fillStyle = g; c.beginPath(); c.arc(p.x, p.y, 11, 0, 7); c.fill(); c.restore();
  }
  function vis(u, cx, cy, vw, vh) { return u.x > cx - 80 && u.x < cx + vw + 80 && u.y > cy - 20 && u.y < cy + vh + 140; }
  const IMG = {};
  function img(n) { if (typeof PT_IMG_SRC === 'undefined' || !PT_IMG_SRC[n]) return null; if (!IMG[n]) { IMG[n] = new Image(); IMG[n].src = PT_IMG_SRC[n]; } return IMG[n].complete && IMG[n].naturalWidth ? IMG[n] : null; }
  function drawFaci(c, f, q) {
    const x = q.x, y = q.y, rs = regSt(R.ci); c.save(); c.textAlign = 'center'; c.font = '900 12px "PingFang TC","Noto Sans TC",sans-serif';
    const label = (t, col) => { c.lineWidth = 3; c.strokeStyle = 'rgba(0,0,0,.8)'; c.strokeText(t, x, y + 18); c.fillStyle = col; c.fillText(t, x, y + 18); };
    c.fillStyle = 'rgba(0,0,0,.4)'; c.beginPath(); c.ellipse(x, y + 2, 52, 14, 0, 0, 7); c.fill();
    const im = img(f.t);
    if (im) { // 老闆嘅蠟筆設施圖
      const w = 118, h = w * im.naturalHeight / im.naturalWidth, off = (f.t === 'station' && !rs.sta[f.z]) || (f.t === 'tea' && (R.tea[f.z] || 0) > R.t);
      if (off) c.filter = 'grayscale(.85) brightness(.6)';
      c.drawImage(im, x - w / 2, y - h + 8, w, h); c.filter = 'none';
      const L = { station:[rs.sta[f.z] ? `地鐵站・${f.z + 1}區` : '地鐵站（未開通）', rs.sta[f.z] ? '#9fe0b8' : '#aaa'], tea:['茶水間', '#ffd69a'], prison:['扣押室', '#d8c8c8'], overtime:['通宵加班房', '#bcd8ff'] }[f.t];
      label(L[0], L[1]); c.restore(); return;
    }
    if (f.t === 'station') { const on = rs.sta[f.z];
      c.fillStyle = '#1c1a22'; c.strokeStyle = '#0a090c'; c.lineWidth = 2; c.fillRect(x - 32, y - 30, 64, 30); c.strokeRect(x - 32, y - 30, 64, 30); c.fillStyle = '#0a090c'; c.fillRect(x - 18, y - 22, 36, 22);
      c.strokeStyle = '#3a3440'; c.beginPath(); c.moveTo(x - 22, y - 30); c.lineTo(x - 22, y - 62); c.stroke(); c.fillStyle = on ? '#3fa36a' : '#555'; c.beginPath(); c.arc(x - 22, y - 70, 12, 0, 7); c.fill(); c.fillStyle = '#fff'; c.font = '900 13px sans-serif'; c.fillText('陰', x - 22, y - 65);
      label(on ? `地鐵站・${f.z + 1}區` : '地鐵站（未開通）', on ? '#9fe0b8' : '#aaa'); }
    else if (f.t === 'tea') { const cd = (R.tea[f.z] || 0) > R.t;
      c.fillStyle = '#3a2e26'; c.strokeStyle = '#0d0a08'; c.lineWidth = 2; c.fillRect(x - 30, y - 34, 60, 34); c.strokeRect(x - 30, y - 34, 60, 34); c.fillStyle = '#2a201a'; c.beginPath(); c.moveTo(x - 36, y - 34); c.lineTo(x, y - 52); c.lineTo(x + 36, y - 34); c.closePath(); c.fill(); c.stroke();
      c.fillStyle = cd ? 'rgba(120,120,120,.5)' : 'rgba(255,214,140,.75)'; c.fillRect(x - 10, y - 26, 20, 14); if (!cd) { c.strokeStyle = 'rgba(255,255,255,.4)'; c.beginPath(); c.moveTo(x - 4, y - 56); c.quadraticCurveTo(x + 4, y - 64, x - 2, y - 72); c.stroke(); }
      label('茶水間', '#ffd69a'); }
    else if (f.t === 'prison') { c.strokeStyle = '#6a6460'; c.lineWidth = 3; c.strokeRect(x - 26, y - 44, 52, 44); for (let i = -2; i <= 2; i++) { c.beginPath(); c.moveTo(x + i * 10, y - 44); c.lineTo(x + i * 10, y); c.stroke(); } label('扣押室', '#d8c8c8'); }
    else if (f.t === 'overtime') { c.fillStyle = '#26222e'; c.strokeStyle = '#0a090c'; c.lineWidth = 2; c.fillRect(x - 34, y - 46, 68, 46); c.strokeRect(x - 34, y - 46, 68, 46); c.fillStyle = 'rgba(160,220,255,.55)'; c.fillRect(x - 26, y - 38, 22, 14); c.fillRect(x + 4, y - 38, 22, 14);
      c.fillStyle = '#e8dcc0'; c.beginPath(); c.arc(x, y - 58, 9, 0, 7); c.fill(); c.strokeStyle = '#222'; c.beginPath(); c.moveTo(x, y - 58); c.lineTo(x, y - 64); c.moveTo(x, y - 58); c.lineTo(x + 5, y - 58); c.stroke(); label('通宵加班房', '#bcd8ff'); }
    c.restore();
  }
  function drawUnit(c, u) {
    const dying = (u.hp <= 0 || u.fled) && !(u.down > 0), p = dying ? Math.min(1, (u.deadT || 0) / (u.fled ? 1.2 : 0.8)) : 0;
    const eo = q => 1 - Math.pow(1 - Math.min(1, Math.max(0, q)), 3);
    let pose = 'idle', pt = 0, ox = 0, oy = 0, rot = 0;
    const a = u.act, tg = a && a.tg;
    if (u.down > 0) { pose = 'down'; pt = 1; }
    else if (dying && !u.fled) { pose = 'die'; pt = p; }
    else if (a) {
      const dir = tg ? Math.sign(tg.x - u.x) || 1 : (u.flip ? -1 : 1), melee = u.rng < 60, Lg = (u.boss ? 16 : 12) * u.s * 1.65;
      if (a.cast || a.slam) { pose = 'windup'; pt = Math.min(1, a.t / a.dur); if (a.ph !== 'windup') { pose = 'strike'; pt = 1; } }
      else if (a.ph === 'windup') { pose = 'windup'; pt = a.t / a.dur; ox = -dir * 3 * eo(pt); }
      else if (a.ph === 'strike') { pose = 'strike'; pt = a.t / ATK.strike; ox = melee ? dir * Lg * eo(pt * 2) : -dir * 4; }
      else { pose = 'recover'; pt = a.t / ATK.recover; ox = melee ? dir * Lg * (1 - eo(pt)) : -dir * 4 * (1 - pt); }
    } else if (u.hurt > 0) { pose = 'hurt'; pt = 1 - u.hurt / 0.24; }
    else if (u.moving) pose = 'move';
    if (pose === 'idle' && !dying) { const tt = R.t + (u.x * 0.013); oy = -Math.abs(Math.sin(tt * 3.2)) * 1.6; }
    if (u.dash > 0) rot = (u.flip ? 0.18 : -0.18);
    const s = u.s * 1.65;
    const o = { t:R.t + (u.x % 7), walk:pose === 'move', pose, pt, flip:!!u.flip, enemy:u.side === 1, tamed:u.side === 0, untied:u.side === 0, rot,
      tdx:tg ? tg.x - u.x : (u.flip ? -40 : 40), tdy:tg ? tg.y - u.y : 0,
      alpha:u.fled ? Math.max(0, 0.6 - p * 0.6) : dying ? 1 - p : u.down > 0 ? 0.55 + 0.3 * Math.sin(R.t * 12) : 1 };
    const x = u.x + ox, y = u.y + oy;
    if (u.side === 0 && R.buff > 0 && u.hp > 0 && !dying) { const ai = fxImg('fx_aura'); if (ai) { c.save(); c.globalCompositeOperation = 'lighter'; c.globalAlpha = 0.35 + 0.15 * Math.sin(R.t * 8 + u.x); const W = 70 * s, H = W * ai.naturalHeight / ai.naturalWidth; c.drawImage(ai, u.x - W / 2, u.y - H * 0.92, W, H); c.restore(); } }
    if (a && (a.cast || a.slam) && a.ph === 'windup') { const ri = fxImg('fx_ring', u.side ? 150 : 0); if (ri) { const pp = Math.min(1, a.t / a.dur); c.save(); c.globalCompositeOperation = 'lighter'; c.globalAlpha = 0.5 + pp * 0.5; const W = (120 - 50 * pp) * s * (u.boss ? 1.4 : 1), H = W * ri.naturalHeight / ri.naturalWidth; c.drawImage(ri, u.x - W / 2, u.y - H / 2, W, H); c.restore(); } else Battle.drawCharge.call({ t:R.t }, c, x, y - 28 * s, s, a.t / a.dur, u.side ? '#ff9ac0' : '#9ff3ff', false); }
    try { ART.drawChar(c, u.k, x, y, s, o); if (u.flash > 0) { c.save(); c.globalCompositeOperation = 'lighter'; ART.drawChar(c, u.k, x, y, s, Object.assign({}, o, { alpha:o.alpha * u.flash * 0.8, shadow:false })); c.restore(); } }
    catch (e) { c.fillStyle = u.side ? '#a55' : '#5a5'; c.beginPath(); c.arc(x, y - 20, 12, 0, 7); c.fill(); }
    if (a && (a.cast || a.slam) && a.ph === 'windup' && !fxImg('fx_ring')) Battle.drawCharge.call({ t:R.t }, c, x, y - 28 * s, s, a.t / a.dur, u.side ? '#ff9ac0' : '#9ff3ff', true);
    if (dying) return;
    const top = u.y - (u.leader ? 70 : u.boss ? 88 : 78) * s - 2;
    if (u.down > 0) { c.save(); c.strokeStyle = '#ffd84a'; c.lineWidth = 3; c.beginPath(); c.arc(u.x, top - 6, 11, -Math.PI / 2, -Math.PI / 2 + Math.PI * 2 * (u.down / u.downMax)); c.stroke(); c.fillStyle = '#ffd84a'; c.font = '900 12px sans-serif'; c.textAlign = 'center'; c.fillText('?', u.x, top - 2); c.restore(); return; }
    const named = u.boss || u.elite || u.guard != null || (u.bryan && u.k === 'npc_rival') || u.otBoss;
    if (u.hp < u.maxhp || named || u.leader) {
      const bw = u.boss ? 62 : named ? 46 : u.leader ? 40 : u.role === 'troop' ? 20 : 28;
      c.fillStyle = 'rgba(0,0,0,.65)'; c.fillRect(u.x - bw / 2 - 1, top - 1, bw + 2, 5); c.fillStyle = u.side ? '#e84a5f' : u.leader ? '#ffd84a' : '#4ade80'; c.fillRect(u.x - bw / 2, top, bw * Math.max(0, u.hp / u.maxhp), 3);
      if (u.sk && u.side === 0 && !u.leader) { c.fillStyle = u.energy >= 100 ? '#ffd84a' : '#7dd3fc'; c.fillRect(u.x - bw / 2, top + 4, bw * Math.min(1, (u.energy || 0) / 100), 2); }
      if (u.role === 'crew' && u.g && (u.g.fat || 0) >= 70) { c.fillStyle = '#ff9a5a'; c.font = '800 10px sans-serif'; c.textAlign = 'center'; c.fillText('累', u.x + bw / 2 + 6, top + 5); }
    }
    if (named || u.leader) {
      c.save(); c.font = `900 ${u.boss ? 13 : 11}px "PingFang TC","Noto Sans TC",sans-serif`; c.textAlign = 'center'; c.lineWidth = 3; c.strokeStyle = 'rgba(0,0,0,.85)';
      const t = u.leader ? '阿福' : u.elite ? `釘子戶・${u.name}` : u.name, col = u.leader ? '#ffe9a0' : u.elite ? '#ffb0ff' : u.bryan ? '#ff9a9a' : '#ffd0d8';
      c.strokeText(t, u.x, top - 5); c.fillStyle = col; c.fillText(t, u.x, top - 5);
      if (u.guard != null && !u.awake && u.boss) { const req = CHAPTERS[R.ci].stages[u.guard].req; if (S.lv < req) { c.fillStyle = '#ff8a8a'; c.strokeText(`需主公 Lv${req}`, u.x, top - 19); c.fillText(`需主公 Lv${req}`, u.x, top - 19); } }
      c.restore();
    }
    if (u.side === 1 && phase(st().min) === 'work' && !u.provoked && u.guard == null && !u.bryan) { c.save(); c.font = '800 10px sans-serif'; c.fillStyle = 'rgba(200,220,255,.75)'; c.textAlign = 'center'; c.fillText('摸魚中 z', u.x, top - 5); c.restore(); }
  }
  function drawMini() {
    if (!mini) return; const m = mini.getContext('2d'), W = mini.width, H = mini.height, k = W / WW;
    m.clearRect(0, 0, W, H); m.fillStyle = 'rgba(8,6,12,.85)'; m.fillRect(0, 0, W, H);
    const cw = Math.ceil(WW / FOG); m.fillStyle = 'rgba(120,110,140,.45)';
    for (let i = 0; i < R.fog.length; i++) if (R.fog[i] === '1') m.fillRect((i % cw) * FOG * k, Math.floor(i / cw) * FOG * k, FOG * k + 0.5, FOG * k + 0.5);
    m.fillStyle = '#000'; for (let i = 0; i < 2; i++) { const y = CH * (i + 1) * k, g = GATES[i]; m.fillRect(0, y - 1, (g.x - GW / 2) * k, 2); m.fillRect((g.x + GW / 2) * k, y - 1, W, 2); if (!gateOpen(i)) { m.fillStyle = '#e84a5f'; m.fillRect((g.x - GW / 2) * k, y - 1.5, GW * k, 3); m.fillStyle = '#000'; } }
    const rs = regSt(R.ci);
    for (const f of FACI) { const q = faciPos(f); m.fillStyle = f.t === 'station' ? (rs.sta[f.z] ? '#3fa36a' : '#666') : f.t === 'tea' ? '#ffd69a' : f.t === 'prison' ? '#d8c8c8' : '#9cc8ff'; m.fillRect(q.x * k - 2, q.y * k - 2, 4, 4); }
    for (let si = 0; si < 3; si++) if (!S.cleared[sidOf(R.ci, si)]) { const q = guardPos(si); m.fillStyle = si === 2 ? '#ff4a6a' : '#ff9a5a'; m.beginPath(); m.arc(q.x * k, q.y * k, si === 2 ? 3.5 : 2.6, 0, 7); m.fill(); }
    if (R.bryan) { const b = R.bryan[0]; m.fillStyle = '#ff6a6a'; m.fillRect(b.x * k - 1.5, b.y * k - 1.5, 3, 3); }
    m.fillStyle = '#ffe9a0'; m.beginPath(); m.arc(R.L.x * k, R.L.y * k, 3, 0, 7); m.fill();
  }
  function hud() {
    if (!R) return; const p = st(), z = zoneAt(R.L.x, R.L.y), ph = PH[phase(p.min)], hh = Math.floor(p.min / 60), mm = Math.floor(p.min % 60);
    const a = $('#pt-reg'), b = $('#pt-zone'), c = $('#pt-clock'), d = $('#pt-ph'), r = $('#pt-res'); if (!a) return;
    a.textContent = `第${'一二三四五六'[R.ci]}區・${CHAPTERS[R.ci].name}`; b.textContent = `${z + 1}/12　${zoneName(R.ci, z)}`;
    c.textContent = `${String(hh).padStart(2, '0')}:${String(mm).padStart(2, '0')}`; d.textContent = ph.n; d.title = ph.d;
    const crew = R.units.filter(u => u.role === 'crew' && u.hp > 0).length, crewAll = R.units.filter(u => u.role === 'crew').length;
    r.innerHTML = `<span>冥幣 ${fmt(S.res.coins)}</span><span>壽包 ${fmt(S.res.buns)}</span>${Object.keys(FAC).map(f => `<span style="color:${FAC[f].col}">${FAC[f].mat} ${fmt(p.mats[f])}</span>`).join('')}<span>部門 ${crew}/${crewAll}</span>${R.streak > 4 ? `<span class="pt-str">連巡 ×${(1 + Math.min(1, R.streak * 0.01)).toFixed(2)}</span>` : ''}`;
    if (R.downs.length) { const v = R.downs[R.downs.length - 1], s = $('#pt-down .pd-t s'); if (s) s.style.width = Math.max(0, v.down / v.downMax * 100) + '%'; }
    const cdv = (id, cd, max) => { const b = $(id); if (!b) return; b.classList.toggle('cd', cd > 0); b.querySelector('i').style.height = (cd > 0 ? cd / max * 100 : 0) + '%'; };
    cdv('#pt-dash', R.dashCd || 0, 3.5); cdv('#pt-pie', R.pieCd || 0, 30);
    const ab = $('#pt-sk-auto'); if (ab) ab.textContent = st().autoSk === false ? '技能：手動' : '技能：自動';
    document.querySelectorAll('#pt-leads [data-lu]').forEach(b => { const u = R.units.find(x => x.gid === b.dataset.lu); if (!u) return; b.classList.toggle('dead', u.hp <= 0); b.classList.toggle('ready', u.hp > 0 && u.energy >= 100); b.querySelector('i').style.height = (u.hp > 0 ? Math.min(100, u.energy || 0) : 0) + '%'; });
  }

  return { open:openPrep, openPrep, close, get active() { return active; }, FAC, facOf, st, regionOpen, _R:() => R, _end:end, _gain:gain, _test:{ foe, onDown, resolveDown, signInfo, fxImg, img, telegraph } };
})();

// ===================== 裝備房 =====================
// 阿福、名鬼都可以戴；件件裝備可以隨時喺角色之間換（武器可互換）。
//   武器：戴嘅角色攻擊 +X%　衣服：戴嘅角色血 +X%，同派系組員血 +一半　員工證掛繩：同派系組員攻擊 +X%
// 加成經 GP（鬼力）帶去所有玩法；組員加成只喺巡陰計（戴住嘅角色要喺部門入面帶隊）。
const Gear = (() => {
  const SLOTS = { wea:'武器', arm:'衣服', acc:'掛繩' };
  const NAMES = {
    wea:[['尖嘴釘書機', '不鏽鋼飯盒', '午睡抱枕'], ['雷射筆', '外賣保溫袋', '人體工學椅背'], ['機械鍵盤', '保溫咖啡壺', '暖蛋寶'], ['碎紙機', '自助餐夾', '按摩槌'], ['投影遙控器', '火鍋長筷', 'U 型頸枕'], ['總裁鋼筆', '金飯碗', '躺平床墊']],
    arm:[['舊恤衫', '油漬圍裙', '珊瑚絨睡衣'], ['保安制服', '外賣制服', '酒店浴袍'], ['二手西裝', '廚師服', '毛毯斗篷'], ['即棄雨衣', '大胃王戰衣', '懶人睡袋'], ['公司風褸', '食評家背心', '連身睡衣'], ['總監西裝', '星級廚袍', '五星浴袍']],
    acc:[['實習生證'], ['正式員工證'], ['組長證'], ['主任證'], ['經理證'], ['總監證']],
  };
  const FK = ['yuan', 'chan', 'lan'];
  function st() { if (!S.gear) S.gear = { items:[], uid:1 }; return S.gear; }
  function nameOf(it) { const l = NAMES[it.slot][it.c]; return it.slot === 'acc' ? `${l[0]}・${Patrol.FAC[it.f].name}` : l[FK.indexOf(it.f)]; }
  function pct(it) { return Math.round((5 + 5 * it.c) * (1 + 0.15 * (it.lv - 1))); }
  function craftCost(c, f) { const k = c + 1, r = { coins:Math.round(150 * Math.pow(k, 1.7)), planks:Math.round(40 * Math.pow(k, 1.5)) }; return { r, mat:{ [f]:Math.round(12 * Math.pow(k, 1.4)) } }; }
  function upCost(it) { const k = it.c + 1; return { r:{ coins:Math.round(60 * k * it.lv), planks:Math.round(10 * k * it.lv) }, mat:{ [it.f]:Math.round(4 * k * it.lv) } }; }
  function canPayAll(c) { const m = Patrol.st().mats; return canPay(c.r) && Object.keys(c.mat).every(f => m[f] >= c.mat[f]); }
  function payAll(c) { pay(c.r); const m = Patrol.st().mats; for (const f in c.mat) m[f] -= c.mat[f]; }
  function costHTML(c) { const m = Patrol.st().mats; return costText(c.r) + '　' + Object.keys(c.mat).map(f => `<span class="${m[f] >= c.mat[f] ? '' : 'lack'}">${Patrol.FAC[f].mat} ${c.mat[f]}</span>`).join(''); }
  function held(g) { return g ? st().items.filter(it => it.who === g.id) : []; }
  function unitMul(g) { let atk = 1, hp = 1; for (const it of held(g)) { const p = pct(it) / 100; if (it.slot === 'wea') atk += p; else if (it.slot === 'arm') hp += p * 1.2; else atk += p * 0.3; } return { atk, hp }; }
  function gpMul(g) { const m = unitMul(g); return 1 + ((m.atk - 1) + (m.hp - 1)) / 2; }
  function crewBuff() { // 帶隊（阿福＋主管）身上嘅衣服／掛繩 → 同派系組員
    const out = { yuan:{ atk:1, hp:1 }, chan:{ atk:1, hp:1 }, lan:{ atk:1, hp:1 } };
    const ids = ['afu'].concat((S.pt && S.pt.lead) || S.team.filter(Boolean));
    for (const it of st().items) if (ids.includes(it.who)) { const p = pct(it) / 100; if (it.slot === 'acc') out[it.f].atk += p * 0.6; if (it.slot === 'arm') out[it.f].hp += p * 0.5; }
    return out;
  }
  function effText(it) { const p = pct(it), f = Patrol.FAC[it.f].name; return it.slot === 'wea' ? `攻擊 +${p}%` : it.slot === 'arm' ? `血 +${Math.round(p * 1.2)}%・${f}組員血 +${Math.round(p * 0.5)}%` : `${f}組員攻擊 +${Math.round(p * 0.6)}%・自己攻擊 +${Math.round(p * 0.3)}%`; }
  let back = null, tab = 'wea';
  function open(b) { if (b) back = b; render(); }
  function render() {
    const s = st(), m = Patrol.st().mats, who = S.ghosts.filter(g => g.q === '名' || g.q === '主');
    let h = `<p class="desc">用冥幣、棺材板和執念打造。武器、衣服、掛繩都可以隨時換給別的角色戴。加成會帶到所有玩法（鬼力）。</p>`;
    h += `<div class="pt-mats">${Object.keys(Patrol.FAC).map(f => `<span style="color:${Patrol.FAC[f].col}"><b>${Patrol.FAC[f].mat}</b> ${fmt(m[f])}</span>`).join('')}<span><b>棺材板</b> ${fmt(S.res.planks)}</span><span><b>冥幣</b> ${fmt(S.res.coins)}</span></div>`;
    h += `<div class="gr-tabs">${Object.keys(SLOTS).map(k => `<button class="btn sm ${tab === k ? 'gold' : ''}" data-tab="${k}">${SLOTS[k]}</button>`).join('')}</div>`;
    const mine = s.items.filter(it => it.slot === tab);
    h += `<div class="ch-h">我的${SLOTS[tab]}（${mine.length}）</div><div class="gr-list">`;
    for (const it of mine) {
      const w = ghostById(it.who), uc = upCost(it);
      h += `<div class="gr-it"><div class="gr-n"><b style="color:${Patrol.FAC[it.f].col}">${nameOf(it)}</b> <i>Lv${it.lv}</i><small>${effText(it)}</small><small>${w ? `佩戴：${w.name}` : '未戴'}</small></div>
        <div class="gr-b"><select data-who="${it.id}"><option value="">— 不戴 —</option>${who.map(g => `<option value="${g.id}" ${g.id === it.who ? 'selected' : ''}>${g.name}</option>`).join('')}</select>
        ${it.lv < 10 ? `<button class="btn sm gold" data-up="${it.id}" ${canPayAll(uc) ? '' : 'disabled'}>升級<small>${costHTML(uc)}</small></button>` : '<small>滿級</small>'}</div></div>`;
    }
    if (!mine.length) h += `<p class="desc">還沒有。在下面打造。</p>`;
    h += `</div><div class="ch-h">打造</div><div class="gr-list">`;
    CHAPTERS.forEach((ch, c) => {
      const open = Patrol.regionOpen(c);
      FK.forEach(f => {
        if (tab === 'acc' && false) return;
        const it = { slot:tab, c, f, lv:1 }, cc = craftCost(c, f);
        h += `<div class="gr-it ${open ? '' : 'dis'}"><div class="gr-n"><b style="color:${Patrol.FAC[f].col}">${nameOf(it)}</b> <i>第${'一二三四五六'[c]}區</i><small>${effText(it)}</small></div><div class="gr-b">${open ? `<button class="btn sm" data-mk="${c},${f}" ${canPayAll(cc) ? '' : 'disabled'}>打造<small>${costHTML(cc)}</small></button>` : '<small>巡到這區才解鎖</small>'}</div></div>`;
      });
    });
    h += `</div><button class="btn wide" id="gr-back">返回</button>`;
    UI.sheet('裝備房', h);
    const root = $('#sheet');
    root.querySelectorAll('[data-tab]').forEach(b => b.onclick = () => { tab = b.dataset.tab; keep(render); });
    root.querySelectorAll('[data-mk]').forEach(b => b.onclick = () => { const [c, f] = b.dataset.mk.split(','); const cc = craftCost(+c, f); if (!canPayAll(cc)) return; payAll(cc); const it = { id:'e' + (s.uid++), slot:tab, c:+c, f, lv:1, who:null }; s.items.push(it); Fx.toast(`打造了 <b>${nameOf(it)}</b>`); try { Sound.play('gong'); } catch (e) {} save(); keep(render); });
    root.querySelectorAll('[data-up]').forEach(b => b.onclick = () => { const it = s.items.find(x => x.id === b.dataset.up), uc = upCost(it); if (!canPayAll(uc) || it.lv >= 10) return; payAll(uc); it.lv++; Fx.toast(`${nameOf(it)} 升到 Lv${it.lv}`); save(); keep(render); });
    root.querySelectorAll('[data-who]').forEach(sel => sel.onchange = () => { const it = s.items.find(x => x.id === sel.dataset.who), id = sel.value || null; // 每個角色每個部位只戴一件
      if (id) s.items.forEach(x => { if (x !== it && x.who === id && x.slot === it.slot) x.who = null; }); it.who = id; save(); keep(render); });
    $('#gr-back').onclick = () => (back ? back() : UI.close());
  }
  function keep(f) { const b = $('#sheet .sh-body'), sc = b ? b.scrollTop : 0; f(); const b2 = $('#sheet .sh-body'); if (b2) b2.scrollTop = sc; }
  return { open, unitMul, gpMul, crewBuff, held, nameOf, pct, SLOTS };
})();
