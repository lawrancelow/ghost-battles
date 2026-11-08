// ===================== 碎碎念、雜鬼性格、雜鬼入村、鬼與鬼對話（chatter.js）：引擎 =====================
// 劇本：chatter_data.js（CHAT_DATA）。
// 存檔：S.chat = { u:{池:[用過嘅序號]}, arc:{笑話:進度}, c:{對話池:[用過]}, e:{類型:[用過嘅入村]}, ev:{事件:{t,n}} }；雜鬼性格存喺 g.arch。
// 接駁（唔改原檔）：Village.pickChatter 換成新版；Village.update 包一層（對話逐句出）；recruitFodder 包一層（性格＋入村）；
// joinGhost／Battle.finish／Theater.play 包一層（記低最近發生咩事）；名冊用 MutationObserver 加「性格」一行。
const Chatter = (() => {
  const D = CHAT_DATA;
  const zh = () => typeof LANG === 'undefined' || LANG.cur !== 'yue';
  const pickT = (y, z) => (zh() ? z : y);
  const rnd = (a) => a[Math.floor(Math.random() * a.length)];
  const now = () => Date.now();
  const EV_LIFE = { win:180e3, lose:180e3, new:240e3, boss:300e3, rival:300e3, hr:300e3 };
  const EVENT_TAGS = ['win', 'lose', 'new', 'boss', 'rival', 'hr'];
  let started = false, queue = [], qOwner = null, enterBusy = false, recent = [], holdUntil = 0;

  function st() {
    if (typeof S === 'undefined' || !S) return null;
    const c = S.chat = S.chat || {};
    c.u = c.u || {}; c.arc = c.arc || {}; c.c = c.c || {}; c.e = c.e || {}; c.ev = c.ev || {};
    return c;
  }
  const seen = (id) => !!(S && S.seen && S.seen[id]);
  function hash(s) { let h = 2166136261; for (let i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); } return h >>> 0; }
  function nick(g) { const i = g.name.indexOf('・'); return i >= 0 ? g.name.slice(i + 1) : g.name; }
  const isFodder = (g) => g && (g.q === '藍' || g.q === '紫') && D.arch[g.k];

  // ---------- 雜鬼性格 ----------
  function archOf(g, fresh) {
    if (!isFodder(g)) return null;
    const list = D.arch[g.k];
    if (g.arch && list.some(a => a.id === g.arch)) return list.find(a => a.id === g.arch);
    const en = /[A-Za-z]/.test(nick(g)), enA = list.filter(a => a.en);
    let a;
    if (fresh) a = en && enA.length && Math.random() < 0.6 ? rnd(enA) : rnd(list);
    else { const h = hash(g.id + '|' + g.name); a = en && enA.length && (h & 7) < 5 ? enA[(h >>> 3) % enA.length] : list[(h >>> 3) % list.length]; } // 舊存檔：由 id 固定揀
    g.arch = a.id; return a;
  }
  function sample(g) { const a = archOf(g); if (!a) return ''; const l = a.lines[0]; return fill(pickT(l[0], l[1]), g); }

  // ---------- 情境 ----------
  function evOn(k) { const c = st(); const e = c && c.ev[k]; return !!(e && now() - e.t < EV_LIFE[k]); }
  function mark(k, n) { const c = st(); if (c) c.ev[k] = { t:now(), n:n || '' }; }
  function hour() { return new Date().getHours(); }
  function tagOk(tag, g, poolKey) {
    if (!tag) return true;
    for (const t of tag.split(',')) {
      if (t === '夜') { const h = hour(); if (!(h >= 23 || h < 4)) return false; }
      else if (t === '晨') { const h = hour(); if (!(h >= 5 && h < 9)) return false; }
      else if (t.indexOf('p:') === 0) { if (!g || g.post !== t.slice(2)) return false; }
      else if (EVENT_TAGS.includes(t)) { if (!evOn(t)) return false; }
      else if (t === 'early') { if (seen('ch1_end')) return false; }
      else if (t === 'mid') { if (!seen('ch3_end')) return false; }
      else if (t === 'late') { if (!(S.ended || seen('ch6_end'))) return false; }
      else if (t.indexOf('arc:') === 0) { const [, id, n] = t.split(':'); if ((st().arc[id] || 0) + 1 !== +n) return false; }
    }
    return true;
  }
  const isEvent = (tag) => tag && tag.split(',').some(t => EVENT_TAGS.includes(t));
  const isCtx = (tag) => tag && tag.split(',').some(t => t === '夜' || t === '晨' || t.indexOf('p:') === 0 || t.indexOf('arc:') === 0);
  function fill(s, g) {
    const c = st(); const nn = (c && c.ev.new && c.ev.new.n) || '新同事';
    return s.split('{N}').join(nn).split('{n}').join(g ? (isFodder(g) ? nick(g) : g.name) : '');
  }

  // ---------- 揀一句（用晒先重新嚟過；用過嘅記入存檔） ----------
  function poolOf(g) {
    if (!g) return null;
    if (D.named[g.k] && !isFodder(g)) return { key:'n:' + g.k, lines:D.named[g.k] };
    const a = archOf(g); if (a) return { key:'a:' + g.k + ':' + a.id, lines:a.lines };
    return null;
  }
  function pickFrom(pool, g) {
    const c = st(); const used = c.u[pool.key] = c.u[pool.key] || [];
    let ok = pool.lines.map((l, i) => i).filter(i => !used.includes(i) && tagOk(pool.lines[i][2], g));
    if (!ok.length) { // 用晒：清返，跑笑話由頭嚟過
      c.u[pool.key] = []; pool.lines.forEach(l => { if (l[2]) l[2].split(',').forEach(t => { if (t.indexOf('arc:') === 0) c.arc[t.split(':')[1]] = 0; }); });
      ok = pool.lines.map((l, i) => i).filter(i => tagOk(pool.lines[i][2], g));
      if (!ok.length) return null;
    }
    const ev = ok.filter(i => isEvent(pool.lines[i][2])), cx = ok.filter(i => isCtx(pool.lines[i][2]));
    const i = ev.length && Math.random() < 0.7 ? rnd(ev) : cx.length && Math.random() < 0.4 ? rnd(cx) : rnd(ok);
    c.u[pool.key].push(i);
    const l = pool.lines[i]; if (l[2]) l[2].split(',').forEach(t => { if (t.indexOf('arc:') === 0) c.arc[t.split(':')[1]] = +t.split(':')[2]; });
    return fill(pickT(l[0], l[1]), g);
  }
  function lineFor(g) { const p = poolOf(g); return p ? pickFrom(p, g) : null; }

  // ---------- 鬼與鬼對話 ----------
  function feudOf(a, b) {
    if (typeof BOND_FEUDS === 'undefined' || !S.bonds) return null;
    for (const F of BOND_FEUDS) {
      const ab = F.a === a.k && F.b === b.k, ba = F.a === b.k && F.b === a.k; if (!ab && !ba) continue;
      const f = S.bonds.feud && S.bonds.feud[F.id]; if (!f || !f.st) return null;
      return { F, state:f.end || 'fight', A:ab ? a : b, B:ab ? b : a };
    }
    return null;
  }
  function takeConv(key, list, ok) {
    const c = st(); const used = c.c[key] = c.c[key] || [];
    let idx = list.map((x, i) => i).filter(i => !used.includes(i) && (!ok || ok(list[i])));
    if (!idx.length) { c.c[key] = []; idx = list.map((x, i) => i).filter(i => !ok || ok(list[i])); }
    if (!idx.length) return null;
    const i = rnd(idx); c.c[key].push(i); return list[i];
  }
  function convFor(a, b) {
    const fd = feudOf(a, b);
    if (fd) { const key = fd.F.id + ':' + fd.state, list = D.feud[key]; if (list && Math.random() < 0.85) { const cv = takeConv('f:' + key, list); if (cv) return { cv, A:fd.A, B:fd.B }; } }
    const pairs = D.pair.filter(p => (p.a === a.k && p.b === b.k) || (p.a === b.k && p.b === a.k));
    if (pairs.length && Math.random() < 0.7 && !isFodder(a) && !isFodder(b)) {
      const cv = takeConv('p:' + [a.k, b.k].sort().join('+'), pairs); if (cv) return { cv, A:cv.a === a.k ? a : b, B:cv.a === a.k ? b : a };
    }
    const cv = takeConv('g', D.gen, (x) => tagOk(x.tag, null));
    return cv ? { cv, A:a, B:b } : null;
  }
  function startConv(r) {
    const V = Village, names = { A:r.A.name, B:r.B.name };
    queue = r.cv.lines.map(l => ({ who:l[0], text:fill(pickT(l[1], l[2]), null).split('{A}').join(names.A).split('{B}').join(names.B), g:l[0] === 'A' ? r.A : l[0] === 'B' ? r.B : null }));
    qOwner = r; next(V);
  }
  function next(V) {
    const it = queue.shift(); if (!it) { qOwner = null; return; }
    if (!it.g) { // 旁白：浮字
      const v = V.vis.find(o => o.g && qOwner && o.g.id === qOwner.A.id);
      try { Fx.float(v ? v.x : 195, v ? v.y - 90 : 400, it.text, '#d9ccff'); } catch (e) {}
      holdUntil = now() + 1800; return; // 停一陣先出下一句
    }
    V.bubble = { id:it.g.id, hero:false, text:it.text, t:0.9 };
  }

  // ---------- 取代村民碎碎念 ----------
  function pickChatter() {
    const V = this;
    if (queue.length || now() < holdUntil) return;
    const top = V.camY + 60, bot = V.camY + V.h / V.scale - 20;
    if (Story.busy() || UI.modalOpen()) return;
    const cand = V.vis.filter(v => v.y > top + 120 && v.y < bot && v.g && poolOf(v.g) && (!v.hero || S.qi > 3));
    if (!cand.length) return;
    if (Math.random() < 0.38) { // 兩隻鬼行埋一齊：講幾句
      const np = cand.filter(v => !v.hero);
      const pairs = [];
      for (let i = 0; i < np.length; i++) for (let j = i + 1; j < np.length; j++) { const d = Math.hypot(np[i].x - np[j].x, np[i].y - np[j].y); if (d < 130 && np[i].g.id !== np[j].g.id) pairs.push([np[i].g, np[j].g, d]); }
      if (pairs.length) {
        pairs.sort((x, y) => (feudOf(y[0], y[1]) ? 1 : 0) - (feudOf(x[0], x[1]) ? 1 : 0) || x[2] - y[2]);
        const p = Math.random() < 0.6 ? pairs[0] : rnd(pairs); const r = convFor(p[0], p[1]);
        if (r) { startConv(r); V.chatT = 9 + Math.random() * 5; return; }
      }
    }
    const v = rnd(cand), line = lineFor(v.g); if (!line) return;
    V.bubble = { id:v.g.id, hero:!!v.hero, text:line, t:0 };
  }

  // ---------- 雜鬼入村 ----------
  function enterFor(g) {
    const list = D.enter[g.k]; if (!list) return null; const a = archOf(g);
    const c = st(); const used = c.e[g.k] = c.e[g.k] || [];
    let idx = list.map((e, i) => i).filter(i => !used.includes(i) && (!list[i].arch || (a && list[i].arch.includes(a.id))));
    if (!idx.length) { c.e[g.k] = []; idx = list.map((e, i) => i).filter(i => !list[i].arch || (a && list[i].arch.includes(a.id))); }
    const mine = idx.filter(i => list[i].arch); // 有自己性格嘅入場優先
    const i = mine.length && Math.random() < 0.55 ? rnd(mine) : rnd(idx); c.e[g.k].push(i); return list[i];
  }
  function css() {
    if (document.getElementById('gjoin-css')) return;
    const s = document.createElement('style'); s.id = 'gjoin-css';
    s.textContent = `#gjoin{position:absolute;left:10px;right:10px;top:calc(env(safe-area-inset-top) + 8px);z-index:62;display:none;background:linear-gradient(#2a2133,#1b1522);border-radius:12px;box-shadow:0 8px 24px rgba(0,0,0,.6),inset 0 0 0 1.5px #6a5236;color:#f4e6c4;overflow:hidden;cursor:pointer}
#gjoin.on{display:flex;animation:gjin .25s ease-out}@keyframes gjin{from{transform:translateY(-30px);opacity:0}to{transform:none;opacity:1}}
#gjoin canvas{width:118px;height:118px;flex:0 0 118px;background:radial-gradient(circle at 50% 70%,#3d3247,#1d1724)}
#gjoin .gj-b{flex:1;padding:9px 34px 9px 10px;display:flex;flex-direction:column;justify-content:center;min-height:118px;box-sizing:border-box}
#gjoin .gj-t{font-size:12px;color:#d9b36a;font-weight:800;letter-spacing:1px;margin-bottom:3px}
#gjoin .gj-w{font-size:13px;color:#ff9f8a;font-weight:800}
#gjoin .gj-x{font-size:15.5px;line-height:1.45;font-weight:700}
#gjoin .gj-x.narr{color:#cbbfe0;font-weight:600;font-size:14.5px}
#gjoin .gj-k{position:absolute;right:6px;top:6px;width:26px;height:26px;border-radius:13px;background:rgba(0,0,0,.35);color:#f4e6c4;font-size:15px;line-height:26px;text-align:center}
#gjoin .gj-n{position:absolute;right:10px;bottom:6px;font-size:11px;color:#9c8fae}`;
    document.head.appendChild(s);
  }
  let ej = null;
  function playEnter(g, e) {
    css(); let el = document.getElementById('gjoin');
    if (!el) { el = document.createElement('div'); el.id = 'gjoin'; el.innerHTML = '<canvas></canvas><div class="gj-b"><div class="gj-t"></div><div class="gj-w"></div><div class="gj-x"></div></div><div class="gj-k">✕</div><div class="gj-n"></div>'; (document.getElementById('app') || document.body).appendChild(el); }
    const cv = el.querySelector('canvas'), dpr = Math.min(2, window.devicePixelRatio || 1); cv.width = 118 * dpr; cv.height = 118 * dpr;
    const a = archOf(g);
    el.querySelector('.gj-t').textContent = `新鬼入村・${g.name}${a ? '（' + a.label + '）' : ''}`;
    const lines = e.lines.map(l => ({ who:l[0], text:fill(pickT(l[1], l[2]), g) }));
    ej = { g, e, lines, i:-1, t:0, lt:0, el, cv, dpr, raf:0, last:performance.now() };
    enterBusy = true; el.className = 'on';
    const adv = () => { if (!ej) return; ej.i++; ej.lt = 0; if (ej.i >= ej.lines.length) { closeEnter(); return; } const l = ej.lines[ej.i];
      const w = el.querySelector('.gj-w'), x = el.querySelector('.gj-x');
      w.textContent = l.who === '旁白' ? '' : l.who === 'G' ? g.name : l.who; x.className = 'gj-x' + (l.who === '旁白' ? ' narr' : ''); x.textContent = l.text;
      el.querySelector('.gj-n').textContent = (ej.i + 1) + '／' + ej.lines.length; };
    ej.adv = adv; adv();
    el.onclick = (ev) => { ev.stopPropagation(); if (ev.target.classList.contains('gj-k')) { closeEnter(); return; } adv(); };
    const loop = (tm) => { if (!ej) return; const dt = Math.min(0.05, (tm - ej.last) / 1000); ej.last = tm; ej.t += dt; ej.lt += dt; drawEnter(); if (ej.lt > Math.max(2.6, ej.lines[ej.i].text.length * 0.11)) adv(); if (ej) ej.raf = requestAnimationFrame(loop); };
    ej.raf = requestAnimationFrame(loop);
  }
  function closeEnter() { if (!ej) return; cancelAnimationFrame(ej.raf); ej.el.className = ''; ej = null; enterBusy = false; }
  function drawEnter() {
    const { cv, dpr, g, e, t } = ej, ctx = cv.getContext('2d'), W = 118, H = 118, SC = typeof PlazaLife !== 'undefined' ? PlazaLife.SC : 0.58;
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0); ctx.clearRect(0, 0, W, H);
    ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.beginPath(); ctx.ellipse(W / 2, H - 14, 26, 6, 0, 0, Math.PI * 2); ctx.fill();
    const ch = ((typeof ART !== 'undefined' && ART.CHAR_H && ART.CHAR_H[g.k]) || 56) * SC, K = 78 / ch;
    const mo = e.mo, enterP = Math.min(1, t / 0.9), ease = 1 - Math.pow(1 - enterP, 3);
    let x = W / 2, y = H - 14, rot = 0, alpha = 1, walk = enterP < 1, flip = false;
    if (mo === 'fall') { y = -10 + (H - 4) * ease; rot = enterP < 1 ? t * 9 : 0; }
    else if (mo === 'wind') { x = -30 + (W / 2 + 30) * ease; y = H - 14 - Math.sin(t * 3) * 6 * (1 - enterP * 0.5); rot = Math.sin(t * 4) * 0.25; }
    else if (mo === 'rise' || mo === 'pop') { y = H + 70 - (84) * ease; }
    else if (mo === 'fast') { const p = Math.min(1, t / 0.5); x = -40 + (W / 2 + 70) * p - (p >= 1 ? Math.max(0, 30 - (t - 0.5) * 60) : 0); }
    else if (mo === 'float') { x = -30 + (W / 2 + 30) * ease; y = H - 18 - Math.sin(t * 2.2) * 4; alpha = 0.85; }
    else { x = -30 + (W / 2 + 30) * ease; }
    if (mo === 'hop' || mo === 'crash' || mo === 'row' || mo === 'bow' || mo === 'blind' || mo === 'resume' || mo === 'dance') { y -= Math.abs(Math.sin(t * 6)) * (enterP < 1 || mo === 'dance' ? 12 : 3); walk = false; }
    if (mo === 'crash' && t > 0.9 && t < 1.3) { x += Math.sin(t * 80) * 3; if (t < 1.25) { ctx.fillStyle = '#ffe9a8'; ctx.font = '900 18px sans-serif'; ctx.fillText('咚！', W / 2 + 8, 26); } }
    if (mo === 'bow' && t > 1.1) rot = Math.min(0.9, (t - 1.1) * 2);
    if (mo === 'dance') { rot = Math.sin(t * 5) * 0.2; flip = Math.sin(t * 2.5) > 0; }
    if (mo === 'grab' && t < 1.2) { ctx.fillStyle = '#4caf50'; ctx.fillRect(W * (t / 1.2) * 1.4 - 70, H - 32, 52, 18); ctx.fillStyle = '#222'; ctx.beginPath(); ctx.arc(W * (t / 1.2) * 1.4 - 58, H - 13, 5, 0, 7); ctx.arc(W * (t / 1.2) * 1.4 - 28, H - 13, 5, 0, 7); ctx.fill(); }
    const draw = (dx, a2) => { ctx.save(); ctx.setTransform(dpr * K, 0, 0, dpr * K, 0, 0); ctx.globalAlpha = alpha * a2;
      const px = (x + dx) / K, py = y / K; ctx.translate(px, py); ctx.rotate(rot); ctx.translate(-px, -py);
      try { ART.drawChar(ctx, g.k, px, py, SC, { t:t * 1.3, walk, flip, tamed:true, untied:true, act:mo === 'sniff' ? 'plaza_sniff' : mo === 'run' ? null : null, at:t }); } catch (err) {}
      ctx.restore(); };
    if (mo === 'row') { if (t < 2.2) { draw(-34, 0.55); draw(34, 0.55); } }
    draw(0, 1);
    if (mo === 'drip' || mo === 'rise') { ctx.fillStyle = 'rgba(150,200,255,.8)'; for (let i = 0; i < 3; i++) { const yy = (H - 60) + ((t * 40 + i * 17) % 40); ctx.fillRect(x - 10 + i * 9, yy, 2, 4); } }
    if (mo === 'blind') { ctx.fillStyle = '#ffe9a8'; ctx.font = '900 12px sans-serif'; ctx.fillText('？', x + 18, y - 70 + Math.sin(t * 3) * 3); }
    if (mo === 'resume' && t > 0.9) { ctx.fillStyle = '#f4ecd6'; ctx.fillRect(x + 16, y - 52, 16, 20); ctx.strokeStyle = '#8a7a5a'; ctx.strokeRect(x + 16, y - 52, 16, 20); }
  }
  function onRecruit(g) {
    if (!g || !isFodder(g)) return;
    archOf(g, true); mark('new', g.name);
    const t = now(); recent = recent.filter(x => t - x < 15000); recent.push(t);
    const e = enterFor(g); if (!e) return;
    const busy = enterBusy || recent.length >= 3 || (typeof Battle !== 'undefined' && Battle.active) || (typeof Theater !== 'undefined' && Theater.on);
    if (busy) { const s = e.toast ? pickT(e.toast[0], e.toast[1]) : (e.lines[e.lines.length - 1] || [])[2]; try { Fx.toast(`<b>${g.name}</b>：${fill(s, g)}`); } catch (er) {} return; }
    setTimeout(() => playEnter(g, e), 250);
  }

  // ---------- 名冊：性格 ----------
  function paintRoster() {
    const sh = document.querySelector('#sheet'); if (!sh || !S) return;
    sh.querySelectorAll('.gcard').forEach(c => {
      if (c.querySelector('.archln')) return; const up = c.querySelector('[data-up],[data-rel]'); const main = c.querySelector('.gc-main'); if (!main) return;
      let g = null; const id = up && (up.dataset.up || up.dataset.rel); if (id) g = S.ghosts.find(x => x.id === id);
      if (!g) { const nm = main.querySelector('b'); g = nm && S.ghosts.find(x => x.name === nm.textContent); }
      if (!isFodder(g)) return; const a = archOf(g);
      const e = document.createElement('small'); e.className = 'tr archln'; e.style.color = '#7a4a9a';
      e.textContent = `性格：${a.label}　「${sample(g)}」`; main.appendChild(e);
    });
  }

  // ---------- 接駁 ----------
  function init() {
    if (started) return; started = true;
    if (typeof Village !== 'undefined') {
      Village.pickChatter = pickChatter;
      const ou = Village.update;
      if (ou) Village.update = function () { const r = ou.apply(this, arguments); try { if (queue.length && !this.bubble && now() >= holdUntil) next(this); } catch (e) {} return r; };
    }
    if (typeof recruitFodder === 'function') {
      const orf = recruitFodder;
      recruitFodder = function () { const g = orf.apply(this, arguments); try { onRecruit(g); } catch (e) { console.error(e); } return g; }; // eslint-disable-line no-global-assign
      try { if (window.G && window.G.recruitFodder) window.G.recruitFodder = recruitFodder; } catch (e) {}
    }
    if (typeof joinGhost === 'function') {
      const oj = joinGhost;
      joinGhost = function (k) { const had = S.ghosts.some(g => g.k === k); const r = oj.apply(this, arguments); if (!had && S.ghosts.some(g => g.k === k)) mark('new', GHOSTS[k] ? GHOSTS[k].name : k); return r; }; // eslint-disable-line no-global-assign
      try { if (window.G && window.G.joinGhost) window.G.joinGhost = joinGhost; } catch (e) {}
    }
    if (typeof Battle !== 'undefined' && Battle.finish) { const of = Battle.finish; Battle.finish = function (win) { try { if (!this.result) mark(win ? 'win' : 'lose'); } catch (e) {} return of.apply(this, arguments); }; }
    if (typeof Theater !== 'undefined' && Theater.play) { const op = Theater.play; Theater.play = function (sc) { try { const n = (sc && sc.cast || []).map(c => c[0]); if (n.includes('龐總')) mark('boss'); if (n.includes('Bryan')) mark('rival'); if (n.includes('冼小姐')) mark('hr'); } catch (e) {} return op.apply(this, arguments); }; }
    (S && S.ghosts || []).forEach(g => { if (isFodder(g)) archOf(g); }); // 舊存檔：補性格
    const sh = document.querySelector('#sheet');
    if (sh && typeof MutationObserver !== 'undefined') new MutationObserver(() => { if (sh.querySelector('.gcard')) paintRoster(); }).observe(sh, { childList:true, subtree:true });
  }
  // 示範頁用
  const demo = { lineFor, convFor, startConv: (a, b) => { const r = convFor(a, b); if (r) startConv(r); return r; }, playEnter, enterFor, onRecruit, mark };
  return { st, init, archOf, sample, lineFor, poolOf, pickFrom, tagOk, convFor, enterFor, onRecruit, demo, get busy() { return enterBusy; }, close:closeEnter };
})();
(function chatterBoot() { if (typeof S === 'undefined' || !S || typeof Village === 'undefined' || !document.querySelector('#sheet')) { setTimeout(chatterBoot, 300); return; } try { Chatter.init(); } catch (e) { console.error(e); } })();
