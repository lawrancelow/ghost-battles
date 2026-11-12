// ===================== 陰間運動會 =====================
// 四個小比賽，靠鬼的怪癖決定玩法：殭屍跳遠（膝蓋不能彎）、舌頭對脖子拔河、天花板倒掛耐力、河童游泳（頭頂碟水不能灑）
// 每項每日第一次贏過 Bryan 的紀錄（拔河是贏轆轤首）：出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60
// 只用現有角色圖（ART.drawChar、Antag.draw），背景用 SCENE.drawBg 再疊程式畫的場地
const Sports = (() => {
  const D = (yue, zh) => { if (typeof LANG !== 'undefined') LANG.add({ [yue]:zh }); return yue; }; // 粵語原句＋中文版（L() 顯示）
  const DAY = 864e5;
  const EV = {
    jump: { name:'殭屍跳遠', who:'laojiang', bg:'field', unit:'米', hi:true,
      rule:'膝蓋不能彎，只能一跳一跳助跑。著地那一下點「跳」，節奏越準越快；最後在白線前點「起跳」，越貼線越遠，踩線犯規。',
      sub:'阿福頂上：他膝蓋可以彎，所以要自己忍住。' },
    tug:  { name:'舌頭對脖子拔河', who:'n30_diaosi', foe:'n30_rokurokubi', bg:'kampung', unit:'', hi:true,
      rule:'狂點「拉」把繩拉過來。繩子變紅就是繃緊了，這時候還拉，舌頭會打滑倒退。把旗拉到你這邊的線就贏。',
      sub:'吊死鬼不在，阿福用領帶頂上。' },
    hang: { name:'天花板倒掛耐力賽', who:'tianhua', bg:'hq', unit:'秒', hi:true,
      rule:'按住畫面才抓得住天花板，放手就掉下來。左右拖動手指，把搖擺拉回中間；風扇和掃把會來搞你。',
      sub:'天花姐不在，阿福倒掛（領帶垂下來了）。' },
    swim: { name:'河童游泳', who:'n30_kappa', bg:'banana', unit:'秒', hi:false,
      rule:'左右輪流划水向前游。划得太急、同一邊連划，頭頂碟裡的水會晃出去；水乾了河童就沒力。游完 50 米，越快越好。',
      sub:'河童不在，阿福頂著一碟水游。' },
  };
  const ORDER = ['jump', 'tug', 'hang', 'swim'];
  const TAUT = (() => { if (typeof LANG !== 'undefined') LANG.add({ '繃緊！唔好拉！':'繃緊了！不要拉！' }); return '繃緊！唔好拉！'; })();
  const BRYAN = {
    jump:D('Bryan：「我籃球跳投出身，跳遠？小意思。」', 'Bryan：「我打籃球跳投出身，跳遠？小意思。」'),
    tug:D('轆轤首：「我條頸三米長，你有幾長？」', '轆轤首：「我的脖子三米長，你有多長？」'),
    hang:D('Bryan：「倒掛？我喺公司掛名都掛咗三年。」', 'Bryan：「倒掛？我在公司掛名都掛了三年。」'),
    swim:D('Bryan：「我游水唔使碟，因為我頭頂冇嘢。等陣，唔係咁講……」', 'Bryan：「我游泳不用碟子，因為我頭上沒東西。等等，不是這樣說……」'),
  };
  const has = (o) => typeof o !== 'undefined';
  const Lx = (x) => typeof L === 'function' ? L(x) : x;
  function st() { if (!S.sports) S.sports = { best:{}, won:{}, plays:0 }; S.sports.best = S.sports.best || {}; S.sports.won = S.sports.won || {}; return S.sports; }
  function gday() { const ms = Date.now(), d = new Date(ms); return Math.floor((ms - d.getTimezoneOffset() * 60000) / DAY); }
  function rnd(seed) { let a = seed | 0; a = (a + 0x6D2B79F5) | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }
  // Bryan 今日的紀錄（每日不同，但同一日固定）
  function target(id) {
    const r = rnd(gday() * 7 + ORDER.indexOf(id) * 131);
    return id === 'jump' ? +(5.6 + r * 1.0).toFixed(2) : id === 'hang' ? Math.round(22 + r * 14) : id === 'swim' ? +(17.5 + r * 4).toFixed(1) : 0;
  }
  // 鬼力（gpower.js）：體能 ×(1＋0.12×(成長−1))；1 級 ×1（同舊版一樣）。倒掛耐力純靠平衡，唔加
  function gpf(a) { try { return a && a.g ? 1 + 0.12 * (GP.grow(a.g) - 1) : 1; } catch (e) { return 1; } }
  function owned(k) { return S.ghosts.find(g => g.k === k) || null; }
  function athlete(id) { const E = EV[id], g = owned(E.who); return g ? { k:E.who, g, name:g.name, sub:false } : { k:'afu', g:S.ghosts.find(x => x.k === 'afu'), name:'阿福', sub:true }; }
  const fmtV = (id, v) => id === 'tug' ? '' : id === 'jump' ? v.toFixed(2) + ' 米' : id === 'swim' ? v.toFixed(1) + ' 秒' : Math.floor(v) + ' 秒';
  function better(id, a, b) { return EV[id].hi ? a > b : a < b; }

  // ---------- 選項目 ----------
  function open() {
    const s = st(), today = gday();
    let h = `<p class="desc">陰間運動會：靠鬼自己的怪癖比賽。每項每日第一次贏過 Bryan 的紀錄，出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60。</p>`;
    h += ORDER.map(id => { const E = EV[id], a = athlete(id), won = s.won[id] === today, best = s.best[id];
      const goal = id === 'tug' ? `對手：${GHOSTS[E.foe] ? GHOSTS[E.foe].name : '轆轤首'}` : `Bryan 今日紀錄：${fmtV(id, target(id))}`;
      return `<div class="sp-ev ${won ? 'won' : ''}"><canvas data-por="${a.k}"></canvas><div><b>${E.name}</b><small>出賽：${a.name}${a.sub ? '（替補）' : ''}　${goal}</small><small>${best != null ? `你的最佳：${id === 'tug' ? best + ' 勝' : fmtV(id, best)}` : '未參賽'}${won ? '　<em>今日已贏</em>' : ''}</small></div><button class="btn sm ${won ? '' : 'gold'}" data-sp="${id}">${won ? '再玩' : '參賽'}</button></div>`; }).join('');
    UI.sheet('陰間運動會', h);
    paintPortraits($('#sheet'));
    $('#sheet').querySelectorAll('[data-sp]').forEach(b => b.onclick = () => { UI.close(); start(b.dataset.sp); });
  }

  // ---------- 比賽 ----------
  let G = null;
  function el() {
    let e = $('#sports'); if (e) return e;
    e = document.createElement('div'); e.id = 'sports'; document.body.appendChild(e); return e;
  }
  function start(id) {
    const E = EV[id], a = athlete(id), root = el();
    G = { id, E, a, t:0, phase:'intro', introT:2.6, done:false, fx:[], score:null, msg:'', msgT:0, gpf:gpf(a) };
    root.innerHTML = `<div id="sp-top"><button class="btn sm ghost" id="sp-quit">收場</button><b>${E.name}</b><span id="sp-hud"></span></div>
      <canvas id="sp-cvs"></canvas><div id="sp-panel"><p id="sp-rule">${E.rule}${a.sub ? `<br><i>${E.sub}</i>` : ''}${id !== 'hang' && a.g ? `<br><small class="gp-sub">${Lx(D('鬼力', '鬼力'))} ${GP.pow(a.g)}・${Lx(D('體能', '體能'))} ×${G.gpf.toFixed(2)}</small>` : ''}</p><div id="sp-btns"></div></div>`;
    root.classList.add('on');
    $('#sp-quit').onclick = () => close();
    const cv = $('#sp-cvs'); G.cv = cv; G.ctx = cv.getContext('2d');
    INIT[id](G);
    resize(); window.addEventListener('resize', resize);
    cv.addEventListener('pointerdown', (e) => { e.preventDefault(); G && G.down && G.down(pt(e)); });
    cv.addEventListener('pointermove', (e) => { G && G.move && G.move(pt(e)); });
    const up = (e) => { G && G.up && G.up(pt(e)); }; cv.addEventListener('pointerup', up); cv.addEventListener('pointercancel', up); cv.addEventListener('pointerleave', up);
    try { Sound.setMode('story'); } catch (e) {}
    G.last = performance.now(); requestAnimationFrame(frame);
  }
  function pt(e) { const r = G.cv.getBoundingClientRect(); return { x:(e.clientX - r.left) / r.width * 390, y:(e.clientY - r.top) / r.width * 390 }; }
  function resize() { if (!G) return; const r = G.cv.getBoundingClientRect(), d = Math.min(2, window.devicePixelRatio || 1); G.cv.width = r.width * d; G.cv.height = r.height * d; G.k = r.width * d / 390; G.H = r.height / r.width * 390; }
  function close() { G = null; const e = $('#sports'); if (e) { e.classList.remove('on'); e.innerHTML = ''; } try { Sound.setMode('village'); } catch (e) {} open(); }
  function btns(list) { const b = $('#sp-btns'); b.innerHTML = list.map((x, i) => `<button class="btn ${x[2] || 'gold'} sp-b" data-i="${i}">${x[0]}</button>`).join(''); b.querySelectorAll('.sp-b').forEach(x => x.addEventListener('pointerdown', (e) => { e.preventDefault(); const f = list[+x.dataset.i][1]; if (G && G.phase === 'play') f(); })); }
  function say(m, t) { G.msg = m; G.msgT = t || 1.2; }
  function frame(now) {
    if (!G) return; const dt = Math.min(0.05, (now - G.last) / 1000); G.last = now;
    G.t += dt; if (G.msgT > 0) G.msgT -= dt;
    if (G.phase === 'intro') { G.introT -= dt; if (G.introT <= 0) G.phase = 'play'; }
    if (G.phase === 'play' && G.tick) G.tick(dt);
    for (const f of G.fx) f.t += dt; G.fx = G.fx.filter(f => f.t < f.life);
    draw(); requestAnimationFrame(frame);
  }
  function draw() {
    const c = G.ctx, H = G.H; c.setTransform(G.k, 0, 0, G.k, 0, 0); c.clearRect(0, 0, 390, H);
    if (!(has(SCENE) && SCENE.drawBg(c, 390, H, G.E.bg))) { c.fillStyle = '#1c1820'; c.fillRect(0, 0, 390, H); }
    c.fillStyle = 'rgba(10,8,16,.35)'; c.fillRect(0, 0, 390, H);
    G.draw(c, H);
    for (const f of G.fx) { const q = f.t / f.life; c.save(); c.globalAlpha = 1 - q; c.font = `bold ${f.size || 18}px "PingFang TC","Noto Sans TC",sans-serif`; c.textAlign = 'center'; c.lineWidth = 4; c.strokeStyle = 'rgba(0,0,0,.75)'; c.fillStyle = f.col || '#fff'; c.strokeText(f.text, f.x, f.y - q * 26); c.fillText(f.text, f.x, f.y - q * 26); c.restore(); }
    if (G.phase === 'intro') banner(c, H, G.E.name, Lx(BRYAN[G.id]));
    if (G.msgT > 0 && G.msg) { c.save(); c.font = 'bold 22px "PingFang TC","Noto Sans TC",sans-serif'; c.textAlign = 'center'; c.lineWidth = 5; c.strokeStyle = 'rgba(0,0,0,.8)'; c.fillStyle = '#ffd84a'; c.strokeText(G.msg, 195, H * 0.2); c.fillText(G.msg, 195, H * 0.2); c.restore(); }
    const hud = $('#sp-hud'); if (hud && G.hud) hud.textContent = G.hud();
  }
  function banner(c, H, a, b) {
    c.save(); c.fillStyle = 'rgba(0,0,0,.6)'; c.fillRect(0, H * 0.32, 390, 92);
    c.textAlign = 'center'; c.fillStyle = '#ffd84a'; c.font = 'bold 26px "PingFang TC","Noto Sans TC",sans-serif'; c.fillText(a, 195, H * 0.32 + 38);
    c.fillStyle = '#eee'; c.font = '14px "PingFang TC","Noto Sans TC",sans-serif'; wrap(c, b, 195, H * 0.32 + 66, 350, 18); c.restore();
  }
  function wrap(c, s, x, y, w, lh) { let line = '', yy = y; for (const ch of s) { if (c.measureText(line + ch).width > w) { c.fillText(line, x, yy); line = ch; yy += lh; } else line += ch; } c.fillText(line, x, yy); }
  function pop(text, x, y, col, size) { G.fx.push({ text, x, y, col, size, t:0, life:0.9 }); }
  function char(c, k, x, y, s, o) { try { ART.drawChar(c, k, x, y, s, Object.assign({ t:G.t }, o || {})); } catch (e) {} }
  function bryan(c, x, y, h, state, o) { try { Antag.draw(c, 'npc_rival', x, y, h, state || 'idle', G.t, Object.assign({ shadow:false, time:G.t }, o || {})); } catch (e) {} }

  // ---------- 結算 ----------
  function finish(v, line) {
    if (G.done) return; G.done = true; G.phase = 'end';
    const s = st(), id = G.id, today = gday(); s.plays = (s.plays || 0) + 1;
    let win, rec = '';
    if (id === 'tug') { win = v > 0; s.best.tug = (s.best.tug || 0) + (win ? 1 : 0); }
    else { win = v != null && better(id, v, target(id)); if (v != null && (s.best[id] == null || better(id, v, s.best[id]))) { s.best[id] = v; rec = '　<b>個人新紀錄！</b>'; } }
    let rw = '';
    if (win && s.won[id] !== today) {
      s.won[id] = today;
      if (has(Presence)) { if (G.a.g) Presence.add(G.a.g, 12); for (const g of S.ghosts) if (g !== G.a.g) Presence.add(g, 3); }
      if (S.contract && S.contract.state === 'active') S.contract.kpi += 2;
      const got = give({ coins:60 }); rw = `<p class="desc">${G.a.name} 存在感 +12，全村 +3${S.contract && S.contract.state === 'active' ? '，合約 KPI +2' : ''}，${got}</p>`;
    } else if (win) rw = '<p class="desc">今日已經領過獎，這場算練習。</p>';
    save();
    const res = id === 'tug' ? (win ? '贏了！' : '輸了') : v == null ? '犯規' : fmtV(id, v);
    const vs = id === 'tug' ? '' : `<p class="desc">Bryan 今日紀錄：${fmtV(id, target(id))}${rec}</p>`;
    const p = $('#sp-panel'); if (!p) return;
    p.innerHTML = `<div class="sp-end"><h3>${win ? '贏了 Bryan！' : id === 'tug' ? '被轆轤首拉過去了' : '輸給 Bryan'}</h3><p class="sp-big">${res}</p>${line ? `<p class="desc"><i>${Lx(line)}</i></p>` : ''}${vs}${rw}<div class="sp-endb"><button class="btn" id="sp-again">再來一次</button><button class="btn gold" id="sp-back">回運動會</button></div></div>`;
    $('#sp-again').onclick = () => start(id); $('#sp-back').onclick = () => close();
  }

  // ===================== 各項目 =====================
  const INIT = {};
  // ---------- 殭屍跳遠 ----------
  INIT.jump = (G) => {
    const T = 0.56, HOPS = 6, PX = 30; // 每跳 0.56 秒；1 米 = 30 單位
    Object.assign(G, { x:40, hop:0, hopT:0, acc:[], speed:0.6, line:0, fly:null, tapped:{}, lineX:0, cam:0 });
    G.lineX = 40 + HOPS * 48 + 40;
    G.hud = () => G.fly ? '' : `節奏 ${Math.round((0.6 + 0.4 * avg()) * 100)}%`;
    const avg = () => G.acc.length ? G.acc.reduce((s, v) => s + v, 0) / G.acc.length : 0;
    const tapHop = () => {
      if (G.fly || G.hop >= HOPS) { takeoff(); return; }
      const land = T - G.hopT, early = G.hopT; const d = Math.min(land, early); // 離最近一次著地有多遠
      const i = land < early ? G.hop : G.hop - 1; if (i < 0 || G.tapped[i]) return; G.tapped[i] = 1;
      const q = d < 0.09 ? 1 : d < 0.17 ? 0.7 : 0.15; G.acc.push(q);
      pop(q === 1 ? '好節奏！' : q > 0.5 ? '還可以' : '亂跳', G.x - (G.cam || 0), G.H * 0.42, q === 1 ? '#ffd84a' : '#ddd', 16);
    };
    const takeoff = () => {
      if (G.fly || G.hop < HOPS) return;
      const gap = (G.lineX - G.x) / PX; const sp = 0.6 + 0.4 * avg();
      if (gap < 0) { G.fly = { t:0, dist:0, foul:true }; say('踩線犯規！', 1.6); return; }
      const dist = Math.max(0.5, sp * 7.6 * G.gpf - gap * 1.2); // 鬼力：17 級 ×1.06、40 級 ×1.13
      G.fly = { t:0, dist, x0:G.x, foul:false };
    };
    btns([['跳', () => tapHop()]]);
    G.down = () => { if (G.phase === 'play') tapHop(); };
    G.tick = (dt) => {
      if (G.fly) { G.fly.t += dt; if (G.fly.t > (G.fly.foul ? 1.2 : 1.4) && !G.done) finish(G.fly.foul ? null : +G.fly.dist.toFixed(2), G.fly.foul ? D('殭屍跳過咗龍，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。', '殭屍跳過了頭，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。') : G.fly.dist > target('jump') ? D('落地姿勢：成條棍咁插落沙池。裁判俾滿分。', '落地姿勢：直挺挺插進沙池。裁判給滿分。') : D('膝頭太直，起跳差少少。', '膝蓋太直，起跳時差一點點。')); return; }
      if (G.hop < HOPS) { G.hopT += dt * (0.85 + 0.3 * G.speed); if (G.hopT >= T) { G.hopT -= T; G.hop++; if (!G.tapped[G.hop - 1]) { G.acc.push(0); } G.speed = 0.6 + 0.4 * avg(); } G.x = 40 + (G.hop + G.hopT / T) * 48; }
      else { G.x += dt * 70 * (0.8 + 0.5 * G.speed); if (G.x > G.lineX + 40 && !G.fly) { G.fly = { t:0, dist:0, foul:true }; say('踩線犯規！', 1.6); } }
    };
    G.draw = (c, H) => {
      const gy = H * 0.66, SC = 1.6;
      const fx = G.fly && !G.fly.foul ? G.lineX + G.fly.dist * PX * Math.min(1, G.fly.t / 0.9) : G.x;
      const cam = Math.max(0, Math.min(G.lineX + 9.5 * PX - 390, fx - 150)); G.cam = cam;
      c.save(); c.translate(-cam, 0);
      c.fillStyle = 'rgba(140,90,60,.6)'; c.fillRect(0, gy - 8, G.lineX + 12 * PX, 26); // 跑道
      c.fillStyle = 'rgba(225,195,125,.6)'; c.fillRect(G.lineX, gy - 8, 10 * PX, 26); // 沙池
      c.fillStyle = '#f4f0e0'; c.fillRect(G.lineX - 2, gy - 10, 5, 30); // 起跳線
      c.font = 'bold 11px sans-serif'; c.textAlign = 'center';
      for (let m = 1; m <= 9; m++) { const x = G.lineX + m * PX; c.fillStyle = 'rgba(255,255,255,.6)'; c.fillRect(x, gy + 18, 1.5, 7); c.fillText(m + '米', x, gy + 38); }
      const bx = G.lineX + target('jump') * PX; c.fillStyle = '#c0392b'; c.fillRect(bx, gy - 44, 3, 44); c.fillRect(bx + 3, gy - 44, 30, 16); c.fillStyle = '#fff'; c.font = 'bold 10px sans-serif'; c.textAlign = 'left'; c.fillText('Bryan', bx + 4, gy - 32);
      let x = G.x, y = gy, pose = null, pt = 0;
      if (G.fly && !G.fly.foul) { const p = Math.min(1, G.fly.t / 0.9); x = fx; y = gy - Math.sin(p * Math.PI) * 110; pose = p < 1 ? 'air' : null; pt = p; }
      else if (!G.fly && G.hop < HOPS) { const p = G.hopT / T; y = gy - Math.sin(p * Math.PI) * 34; }
      if (!G.fly && G.hop < HOPS) { const p = G.hopT / T, r = 10 + (1 - p) * 34; c.strokeStyle = p > 0.75 ? '#ffd84a' : 'rgba(255,255,255,.55)'; c.lineWidth = 3; c.beginPath(); c.ellipse(G.x, gy + 4, r, r * 0.32, 0, 0, Math.PI * 2); c.stroke(); }
      char(c, G.a.k, x, y, SC, { pose, pt, shadow:false });
      if (G.fly && !G.fly.foul && G.fly.t > 0.9) { c.fillStyle = '#ffd84a'; c.fillRect(fx - 1, gy - 6, 3, 22); }
      c.restore();
      if (!G.fly && G.hop >= HOPS) { c.save(); c.font = 'bold 24px sans-serif'; c.textAlign = 'center'; c.lineWidth = 5; c.strokeStyle = '#000'; c.fillStyle = '#ffd84a'; c.strokeText('起跳！', 195, H * 0.3); c.fillText('起跳！', 195, H * 0.3); c.restore(); }
      if (G.fly && !G.fly.foul && G.fly.t > 0.9) { c.save(); c.font = 'bold 30px sans-serif'; c.textAlign = 'center'; c.lineWidth = 6; c.strokeStyle = '#000'; c.fillStyle = '#fff'; const t = G.fly.dist.toFixed(2) + ' 米'; c.strokeText(t, 195, H * 0.3); c.fillText(t, 195, H * 0.3); c.restore(); }
    };
  };

  // ---------- 舌頭對脖子拔河 ----------
  INIT.tug = (G) => {
    Object.assign(G, { p:0, ai:0.12, taut:0, tautT:2.2, time:30, slip:0 });
    G.hud = () => `剩 ${Math.max(0, Math.ceil(G.time))} 秒`;
    const pull = () => {
      if (G.done) return;
      if (G.taut > 0) { G.p -= 0.07; G.slip = 0.5; pop('舌頭打滑！', 120, G.H * 0.42, '#ff8080', 16); return; }
      G.p += 0.032 * G.gpf; if (Math.random() < 0.25) pop('拉！', 90 + Math.random() * 40, G.H * 0.46, '#ffe8a0', 14);
    };
    btns([['拉', pull]]);
    G.down = () => { if (G.phase === 'play') pull(); };
    G.tick = (dt) => {
      if (G.done) return;
      G.time -= dt; G.slip = Math.max(0, G.slip - dt);
      // 轆轤首：穩定地拉，間中發力
      const surge = Math.sin(G.t * 1.3) > 0.85 ? 0.22 : 0;
      G.p -= dt * (G.ai + surge + Math.max(0, G.t - 8) * 0.004);
      // 繃緊：每隔一陣出現 0.8 秒
      G.tautT -= dt; if (G.tautT <= 0) { G.taut = 0.85; G.tautT = 1.8 + Math.random() * 1.8; }
      if (G.taut > 0) G.taut -= dt;
      if (G.p >= 1) finish(1, D('轆轤首條頸拉到打咗個結。佢話下年再嚟。', '轆轤首的脖子被拉到打了個結。她說明年再來。'));
      else if (G.p <= -1) finish(0, D('條脷被拉咗過對面，要行過去執返。', '舌頭被拉到對面，要走過去撿回來。'));
      else if (G.time <= 0) finish(G.p > 0 ? 1 : 0, G.p > 0 ? D('夠鐘，面旗喺你嗰邊。險勝。', '時間到，旗子在你這邊。險勝。') : D('夠鐘，面旗喺對面。差少少。', '時間到，旗子在對面。差一點。'));
    };
    G.draw = (c, H) => {
      const gy = H * 0.68, cx = 195 + G.p * 100, ry = gy - 66, LH = ((typeof CHAR_H !== 'undefined' && CHAR_H[G.a.k]) || 56) * 1.6, RH = ((typeof CHAR_H !== 'undefined' && CHAR_H[G.E.foe]) || 56) * 1.6;
      c.fillStyle = 'rgba(255,255,255,.75)'; c.fillRect(94, ry - 24, 3, 40); c.fillRect(293, ry - 24, 3, 40); // 勝利線
      c.fillStyle = 'rgba(255,255,255,.3)'; c.fillRect(194, ry - 18, 2, 34);
      // 繩（我方是舌頭／領帶，對方是頸）
      const ropeCol = G.taut > 0 ? '#ff4040' : G.a.k === 'afu' ? '#c0392b' : '#d86a7a';
      c.strokeStyle = ropeCol; c.lineWidth = G.taut > 0 ? 6 : 5; c.beginPath(); c.moveTo(70, gy - LH * 0.62); c.quadraticCurveTo(cx - 50, ry + 8 + Math.sin(G.t * 9) * (G.taut > 0 ? 1 : 4), cx, ry); c.stroke();
      c.strokeStyle = '#e8dcc8'; c.lineWidth = 7; c.beginPath(); c.moveTo(cx, ry); c.quadraticCurveTo(cx + 60, ry - 4, 326, gy - RH * 0.82); c.stroke();
      c.fillStyle = '#ffd84a'; c.beginPath(); c.moveTo(cx, ry); c.lineTo(cx, ry - 32); c.lineTo(cx + 20, ry - 24); c.lineTo(cx, ry - 16); c.fill(); c.fillStyle = '#5a3a1a'; c.fillRect(cx - 1, ry - 32, 2, 32);
      char(c, G.a.k, 58, gy, 1.6, { pose:G.slip > 0 ? 'hurt' : null, pt:0.5, shadow:false, rot:-0.15 - (G.taut > 0 ? 0 : 0.05) });
      char(c, G.E.foe, 338, gy, 1.6, { flip:true, shadow:false, rot:0.15 });
      if (G.taut > 0) { c.save(); c.font = 'bold 20px sans-serif'; c.textAlign = 'center'; c.fillStyle = '#ff6060'; c.lineWidth = 4; c.strokeStyle = '#000'; const tx = Lx(TAUT); c.strokeText(tx, 195, H * 0.3); c.fillText(tx, 195, H * 0.3); c.restore(); }
    };
  };

  // ---------- 天花板倒掛耐力 ----------
  INIT.hang = (G) => {
    Object.assign(G, { hold:false, sw:0, v:0, fx0:null, time:0, push:0, evT:4, ev:null, fall:null });
    G.hud = () => `${Math.floor(G.time)} 秒`;
    btns([]); $('#sp-btns').innerHTML = '<p class="sp-tip">按住畫面開始，左右拖動保持平衡</p>';
    G.down = (p) => { if (G.phase !== 'play' || G.fall) return; G.hold = true; G.fx0 = p.x; G.dx = 0; };
    G.move = (p) => { if (G.hold && G.fx0 != null) { G.dx = (p.x - G.fx0) / 90; } };
    G.up = () => { if (G.hold && !G.done && !G.fall && G.time > 0.3) { G.fall = { t:0 }; say('放手了！', 1.4); } G.hold = false; };
    G.tick = (dt) => {
      if (G.fall) { G.fall.t += dt; if (G.fall.t > 1 && !G.done) finish(+G.time.toFixed(1), G.time > target('hang') ? D('跌落嚟嗰陣，啱啱壓住 Bryan 塊紀錄牌。', '掉下來的時候，剛好壓住 Bryan 的紀錄牌。') : D('落地。清潔安娣：「又係你，日日都跌落嚟。」', '落地。清潔安娣：「又是你，每天都掉下來。」')); return; }
      if (!G.hold) return;
      G.time += dt;
      const lv = 1 + G.time / 20; // 越掛越難
      G.evT -= dt; if (G.evT <= 0) { G.ev = { k:Math.random() < 0.5 ? 'fan' : 'broom', t:0, dir:Math.random() < 0.5 ? -1 : 1 }; G.evT = 3 + Math.random() * 3 / lv; pop(G.ev.k === 'fan' ? '風扇開了！' : '安娣的掃把！', 195, G.H * 0.62, '#ffe8a0', 16); }
      let f = Math.sin(G.t * 1.7) * 0.35 * lv + Math.sin(G.t * 0.63 + 1) * 0.25 * lv;
      if (G.ev) { G.ev.t += dt; f += G.ev.dir * (G.ev.k === 'fan' ? 1.1 : 2.2) * lv * (G.ev.k === 'broom' ? Math.max(0, 1 - Math.abs(G.ev.t - 0.4) * 3) : 1); if (G.ev.t > (G.ev.k === 'fan' ? 1.8 : 0.9)) G.ev = null; }
      G.v += (f - G.dx * 2.6 - G.sw * 0.6) * dt; G.v *= 0.985; G.sw += G.v * dt * 1.6;
      if (Math.abs(G.sw) > 1) { G.fall = { t:0 }; say('甩下來了！', 1.4); }
    };
    G.draw = (c, H) => {
      const cy = H * 0.18;
      c.fillStyle = 'rgba(60,50,70,.9)'; c.fillRect(0, 0, 390, cy); c.fillStyle = 'rgba(255,255,255,.08)'; for (let x = 0; x < 390; x += 48) c.fillRect(x, cy - 2, 46, 2);
      // 平衡尺
      c.fillStyle = 'rgba(0,0,0,.5)'; c.fillRect(95, H * 0.84, 200, 10); c.fillStyle = 'rgba(120,220,120,.6)'; c.fillRect(165, H * 0.84, 60, 10);
      c.fillStyle = Math.abs(G.sw) > 0.7 ? '#ff5050' : '#ffd84a'; c.fillRect(195 + G.sw * 100 - 3, H * 0.84 - 4, 6, 18);
      const ang = G.sw * 0.6, fy = G.fall ? Math.min(H * 0.72, cy + G.fall.t * G.fall.t * 900) : cy;
      c.save(); c.translate(195, fy); c.rotate(Math.PI + ang); char(c, G.a.k, 0, 0, 2.0, { shadow:false, pose:G.fall ? 'hurt' : null, pt:0.5 }); c.restore();
      if (!G.hold && !G.fall && G.phase === 'play') { c.save(); c.font = 'bold 18px sans-serif'; c.textAlign = 'center'; c.fillStyle = '#fff'; c.fillText('按住畫面抓實天花板', 195, H * 0.55); c.restore(); }
      if (G.ev && G.ev.k === 'fan') { c.save(); c.translate(G.ev.dir < 0 ? 370 : 20, H * 0.4); c.rotate(G.t * 20); c.strokeStyle = 'rgba(255,255,255,.6)'; c.lineWidth = 4; for (let i = 0; i < 3; i++) { c.rotate(Math.PI * 2 / 3); c.beginPath(); c.moveTo(0, 0); c.lineTo(22, 0); c.stroke(); } c.restore(); }
      if (G.ev && G.ev.k === 'broom') { const x = 195 - G.ev.dir * (160 - G.ev.t * 300); c.save(); c.strokeStyle = '#8a6a3a'; c.lineWidth = 5; c.beginPath(); c.moveTo(x, H * 0.75); c.lineTo(x + G.ev.dir * 20, H * 0.32); c.stroke(); c.fillStyle = '#c8a860'; c.fillRect(x + G.ev.dir * 20 - 14, H * 0.28, 28, 10); c.restore(); }
      // Bryan 紀錄
      c.save(); c.font = '12px sans-serif'; c.textAlign = 'right'; c.fillStyle = '#ffd0c0'; c.fillText(`Bryan：${target('hang')} 秒`, 380, H * 0.82); c.restore();
    };
  };

  // ---------- 河童游泳 ----------
  INIT.swim = (G) => {
    Object.assign(G, { dist:0, vel:0, water:1, slosh:0, sv:0, lastSide:0, lastT:-9, time:0, finished:false, stroke:0 });
    G.hud = () => `${Math.min(50, Math.floor(G.dist))}／50 米　${G.time.toFixed(1)} 秒`;
    const stroke = (side) => {
      if (G.finished) return;
      const gap = G.t - G.lastT; G.lastT = G.t;
      const same = side === G.lastSide; G.lastSide = side; G.stroke = 0.35;
      const power = G.water > 0.25 ? 1 : 0.45; // 碟水乾了就冇力
      G.vel += (same ? 0.5 : 2.1) * power * (gap < 0.22 ? 0.6 : 1) * G.gpf; // 同一邊連划、划得太急都冇乜力
      let kick = same ? 0.9 : 0.35; if (gap < 0.22) kick += 0.6; // 划太急
      G.sv += side * kick;
      if (same) pop('同一邊！', 195 + side * 70, G.H * 0.38, '#ffb0a0', 14);
    };
    btns([['左划', () => stroke(-1), ''], ['右划', () => stroke(1), '']]); G.stroke_ = stroke;
    G.tick = (dt) => {
      if (G.finished) return;
      G.time += dt; G.stroke = Math.max(0, G.stroke - dt);
      G.vel *= Math.pow(0.35, dt); G.dist += G.vel * dt * 0.5;
      G.sv += -G.slosh * 14 * dt; G.sv *= Math.pow(0.4, dt); G.slosh += G.sv * dt * 3;
      if (Math.abs(G.slosh) > 0.55) { const loss = (Math.abs(G.slosh) - 0.55) * dt * 0.9; G.water = Math.max(0, G.water - loss); if (Math.random() < dt * 6) pop('水灑了！', 195, G.H * 0.33, '#9fd8ff', 13); }
      if (G.dist >= 50) { G.finished = true; finish(+G.time.toFixed(1), G.water > 0.6 ? D('游完，頭頂碟水仲有大半。河童協會頒發「穩陣獎」。', '游完，頭頂碟水還有大半。河童協會頒發「穩健獎」。') : G.water > 0.25 ? D('游完，碟水剩返一半，個頭有啲暈。', '游完了，碟裡的水剩一半，頭有點暈。') : D('碟水乾晒，最後幾米係爬上岸。', '碟水全乾了，最後幾米是爬上岸的。')); }
      if (G.time > 60 && !G.finished) { G.finished = true; finish(null, D('一分鐘都未游完。救生員（一隻水鬼）將你撈咗上岸。', '一分鐘都沒游完。救生員（一隻水鬼）把你撈上岸。')); }
    };
    G.draw = (c, H) => {
      const top = H * 0.4, bot = H * 0.78;
      c.fillStyle = 'rgba(40,90,120,.75)'; c.fillRect(0, top, 390, bot - top);
      for (let i = 0; i < 6; i++) { c.strokeStyle = 'rgba(255,255,255,.12)'; c.beginPath(); const y = top + 12 + i * (bot - top) / 6; for (let x = 0; x <= 390; x += 12) c.lineTo(x, y + Math.sin(x * 0.05 + G.t * 2 + i) * 2); c.stroke(); }
      // 泳道浮標：跟距離捲動
      const off = (G.dist * 24) % 48; c.fillStyle = '#e05050'; for (let x = -off; x < 400; x += 48) { c.beginPath(); c.arc(x, top + 4, 4, 0, Math.PI * 2); c.arc(x + 24, bot - 4, 4, 0, Math.PI * 2); c.fill(); }
      // Bryan 的影子（按紀錄速度游）
      const bd = Math.min(50, G.time / target('swim') * 50), bx = 150 + (bd - G.dist) * 24;
      if (bx > -40 && bx < 430) { c.save(); c.globalAlpha = 0.5; c.beginPath(); c.rect(0, 0, 390, top + 30); c.clip(); bryan(c, bx, top + 60, 96, 'walk', { faceRight:true }); c.restore(); c.save(); c.font = 'bold 11px sans-serif'; c.textAlign = 'center'; c.fillStyle = '#ffd0c0'; c.fillText('Bryan', bx, top - 46); c.restore(); }
      const y = (top + bot) / 2 + 40 + Math.sin(G.t * 7) * (G.vel > 0.5 ? 3 : 1.5), lean = Math.min(0.35, G.vel * 0.05), SC = 1.5, HH = ((typeof CHAR_H !== 'undefined' && CHAR_H[G.a.k]) || 56) * SC + 4 * SC - 7; // 碟要坐喺頭頂
      c.save(); c.beginPath(); c.rect(0, 0, 390, y - 22); c.clip(); // 水面以下唔畫（半身浸喺水）
      c.save(); c.translate(150, y); c.rotate(lean); char(c, G.a.k, 0, 0, SC, { shadow:false, walk:G.vel > 0.5 });
      // 頭頂碟水（跟住個頭）
      c.translate(0, -HH); c.rotate(G.slosh * 0.6); c.fillStyle = '#c8c0a8'; c.strokeStyle = 'rgba(0,0,0,.4)'; c.lineWidth = 1.5; c.beginPath(); c.ellipse(0, 0, 22, 6.5, 0, 0, Math.PI * 2); c.fill(); c.stroke();
      if (G.water > 0) { c.fillStyle = 'rgba(120,200,255,.9)'; c.beginPath(); c.ellipse(G.slosh * 6, -1.5, 18 * Math.sqrt(G.water), 4.2 * Math.sqrt(G.water), 0, 0, Math.PI * 2); c.fill(); }
      c.restore(); c.restore();
      c.fillStyle = 'rgba(40,90,120,.55)'; c.fillRect(0, y - 22, 390, bot - y + 22); // 前景水
      if (G.stroke > 0) { const q = 1 - G.stroke / 0.35; c.strokeStyle = `rgba(255,255,255,${0.7 * (1 - q)})`; c.lineWidth = 2; c.beginPath(); c.ellipse(150 + G.lastSide * 30, y - 20, 12 + q * 22, 4 + q * 6, 0, 0, Math.PI * 2); c.stroke(); }
      // 碟水量
      c.fillStyle = 'rgba(0,0,0,.5)'; c.fillRect(20, H * 0.86, 120, 9); c.fillStyle = G.water > 0.25 ? '#7fd0ff' : '#ff7070'; c.fillRect(20, H * 0.86, 120 * G.water, 9);
      c.fillStyle = '#fff'; c.font = '11px sans-serif'; c.textAlign = 'left'; c.fillText('頭頂碟水', 20, H * 0.86 - 4);
      // 終點
      const fx = 150 + (50 - G.dist) * 24; if (fx < 400) { c.fillStyle = '#fff'; c.fillRect(fx, top, 4, bot - top); }
    };
  };

  return { open, start, EV, target, st, athlete, _g:() => G }; // _g：測試用
})();
