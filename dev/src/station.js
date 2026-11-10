// ===================== 站崗嚇人・陽間地盤 =====================
// 鬼派去陽間地圖站崗：路人沿一條路行過，經過崗位時嗰隻鬼自動出手（用「怕咩」：怕 ×1.5、唔怕 ×0.5、崗位啱用 ×1.3、
// 上一個崗位嚇到失神 → 下一個用佢怕嘅另一種接上＝連嚇 ×1.5）。路人見慣度 1→10（10 封頂＝老江湖），頂得住就「穩定」。
// Bryan 夜冷村：喺同一條路搶崗位、補一腳搶功、騷擾我方站崗嘅鬼（氣勢跌到 0 就被趕走）。
// 模擬層（sim*）唔掂畫面，可以無畫面跑；實況畫面（Live）只係睇同點。
const Station = (() => {
  const has = (o) => typeof o !== 'undefined';
  const R = (a, b) => a + Math.random() * (b - a);
  const pick = (a) => a[Math.floor(Math.random() * a.length)];
  const W = { breath:'吹氣', light:'燈', cold:'凍', sound:'怪聲', paper:'紙', phone:'電話', face:'鬼臉', shadow:'黑影' };
  const TYPES = Object.keys(W);
  const TUNE = {
    every:8,            // 每幾秒一個路人（實況同放置一樣）
    hp0:60, hpLv:15,    // 路人膽量＝hp0＋見慣度×hpLv
    habitUp:0.03,       // 每個撐到盡頭嘅路人，見慣度額外 +
    habitSeen:0.004,    // 每個路人（見得多就慣）：全部嚇破膽都要約 5 小時先到 10
    stableRatio:0.70, stableHours:24, failRatio:0.40,
    morale:100, harass:4,   // 氣勢；每分鐘被騷擾扣幾多
    raidMin:25, raidMax:45, // 夜冷村每幾分鐘派一隻鬼嚟
    bryanH:6,               // Bryan 親自站崗：每幾小時一次
    offlineCap:8,           // 離線最多補算幾小時
  };

  // ---------- 地圖 ----------
  // x：辦公室全景圖（12168 寬）嘅像素；路人由右（茶水間）行去左（電梯）落班
  const MAPS = [
    { id:'office', name:'舊公司・二十三樓', short:'舊公司', bg:'bg_office_pano', seg:[3232, 7628], walkY:0.80, dir:-1, need:'ch1_end',
      desc:'加班仔收工、IT 值夜、阿姨倒垃圾，全部經茶水間、工位走道行去電梯。',
      posts:[ { x:6890, name:'茶水間', fit:'cold' }, { x:6300, name:'影印機', fit:'paper' }, { x:5300, name:'工位走道', fit:'light' }, { x:3700, name:'電梯口', fit:'sound' } ],
      people:[
        { spr:'npc_ken', name:'加班仔', weak:['phone', 'face', 'paper'], imm:['light', 'cold'] },
        { spr:'npc_it', name:'IT 值夜', weak:['phone', 'sound', 'shadow'], imm:['light', 'paper'] },
        { spr:'npc_auntie', name:'清潔阿姨', weak:['face', 'shadow', 'breath'], imm:['sound', 'cold'] },
        { spr:'npc_mis', name:'前台秘書', weak:['face', 'cold', 'shadow'], imm:['phone', 'paper'] },
        { spr:'npc_boss', name:'老闆', weak:['phone', 'paper', 'breath'], imm:['face', 'shadow'] },
      ] },
    { id:'flat', name:'組屋走廊', short:'組屋', bg:'st_flat', soon:true, desc:'夜歸上班族、倒垃圾的阿姨、打遊戲的學生。路人膽子小，入門地圖。', posts:[], people:[] },
    { id:'bus', name:'巴士站', short:'巴士站', bg:'st_bus', soon:true, desc:'等末班車的人會停很久：同一個崗位可以重複嚇同一個人。', posts:[], people:[] },
  ];
  const mapOf = (id) => MAPS.find(m => m.id === id);
  const open = (m) => !m.soon && (!m.need || (has(S) && S.seen && S.seen[m.need])) && (!m.bg || (has(SPR) && SPR[m.bg]));

  // ---------- 夜冷村 ----------
  const RIVALS = ['youhun', 'egui', 'xiaogui', 'zombie', 'zhiren', 'shuigui', 'niutou', 'mamian'];
  const RNAME = { youhun:'遊魂', egui:'餓鬼', xiaogui:'小鬼', zombie:'殭屍', zhiren:'紙人', shuigui:'水鬼', niutou:'牛頭', mamian:'馬面', bryan:'Bryan' };
  const BRYAN_LINES = ['Bryan：「呢個客係我嚇走嘅，你哋唔好亂講。」', 'Bryan：「你嗰度啲人怕咩，我全部抄低咗。多謝分享。」', 'Bryan：「籃球拍一下，成條走廊都靜晒。學下啦。」', 'Bryan：「功勞唔使分，我攞晒就得。」'];
  const D = (yue, zh) => { if (has(LANG)) LANG.add({ [yue]:zh }); return yue; };
  BRYAN_LINES.forEach((l, i) => D(l, ['Bryan：「這個客人是我嚇走的，你們不要亂講。」', 'Bryan：「你那邊的人怕什麼，我全部抄下來了。謝謝分享。」', 'Bryan：「籃球拍一下，整條走廊都安靜了。學一下吧。」', 'Bryan：「功勞不用分，我全拿就行。」'][i]));
  const L = (s) => (typeof window !== 'undefined' && window.L) ? window.L(s) : s;

  // ---------- 傳說 ----------
  const LEGEND = { afu:'半夜亮著燈的空工位', tianhua:'天花板上的女人', eguiking:'收攤後的開飯鈴', laojiang:'走廊一跳一跳的影子', xiaozhi:'門縫下的紙人', pontianak:'窗外的笑聲', penanggal:'窗外飄過的頭', toyol:'錢包少了錢' };
  const LEG_N = [30, 100, 300], LEG_T = ['', '傳聞', '都市傳說', '經典'];
  const legendName = (k, g) => LEGEND[k] || `${g ? g.name : k}的怪談`;

  // ---------- 狀態 ----------
  function st() {
    if (!S.station) S.station = { maps:{}, t:Date.now(), log:[] };
    const s = S.station; s.maps = s.maps || {}; s.log = s.log || [];
    for (const m of MAPS) if (!s.maps[m.id]) s.maps[m.id] = { posts:m.posts.map(() => null), habit:1, hist:[], used:{}, stableAt:0, stable:false, enemy:m.posts.map(() => null), morale:{}, leg:{}, nextRaid:0, nextBryan:0, bank:0, cd:{}, boost:{} };
    for (const m of MAPS) { const ms = s.maps[m.id]; while (ms.posts.length < m.posts.length) ms.posts.push(null); while (ms.enemy.length < m.posts.length) ms.enemy.push(null); }
    return s;
  }
  const ms = (id) => st().maps[id];
  const ghost = (id) => S.ghosts.find(g => g.id === id);
  function typesOf(k) { if (has(Rework)) { const t = Rework.typesOf(k); if (t) return t; } const g = has(SCARE_GHOSTS) && SCARE_GHOSTS[k]; return g ? (g.types || [g.type]) : [TYPES[(k.length * 7) % 8]]; }
  function drillLv(k) { return has(Rework) ? Rework.drillLv(k) : 1; }
  function rivalType(k) { if (k === 'bryan') return 'sound'; const f = has(Rework) ? Rework.fearOf(k) : null; return f ? f.i[0] : 'shadow'; }
  // 鬼嘅站崗威力
  function power(g) { const lv = has(F) ? F.glv(g) : 1; return 34 * (1 + 0.24 * (drillLv(g.k) - 1)) * (1 + lv / 55); }
  function rivalPower(k, m) { return k === 'bryan' ? 70 : 30 + m.habit * 2.2; }
  const share = (m) => { const h = m.hist; if (!h.length) return { me:0, en:0, n:0 }; let a = 0, b = 0; for (const x of h) { if (x === 1) a++; else if (x === 2) b++; } return { me:a / h.length, en:b / h.length, n:h.length }; };
  const brokeRatio = (m) => { const s = share(m); return s.me + s.en; };
  function status(m) { const s = share(m); if (s.n < 10) return { k:'new', t:'剛開始' }; if (s.me >= 0.6) return { k:'own', t:'佔領' }; if (s.me >= 0.4) return { k:'war', t:'爭奪中' }; return { k:'lost', t:'失守' }; }
  function adapt(m, type) { const u = m.used, tot = Object.values(u).reduce((a, b) => a + b, 0) || 1, f = (u[type] || 0) / tot; return 1 - Math.max(0, Math.min(0.4, (f - 0.34) * 0.6)); }
  function legLv(m, gid) { const n = m.leg[gid] || 0; return n >= LEG_N[2] ? 3 : n >= LEG_N[1] ? 2 : n >= LEG_N[0] ? 1 : 0; }

  // 生一個路人
  function makePerson(def, m) {
    const p = def.people[Math.floor(Math.random() * def.people.length)], hb = m.habit;
    let weak = p.weak.slice().sort(() => Math.random() - 0.5);
    const nWeak = hb < 4 ? 2 : hb < 7 ? (Math.random() < 0.5 ? 2 : 1) : 1;
    weak = weak.slice(0, nWeak);
    const tough = hb >= 10 ? 3 : hb >= 7 ? 2 : 1; // 要幾連嚇先破
    return { def:p, spr:p.spr, name:p.name, weak, imm:p.imm, hp:TUNE.hp0 + Math.min(10, hb) * TUNE.hpLv, fear:0, dazed:null, hits:0, tough, done:false, by:0, x:0, i:0, t:0, react:0, say:null };
  }
  // 一個崗位對一個路人出手：返回 { dmg, combo, tag }
  function strike(def, m, pi, P, who) {
    const post = def.posts[pi];
    let type, pw, g = null, legend = 0;
    if (who === 1) { g = ghost(m.posts[pi]); if (!g) return null; type = typesOf(g.k)[0]; pw = power(g); legend = legLv(m, g.id); }
    else { const e = m.enemy[pi]; if (!e) return null; type = rivalType(e.k); pw = rivalPower(e.k, m); }
    let mul = 1, tag = '';
    if (P.imm.includes(type) && !(legend >= 3)) { mul *= 0.5; tag = '不怕'; }
    else if (P.weak.includes(type) || legend >= 3) { mul *= 1.5; tag = '怕'; }
    if (post.fit === type) mul *= 1.3;
    let combo = false;
    if (P.dazed && P.dazed !== type && (!P.imm.includes(type) || legend >= 3)) { mul *= 1.5; combo = true; } // 失神後換一種（佢唔係唔怕嘅）嚇法接上＝連嚇
    mul *= adapt(m, type);
    if (P.tough > 1 && P.hits === 0) mul *= 0.5; // 不信邪：第一下打折
    if (who === 1 && m.boost[pi]) { mul *= 2.5; m.boost[pi] = 0; tag = '大招'; }
    if (who === 1 && legend >= 1) mul *= 1 + 0.08 * legend;
    if (who === 2 && m.stable) mul *= 0.8; // 穩定地盤：路人對我方有印象
    const dmg = pw * mul * R(0.85, 1.15);
    m.used[type] = (m.used[type] || 0) * 0.98 + 1;
    return { dmg, combo, tag, type, g };
  }
  // 路人經過第 pi 個崗位（實況同放置共用）
  function passPost(def, m, pi, P) {
    const res = [];
    for (const who of [2, 1]) { // 兩邊都站咗：夜冷村搶先（佢哋鍾意搶）
      if (P.done) break;
      const r = strike(def, m, pi, P, who); if (!r) continue;
      P.fear += r.dmg; P.hits++; if (r.combo) P.combos = (P.combos || 0) + 1;
      const broke = P.fear >= P.hp && (P.tough <= 1 || (P.combos || 0) >= P.tough - 1);
      if (P.fear >= P.hp * 0.5) P.dazed = r.type;
      res.push({ who, ...r, broke });
      if (broke) { P.done = true; P.by = who; }
    }
    return res;
  }
  function finish(def, m, P) {
    m.hist.push(P.by || 0); if (m.hist.length > 100) m.hist.shift();
    // 見慣度：見得多就慣（每個路人都加少少），撐到盡頭冇事嘅加得多；有傳說嘅地圖慢 20%
    const slow = Object.values(m.leg).some((n) => n >= LEG_N[0]) ? 0.8 : 1;
    m.habit = Math.min(10, m.habit + (TUNE.habitSeen + (P.by ? 0 : TUNE.habitUp)) * slow);
    if (!P.by) return;
    if (P.by === 1) {
      const pts = 1 + m.habit * 0.3; m.bank += pts;
      const gid = m.posts[P.atPost]; if (gid != null) m.leg[gid] = (m.leg[gid] || 0) + 1;
    }
  }
  // 放置：一個路人即時行完
  function simOne(def, m) {
    const P = makePerson(def, m), order = def.posts.map((_, i) => i);
    for (const i of order) { if (P.done) break; const res = passPost(def, m, i, P); if (P.done) P.atPost = i; }
    finish(def, m, P); return P;
  }
  // 夜冷村行動（每次 tick 用實際分鐘數）
  function rivalStep(def, m, mins) {
    const now = Date.now(), heldN = MAPS.filter(d => open(d) && status(ms(d.id)).k === 'own').length;
    if (!m.nextRaid) m.nextRaid = now + R(TUNE.raidMin, TUNE.raidMax) * 60000 / (1 + heldN * 0.3);
    if (now >= m.nextRaid) {
      m.nextRaid = now + R(TUNE.raidMin, TUNE.raidMax) * 60000 / (1 + heldN * 0.3);
      const empty = m.enemy.map((e, i) => (!e && m.posts[i] == null) ? i : -1).filter(i => i >= 0);
      const mine = m.enemy.map((e, i) => (!e && m.posts[i] != null) ? i : -1).filter(i => i >= 0);
      const front = (a) => a.sort((x, y) => x - y)[0]; // 路線前段最搶手
      const i = empty.length ? front(empty) : mine.length ? pick(mine) : -1;
      if (i >= 0) { m.enemy[i] = { k:pick(RIVALS), hp:100, at:now }; log(`夜冷村派了${RNAME[m.enemy[i].k]}到<b>${def.short}・${def.posts[i].name}</b>${m.posts[i] != null ? '，正在騷擾我方的鬼' : ''}`); }
    }
    if (!m.nextBryan) m.nextBryan = now + TUNE.bryanH * 3600000 * R(0.6, 1.2);
    if (now >= m.nextBryan && status(m).k !== 'new') {
      m.nextBryan = now + TUNE.bryanH * 3600000 * R(0.8, 1.3);
      const free = m.enemy.map((e, i) => !e ? i : -1).filter(i => i >= 0); const i = free.length ? free[0] : 0;
      m.enemy[i] = { k:'bryan', hp:220, at:now }; log(`<b>Bryan 親自站崗</b>：${def.short}・${def.posts[i].name}。${L(pick(BRYAN_LINES))}`);
    }
    // 騷擾：敵鬼同我方鬼同一個崗位 → 扣氣勢；有支援（兩隻）就反過來趕佢
    m.enemy.forEach((e, i) => {
      if (!e || m.posts[i] == null) return; const gid = m.posts[i];
      const mor = (m.morale[gid] == null ? TUNE.morale : m.morale[gid]) - TUNE.harass * mins * (e.k === 'bryan' ? 2 : 1);
      m.morale[gid] = Math.max(0, mor);
      if (m.morale[gid] <= 0) { const g = ghost(gid); m.posts[i] = null; if (g) { g.post = null; g.tiredUntil = now + 30 * 60000; } m.morale[gid] = TUNE.morale; log(`<b>${g ? g.name : '我方的鬼'}</b>在${def.short}・${def.posts[i].name}被${RNAME[e.k]}趕走了，崗位被搶。`); }
    });
    // 冇人騷擾嘅鬼慢慢回氣
    m.posts.forEach((gid, i) => { if (gid != null && !m.enemy[i]) m.morale[gid] = Math.min(TUNE.morale, (m.morale[gid] == null ? TUNE.morale : m.morale[gid]) + 6 * mins); });
  }
  function log(html) { const s = st(); s.log.unshift({ t:Date.now(), h:html }); if (s.log.length > 30) s.log.length = 30; if (has(Fx) && !Live.on && !Live._quiet) try { Fx.toast(html); } catch (e) {} }
  // 穩定判定
  function stableStep(def, m) {
    const s = share(m), ok = m.habit >= 10 && s.n >= 50 && s.me >= TUNE.stableRatio;
    if (ok) { if (!m.stableAt) m.stableAt = Date.now(); if (!m.stable && Date.now() - m.stableAt >= TUNE.stableHours * 3600000) { m.stable = true; log(`<b>${def.name}</b> 地盤穩定了！見慣度封頂也頂得住，之後固定產出，離線照算。`); } }
    else { m.stableAt = 0; if (m.stable && s.me < TUNE.failRatio) { m.stable = false; log(`<b>${def.name}</b> 撐不住，不再穩定。`); } }
  }
  // 收益：每 40 分換 1 點合約 KPI，站崗的鬼加存在感
  function payStep(def, m) {
    while (m.bank >= 40) {
      m.bank -= 40;
      if (S.contract && S.contract.state === 'active') S.contract.kpi += 1;
      if (has(Presence)) m.posts.forEach(gid => { const g = gid != null && ghost(gid); if (g) Presence.add(g, 1.5); });
      st().earned = (st().earned || 0) + 1;
    }
  }
  // 傳說升級提示
  function legendStep(def, m) {
    m.legSeen = m.legSeen || {};
    for (const gid in m.leg) { const lv = legLv(m, gid); if (lv > (m.legSeen[gid] || 0)) { m.legSeen[gid] = lv; const g = ghost(+gid) || ghost(gid); if (g) log(`<b>${g.name}</b> 在${def.short}的怪談升級為「${LEG_T[lv]}」：${legendName(g.k, g)}`); } }
  }
  // 主 tick：實際經過時間 → 放置路人（實況中嗰張地圖由 Live 逐個行）
  // 鬼被村裡派咗去幹活（或者被趕走）：崗位清返
  function validate() { for (const d of MAPS) { const m = ms(d.id); m.posts.forEach((gid, i) => { if (gid == null) return; const g = ghost(gid); if (!g || g.post !== 'station') m.posts[i] = null; }); } }
  function tick() {
    if (!has(S) || !S.ghosts) return; const s = st(), now = Date.now(); validate();
    let dt = Math.max(0, Math.min(TUNE.offlineCap * 3600, (now - (s.t || now)) / 1000)); s.t = now;
    // 離線補算：超過 10 分鐘就出一份「你唔喺度嗰陣」報告
    const rep = dt > 600 ? { mins:Math.round(dt / 60), n:0, me:0, en:0, kpi0:s.earned || 0, log0:s.log.length ? s.log[0].t : 0 } : null;
    if (rep) Live._quiet = true;
    for (const def of MAPS) {
      if (!open(def)) continue; const m = ms(def.id);
      const mine = m.posts.some(x => x != null), anyone = mine || m.enemy.some(Boolean);
      if (anyone && !(Live.on && Live.def === def)) {
        m.acc = (m.acc || 0) + dt;
        while (m.acc >= TUNE.every) { m.acc -= TUNE.every; const P = simOne(def, m); if (rep) { rep.n++; if (P.by === 1) rep.me++; else if (P.by === 2) rep.en++; } }
      }
      if (mine || m.enemy.some(Boolean)) rivalStep(def, m, dt / 60);
      stableStep(def, m); payStep(def, m); legendStep(def, m);
    }
    if (rep) { Live._quiet = false; if (rep.n) { rep.kpi = (s.earned || 0) - rep.kpi0; rep.events = s.log.filter(x => x.t > rep.log0).slice(0, 6).map(x => x.h); s.report = rep; } }
  }

  // ---------- 派鬼 ----------
  function assign(mapId, pi, gid) {
    const def = mapOf(mapId), m = ms(mapId), old = m.posts[pi];
    if (old != null) { const og = ghost(old); if (og && og.post === 'station') og.post = null; }
    if (gid == null) { m.posts[pi] = null; return; }
    const g = ghost(gid); if (!g) return;
    // 由別處調過嚟：先離開原本崗位
    for (const d of MAPS) { const mm = ms(d.id); mm.posts.forEach((x, i) => { if (x === gid) mm.posts[i] = null; }); }
    g.post = 'station'; m.posts[pi] = gid; if (m.morale[gid] == null) m.morale[gid] = TUNE.morale;
    if (m.enemy[pi] && m.enemy[pi].k !== 'bryan') { /* 有鬼頂住：敵鬼仍然在，要打走 */ }
  }
  function freeGhosts() { const now = Date.now(); return S.ghosts.filter(g => g.k !== 'afu' && !g.post && !(g.tiredUntil > now)); }
  // 驅趕敵鬼（實況點佢、或者面板「出手」）：用我方同崗位或最近崗位嘅鬼嘅嚇法打佢嘅怕
  function hitRival(mapId, pi) {
    const def = mapOf(mapId), m = ms(mapId), e = m.enemy[pi]; if (!e) return null;
    const now = Date.now(); if ((m.hitCd || 0) > now) return { msg:'喘口氣……', cd:true }; m.hitCd = now + 1400;
    let gi = m.posts[pi]; if (gi == null) { const near = m.posts.map((x, i) => x != null ? i : -1).filter(i => i >= 0).sort((a, b) => Math.abs(a - pi) - Math.abs(b - pi)); gi = near.length ? m.posts[near[0]] : null; }
    const g = gi != null ? ghost(gi) : null; if (!g) return { msg:'這張地圖沒有我方的鬼可以出手' };
    const type = typesOf(g.k)[0], f = e.k === 'bryan' ? { w:['light', 'face'], i:['sound'] } : (has(Rework) ? Rework.fearOf(e.k) : { w:[], i:[] });
    let mul = f.w.includes(type) ? 1.6 : f.i.includes(type) ? 0.4 : 1, tag = f.w.includes(type) ? '怕' : f.i.includes(type) ? '不怕' : '';
    const dmg = Math.round(power(g) * 0.55 * mul * R(0.85, 1.15)); e.hp -= dmg;
    let gone = false; if (e.hp <= 0) { gone = true; m.enemy[pi] = null; log(`把${RNAME[e.k]}從${def.short}・${def.posts[pi].name}趕走了！`); if (e.k === 'bryan' && S.contract && S.contract.state === 'active') S.contract.kpi += 3; }
    return { dmg, tag, gone, g, type };
  }
  function boost(mapId, pi) { const m = ms(mapId), now = Date.now(); if ((m.cd[pi] || 0) > now) return Math.ceil((m.cd[pi] - now) / 1000); m.boost[pi] = 1; m.cd[pi] = now + 20000; return 0; }

  // ---------- 面板 ----------
  const pct = (x) => Math.round(x * 100) + '%';
  function mapCard(def) {
    if (!open(def)) return `<div class="stn-card soon"><div class="stn-h"><b>${def.name}</b><em>${def.soon ? '即將開放' : '未解鎖'}</em></div><small>${def.desc}</small></div>`;
    const m = ms(def.id), s = share(m), sta = status(m), stbl = m.stable ? '<em class="stn-stable">地盤穩定</em>' : '';
    const stProg = m.stable ? '' : m.stableAt ? `穩定倒數 ${Math.max(0, Math.ceil((TUNE.stableHours * 3600000 - (Date.now() - m.stableAt)) / 3600000))} 小時` : m.habit >= 10 ? `嚇破膽要 ≥${pct(TUNE.stableRatio)} 才開始計穩定` : `見慣度到 10 才能穩定`;
    let h = `<div class="stn-card"><div class="stn-h"><b>${def.name}</b><em class="stn-${sta.k}">${sta.t}</em>${stbl}</div>`;
    h += `<div class="stn-bar"><i class="me" style="width:${pct(s.me)}"></i><i class="en" style="width:${pct(s.en)}"></i></div><small class="stn-sub">我方 ${pct(s.me)}　夜冷村 ${pct(s.en)}　沒嚇到 ${pct(Math.max(0, 1 - s.me - s.en))}（最近 ${s.n} 個路人）</small>`;
    h += `<small class="stn-sub">見慣度 <b>${m.habit.toFixed(1)}</b> / 10　${stProg}</small><div class="stn-posts">`;
    def.posts.forEach((p, i) => {
      const g = m.posts[i] != null ? ghost(m.posts[i]) : null, e = m.enemy[i], mor = g ? Math.round(m.morale[g.id] == null ? 100 : m.morale[g.id]) : 0, lv = g ? legLv(m, g.id) : 0;
      h += `<div class="stn-post ${e ? 'raid' : ''}"><div class="stn-pn">${i + 1}. ${p.name}<small>適合：${W[p.fit]}</small></div>`;
      h += g ? `<div class="stn-g"><canvas data-por="${g.k}"></canvas><span><b>${g.name}</b><small>${typesOf(g.k).map(t => W[t]).join('／')}　氣勢 ${mor}${lv ? `　<i class="stn-leg">${LEG_T[lv]}</i>` : ''}</small></span></div>` : `<div class="stn-g empty">空崗</div>`;
      if (e) h += `<div class="stn-en">⚑ ${RNAME[e.k]}（${W[rivalType(e.k)]}）${g ? '騷擾中' : '佔了這個崗位'}</div>`;
      h += `<div class="stn-btns"><button class="btn sm" data-st-as="${def.id}:${i}">${g ? '換鬼' : '派鬼'}</button>${g ? `<button class="btn sm ghost" data-st-un="${def.id}:${i}">撤回</button>` : ''}${e ? `<button class="btn sm red" data-st-hit="${def.id}:${i}">出手驅趕</button>` : ''}</div></div>`;
    });
    h += `</div><div class="stn-acts"><button class="btn gold" data-st-live="${def.id}">看實況</button></div></div>`;
    return h;
  }
  function panelHTML() {
    const s = st();
    let h = '';
    if (s.report) { const r = s.report; h += `<div class="stn-report"><b>你不在的 ${r.mins >= 60 ? Math.floor(r.mins / 60) + ' 小時' : ''}${r.mins % 60 ? (r.mins % 60) + ' 分鐘' : ''}裡</b><p>經過 ${r.n} 個路人：我方嚇破膽 ${r.me} 個，夜冷村搶走 ${r.en} 個。合約 KPI +${r.kpi || 0}。</p>${(r.events || []).map(x => `<p class="ev">${x}</p>`).join('')}</div>`; s.report = null; }
    h += `<div class="stn-top"><p>派鬼到陽間各張地圖站崗，嚇路過的人。路人會越來越難嚇，但見慣度最高 10；在 10 也頂得住、而且連續 ${TUNE.stableHours} 小時嚇破膽 ≥${pct(TUNE.stableRatio)}，地盤就穩定。夜冷村的 Bryan 會來搶崗位、搶功、騷擾你的鬼。</p><small>站崗的鬼不能同時在村裡幹活。站崗累積的業績已換成合約 KPI <b>${s.earned || 0}</b> 點。</small></div>`;
    h += MAPS.map(mapCard).join('');
    if (s.log.length) h += `<div class="stn-log"><b>最近發生</b>${s.log.slice(0, 8).map(x => `<p>${x.h}</p>`).join('')}</div>`;
    return h;
  }
  function pickHTML(mapId, pi) {
    const def = mapOf(mapId), p = def.posts[pi], list = freeGhosts();
    const cur = ms(mapId).posts[pi];
    let h = `<p class="desc">派一隻鬼到 <b>${def.short}・${p.name}</b>。這個崗位適合「${W[p.fit]}」。路人：${def.people.map(x => x.name).join('、')}。</p>`;
    h += `<div class="stn-pick">` + list.map(g => { const ts = typesOf(g.k), fit = ts.includes(p.fit); return `<div class="gi" data-st-pick="${g.id}"><canvas data-por="${g.k}"></canvas><div><b>${g.name}</b> <i class="q q${g.q}">${g.q}</i><small>嚇法：${ts.map(t => W[t]).join('／')}${fit ? '　<em class="stn-fit">啱這個崗位</em>' : ''}　嚇功 Lv${drillLv(g.k)}　威力 ${Math.round(power(g))}</small></div></div>`; }).join('') + `</div>`;
    if (!list.length) h += `<p class="desc">沒有空閒的鬼。先把村裡幹活的鬼撤下來，或等被趕走的鬼休息好。</p>`;
    h += `<button class="btn" data-st-back="1">返回</button>`;
    return h;
  }
  function openPanel() {
    tick();
    const render = () => panelHTML();
    UI.sheet('陽間地盤・站崗', render(), () => { const b = $('#sheet .sh-body'); if (b && !b.dataset.picking) { b.innerHTML = render(); bind(); drawPors(); } });
    bind(); drawPors();
  }
  function drawPors() { try { paintPortraits($('#sheet')); } catch (e) {} }
  function bind() {
    const b = $('#sheet .sh-body'); if (!b) return; delete b.dataset.picking;
    b.querySelectorAll('[data-st-as]').forEach(x => x.onclick = () => { const [id, i] = x.dataset.stAs.split(':'); b.dataset.picking = 1; b.innerHTML = pickHTML(id, +i); drawPors();
      b.querySelectorAll('[data-st-pick]').forEach(y => y.onclick = () => { assign(id, +i, +y.dataset.stPick || y.dataset.stPick); Sound.play && Sound.play('click'); openPanel(); });
      b.querySelector('[data-st-back]').onclick = () => openPanel(); });
    b.querySelectorAll('[data-st-un]').forEach(x => x.onclick = () => { const [id, i] = x.dataset.stUn.split(':'); assign(id, +i, null); openPanel(); });
    b.querySelectorAll('[data-st-hit]').forEach(x => x.onclick = () => { const [id, i] = x.dataset.stHit.split(':'); const r = hitRival(id, +i); if (r && r.msg) Fx.toast(r.msg); else if (r) Fx.toast(`${r.g.name}出手（${W[r.type]}）${r.tag ? `，對方${r.tag}` : ''}：−${r.dmg}${r.gone ? '，趕走了！' : ''}`); openPanel(); });
    b.querySelectorAll('[data-st-live]').forEach(x => x.onclick = () => { UI.close(); Live.open(x.dataset.stLive); });
  }
  function entryHTML() {
    const n = MAPS.filter(open).length; if (!n) return '';
    const s = st(), own = MAPS.filter(d => open(d) && status(ms(d.id)).k === 'own').length, raid = MAPS.some(d => open(d) && ms(d.id).enemy.some(Boolean));
    return `<div class="sc-entry stn-entry"><div><b>陽間地盤・站崗</b><small>佔領 ${own} 張地圖${raid ? '　<em class="stn-alert">⚑ 夜冷村在搶</em>' : ''}　派鬼站崗嚇路人</small></div><button class="btn gold" id="stn-open">打開</button></div>`;
  }

  // ---------- 實況畫面 ----------
  const Live = {
    on:false, def:null, cv:null, ctx:null, camX:0, last:0, walkers:[], fx:[], spawnAcc:0, raf:0,
    open(id) {
      const def = mapOf(id); if (!def || !open(def)) return; tick();
      this.def = def; this.on = true; this.walkers = []; this.fx = []; this.spawnAcc = TUNE.every - 1.5; this.t = 0;
      let el = $('#stn-live'); if (!el) { el = document.createElement('div'); el.id = 'stn-live'; document.body.appendChild(el); }
      el.innerHTML = `<canvas id="stn-cv"></canvas><div class="stn-hud"><button class="btn sm" id="stn-x">返回</button><div class="stn-hh"><b>${def.name}</b><span id="stn-info"></span></div></div><div class="stn-board" id="stn-board"></div><div class="stn-tip" id="stn-tip">點站崗的鬼放大招（下一個路人 ×2.5，冷卻 20 秒）。點夜冷村的鬼出手驅趕。左右拖動看整條路。</div>`;
      el.classList.add('on'); this.cv = $('#stn-cv'); this.ctx = this.cv.getContext('2d');
      this.resize(); this.camX = this.maxCam(); // 路人由右邊行入
      $('#stn-x').onclick = () => this.close();
      this.bindPan(); this.last = performance.now(); cancelAnimationFrame(this.raf); this.raf = requestAnimationFrame((n) => this.frame(n));
      if (has(Sound) && Sound.setMode) try { Sound.setMode('scare'); } catch (e) {}
    },
    close() { this.on = false; cancelAnimationFrame(this.raf); const el = $('#stn-live'); if (el) el.classList.remove('on'); st().t = Date.now(); if (has(Sound) && Sound.setMode) try { Sound.setMode('village'); } catch (e) {} openPanel(); },
    resize() { const dpr = Math.min(2, window.devicePixelRatio || 1), r = this.cv.getBoundingClientRect(); this.W = r.width || innerWidth; this.H = r.height || innerHeight; this.cv.width = Math.round(this.W * dpr); this.cv.height = Math.round(this.H * dpr); this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0); this.dpr = dpr; },
    // 背景：底部對齊，高度填滿畫面
    img() { if (this.def.id === 'office' && has(OFFMAP) && OFFMAP.pano) { const c = OFFMAP.pano(); if (c) return c; } return SPR[this.def.bg]; },
    // 竪屏：背景縮細放中間偏下（上面留位俾 HUD 同夜空），一屏睇得到成段路
    bgH() { return Math.min(this.H * 0.60, this.W * 1.25); },
    top() { return Math.max(this.H * 0.16, this.H - this.bgH() - this.H * 0.17); },
    sc() { const img = this.img(); return this.bgH() / img.height; },
    maxCam() { const [a, b] = this.def.seg; return Math.max(0, (b - a) * this.sc() - this.W); },
    sx(px) { return (px - this.def.seg[0]) * this.sc() - this.camX; },
    personH() { return this.bgH() * 0.40; },
    bindPan() {
      const cv = this.cv; let d = null;
      cv.onpointerdown = (e) => { d = { x0:e.clientX, c0:this.camX, moved:false }; try { cv.setPointerCapture(e.pointerId); } catch (_) {} };
      cv.onpointermove = (e) => { if (!d) return; const dx = e.clientX - d.x0; if (Math.abs(dx) > 8) d.moved = true; if (d.moved) this.camX = Math.max(0, Math.min(this.maxCam(), d.c0 - dx)); };
      cv.onpointerup = (e) => { const was = d; d = null; if (was && !was.moved) this.tap(e); };
      cv.onpointercancel = () => { d = null; };
    },
    postXY(i) { const p = this.def.posts[i]; return [this.sx(p.x), this.top() + this.bgH() * this.def.walkY]; },
    tap(e) {
      const r = this.cv.getBoundingClientRect(), x = e.clientX - r.left, y = e.clientY - r.top, m = ms(this.def.id), h = this.personH();
      for (let i = 0; i < this.def.posts.length; i++) {
        const [px, py] = this.postXY(i);
        // 敵鬼站喺崗位右邊少少
        if (m.enemy[i] && Math.abs(x - (px + h * 0.32)) < h * 0.28 && y > py - h * 1.1 && y < py + 10) {
          const res = hitRival(this.def.id, i); if (!res) return;
          if (res.msg) this.float(px, py - h, res.msg, '#ffd'); else { this.float(px + h * 0.32, py - h * 1.05, `${W[res.type]}${res.tag ? '・' + res.tag : ''} −${res.dmg}`, res.tag === '怕' ? '#ff8' : res.tag === '不怕' ? '#aab' : '#fff'); if (res.gone) this.float(px + h * 0.32, py - h * 1.3, '趕走了！', '#7f7'); }
          return;
        }
        if (m.posts[i] != null && Math.abs(x - (px - h * 0.18)) < h * 0.3 && y > py - h * 1.1 && y < py + 10) {
          const left = boost(this.def.id, i);
          this.float(px - h * 0.18, py - h * 1.1, left ? `冷卻中 ${left} 秒` : '大招準備好！下一個路人 ×2.5', left ? '#aab' : '#ffb347');
          return;
        }
      }
    },
    float(x, y, t, c) { // 同一位置短時間內嘅飄字自動錯開，唔好疊埋一齊
      let k = 0; for (const f of this.fx) if (f.a < 0.9 && Math.abs(f.x - x) < 120 && Math.abs(f.y0 - y) < 40) k++;
      this.fx.push({ x, y:y - k * 26, y0:y, t, c, a:0 }); },
    frame(now) {
      if (!this.on) return; this.raf = requestAnimationFrame((n) => this.frame(n));
      if (now - this.last < 1000 / 30 - 2) return; // 上限 30 格
      const dt = Math.min(0.1, (now - this.last) / 1000); this.last = now; this.t += dt;
      this.step(dt); this.draw();
    },
    step(dt) {
      const def = this.def, m = ms(def.id);
      // 夜冷村、穩定、收益照行
      st().t = Date.now(); rivalStep(def, m, dt / 60); stableStep(def, m); payStep(def, m); legendStep(def, m);
      this.spawnAcc += dt;
      if (this.spawnAcc >= TUNE.every) { this.spawnAcc -= TUNE.every; const P = makePerson(def, m); P.x = def.dir < 0 ? def.seg[1] - 40 : def.seg[0] + 40; P.next = 0; P.speed = R(150, 190); this.walkers.push(P); }
      const order = def.posts.map((p, i) => i);
      for (const P of this.walkers) {
        if (P.react > 0) { P.react -= dt; continue; }
        if (P.done && P.by) { P.x += def.dir * P.speed * 2.2 * dt; P.flee = true; if ((def.dir < 0 && P.x < def.seg[0] - 200) || (def.dir > 0 && P.x > def.seg[1] + 200)) P.gone = true; continue; }
        P.x += def.dir * P.speed * dt;
        const i = order[P.next];
        if (i != null && ((def.dir < 0 && P.x <= def.posts[i].x) || (def.dir > 0 && P.x >= def.posts[i].x))) {
          P.next++;
          const res = passPost(def, m, i, P);
          if (P.done) P.atPost = i;
          const [px, py] = this.postXY(i), h = this.personH();
          res.forEach((r, k) => {
            const who = r.who === 1 ? '' : '夜冷村　';
            const txt = `${who}${W[r.type]}${r.combo ? '・連嚇' : ''}${r.tag ? '・' + r.tag : ''}${r.broke ? '　嚇破膽！' : ''}`;
            this.float(px, py - h * (1.15 + k * 0.18), txt, r.who === 2 ? '#ff7b7b' : r.broke ? '#ffe066' : r.tag === '不怕' ? '#aab' : '#e8f4ff');
            if (r.who === 1 && r.g) { r.g._act = this.t; }
          });
          if (res.length) { P.react = 0.7; P.scaredT = this.t; }
          if (P.done && P.by === 2 && res.length && res[res.length - 1].who === 2 && m.posts.some((x, j) => j < i && x != null)) { if (Math.random() < 0.35) this.float(px, py - h * 1.6, L(pick(BRYAN_LINES)).replace(/^Bryan：/, 'Bryan：'), '#ff9a9a'); }
        }
        if ((def.dir < 0 && P.x < def.seg[0] - 100) || (def.dir > 0 && P.x > def.seg[1] + 100)) { if (!P.done) { P.done = true; P.by = 0; } P.gone = true; }
        if (P.gone && !P.fin) { P.fin = true; finish(def, m, P); }
      }
      this.walkers = this.walkers.filter(P => !P.gone);
      for (const f of this.fx) f.a += dt; this.fx = this.fx.filter(f => f.a < 2.2);
      const s = share(m), sta = status(m);
      const info = $('#stn-info'); if (info && (!this._it || this.t - this._it > 0.5)) { this._it = this.t; info.innerHTML = `${sta.t}${m.stable ? '　<em>地盤穩定</em>' : ''}`;
        const bd = $('#stn-board'); if (bd) { const stp = m.stable ? '已穩定：固定產出，離線照算' : m.stableAt ? `穩定倒數 ${Math.max(0, Math.ceil((TUNE.stableHours * 3600000 - (Date.now() - m.stableAt)) / 3600000))} 小時` : m.habit >= 10 ? `嚇破膽要 ≥${pct(TUNE.stableRatio)} 才開始計穩定（現在 ${pct(s.me)}）` : '見慣度到 10 才能穩定';
          bd.innerHTML = `<div class="stn-bar"><i class="me" style="width:${pct(s.me)}"></i><i class="en" style="width:${pct(s.en)}"></i></div><div class="stn-bl"><span class="me">我方 ${pct(s.me)}</span><span class="en">夜冷村 ${pct(s.en)}</span><span>最近 ${s.n} 人</span></div>`
            + `<div class="stn-hab"><span>見慣度</span><div class="stn-hm"><i style="width:${m.habit * 10}%"></i></div><b>${m.habit.toFixed(1)}</b></div><small>${stp}</small>`
            + st().log.slice(0, 3).map(x => `<p>${x.h}</p>`).join(''); } }
    },
    drawChar(ctx, id, x, y, h, pose, right, alpha) {
      ctx.save(); if (alpha != null) ctx.globalAlpha = alpha;
      let ok = false; try { ok = has(MeshAnim) && MeshAnim.RIG[id] && MeshAnim.draw(ctx, id, x, y, h, pose, right); } catch (e) { ok = false; }
      if (!ok) { const img = SPR[id]; if (img) { const w = h * img.width / img.height, bob = pose && pose._bob || 0; ctx.translate(x, y + bob); if (!right) ctx.scale(-1, 1); ctx.drawImage(img, -w / 2, -h, w, h); } }
      ctx.restore();
    },
    draw() {
      const ctx = this.ctx, def = this.def, m = ms(def.id), W0 = this.W, H0 = this.H, img = this.img(), sc = this.sc();
      const T = this.top(), BH = this.bgH();
      if (!this._sky || this._sky.h !== H0) { const g = ctx.createLinearGradient(0, 0, 0, H0); g.addColorStop(0, '#0b0818'); g.addColorStop(0.5, '#1c1430'); g.addColorStop(1, '#100b1c'); this._sky = { g, h:H0 }; }
      ctx.fillStyle = this._sky.g; ctx.fillRect(0, 0, W0, H0);
      if (img) { const sx = def.seg[0] + this.camX / sc, sw = W0 / sc; ctx.drawImage(img, sx, 0, sw, img.height, 0, T, W0, BH); }
      ctx.fillStyle = 'rgba(40,20,80,0.22)'; ctx.fillRect(0, T, W0, BH); // 夜色
      ctx.fillStyle = '#2a1f3d'; ctx.fillRect(0, T + BH, W0, H0 - T - BH); ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.fillRect(0, T + BH, W0, 3);
      const h = this.personH(), y0 = T + BH * def.walkY, t = this.t;
      // 崗位
      def.posts.forEach((p, i) => {
        const [px, py] = this.postXY(i); if (px < -h || px > W0 + h) return;
        ctx.fillStyle = 'rgba(160,120,255,0.18)'; ctx.beginPath(); ctx.ellipse(px, py + 4, h * 0.42, h * 0.07, 0, 0, Math.PI * 2); ctx.fill();
        ctx.font = `bold ${Math.round(h * 0.075)}px sans-serif`; ctx.textAlign = 'center'; ctx.fillStyle = '#d9ccff'; ctx.strokeStyle = 'rgba(0,0,0,.7)'; ctx.lineWidth = 3;
        ctx.strokeText(`${i + 1}. ${p.name}`, px, py + h * 0.17); ctx.fillText(`${i + 1}. ${p.name}`, px, py + h * 0.17);
        const gid = m.posts[i], g = gid != null ? ghost(gid) : null;
        if (g) {
          const act = g._act && t - g._act < 0.8, pose = act ? MeshAnim.ANIM.attack((t - g._act) * 1.4 + 0.5) : MeshAnim.ANIM.idle(t + i);
          this.drawChar(ctx, g.k, px - h * 0.18, py - h * 0.05 + Math.sin(t * 2 + i) * 3, h * 0.82, pose, true, 0.85);
          const mor = m.morale[gid] == null ? 100 : m.morale[gid];
          ctx.fillStyle = 'rgba(0,0,0,.55)'; ctx.fillRect(px - h * 0.4, py - h * 1.02, h * 0.44, 6); ctx.fillStyle = mor > 40 ? '#7be08a' : '#ff7070'; ctx.fillRect(px - h * 0.4, py - h * 1.02, h * 0.44 * mor / 100, 6);
          if (m.boost[i]) { ctx.fillStyle = '#ffb347'; ctx.fillText('大招', px - h * 0.18, py - h * 1.08); }
        }
        const e = m.enemy[i];
        if (e) {
          const id = e.k === 'bryan' ? 'npc_rival' : e.k, eh = e.k === 'bryan' ? h * 0.95 : h * 0.72;
          this.drawChar(ctx, id, px + h * 0.32, py - h * 0.04 + Math.sin(t * 2.4 + i * 2) * 3, eh, MeshAnim.ANIM.idle(t * 1.2 + i), false, e.k === 'bryan' ? 1 : 0.85);
          ctx.fillStyle = 'rgba(0,0,0,.55)'; ctx.fillRect(px + h * 0.12, py - h * 1.02, h * 0.4, 6); ctx.fillStyle = '#ff6a6a'; ctx.fillRect(px + h * 0.12, py - h * 1.02, h * 0.4 * Math.max(0, e.hp) / (e.k === 'bryan' ? 220 : 100), 6);
          ctx.fillStyle = '#ffb0b0'; ctx.strokeText(`夜冷村・${RNAME[e.k]}`, px + h * 0.32, py - h * 1.08); ctx.fillText(`夜冷村・${RNAME[e.k]}`, px + h * 0.32, py - h * 1.08);
        }
      });
      // 路人（由後到前）
      const sorted = this.walkers.slice().sort((a, b) => a.x - b.x);
      for (const P of sorted) {
        const x = this.sx(P.x); if (x < -h || x > W0 + h) continue;
        const scared = P.scaredT != null && t - P.scaredT < 0.8, right = P.flee ? def.dir > 0 : def.dir > 0;
        const pose = scared ? MeshAnim.ANIM.scared(t - P.scaredT) : MeshAnim.ANIM.walk(t * (P.flee ? 1.8 : 1) + P.hp);
        pose._bob = scared ? -8 : Math.abs(Math.sin(t * 7 + P.hp)) * -3;
        this.drawChar(ctx, P.spr, x, y0 + 6, h, pose, right);
        // 頭頂：膽量條＋怕咩
        const fw = h * 0.5, fy = y0 - h * 1.08;
        ctx.fillStyle = 'rgba(0,0,0,.55)'; ctx.fillRect(x - fw / 2, fy, fw, 7); ctx.fillStyle = P.fear >= P.hp ? '#ffe066' : '#c58bff'; ctx.fillRect(x - fw / 2, fy, fw * Math.min(1, P.fear / P.hp), 7);
        ctx.font = `${Math.round(h * 0.07)}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = 'rgba(0,0,0,.75)';
        const lab = P.flee ? (P.by === 2 ? '被夜冷村嚇走' : '嚇破膽！') : `${P.name}　怕${P.weak.map(k => W[k]).join('、')}${P.tough > 1 ? `　要${P.tough}連嚇` : ''}`;
        ctx.fillStyle = P.flee ? (P.by === 2 ? '#ff8a8a' : '#ffe066') : '#fff'; ctx.strokeText(lab, x, fy - 6); ctx.fillText(lab, x, fy - 6);
      }
      // 飄字
      for (const f of this.fx) { const a = Math.max(0, 1 - f.a / 2.2); ctx.globalAlpha = a; ctx.font = `bold ${Math.round(h * 0.085)}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 4; ctx.strokeStyle = 'rgba(0,0,0,.8)'; ctx.fillStyle = f.c; const y = f.y - f.a * 28; ctx.strokeText(f.t, f.x, y); ctx.fillText(f.t, f.x, y); }
      ctx.globalAlpha = 1;
    },
  };

  function init() {
    if (has(POSTS) && !POSTS.station) POSTS.station = { name:'陽間站崗', bld:null, stat:2, desc:'在陽間地盤站崗嚇路人' };
    try { st(); } catch (e) {}
    setInterval(() => { try { if (!Live.on) tick(); } catch (e) { console.error(e); } }, 5000);
    window.addEventListener('resize', () => { if (Live.on) Live.resize(); });
  }
  return { MAPS, TUNE, st, ms, tick, simOne, assign, hitRival, boost, share, status, openPanel, entryHTML, panelHTML, Live, init, power, freeGhosts, legLv, mapOf, open };
})();
(function stationBoot() { if (typeof S === 'undefined' || !S || !S.ghosts || typeof UI === 'undefined') { setTimeout(stationBoot, 300); return; } try { Station.init(); } catch (e) { console.error(e); } })();
