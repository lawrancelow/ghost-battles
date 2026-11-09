// ===================== 存在感＋試用期合約（presence.js）：引擎 =====================
// 主題：鬼要有人驚、有人講、有人記得先存在。冇人記得，就會淡走（魂飛魄散）。
// 存檔：S.presence = { v, p:{鬼id:0–100}, t, grace, skew, warn:{}, cd:{}, gone:[], haunt:{}, day, mailed:{} }
//       S.contract = { rank, state:'none'|'active'|'crisis', start, end, kpi, target, taunted, crisis:{end}, hist:[] }
// 接駁（唔改原檔）：window 'gb:nightEnd'（scare.js 發）；ART.drawChar／PlazaLife.frame／Village.update／Battle.mkGhostUnit／Battle.finish／
// Standup.play／Theater.play 包一層；名冊、招魂台用 MutationObserver 加資料；HUD 加一粒合約掣。
const Presence = (() => {
  const DAY = 864e5, HOUR = 36e5;
  // ---------- 調校 ----------
  const TUNE = {
    DECAY:4,          // 每日跌幾多（真實時間；開住遊戲同離線都計）
    GRACE:7,          // 新功能上線／新玩家：頭 7 日唔跌
    FADE:60,          // 低過呢個開始變透明
    LOWSTAT:50,       // 低過呢個，出陣能力慢慢跌（最多 −10%）
    WARN:25,          // 警告（名冊紅牌、村裡擔心、冼小姐電郵）
    COUNT:12,         // 開始 3 日倒數
    CD_DAYS:3,
    AFU_FLOOR:35,     // 阿福平時唔會低過呢個（佢嘅命運由合約決定）
    OFFLINE_FLOOR:13, // 離線太耐返嚟：未警告過嘅鬼，最多跌到呢度（一定會先見到警告同倒數）
    RIPPLE:6, RIPPLE_STAR:3,     // 每晚回陽間：全村 +6 +3×星
    SQUAD:18, SQUAD_SCARE:4, SQUAD_CAP:45, // 出動嘅鬼：+18 +4×嚇到嘅次數（最多 +45）
    LEGEND:2,         // 之前喺同一個地點嚇過人嘅鬼：+2×傳說等級
    DAILY_LEGEND:4,   // 每日：嚇過人嘅地點仲有傳說流傳，最多 +4
    WIN:2, STANDUP:8, SKIT:3,
  };
  const S_ = () => (typeof S !== 'undefined' ? S : null);
  const zh = () => typeof LANG === 'undefined' || LANG.cur !== 'yue';
  const WRITTEN = { 旁白:1, 系統:1, 寄件人:1, 主旨:1 };
  const T = (l) => (zh() || WRITTEN[l[0]] ? l[2] : l[1]);
  const seen = (id) => !!(S && S.seen && S.seen[id]);
  const rnd = (a) => a[Math.floor(Math.random() * a.length)];
  let started = false, scenes = [], playing = false, inPlaza = false, lastBub = null, sceneGap = 0, cur = null;

  // ---------- 時間（示範同測試可以撥快） ----------
  function clock() { const p = S_() && S.presence; return Date.now() + ((p && p.skew) || 0); }
  function gday(ms) { const d = new Date(ms); return Math.floor((ms - d.getTimezoneOffset() * 60000) / DAY); }

  // ---------- 存檔 ----------
  function st() {
    if (!S_()) return null;
    if (!S.presence) S.presence = { v:1, p:{}, t:Date.now(), grace:Date.now() + TUNE.GRACE * DAY, skew:0, warn:{}, cd:{}, gone:[], haunt:{}, day:gday(Date.now()), mailed:{} };
    const p = S.presence; p.p = p.p || {}; p.warn = p.warn || {}; p.cd = p.cd || {}; p.gone = p.gone || []; p.haunt = p.haunt || {}; p.mailed = p.mailed || {};
    if (typeof p.skew !== 'number') p.skew = 0; if (!p.t) p.t = clock(); if (p.grace == null) p.grace = clock() + TUNE.GRACE * DAY; if (p.day == null) p.day = gday(clock());
    (S.ghosts || []).forEach(g => { if (typeof p.p[g.id] !== 'number') p.p[g.id] = 100; });
    return p;
  }
  function cst() {
    if (!S_()) return null;
    const c = S.contract = S.contract || { rank:0, state:'none', start:0, end:0, kpi:0, target:0, taunted:false, crisis:null, hist:[] };
    c.hist = c.hist || []; return c;
  }
  const isAfu = (g) => g && g.k === 'afu';
  function val(g) { const p = st(); return p && g ? (typeof p.p[g.id] === 'number' ? p.p[g.id] : 100) : 100; }
  function set(g, v) { const p = st(); p.p[g.id] = Math.max(0, Math.min(100, v)); if (p.p[g.id] > TUNE.WARN + 5) delete p.warn[g.id]; if (p.p[g.id] > TUNE.COUNT) delete p.cd[g.id]; }
  function add(g, amt) { if (!g) return; if (isAfu(g) && cst().state === 'crisis') return; set(g, val(g) + amt); }

  // ---------- 職級好處 ----------
  function perk(name) {
    const r = (cst() && cst().rank) || 0;
    if (name === 'squad') return (r >= 1 ? 1 : 0) + (r >= 3 ? 1 : 0); // 回陽間多帶幾隻（scare.js 可讀）
    if (name === 'decay') return r >= 4 ? 0.7 : r >= 1 ? 0.85 : 1;
    if (name === 'ripple') return r >= 2 ? 3 : 0;
    if (name === 'atk') return r >= 4 ? 1.05 : r >= 2 ? 1.03 : 1;
    return 0;
  }

  // ---------- 流失 ----------
  function update() {
    const p = st(), c = cst(); if (!p) return;
    const now = clock(), from = Math.max(p.t, p.grace), dt = Math.max(0, now - from), offline = now - p.t > 6 * HOUR;
    p.t = now;
    if (dt > 0) {
      const d = TUNE.DECAY * perk('decay') * dt / DAY;
      for (const g of S.ghosts) {
        let v = val(g) - d;
        if (isAfu(g)) v = c.state === 'crisis' ? Math.min(val(g), 18) : Math.max(TUNE.AFU_FLOOR, v);
        else if (offline && !p.warn[g.id]) v = Math.max(Math.min(val(g), TUNE.OFFLINE_FLOOR), v);
        p.p[g.id] = Math.max(0, Math.min(100, v));
      }
    }
    if (c.state === 'crisis') { const a = S.ghosts.find(isAfu); if (a) p.p[a.id] = Math.min(val(a), 18); }
    // 警告 → 倒數 → 魂飛魄散
    const newWarn = [];
    for (const g of S.ghosts) {
      if (isAfu(g)) continue; const v = val(g);
      if (v <= TUNE.WARN && !p.warn[g.id]) { p.warn[g.id] = 1; newWarn.push(g); }
      if (v <= TUNE.COUNT && p.warn[g.id] && !p.cd[g.id]) { p.cd[g.id] = now + TUNE.CD_DAYS * DAY; try { Fx.toast(`<b>${g.name}</b> 存在感只剩 ${Math.round(v)}：魂飛魄散倒數 ${TUNE.CD_DAYS} 日`); } catch (e) {} }
      if (p.cd[g.id] && now >= p.cd[g.id] && v <= TUNE.COUNT && !scenes.some(s => s.kind === 'farewell' && s.g === g)) scenes.push({ kind:'farewell', g });
    }
    if (newWarn.length) scenes.push({ kind:'mail', list:newWarn });
    // 新一日：嚇過人嘅地點仲有傳說流傳
    const today = gday(now);
    if (today !== p.day) { p.day = today; for (const g of S.ghosts) { const locs = p.haunt[g.id]; if (!locs || !locs.length) continue; let s = 0; for (const l of locs) s += legendLv(l); if (s > 0) add(g, Math.min(TUNE.DAILY_LEGEND, s)); } }
  }
  function legendLv(loc) {
    try { if (typeof Scare !== 'undefined' && Scare.legend) { const r = Scare.legend(loc); return typeof r === 'number' ? r : (r && (r.lv || r.legendLv || r.level)) || 0; } } catch (e) {}
    return 0;
  }
  function daysLeft(g) { const p = st(); return p.cd[g.id] ? Math.max(0, Math.ceil((p.cd[g.id] - clock()) / DAY)) : null; }

  // ---------- 回陽間收工 ----------
  function findG(key) { return S.ghosts.find(g => g.id === key) || S.ghosts.find(g => g.k === key); }
  function nightEnd(d) {
    if (!S_() || !d) return null;
    update();
    const p = st(), c = cst(), stars = Math.max(0, Math.min(3, d.stars | 0)), lv = d.legendLv | 0;
    const ripple = TUNE.RIPPLE + TUNE.RIPPLE_STAR * stars + perk('ripple');
    const squad = new Set((d.ghosts || []).map(findG).filter(Boolean));
    const per = d.perGhost || {};
    for (const k in per) { const g = findG(k); if (g) squad.add(g); }
    if (c.state === 'crisis' && stars >= 1) { /* 阿福會喺補救場景之後先恢復 */ }
    let sq = 0;
    for (const g of S.ghosts) {
      if (isAfu(g) && c.state === 'crisis') continue;
      let a = ripple;
      if (squad.has(g)) { const sc = (per[g.id] || per[g.k] || {}).scares | 0; const b = Math.min(TUNE.SQUAD_CAP, TUNE.SQUAD + TUNE.SQUAD_SCARE * Math.min(6, sc)); a += b; sq = Math.max(sq, b);
        if (d.loc) { const h = p.haunt[g.id] = p.haunt[g.id] || []; if (!h.includes(d.loc)) h.push(d.loc); } }
      else if (d.loc && p.haunt[g.id] && p.haunt[g.id].includes(d.loc)) a += TUNE.LEGEND * lv;
      set(g, val(g) + a);
    }
    const pts = kpiOf(d);
    if (c.state === 'active') c.kpi += pts;
    if (c.state === 'crisis' && stars >= 1) c.crisis.ok = true;
    try { Fx.toast(`回陽間收工：全村存在感 +${ripple}${sq ? `，出動的鬼再 +${sq}` : ''}${c.state === 'active' ? `；合約 KPI +${pts}` : ''}`); } catch (e) {}
    try { save(); } catch (e) {}
    return { ripple, squad:sq, pts };
  }
  function kpiOf(d) { const stars = Math.max(0, Math.min(3, d.stars | 0)); return 10 * stars + Math.min(25, 5 * (d.legendLv | 0)) + ((d.score | 0) > 0 ? 5 : 0) - (d.exorcised ? 5 : 0); }

  // ---------- 合約 ----------
  function rankOf(i) { return PRES_RANKS[Math.min(i, PRES_RANKS.length - 1)]; }
  function newPeriod(extra) {
    const c = cst(), r = rankOf(c.rank), now = clock();
    Object.assign(c, { state:'active', start:now, end:now + (r.days + (extra || 0)) * DAY, kpi:0, target:r.target, taunted:false, crisis:null });
  }
  const has = (k) => cur === k || scenes.some(s => s.kind === k); // 正在播嗰幕都算（避免重複排隊）
  function contractTick() {
    const c = cst(), now = clock(), a = S.ghosts.find(isAfu);
    if (c.state === 'none') { if (seen('ch1_end') && !has('issue')) scenes.push({ kind:'issue' }); return; }
    if (c.state === 'active') {
      if (c.kpi >= c.target && !has('promote')) { scenes.push({ kind:'promote' }); return; }
      if (now >= c.end && c.kpi < c.target && !has('crisis')) { scenes.push({ kind:'crisis' }); return; }
      const el = (now - c.start) / (c.end - c.start);
      if (!c.taunted && el > 0.55 && c.kpi < c.target * 0.5 && !has('taunt')) scenes.push({ kind:'taunt' });
    }
    if (c.state === 'crisis') {
      if (a) st().p[a.id] = Math.min(val(a), 18);
      if (c.crisis.ok && !has('redeem')) scenes.push({ kind:'redeem' });
      else if (!c.crisis.ok && now >= c.crisis.end && !has('more')) scenes.push({ kind:'more' });
    }
  }

  // ---------- 劇場 ----------
  const ART3 = { 阿福:'afu', 冼小姐:'npc_hr', 龐總:'npc_kpiboss', Bryan:'npc_rival' };
  const LOOK = { 龐總:{ base:'ag:inspect', talk:'ag:tap' }, Bryan:{ base:'ag:spin', talk:'ag:dribble' }, 冼小姐:{ base:'ag:clip', talk:'ag:glasses' } };
  function keyOf(n) { if (ART3[n]) return ART3[n]; for (const k in GHOSTS) if (GHOSTS[k].name === n) return k; return null; }
  function reactor(not) {
    const pool = ['xiaozhi', 'mengpo', 'eguiking', 'tianhua', 'laojiang', 'toyol'].filter(k => S.ghosts.some(g => g.k === k) && (!not || k !== not.k));
    if (pool.length) return S.ghosts.find(g => g.k === pool[0]);
    return S.ghosts.find(g => !isAfu(g) && g !== not && GHOSTS[g.k]) || null;
  }
  function stage(lines, g, title, tag, cb) {
    const R = reactor(g);
    const nm = (w) => w === 'G' ? (g ? g.name : '？') : w === 'R' ? (R ? R.name : '小紙') : w;
    const lns = lines.map(l => [nm(l[0]), T(l).split('{n}').join(g ? g.name : ''), l[3] || null]);
    const names = []; for (const l of lns) if (l[0] !== '旁白' && l[0] !== '系統' && !names.includes(l[0])) names.push(l[0]);
    const cast = names.slice(0, 4).map(n => { let k = n === (g && g.name) ? g.k : n === (R && R.name) ? R.k : keyOf(n); return [n, k || 'afu', LOOK[n] ? Object.assign({}, LOOK[n]) : undefined]; });
    Theater.play({ tag, title, bg:'village', cast, lines:lns }, cb);
  }
  function chat(lines, title, cb) { Story.queue({ style:'chat', title, group:'小紙、孟婆、餓鬼王、Toyol…', av:['村', '#3f6a5a'], lines:lines.map(l => [l[0], T(l)]) }, cb); }
  function quiet() {
    if (playing || (typeof Theater !== 'undefined' && Theater.on)) return false;
    if (typeof Skits !== 'undefined' && Skits.quiet) return Skits.quiet();
    return !(typeof Story !== 'undefined' && Story.busy()) && !(typeof Battle !== 'undefined' && Battle.active);
  }
  function runScene(s) {
    const c = cst(), done = () => { playing = false; cur = null; sceneGap = 4; try { save(); } catch (e) {} try { UI.refresh && UI.refresh(); } catch (e) {} hud(); };
    playing = true; cur = s.kind;
    if (s.kind === 'issue') {
      stage(PRES_TXT.issue, null, '試用期合約', '合約', () => { newPeriod(3); done(); try { Fx.toast(`試用期合約：<b>${PRES_RANKS[0].days + 3} 日</b>內 KPI ${PRES_RANKS[0].target}。右下角可以查看合約。`); } catch (e) {} });
    } else if (s.kind === 'taunt') {
      c.taunted = true; stage(rnd(PRES_TXT.taunt), null, 'Bryan 的冷嘲熱諷', '合約', done);
    } else if (s.kind === 'promote') {
      const top = c.rank >= PRES_RANKS.length - 1, nr = Math.min(c.rank + 1, PRES_RANKS.length - 1);
      const lines = top ? PRES_TXT.renew : PRES_TXT.promote[nr];
      stage(lines, null, top ? '年度考核' : `升職：${PRES_RANKS[nr].name}`, '合約', () => {
        c.hist.push({ rank:c.rank, ok:true, at:clock() });
        if (!top) { c.rank = nr; if (nr === 3) try { give({ coins:3000 }); } catch (e) {} } else try { give({ coins:2000 }); } catch (e) {}
        newPeriod(0); done(); try { Fx.toast(top ? '年度考核過關：花紅 冥幣 2000' : `升職：<b>${PRES_RANKS[nr].name}</b>　解鎖：${PRES_RANKS[nr].unlock}`); } catch (e) {}
      });
    } else if (s.kind === 'crisis') {
      c.hist.push({ rank:c.rank, ok:false, at:clock() }); c.state = 'crisis'; c.crisis = { end:clock() + 3 * DAY, ok:false };
      const a = S.ghosts.find(isAfu); if (a) st().p[a.id] = 18;
      stage(PRES_TXT.crisis, null, '淡化危機', '合約', () => chat(PRES_TXT.crisis_chat, '落魄村村民群', done));
    } else if (s.kind === 'redeem') {
      stage(PRES_TXT.redeem, null, '被記起', '合約', () => { const a = S.ghosts.find(isAfu); newPeriod(0); if (a) set(a, 100); done(); try { Fx.toast('阿福被記起了：合約重新計日'); } catch (e) {} });
    } else if (s.kind === 'more') {
      c.crisis.end = clock() + 3 * DAY; stage(PRES_TXT.crisis_more, null, '延期', '合約', done);
    } else if (s.kind === 'mail') {
      const list = s.list.filter(g => S.ghosts.includes(g) && val(g) <= TUNE.WARN).map(g => g.name).join('、'); if (!list) { done(); return; }
      Story.queue({ style:'mail', title:'存在感不足警告', lines:PRES_TXT.warn_mail.map(l => [l[0], T(l).split('{list}').join(list)]) }, done);
    } else if (s.kind === 'farewell') {
      const g = s.g; if (!S.ghosts.includes(g) || val(g) > TUNE.COUNT) { done(); return; }
      stage(rnd(PRES_FAREWELL), g, `${g.name}・魂飛魄散`, '道別', () => { vanish(g); done(); });
    } else if (s.kind === 'amnesia') {
      stage(rnd(PRES_AMNESIA), s.g, `${s.g.name}・失憶回歸`, '重新招魂', done);
    } else done();
  }

  // ---------- 魂飛魄散／重新招魂 ----------
  function vanish(g) {
    const p = st();
    p.gone.push({ k:g.k, name:g.name, q:g.q, lv:g.lv, st:g.st, arch:g.arch || null, at:clock() });
    S.ghosts = S.ghosts.filter(x => x !== g); S.team = S.team.map(x => x === g.id ? null : x); if (S.adviser === g.id) S.adviser = null;
    delete p.p[g.id]; delete p.warn[g.id]; delete p.cd[g.id]; delete p.haunt[g.id];
    try { Fx.toast(`<b>${g.name}</b> 魂飛魄散了。可以在招魂台重新招魂（會失憶）。`); } catch (e) {}
    try { save(); UI.refresh(); } catch (e) {}
  }
  function resummon(i, silent) {
    const p = st(), o = p.gone[i]; if (!o) return null;
    const named = o.q === '名';
    if (!named && typeof fodderCount === 'function' && fodderCount() >= F.rosterCap()) { try { Fx.toast('雜鬼名額已滿'); } catch (e) {} return null; }
    const c = F.recruitCost(); if (!silent) { if (!canPay(c)) { try { Fx.toast('冥幣或壽包不夠'); } catch (e) {} return null; } pay(c); }
    let g;
    if (named) { joinGhost(o.k); g = S.ghosts.find(x => x.k === o.k); }
    else { g = { id:'g' + (S.uid++), k:o.k, name:o.name, q:o.q, lv:1, st:o.st, post:null, spent:0, arch:o.arch }; S.ghosts.push(g); }
    if (!g) return null;
    g.lv = Math.max(1, Math.round((o.lv || 1) * 0.5));
    p.gone.splice(i, 1); set(g, 70);
    if (typeof BOND_FEUDS !== 'undefined' && S.bonds && S.bonds.feud) for (const Fd of BOND_FEUDS) if (Fd.a === g.k || Fd.b === g.k) delete S.bonds.feud[Fd.id]; // 冤家由頭嚟過
    scenes.unshift({ kind:'amnesia', g });
    try { save(); UI.refresh(); } catch (e) {}
    return g;
  }

  // ---------- 畫面：透明、閃 ----------
  function alphaOf(g) {
    if (!g) return 1; const v = val(g);
    if (v >= TUNE.FADE) return 1;
    let a = 0.3 + 0.7 * (v / TUNE.FADE);
    if (v < 15 && Math.random() < 0.12) a *= 0.25; // 閃
    return a;
  }
  function gOfKey(k) { if (!S_() || !S.ghosts) return null; if (k === 'afu') return S.ghosts.find(isAfu); const gs = S.ghosts.filter(g => g.k === k); return gs.length === 1 && gs[0].q === '名' ? gs[0] : null; }
  function statMult(g) { const v = val(g); return v >= TUNE.LOWSTAT ? 1 : 0.9 + 0.1 * v / TUNE.LOWSTAT; }

  // ---------- 名冊／招魂台／合約面板 ----------
  function bar(v) { const col = v > TUNE.FADE ? '#6ec27a' : v > TUNE.WARN ? '#e0b44a' : '#e0604a'; return `<span style="display:inline-block;vertical-align:middle;width:70px;height:7px;border-radius:4px;background:rgba(0,0,0,.18);overflow:hidden;margin:0 4px"><i style="display:block;height:100%;width:${Math.round(v)}%;background:${col}"></i></span>`; }
  function badge(g) { const v = val(g), d = daysLeft(g); return d != null ? `<b style="color:#c0392b">魂飛魄散倒數 ${d} 日</b>` : v <= TUNE.WARN ? '<b style="color:#c0392b">⚠ 存在感不足</b>' : v < TUNE.FADE ? '<span style="color:#9a7a3a">變淡中</span>' : ''; }
  function paintSheet() {
    const sh = document.querySelector('#sheet'); if (!sh || !S_()) return;
    sh.querySelectorAll('.gcard').forEach(c => {
      if (c.querySelector('.presln')) return; const main = c.querySelector('.gc-main'); if (!main) return;
      const up = c.querySelector('[data-up],[data-rel]'); let g = up ? S.ghosts.find(x => x.id === (up.dataset.up || up.dataset.rel)) : null;
      if (!g) { const nm = main.querySelector('b'); g = nm && S.ghosts.find(x => x.name === nm.textContent); }
      if (!g) return; const v = val(g);
      const e = document.createElement('small'); e.className = 'tr presln'; e.innerHTML = `存在感 ${Math.round(v)}${bar(v)}${badge(g)}`; main.appendChild(e);
      const cv = c.querySelector('canvas'); if (cv) cv.style.opacity = alphaOf(g);
      if (isAfu(g) && cst().rank >= 5) { c.style.boxShadow = '0 0 0 2px #d9b440, 0 0 10px rgba(217,180,64,.55)'; c.style.borderRadius = '10px'; } // 合夥鬼：名冊金邊
    });
    const rc = sh.querySelector('[data-act=recruit]');
    if (rc && !sh.querySelector('#pres-gone')) {
      const p = st(); if (!p.gone.length) return;
      const d = document.createElement('div'); d.id = 'pres-gone';
      d.innerHTML = `<h4 class="stand-h">魂飛魄散名單</h4><p class="desc">淡走了的鬼，招魂台上還留著寫有他們名字的黃紙。重新招魂費用跟招魂一樣；回來的會失憶（等級剩一半，冤家關係重新開始）。</p>` +
        p.gone.map((o, i) => `<div class="row"><span>${o.name}　Lv${o.lv}</span><button class="btn sm gold" data-regone="${i}">重新招魂</button></div>`).join('');
      rc.closest('.row').parentNode.appendChild(d);
      d.querySelectorAll('[data-regone]').forEach(b => b.onclick = () => { const g = resummon(+b.dataset.regone); if (g) { UI.close(); } });
    }
  }
  function panelHTML() {
    const c = cst(), r = rankOf(c.rank), now = clock();
    let h = '';
    if (c.state === 'none') h += `<p class="desc">打完第一章後，龐總會來跟你簽試用期合約。</p>`;
    else {
      h += `<p class="desc">職級：<b>${PRES_RANKS[c.rank].name}</b>${c.rank >= PRES_RANKS.length - 1 ? '（年度考核）' : ''}</p>`;
      if (c.state === 'active') {
        const left = Math.max(0, (c.end - now) / DAY), pr = Math.min(1, c.kpi / c.target);
        h += `<p class="desc">KPI ${c.kpi}／${c.target}<span style="display:block;height:10px;border-radius:5px;background:rgba(0,0,0,.18);overflow:hidden;margin:4px 0"><i style="display:block;height:100%;width:${pr * 100}%;background:#d9a441"></i></span>剩下 <b>${left.toFixed(1)}</b> 日</p>`;
      } else h += `<p class="desc" style="color:#c0392b"><b>淡化危機</b>：${Math.max(0, (c.crisis.end - now) / DAY).toFixed(1)} 日內回陽間完成一晚（一星或以上），阿福就會被記起。不會遊戲結束。</p>`;
      const nx = PRES_RANKS[c.rank + 1]; h += `<p class="desc">${nx ? `下一級：<b>${nx.name}</b>　解鎖：${nx.unlock}` : '已經是最高職級。每期過關有花紅。'}</p>`;
      h += `<p class="desc">KPI 怎樣算：每晚回陽間，每顆星 10 分；傳說熱度每級 5 分（最多 25）；有驚嚇值 5 分；被道士請走扣 5 分。</p>`;
    }
    h += `<h4 class="stand-h">村裡的存在感</h4><p class="desc">鬼要有人記得才存在。每天自然流失 ${(TUNE.DECAY * perk('decay')).toFixed(1)}；回陽間一晚全村 +${TUNE.RIPPLE}～${TUNE.RIPPLE + TUNE.RIPPLE_STAR * 3 + perk('ripple')}，出動的鬼更多。上台講棟篤笑、打贏仗、在陰間日常出場也有少少。</p>`;
    const p = st(); if (clock() < p.grace) h += `<p class="desc">新功能保護期：還有 ${((p.grace - clock()) / DAY).toFixed(1)} 日不會流失。</p>`;
    h += S.ghosts.slice().sort((a, b) => val(a) - val(b)).map(g => `<div class="row"><span>${g.name}</span><span>${Math.round(val(g))}${bar(val(g))}${badge(g)}</span></div>`).join('');
    return h;
  }
  function openPanel() { try { UI.sheet('合約與存在感', panelHTML()); } catch (e) {} }
  function hud() {
    const wrap = document.getElementById('stagewrap'); if (!wrap || !S_()) return;
    let el = document.getElementById('pres-chip'); const c = cst();
    if (c.state === 'none') { if (el) el.remove(); return; }
    if (!el) { el = document.createElement('div'); el.id = 'pres-chip'; wrap.appendChild(el); el.onclick = openPanel;
      const s = document.createElement('style'); s.textContent = '#pres-chip{position:absolute;right:8px;bottom:8px;z-index:4;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13px;line-height:1.45;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45);cursor:pointer;text-align:right}#pres-chip.cr{box-shadow:inset 0 0 0 1.5px #e0604a;color:#ffb4a0}'; document.head.appendChild(s); }
    const now = clock(); const warnN = S.ghosts.filter(g => !isAfu(g) && val(g) <= TUNE.WARN).length;
    const h = c.state === 'crisis' ? `<b>淡化危機</b>　剩 ${Math.max(0, (c.crisis.end - now) / DAY).toFixed(1)} 日` : `<b>${PRES_RANKS[c.rank].name}</b>　KPI ${c.kpi}/${c.target}　剩 ${Math.max(0, (c.end - now) / DAY).toFixed(1)} 日${warnN ? `<br>⚠ ${warnN} 隻鬼存在感不足` : ''}`;
    if (el.innerHTML !== h) el.innerHTML = h; el.className = c.state === 'crisis' ? 'cr' : '';
  }

  // ---------- 主循環 ----------
  function tick() {
    if (!S_() || !S.ghosts) return;
    update(); contractTick(); hud();
    if (sceneGap > 0) { sceneGap -= 2; return; }
    if (scenes.length && quiet()) { const s = scenes.shift(); runScene(s); }
  }

  // ---------- 接駁 ----------
  function init() {
    if (started) return; started = true;
    st(); cst();
    window.addEventListener('gb:nightEnd', (e) => { try { nightEnd(e.detail || {}); } catch (err) { console.error(err); } });
    if (typeof ART !== 'undefined' && ART.drawChar) {
      const od = ART.drawChar;
      ART.drawChar = function (ctx, k, x, y, s, o) {
        if (!inPlaza && S_() && S.presence) {
          const g = o && o.wkey != null ? S.ghosts.find(z => z.id === o.wkey) : gOfKey(k);
          const m = g ? alphaOf(g) : 1;
          if (m < 1) { o = Object.assign({}, o || {}); o.alpha = (o.alpha != null ? o.alpha : ctx.globalAlpha) * m; }
        }
        return od.call(this, ctx, k, x, y, s, o);
      };
    }
    if (typeof PlazaLife !== 'undefined' && PlazaLife.frame) {
      const of = PlazaLife.frame;
      PlazaLife.frame = function (V, idle, items, vis, ctx, t) {
        const i0 = items.length, v0 = vis.length; const r = of.apply(this, arguments);
        const nv = vis.slice(v0), ag = items.slice(items.length - nv.length);
        if (items.length - i0 >= nv.length) ag.forEach((it, j) => { const g = nv[j] && nv[j].g; const f = it.f; it.f = () => { const m = alphaOf(g); inPlaza = true; ctx.save(); ctx.globalAlpha *= m; try { f(); } finally { ctx.restore(); inPlaza = false; } }; });
        return r;
      };
    }
    if (typeof Village !== 'undefined' && Village.update) { // 存在感低：碎碎念換成擔心說話
      const ou = Village.update;
      Village.update = function () {
        const r = ou.apply(this, arguments);
        try { const b = this.bubble; if (b && b !== lastBub) { lastBub = b; const g = b.hero ? S.ghosts.find(isAfu) : S.ghosts.find(x => x.id === b.id);
          if (g && !isAfu(g) && val(g) <= TUNE.WARN && b.t < 0.2 && Math.random() < 0.6) { const d = daysLeft(g); const pool = d != null ? PRES_COUNT : PRES_WORRY; const l = rnd(pool); b.text = (zh() ? l[1] : l[0]).split('{n}').join(g.name).split('{d}').join(d != null ? d : ''); } } } catch (e) {}
        return r;
      };
    }
    if (typeof Battle !== 'undefined') {
      if (Battle.mkGhostUnit) { const om = Battle.mkGhostUnit; Battle.mkGhostUnit = function (g) { const u = om.apply(this, arguments); try { const m = statMult(g) * perk('atk'); u.atk *= m; const hm = statMult(g); u.hp *= hm; u.maxhp *= hm; } catch (e) {} return u; }; }
      if (Battle.finish) { const of = Battle.finish; Battle.finish = function (win) { try { if (win && !this.result) (this.units || []).filter(u => u.side === 0 && u.gid).forEach(u => add(S.ghosts.find(g => g.id === u.gid), TUNE.WIN)); } catch (e) {} return of.apply(this, arguments); }; }
    }
    if (typeof Standup !== 'undefined' && Standup.play) { const op = Standup.play; Standup.play = function (id, opt) { try { const b = (Standup.list || []).find(x => x.id === id); if (b && !(opt && opt.replay)) add(S.ghosts.find(g => g.k === b.k), TUNE.STANDUP); } catch (e) {} return op.apply(this, arguments); }; }
    if (typeof Theater !== 'undefined' && Theater.play) { const op = Theater.play; Theater.play = function (sc) { try { if (sc && sc.tag === '陰間日常') (sc.cast || []).forEach(c => { const g = S.ghosts.find(x => x.k === c[1] && x.q === '名'); if (g) add(g, TUNE.SKIT); }); } catch (e) {} return op.apply(this, arguments); }; }
    const sh = document.querySelector('#sheet');
    if (sh && typeof MutationObserver !== 'undefined') new MutationObserver(() => { if (sh.querySelector('.gcard,[data-act=recruit]')) paintSheet(); }).observe(sh, { childList:true, subtree:true });
    setInterval(tick, 2000); tick();
  }
  // 測試／示範用
  const dev = {
    days(n) { const p = st(); p.skew += n * DAY; update(); contractTick(); hud(); },
    set(g, v) { set(g, v); }, scenes:() => scenes, run() { if (scenes.length) runScene(scenes.shift()); },
    play(kind, extra) { runScene(Object.assign({ kind }, extra || {})); },
    issue() { newPeriod(3); }, newPeriod, vanish, resummon,
  };
  return { TUNE, st, cst, val, add, perk, alphaOf, statMult, nightEnd, kpiOf, update, contractTick, daysLeft, openPanel, panelHTML, hud, init, tick, dev, get playing() { return playing; } };
})();
(function presenceBoot() { if (typeof S === 'undefined' || !S || typeof Village === 'undefined' || !document.querySelector('#sheet')) { setTimeout(presenceBoot, 300); return; } try { Presence.init(); } catch (e) { console.error(e); } })();
