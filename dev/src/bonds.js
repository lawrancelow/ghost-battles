// ===================== 收服劇情＋冤家（bonds.js）：引擎 =====================
// 劇本喺 bonds_data.js（BOND_RECRUIT、BOND_FEUDS）。
// 存檔：S.bonds = { rec:{鬼:1}, pend:[鬼], feud:{id:{st, picks, end, wait}}, gap }
// 接駁（唔改原檔）：joinGhost 包一層（收服 → 排隊播入村劇情）；Rivals.tick 包一層（安靜＋有操作時先出場）；
// GhostStreet.battleBuffs 包一層（冤家同隊加成／減益＋戰鬥對白）；UI.openStory 加重溫；名冊用 MutationObserver 加「冤家」一行。
const Bonds = (() => {
  const ART3 = { 阿福:'afu', 冼小姐:'npc_hr', 龐總:'npc_kpiboss', Bryan:'npc_rival' };
  const LOOK = { 龐總:{ base:'ag:inspect', talk:'ag:tap' }, Bryan:{ base:'ag:spin', talk:'ag:dribble' }, 冼小姐:{ base:'ag:clip', talk:'ag:glasses' } };
  const WRITTEN = { 旁白:1, 系統:1, 主播:1 };
  const XWHO = { hr:'冼小姐', boss:'龐總', bryan:'Bryan' };
  const END_ZH = { friends:'和好', rivals:'死對頭', united:'同仇敵愾' };
  const GAP_ANY = 150, GAP_FEUD1 = 260, GAP_FEUD2 = 420; // 有操作嘅秒數
  const seen = (id) => !!(S && S.seen && S.seen[id]);
  const owned = (k) => !!(S && S.ghosts && S.ghosts.some(g => g.k === k));
  const gname = (k) => (typeof GHOSTS !== 'undefined' && GHOSTS[k] && GHOSTS[k].name) || k;
  const zh = () => typeof LANG === 'undefined' || LANG.cur !== 'yue';
  const T = (p) => Array.isArray(p) ? (zh() ? (p[1] != null ? p[1] : p[0]) : p[0]) : p; // [粵, 中]
  const art = (k) => typeof sprOk !== 'function' || sprOk(k);
  let started = false, mo = null;

  function st() {
    if (typeof S === 'undefined' || !S) return null;
    if (!S.bonds) { // 第一次：已經有嘅鬼當睇過（舊存檔唔會一次過彈晒出嚟）
      S.bonds = { rec:{}, pend:[], feud:{}, gap:0 };
      (S.ghosts || []).forEach(g => { if (BOND_RECRUIT[g.k]) S.bonds.rec[g.k] = 1; });
    }
    const b = S.bonds; b.rec = b.rec || {}; b.pend = b.pend || []; b.feud = b.feud || {}; if (typeof b.gap !== 'number') b.gap = 0;
    return b;
  }
  function fs(id) { const b = st(); const f = b.feud[id] = b.feud[id] || {}; if (typeof f.st !== 'number') f.st = 0; f.picks = f.picks || []; if (typeof f.wait !== 'number') f.wait = 0; f.end = f.end || null; return f; }

  // ---------- 角色 ----------
  function keyOf(name) {
    if (ART3[name]) return ART3[name];
    if (typeof GHOSTS !== 'undefined') for (const k in GHOSTS) if (GHOSTS[k].name === name) return k;
    return null;
  }
  function reactor(k, rl) {
    for (const r of (rl || [])) if (r !== k && owned(r)) return r;
    const pool = (S.ghosts || []).map(g => g.k).filter(x => x !== k && x !== 'afu' && BOND_RECRUIT[x] && art(x));
    if (pool.length) return pool[Math.floor(Math.random() * pool.length)];
    return owned('xiaozhi') && k !== 'xiaozhi' ? 'xiaozhi' : 'afu';
  }
  // [說話者, 粵, 中, 動作?, {A/B: 動作}?, 特效?] → Theater 格式
  function conv(lines, map) {
    return lines.map(l => {
      const who = map[l[0]] || l[0], text = zh() || WRITTEN[who] ? l[2] : l[1]; // 旁白／系統／主播：一律書面語
      let act = l[3] || null; const re0 = l[4] || null; let re = null;
      if (re0) { re = {}; for (const n in re0) re[map[n] || n] = re0[n]; }
      if (!act && LOOK[who] && /[！？]/.test(text) && Math.random() < 0.5) act = who === 'Bryan' ? 'ag:jump' : who === '龐總' ? 'ag:yell' : 'ag:stamp';
      return [who, text, act, re, l[5] || null];
    });
  }
  function castFor(lines, first, map) {
    const names = []; const add = (n) => { if (n && !names.includes(n) && n !== '旁白' && n !== '系統' && n !== '主播' && keyOf(n)) names.push(n); };
    first.forEach(add); lines.forEach(l => add(map[l[0]] || l[0]));
    return names.slice(0, 4).map(n => { const k = keyOf(n); return [n, k, LOOK[n] ? Object.assign({}, LOOK[n]) : undefined]; });
  }

  // ---------- 收服劇情 ----------
  const TAG = { stage:'收服劇情', hr:'入職面試', boss:'入職 KPI', chat:'村民群組', news:'陰間新聞台', sys:'系統通知' };
  const BG = { stage:'village', hr:'hq', boss:'hq' };
  function playRecruit(k, cb, opt) {
    const d = BOND_RECRUIT[k]; if (!d) { cb && cb(); return false; }
    opt = opt || {};
    const R = opt.r || reactor(k, d.r); const map = { 新:gname(k), R:gname(R) };
    const title = `${gname(k)}入村`;
    const fin = (res) => { cb && cb(res); };
    if (d.f === 'chat' || d.f === 'news' || d.f === 'sys') {
      let hh = 21, mm = 3;
      const lines = d.lines.map(l => { const who = map[l[0]] || l[0], t = zh() || WRITTEN[who] ? l[2] : l[1];
        if (d.f !== 'chat') return [who, t];
        mm += 1 + Math.floor(Math.random() * 2); if (mm > 59) { mm -= 60; hh++; }
        return [who, who === '旁白' ? t : `${String(hh).padStart(2, '0')}:${String(mm).padStart(2, '0')}|${t}`]; });
      const sc = d.f === 'chat' ? { style:'chat', title:'落魄村村民群', group:`${gname(k)}、${gname(R)}、阿福…`, av:['村', '#3f6a5a'], lines }
        : d.f === 'news' ? { style:'news', title:'陰間新聞台', lines } : { style:'sys', title:'陰司系統通知', lines };
      Story.queue(sc, () => fin({ skipped:false })); return true;
    }
    const lines = conv(d.lines, map);
    const first = d.f === 'hr' ? ['冼小姐', map.新] : d.f === 'boss' ? ['龐總', map.新] : [map.新];
    const cast = castFor(d.lines, first, map);
    Theater.play({ tag:TAG[d.f] || '收服劇情', title, bg:BG[d.f] || 'village', cast, lines }, fin);
    return true;
  }
  function recruitNow(k) {
    const b = st(); if (!b || b.rec[k]) return false;
    b.pend = b.pend.filter(x => x !== k); b.gap = 0;
    playRecruit(k, () => { b.rec[k] = 1; try { save(); } catch (e) {} });
    return true;
  }

  // ---------- 冤家 ----------
  const OPENERS = [
    ['旁白', '兩隻鬼對望，擺好架勢。', '兩隻鬼對望，擺好架勢。', null, { A:'pose:strike', B:'pose:strike' }, 'shake'],
    ['旁白', '空氣突然靜咗。遠處有隻烏鴉，識趣咁飛走咗。', '空氣突然安靜下來。遠處有一隻烏鴉，識趣地飛走了。', null, { A:'pose:strike', B:'pose:strike' }, 'shake'],
    ['旁白', '兩隻鬼同時出招——停喺半空，邊個都冇打落去。', '兩隻鬼同時出招——停在半空，誰都沒打下去。', null, { A:'pose:strike', B:'pose:strike' }, 'shake,flash'],
  ];
  const TO_BE = ['旁白', '（兩隻鬼約好：下次再嘈。）', '（兩隻鬼約好了：下次再吵。）'];
  function endOf(picks) {
    if (picks.includes('c')) return 'united';
    return picks[0] === picks[1] ? 'rivals' : 'friends';
  }
  function feudScene(F, stage, picks, cb, replay) {
    const A = gname(F.a), B = gname(F.b), X = XWHO[F.x], map = { A, B };
    const s = F['s' + stage];
    const lines = conv([OPENERS[(F.id.length + stage) % OPENERS.length]].concat(s.lines), map);
    const finish = (picks2) => {
      if (stage === 1) return conv([TO_BE], map);
      const e = endOf(picks2); const out = conv(F.end[e], map);
      out.push(['旁白', `【冤家結局：${END_ZH[e]}】`, null, e === 'rivals' ? { [A]:'pose:strike', [B]:'pose:strike' } : null, e === 'friends' ? 'joss' : e === 'rivals' ? 'shake' : 'flash']);
      return out;
    };
    const opt = (k) => { const o = s[k]; return { lines:conv(o.lines, map), on:(p) => finish(stage === 1 ? p : (picks || []).concat(p)) }; };
    const xl = s.x.label ? s.x.label[1] || s.x.label[0] : '交俾第三方';
    const choice = { q:`${A}和${B}吵起來了。阿福站哪一邊？`,
      a:Object.assign({ label:`站${A}那邊` }, opt('a')), b:Object.assign({ label:`站${B}那邊` }, opt('b')), c:Object.assign({ label:xl }, opt('x')), plain:true };
    const cast = [[A, F.a], ['阿福', 'afu'], [B, F.b], [X, ART3[X], Object.assign({}, LOOK[X])]];
    Theater.play({ tag:'冤家', title:`${T(F.title)}（${stage}／2）`, bg:'village', cast, xs:[0.15, 0.4, 0.85, 0.63], lines, choice }, cb);
    try { // 第三方先唔出場：揀咗 x 先飄入嚟
      const c = Theater.cast(); const xa = c[3]; if (xa) { xa.tx = xa.px; const oc = choice.c.on; choice.c.on = (p) => { xa.tx = xa.home; const af = c[1]; if (af) af.tx = Theater.size().W * 0.36; return oc(p); }; }
    } catch (e) {}
  }
  function playFeud(id, cb, opt) {
    opt = opt || {};
    const F = BOND_FEUDS.find(f => f.id === id); if (!F) return false;
    const f = opt.replay ? { st:(opt.stage || 1) - 1, picks:(opt.picks || []).slice() } : fs(id);
    const stage = f.st + 1; if (stage > 2) return false;
    feudScene(F, stage, f.picks, (res) => {
      if (opt.replay || !res || res.skipped || !res.choice) { cb && cb(res); return; } // 跳過：下次再嚟
      const c = res.choice; f.picks.push(c); f.st = stage; f.wait = 0;
      if (stage === 2) { f.end = endOf(f.picks); try { Fx.toast(endToast(F, f.end)); } catch (e) {} }
      try { save(); } catch (e) {}
      try { UI.refresh && UI.refresh(); } catch (e) {}
      cb && cb(res);
    }, opt.replay);
    return true;
  }
  function endToast(F, e) {
    const A = gname(F.a), B = gname(F.b);
    if (e === 'friends') return `冤家和好：<b>${A}＋${B}</b>，同隊出陣攻擊、生命 +8%`;
    if (e === 'rivals') return `冤家變死對頭：<b>${A}／${B}</b>，同隊出陣攻擊 −3%（還會在戰場上吵架）`;
    return `同仇敵愾：<b>${A}＋${B}</b>，同隊出陣開場能量 +25`;
  }
  function feudReady(F) {
    if (!owned(F.a) || !owned(F.b) || !art(F.a) || !art(F.b) || !art(ART3[XWHO[F.x]])) return false;
    const b = st(); if ((BOND_RECRUIT[F.a] && !b.rec[F.a]) || (BOND_RECRUIT[F.b] && !b.rec[F.b])) return false;
    const f = fs(F.id); if (f.st >= 2) return false;
    return f.wait >= (f.st === 0 ? GAP_FEUD1 : GAP_FEUD2);
  }

  // ---------- 排程（Rivals.tick 之前問） ----------
  function tick() {
    const b = st(); if (!b || !seen('prologue_sys')) return false;
    b.gap++;
    for (const F of BOND_FEUDS) if (owned(F.a) && owned(F.b)) { const f = fs(F.id); if (f.st < 2) f.wait++; }
    if (b.pend.length && b.gap >= 3) { // 啱啱收服：唔使等太耐
      const k = b.pend.find(x => art(x)); if (k) return recruitNow(k);
    }
    if (b.gap < GAP_ANY || !seen('ch1_end')) return false;
    const ready = BOND_FEUDS.filter(feudReady); if (!ready.length) return false;
    if (Math.random() > 1 / 30) return false;
    const F = ready[Math.floor(Math.random() * ready.length)]; b.gap = 0;
    return playFeud(F.id);
  }

  // ---------- 戰鬥 ----------
  function teamPairs(units) {
    const ks = new Set(units.filter(u => u.side === 0 && !u.minion).map(u => u.k)); const b = st(); const out = [];
    if (!b) return out;
    for (const F of BOND_FEUDS) { const f = b.feud[F.id]; if (f && f.end && ks.has(F.a) && ks.has(F.b)) out.push([F, f.end]); }
    return out;
  }
  function battleFx(units) {
    const pairs = teamPairs(units); if (!pairs.length) return;
    const msgs = [];
    for (const [F, e] of pairs) {
      const us = units.filter(u => u.side === 0 && (u.k === F.a || u.k === F.b));
      if (e === 'friends') { us.forEach(u => { u.atk *= 1.08; u.maxhp *= 1.08; u.hp *= 1.08; }); msgs.push(`冤家同隊 ${gname(F.a)}＋${gname(F.b)}：攻擊、生命 +8%`); }
      else if (e === 'united') { us.forEach(u => u.energy = Math.min(100, (u.energy || 0) + 25)); msgs.push(`同仇敵愾 ${gname(F.a)}＋${gname(F.b)}：開場能量 +25`); }
      else { us.forEach(u => u.atk *= 0.97); msgs.push(`死對頭同隊 ${gname(F.a)}／${gname(F.b)}：攻擊 −3%`);
        const say = (n) => { try { if (typeof Battle === 'undefined' || !Battle.active) return; const u = Battle.units.find(v => v.side === 0 && v.k === (n % 2 ? F.b : F.a) && v.hp > 0); if (!u) return;
          Battle.fx.push({ x:u.x, y:Battle.uy(u) - 125, text:T(F.rb), col:'#ffd0a0', t:0, life:2.2, skill:true }); } catch (e) {} };
        setTimeout(() => say(0), 1800); setTimeout(() => say(1), 3600); setTimeout(() => say(2), 14000);
      }
    }
    try { Fx.toast(msgs.join('<br>')); } catch (e) {}
  }

  // ---------- 名冊：冤家一行 ----------
  function bondLine(k) {
    const b = st(); if (!b) return '';
    const out = [];
    for (const F of BOND_FEUDS) {
      if (F.a !== k && F.b !== k) continue; const f = b.feud[F.id]; if (!f || !f.st) continue;
      const o = F.a === k ? F.b : F.a;
      out.push(`冤家：${gname(o)}（${f.end ? END_ZH[f.end] : '吵架中'}）`);
    }
    return out.join('　');
  }
  function paintRoster() {
    const sh = document.querySelector('#sheet'); if (!sh) return;
    sh.querySelectorAll('.gcard').forEach(c => {
      if (c.querySelector('.bondln')) return; const cv = c.querySelector('canvas[data-por]'); const main = c.querySelector('.gc-main'); if (!cv || !main) return;
      const t = bondLine(cv.dataset.por); if (!t) return;
      const e = document.createElement('small'); e.className = 'tr bondln'; e.style.color = '#ffb4a0'; e.textContent = t; main.appendChild(e);
    });
  }

  // ---------- 重溫 ----------
  function storyHook() {
    const body = document.querySelector('#sheet .sh-body'), hr = body && body.querySelector('hr'); if (!hr) return;
    const b = st(); if (!b) return;
    const rec = Object.keys(BOND_RECRUIT).filter(k => b.rec[k] && owned(k));
    const fds = BOND_FEUDS.filter(F => b.feud[F.id] && b.feud[F.id].st >= 1);
    const div = document.createElement('div');
    div.innerHTML = `<h4 class="stand-h">收服劇情・冤家</h4><p class="desc">收服名鬼後會上演入村劇情；有些鬼天生不和，日後會吵起來（${fds.length}/${BOND_FEUDS.length}）。</p><div class="slist">`
      + rec.map(k => `<button class="btn wide" data-brec="${k}">${gname(k)}入村</button>`).join('')
      + fds.map(F => { const f = b.feud[F.id]; return `<button class="btn wide" data-bfeud="${F.id}">冤家：${T(F.title)}（${f.end ? END_ZH[f.end] : '吵架中'}）</button>`; }).join('')
      + (rec.length + fds.length ? '' : '<p class="desc">還沒有。去收服幾隻名鬼吧。</p>') + '</div>';
    hr.parentNode.insertBefore(div, hr);
    div.querySelectorAll('[data-brec]').forEach(x => x.onclick = () => { UI.close(); setTimeout(() => playRecruit(x.dataset.brec), 60); });
    div.querySelectorAll('[data-bfeud]').forEach(x => x.onclick = () => { UI.close(); const f = b.feud[x.dataset.bfeud]; setTimeout(() => playFeud(x.dataset.bfeud, (r) => { if (f.st >= 2 && r && !r.skipped) setTimeout(() => playFeud(x.dataset.bfeud, null, { replay:true, stage:2, picks:[f.picks[0]] }), 300); }, { replay:true, stage:1 }), 60); });
  }

  // ---------- 接駁 ----------
  function init() {
    if (started) return; started = true;
    if (typeof joinGhost === 'function') {
      const oj = joinGhost;
      joinGhost = function (k) { // eslint-disable-line no-global-assign
        const b = st(); const had = owned(k); const r = oj.apply(this, arguments);
        if (b && !had && owned(k) && BOND_RECRUIT[k] && !b.rec[k] && !b.pend.includes(k)) { b.pend.push(k); b.gap = Math.min(b.gap, 0); }
        return r;
      };
      try { if (window.G && window.G.joinGhost) window.G.joinGhost = joinGhost; } catch (e) {}
    }
    if (typeof Rivals !== 'undefined' && Rivals.tick) { const ot = Rivals.tick; Rivals.tick = function () { if (tick()) return true; return ot.apply(this, arguments); }; }
    if (typeof GhostStreet !== 'undefined' && GhostStreet.battleBuffs) { const ob = GhostStreet.battleBuffs; GhostStreet.battleBuffs = function (units) { const r = ob.apply(this, arguments); try { battleFx(units || []); } catch (e) {} return r; }; }
    if (typeof UI !== 'undefined' && UI.openStory) { const os = UI.openStory; UI.openStory = function () { const r = os.apply(this, arguments); try { storyHook(); } catch (e) {} return r; }; }
    const sh = document.querySelector('#sheet');
    if (sh && typeof MutationObserver !== 'undefined') { mo = new MutationObserver(() => { if (sh.querySelector('.gcard')) paintRoster(); }); mo.observe(sh, { childList:true, subtree:true }); }
  }
  // 示範頁用
  const demo = {
    recruit(k, r) { return playRecruit(k, null, { r }); },
    feud(id, stage, first) { return playFeud(id, null, { replay:true, stage:stage || 1, picks:first ? [first] : [] }); },
  };
  return { st, init, tick, playRecruit, playFeud, recruitNow, bondLine, battleFx, endOf, demo, list:BOND_FEUDS, recruits:BOND_RECRUIT };
})();
(function bondsBoot() { if (typeof S === 'undefined' || !document.querySelector('#sheet')) { setTimeout(bondsBoot, 300); return; } try { Bonds.init(); } catch (e) { console.error(e); } })();
