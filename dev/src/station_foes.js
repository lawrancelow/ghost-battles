// ===================== 陽間站崗・強敵＋封禁（StnFoes） =====================
// 獨立模組：唔直接改 street.js，由 Street.Turf 經少量 hook 接駁（見 station_foes_HOOKS.md）。
// 強敵本身係「路人」：用 Turf.newWalker() 生出嚟，再交 StnFoes.decorate() 改裝，所以行路、受驚、逃走、漏走全部沿用 street.js。
// 三款強敵（專業對手，唔殺鬼，只短暫封禁鬼／設備）：
//   茅山道士 taoist   ：入射程停低念咒（頭頂進度圈）→ 向最近設備／名鬼貼黃符，封禁 6–10 秒；同時最多封 2 部；膽量跌到 45% 以下即撤符。
//   現代捉鬼師 hunter ：羅盤＋強光電筒，前方扇形內設備暫停 4 秒；間中灑鹽米，範圍內設備效果 −40%（6 秒）。
//   靈異直播主 streamer：環形燈光環，附近路人膽量 +30%；本身好易嚇。
// 「要幾種設備合力」：道士／捉鬼師對同一類設備有抗性——單一類設備最多只可以實打佢 40% 膽量，之後嗰類設備只得兩成效果。
// 符咒只用抽象符紋，唔寫真實文字。
const StnFoes = (() => {
  const PX = 1 / 2160, CELL = 150 * PX;
  const R = (a, b) => a + Math.random() * (b - a);
  const pick = (a) => a[Math.floor(Math.random() * a.length)];
  const T = (yue, zh) => { try { if (typeof LANG !== 'undefined' && LANG.add) LANG.add({ [yue]:zh }); if (typeof window !== 'undefined' && window.L) return window.L(yue); } catch (e) {} return yue; };
  const now = () => (typeof performance !== 'undefined' ? performance.now() : Date.now()) / 1000;

  // ---------- 數值 ----------
  const RES = { cap:0.4, tail:0.2 };             // 同一類設備：頭 40% 膽量全效，之後兩成
  const FOES = {
    taoist:{ n:['茅山道士', '茅山道士'], tag:'#ffd45a', minLv:6, w:1.0, hp:3.6, spd:0.8, award:4, res:true,
      range:240, chant:1.6, seal:[6, 10], maxSeal:2, cd:3.5, retreat:0.45,
      chantL:[['孽障，乖乖返去！', '孽障，乖乖回去！'], ['呢度唔到你放肆！', '這裡輪不到你放肆！'], ['貧道今晚當值，咪搞事。', '貧道今晚值班，別搗亂。'], ['陰陽有別，退！', '陰陽有別，退！'], ['定！', '定！']],
      retreatL:[['好重陰氣……撤符先！', '陰氣好重……先撤符！'], ['今晚算你哋叻。', '今晚算你們厲害。']],
      re:[['嗯？有啲門道。', '嗯？有點門道。'], ['穩住，唔好亂。', '穩住，不要亂。'], ['小把戲。', '小把戲。']],
      big:[['改日再嚟會你！', '改天再來會你！'], ['道行唔夠，收工！', '道行不夠，收工！']] },
    hunter:{ n:['現代捉鬼師', '現代捉鬼師'], tag:'#7fd0ff', minLv:4, w:1.2, hp:3.0, spd:0.95, award:3.5, res:true,
      beam:{ r:300, half:0.75, dur:4, cd:[5, 7], scan:1.1 }, salt:{ r:1.3, reach:300, dur:6, mul:0.6, cd:[9, 13] },
      beamL:[['照住你，咪郁！', '照住你，別動！'], ['羅盤轉到癲咗，就喺度！', '羅盤轉瘋了，就在這！'], ['讀數爆錶！', '讀數爆表！']],
      saltL:[['鹽米開路！', '鹽米開路！'], ['灑啲鹽米先，穩陣啲。', '先撒點鹽米，穩妥點。']],
      re:[['數據有異動……', '數據有異動……'], ['冇事，計我嘅。', '沒事，交給我。']],
      big:[['數據唔對路，撤！', '數據不對勁，撤！'], ['器材頂唔順喇！', '器材撐不住了！']] },
    streamer:{ n:['靈異直播主', '靈異直播主'], tag:'#ff7ab8', minLv:2, w:1.4, hp:0.7, spd:0.9, award:2.5, res:false, take:1.3,
      aura:{ r:170, mul:1.3 }, talkCd:[6, 9],
      talkL:[['家人們，入嚟睇吓！', '家人們，進來看看！'], ['打賞夠一千我就行入去！', '打賞滿一千我就走進去！'], ['唔使驚，有我喺度！', '不用怕，有我在！'], ['燈開大啲，畀大家睇清楚！', '燈開大點，讓大家看清楚！']],
      re:[['啊！你哋見唔見到？', '啊！你們看到沒有？'], ['冇事冇事……', '沒事沒事……']],
      big:[['哇！斷咗線先！', '哇！先斷線！'], ['今晚唔播喇！', '今晚不播了！']] },
  };
  const IDS = Object.keys(FOES);

  // ---------- 狀態（唔入存檔）----------
  let S = null;
  function reset() { S = { seals:[], brk:[], pause:new Map(), salt:new Map(), saltFx:[], beams:[], wave:0, warned:new Set(), lines:new Set() }; }
  // 解封／撤符：記低位置，畫封條撕開、鎖鏈散開（1 秒）
  const brkAdd = (s, W) => { if (!S.brk) S.brk = []; const p = spotOf(s, W); if (p) S.brk.push({ kind:s.kind, i:s.i, x:p[0], y:p[1], t:0, dur:1.0, seed:s.seed || 0 }); };
  const sealIm = () => { const im = typeof SPR !== 'undefined' && SPR.vfx_seal; return im && im.naturalWidth ? im : null; };
  reset();

  // 同一關內唔好兩個角色講同一句：每句講完先回收
  function line(w, pool, dur) {
    const free = pool.filter(q => !S.lines.has(q[0])), q = pick(free.length ? free : pool);
    if (w.say && w.say._foe) S.lines.delete(w.say._foe);
    S.lines.add(q[0]); w.say = { s:T(q[0], q[1]), t:dur || 1.6, _foe:q[0] };
    setTimeoutSafe(() => S && S.lines.delete(q[0]), (dur || 1.6) * 1000 + 200);
  }
  const setTimeoutSafe = (f, ms) => { try { setTimeout(f, ms); } catch (e) {} };

  // ---------- 生成 ----------
  function slotChance(lv) { return Math.min(0.3, Math.max(0, 0.03 + 0.012 * (lv - 2)) * (1 + Math.min(1, S.wave / 20))); }
  function spawnTable(lv) {
    const ok = IDS.filter(id => lv >= FOES[id].minLv), tw = ok.reduce((a, id) => a + FOES[id].w, 0), pc = ok.length ? slotChance(lv) : 0;
    return ok.map(id => ({ id, name:T(FOES[id].n[0], FOES[id].n[1]), weight:FOES[id].w, chance:pc * FOES[id].w / tw, hpMul:FOES[id].hp }));
  }
  const waveCap = (lv) => lv < 8 ? 1 : lv < 18 ? 2 : 3;
  // 每個空位擲一次；q = Turf.q（排隊物件），用嚟計每波上限
  function roll(lv, q) {
    if (q) { if (q.made <= 1 || q._foeWave !== q) { q._foeN = 0; q._foeWave = q; } if (q.made <= 1) S.wave++; if (q._foeN >= waveCap(lv)) return null; }
    const tb = spawnTable(lv); if (!tb.length) return null;
    let r = Math.random(); for (const e of tb) { if (r < e.chance) { if (q) q._foeN = (q._foeN || 0) + 1; return e.id; } r -= e.chance; }
    return null;
  }
  function decorate(w, id) {
    const C = FOES[id]; if (!C || !w) return w;
    w.foe = { id, by:{}, cd:R(1, 2), bcd:R(1.5, 3), scd:R(4, 6), lt:R(1, 3), chant:null, scan:0, retreated:false };
    w.tr = null; w.mate = null; w.tint = null; w.el = null; w.tT = 99;
    w.p = { id:'foe_' + id, n:C.n[0], zh:C.n[1], re:C.re, big:C.big, hp:1, spd:1, w:0 };
    w.n = T(C.n[0], C.n[1]); w.spr = 'foe_' + id;
    w.hp = w.max = Math.round(w.max * C.hp); w.spd *= C.spd; w.award = Math.round(13 * C.award);
    return w;
  }

  // ---------- 查詢（street.js 用）----------
  const sealOf = (o) => S.seals.find(s => s.tgt === o);
  function isSealed(o) { const s = o && sealOf(o); return s ? Math.max(0, s.dur - s.t) : 0; }
  function isPaused(p) { const s = p && S.pause.get(p); return s ? Math.max(0, s.dur - s.t) : 0; }
  function blocks(o) { return isSealed(o) > 0 || isPaused(o) > 0; }
  function devMul(p) { const s = p && S.salt.get(p); return s ? FOES.hunter.salt.mul : 1; }

  // ---------- 受驚（street.js hit() 入面調用）----------
  function onHit(w, dmg, o, W) {
    o = o || {}; const role = (W && W._foeRole) || 'other';
    if (W && (!w.foe || w.foe.id !== 'streamer')) { const pos = W.wp(w), A = FOES.streamer.aura;
      if (W.walkers.some(q => q !== w && q.foe && q.foe.id === 'streamer' && W.alive(q) && W.dist(W.wp(q), pos) < A.r * PX)) dmg /= A.mul; }
    if (!w.foe) return dmg;
    const F = w.foe, C = FOES[F.id]; if (C.take) dmg *= C.take;
    if (C.res && !o.force) {
      const capAmt = RES.cap * w.max, done = F.by[role] || 0, full = Math.min(dmg, Math.max(0, capAmt - done));
      const eff = full + (dmg - full) * RES.tail; F.by[role] = done + eff;
      if (dmg - full > 0 && !S.warned.has(w) && W) { S.warned.add(w); const [x, y] = W.wp(w); W.float(x, y - 0.12, T('同一招唔夠嚇佢，夾埋第二類設備！', '同一招嚇不倒他，搭配其他類設備！'), '#ffcf7a'); }
      dmg = eff;
    } else F.by[role] = (F.by[role] || 0) + dmg;
    if (F.chant && dmg >= 0.06 * w.max) { F.chant.t = Math.max(0, F.chant.t - 0.5); F.chant.jolt = 0.4; }
    return dmg;
  }

  // ---------- 更新 ----------
  function release(by, W, quiet) {
    S.seals = S.seals.filter(s => { if (s.by !== by) return true; if (W) brkAdd(s, W); if (!quiet && W) { const p = spotOf(s, W); if (p) W.float(p[0], p[1] - 0.06, T('黃符撤走', '黃符撤走'), '#ffe9a0'); } return false; });
  }
  function spotOf(s, W) { if (s.kind === 'boss') return W.bpos ? W.bpos(s.tgt) : null; const sp = W.lay.posts[s.i]; return sp ? [sp.x, sp.y] : null; }
  function devList(W) { const out = []; (W.sd.posts || []).forEach((p, i) => { const sp = W.lay.posts[i]; if (p && p.role && !(p.build > 0) && sp) out.push({ p, i, sp }); }); return out; }

  function update(dt, W) {
    for (const s of S.seals) s.t += dt;
    S.seals = S.seals.filter(s => { const gone = s.kind === 'boss' ? !(W.bosses || []).includes(s.tgt) : W.sd.posts[s.i] !== s.tgt;
      if (gone) return false; if (s.t < s.dur) return true; brkAdd(s, W); const p = spotOf(s, W); if (p) W.float(p[0], p[1] - 0.06, T('解封！', '解封！'), '#9ef0b0'); return false; });
    for (const M of [S.pause, S.salt]) for (const [k, v] of M) { v.t += dt; if (v.t >= v.dur) M.delete(k); }
    S.saltFx = S.saltFx.filter(f => (f.t += dt) < f.dur); S.brk = (S.brk || []).filter(f => (f.t += dt) < f.dur);
    S.beams = S.beams.filter(f => (f.t += dt) < f.dur);
    for (const w of W.walkers) {
      if (!w.foe) continue; const F = w.foe;
      if (w.gone) { if (F.id === 'taoist' && !F.released) { F.released = true; release(w, W); } continue; }
      if (!W.alive(w)) continue;
      if (F.id === 'taoist') taoTick(w, F, dt, W); else if (F.id === 'hunter') huntTick(w, F, dt, W); else streamTick(w, F, dt, W);
    }
  }
  function taoTick(w, F, dt, W) {
    const C = FOES.taoist, pos = W.wp(w); F.cd -= dt;
    if (!F.retreated && w.hp / w.max < C.retreat) { F.retreated = true; F.chant = null; release(w, W); line(w, C.retreatL, 1.8); return; }
    if (F.chant) { const ch = F.chant; if (ch.jolt > 0) ch.jolt -= dt;
      const tgtOk = ch.kind === 'boss' ? (W.bosses || []).includes(ch.tgt) && !isSealed(ch.tgt) : W.sd.posts[ch.i] === ch.tgt && !isSealed(ch.tgt);
      if (!tgtOk) { F.chant = null; F.cd = 1; return; }
      w.block = Math.max(w.block || 0, 0.15); ch.t += dt;
      if (ch.t >= ch.dur) { S.seals.push({ tgt:ch.tgt, kind:ch.kind, i:ch.i, t:0, dur:R(C.seal[0], C.seal[1]), by:w, seed:Math.random() * 9 }); F.chant = null; F.cd = C.cd;
        const p = spotOf(S.seals[S.seals.length - 1], W); if (p) W.float(p[0], p[1] - 0.08, ch.kind === 'boss' ? T('名鬼被封印！', '名鬼被封印！') : T('設備被封！', '設備被封！'), '#ffd45a'); }
      return; }
    if (F.retreated || F.cd > 0 || S.seals.filter(s => s.by === w).length >= C.maxSeal) return;
    let best = null, bd = C.range * PX;
    for (const d of devList(W)) { if (isSealed(d.p)) continue; const r = W.rdist ? W.rdist(pos, d.sp) : W.dist(pos, [d.sp.x, d.sp.y]); if (r <= bd) { bd = r; best = { tgt:d.p, kind:'dev', i:d.i }; } }
    for (const B of W.bosses || []) { if (B.hid || isSealed(B) || !W.bpos) continue; const r = W.dist(pos, W.bpos(B)); if (r <= bd) { bd = r; best = { tgt:B, kind:'boss', i:-1 }; } }
    if (!best) { F.cd = 0.4; return; }
    F.chant = Object.assign(best, { t:0, dur:C.chant, jolt:0 }); w.block = Math.max(w.block || 0, 0.15); line(w, C.chantL, 1.8);
  }
  function huntTick(w, F, dt, W) {
    const C = FOES.hunter, pos = W.wp(w); F.bcd -= dt; F.scd -= dt;
    if (F.scan > 0) { F.scan -= dt; w.block = Math.max(w.block || 0, 0.15); return; }
    if (F.bcd <= 0) {
      const ah = W.wp(w, CELL * 0.6), dir = Math.atan2((ah[1] - pos[1]) * 1.5, ah[0] - pos[0]), B = C.beam;
      const hitL = devList(W).filter(d => { const dx = d.sp.x - pos[0], dy = (d.sp.y - pos[1]) * 1.5, r = Math.hypot(dx, dy); if (r > B.r * PX) return false; let da = Math.atan2(dy, dx) - dir; da = Math.atan2(Math.sin(da), Math.cos(da)); return Math.abs(da) <= B.half; });
      if (hitL.length) { hitL.forEach(d => { const o = S.pause.get(d.p); if (!o || o.dur - o.t < B.dur) S.pause.set(d.p, { t:0, dur:B.dur, i:d.i }); });
        S.beams.push({ w, dir, t:0, dur:B.scan + 0.3, r:B.r * PX, half:B.half, x:pos[0], y:pos[1] }); F.scan = B.scan; F.bcd = R(B.cd[0], B.cd[1]); w.block = Math.max(w.block || 0, 0.15); line(w, C.beamL, 1.5); return; }
      F.bcd = 0.6;
    }
    if (F.scd <= 0) {
      const ds = devList(W).filter(d => W.dist(pos, [d.sp.x, d.sp.y]) <= C.salt.reach * PX); if (!ds.length) { F.scd = 1; return; }
      const rr = C.salt.r * CELL, score = (d) => ds.filter(e => W.dist([d.sp.x, d.sp.y], [e.sp.x, e.sp.y]) <= rr).length - W.dist(pos, [d.sp.x, d.sp.y]);
      const c0 = ds.slice().sort((a, b) => score(b) - score(a))[0], cx = c0.sp.x, cy = c0.sp.y;
      devList(W).filter(d => W.dist([cx, cy], [d.sp.x, d.sp.y]) <= rr).forEach(d => S.salt.set(d.p, { t:0, dur:C.salt.dur, i:d.i }));
      const gr = []; for (let j = 0; j < 46; j++) { const a = Math.random() * 6.283, k = Math.sqrt(Math.random()); gr.push([Math.cos(a) * k * rr, Math.sin(a) * k * rr / 1.5, Math.random()]); }
      S.saltFx.push({ x:cx, y:cy, fx:pos[0], fy:pos[1], r:rr, t:0, dur:C.salt.dur, gr });
      F.scd = R(C.salt.cd[0], C.salt.cd[1]); line(w, C.saltL, 1.4);
    }
  }
  function streamTick(w, F, dt) { const C = FOES.streamer; F.lt -= dt; if (F.lt <= 0 && !w.say) { F.lt = R(C.talkCd[0], C.talkCd[1]); line(w, C.talkL, 1.6); } }

  // ---------- 畫圖 ----------
  let FU = null;
  function fuCanvas() { // 黃符（抽象符紋，唔係真字）：一次畫好再切條飄動
    if (FU || typeof document === 'undefined') return FU;
    const cv = document.createElement('canvas'); cv.width = 64; cv.height = 160; const g = cv.getContext('2d');
    g.fillStyle = '#f2cf45'; g.fillRect(0, 0, 64, 160); const gr = g.createLinearGradient(0, 0, 64, 0); gr.addColorStop(0, 'rgba(160,100,10,0.25)'); gr.addColorStop(0.5, 'rgba(255,255,255,0)'); gr.addColorStop(1, 'rgba(160,100,10,0.25)'); g.fillStyle = gr; g.fillRect(0, 0, 64, 160);
    g.strokeStyle = '#b8261c'; g.fillStyle = '#b8261c'; g.lineCap = 'round'; g.lineJoin = 'round';
    g.lineWidth = 2; g.strokeRect(4, 4, 56, 152);
    for (let j = 0; j < 3; j++) { g.beginPath(); g.arc(18 + j * 14, 18, 4.5, 0, 7); g.fill(); }                  // 頂三點
    g.lineWidth = 3.2; g.beginPath(); g.moveTo(10, 30); g.lineTo(54, 30); g.stroke();
    g.beginPath(); g.moveTo(32, 30); for (let y = 30; y <= 120; y += 3) g.lineTo(32 + Math.sin(y * 0.16) * 9, y); g.stroke(); // 中間波紋
    g.lineWidth = 2.4; for (const [cx, cy, s] of [[17, 56, 1], [47, 74, -1], [17, 94, 1]]) { g.beginPath(); for (let a = 0; a < 12; a += 0.25) { const r = 1 + a * 0.75; g.lineTo(cx + Math.cos(a * s) * r, cy + Math.sin(a * s) * r); } g.stroke(); } // 漩渦
    g.lineWidth = 2.6; for (const y of [44, 84, 108]) { g.beginPath(); g.moveTo(40, y); g.lineTo(54, y - 4); g.stroke(); g.beginPath(); g.moveTo(10, y + 6); g.lineTo(22, y + 10); g.stroke(); }
    g.lineWidth = 3; g.beginPath(); g.moveTo(18, 126); g.lineTo(46, 126); g.lineTo(46, 146); g.lineTo(18, 146); g.closePath(); g.stroke(); // 底框
    g.beginPath(); g.moveTo(18, 126); g.lineTo(46, 146); g.moveTo(46, 126); g.lineTo(18, 146); g.stroke();
    return (FU = cv);
  }
  function drawFu(c, x, y, w, h, t, seed, alpha) { // (x,y) = 頂中，向下飄
    const im = fuCanvas(); c.save(); c.globalAlpha *= alpha == null ? 1 : alpha;
    const n = 18, sh = h / n;
    for (let k = 0; k < n; k++) { const e = k / (n - 1), off = Math.sin(t * 5.5 + seed - k * 0.32) * w * 0.13 * e * e, sk = 1 - 0.06 * e * Math.abs(Math.sin(t * 3 + seed + k * 0.3));
      if (im) c.drawImage(im, 0, k * 160 / n, 64, 160 / n + 0.5, x - w * sk / 2 + off, y + k * sh, w * sk, sh + 0.8);
      else { c.fillStyle = '#f2cf45'; c.fillRect(x - w * sk / 2 + off, y + k * sh, w * sk, sh + 0.8); } }
    c.restore();
  }
  function chainLine(c, ax, ay, bx, by, U, t) {
    const L = Math.hypot(bx - ax, by - ay), n = Math.max(3, Math.floor(L / (9 * U))), ang = Math.atan2(by - ay, bx - ax);
    for (let j = 0; j <= n; j++) { const k = j / n, x = ax + (bx - ax) * k, y = ay + (by - ay) * k + Math.sin(k * Math.PI) * 4 * U; c.save(); c.translate(x, y); c.rotate(ang);
      c.lineWidth = 2.6 * U; c.strokeStyle = '#5a3c08'; c.beginPath(); if (j % 2) c.ellipse(0, 0, 5.5 * U, 1.6 * U, 0, 0, 7); else c.ellipse(0, 0, 5.5 * U, 3.4 * U, 0, 0, 7); c.stroke();
      c.lineWidth = 1.6 * U; c.strokeStyle = `hsl(45,95%,${58 + 12 * Math.sin(t * 4 + j)}%)`; c.stroke(); c.restore(); }
  }
  const bigTxt = (c, s, x, y, px, fill, stroke) => { c.font = `900 ${px}px sans-serif`; c.textAlign = 'center'; c.lineJoin = 'round'; c.lineWidth = Math.max(3, px * 0.22); c.strokeStyle = stroke || '#1a0f04'; c.strokeText(s, x, y); c.fillStyle = fill; c.fillText(s, x, y); };

  function devRect(W, i) { const sp = W.lay.posts[i], b = W.box; if (!sp) return null; const q = W.rect ? W.rect(sp) : [sp.x - CELL / 2, sp.y - CELL / 3, sp.x + CELL / 2, sp.y + CELL / 3]; return [b.x + q[0] * b.w, b.y + q[1] * b.h, (q[2] - q[0]) * b.w, (q[3] - q[1]) * b.h]; }

  // 喺 Turf.draw() 鏡頭變換入面調用（地圖座標），畫晒所有強敵特效
  function draw(c, W) {
    const b = W.box, U = b.w / 840, hh = b.h * 0.042, t = now();
    c.save();
    // 鹽米：地上白點粒子＋飛出去嘅軌跡
    for (const f of S.saltFx) { const [cx, cy] = W.P(f.x, f.y), fade = Math.min(1, (f.dur - f.t) / 0.8), land = Math.min(1, f.t / 0.35);
      if (land < 1) { const [ax, ay] = W.P(f.fx, f.fy); for (const g of f.gr) { const k = Math.min(1, land * (0.8 + g[2] * 0.4)), x = ax + (cx + g[0] * b.w - ax) * k, y = ay + (cy + g[1] * b.w - ay) * k - Math.sin(k * Math.PI) * 40 * U; c.fillStyle = 'rgba(255,255,255,0.95)'; c.fillRect(x - 1.5 * U, y - 1.5 * U, 3 * U, 3 * U); } continue; }
      c.fillStyle = `rgba(230,240,255,${0.10 * fade})`; c.beginPath(); c.ellipse(cx, cy, f.r * b.w, f.r * b.w / 1.5, 0, 0, 7); c.fill();
      c.strokeStyle = `rgba(240,248,255,${0.35 * fade})`; c.setLineDash([2 * U, 5 * U]); c.lineWidth = 1.5 * U; c.stroke(); c.setLineDash([]);
      for (const g of f.gr) { const tw = 0.55 + 0.45 * Math.sin(t * 6 + g[2] * 20); c.fillStyle = g[2] < 0.35 ? `rgba(240,220,170,${0.9 * fade * tw})` : `rgba(255,255,255,${0.95 * fade * tw})`; c.beginPath(); c.arc(cx + g[0] * b.w, cy + g[1] * b.w, (g[2] < 0.35 ? 2.2 : 1.7) * U, 0, 7); c.fill(); } }
    // 強光電筒扇形
    for (const B of S.beams) { const w = B.w, pos = w && !w.gone ? W.wp(w) : [B.x, B.y], [x, y] = W.P(pos[0], pos[1] - 0.012), k = B.t / B.dur, al = (k < 0.15 ? k / 0.15 : 1 - Math.max(0, k - 0.6) / 0.4) * (0.85 + 0.15 * Math.sin(t * 30)), r = B.r * b.w;
      c.save(); c.translate(x, y); c.scale(1, 1 / 1.5); const g = c.createRadialGradient(0, 0, 4 * U, 0, 0, r); g.addColorStop(0, `rgba(255,252,215,${0.75 * al})`); g.addColorStop(0.6, `rgba(255,248,190,${0.32 * al})`); g.addColorStop(1, 'rgba(255,245,180,0)');
      c.fillStyle = g; c.beginPath(); c.moveTo(0, 0); c.arc(0, 0, r, B.dir - B.half, B.dir + B.half); c.closePath(); c.fill();
      c.strokeStyle = `rgba(255,250,210,${0.5 * al})`; c.lineWidth = 2 * U; c.beginPath(); c.moveTo(0, 0); c.lineTo(Math.cos(B.dir - B.half) * r, Math.sin(B.dir - B.half) * r); c.moveTo(0, 0); c.lineTo(Math.cos(B.dir + B.half) * r, Math.sin(B.dir + B.half) * r); c.stroke(); c.restore(); }
    // 直播主環形燈光環
    for (const w of W.walkers) { if (!w.foe || w.foe.id !== 'streamer' || !W.alive(w)) continue; const [x, y] = W.P(...W.wp(w)), r = FOES.streamer.aura.r * PX * b.w, pu = 0.8 + 0.2 * Math.sin(t * 3);
      const g = c.createRadialGradient(x, y, r * 0.2, x, y, r); g.addColorStop(0, 'rgba(255,150,210,0)'); g.addColorStop(0.75, `rgba(255,150,210,${0.12 * pu})`); g.addColorStop(1, 'rgba(255,150,210,0)'); c.fillStyle = g; c.beginPath(); c.ellipse(x, y, r, r / 1.5, 0, 0, 7); c.fill();
      c.strokeStyle = `rgba(255,170,220,${0.55 * pu})`; c.lineWidth = 2 * U; c.setLineDash([6 * U, 5 * U]); c.lineDashOffset = -t * 20; c.beginPath(); c.ellipse(x, y, r, r / 1.5, 0, 0, 7); c.stroke(); c.setLineDash([]);
      for (const q of W.walkers) { if (q === w || q.foe || !W.alive(q) || W.dist(W.wp(q), W.wp(w)) >= FOES.streamer.aura.r * PX) continue; const [qx, qy] = W.P(...W.wp(q)); bigTxt(c, '膽+30%', qx, qy - hh - 20 * U, 9 * U, '#ffb0dc'); } }
    // 設備：暫停／減益
    for (const [p, v] of S.pause) { const rc = devRect(W, v.i); if (!rc || isSealed(p)) continue; const [x0, y0, cw, ch] = rc, left = v.dur - v.t;
      c.fillStyle = `rgba(255,250,205,${0.38 + 0.1 * Math.sin(t * 12)})`; c.fillRect(x0, y0, cw, ch); c.strokeStyle = '#fff6c0'; c.lineWidth = 2.5 * U; c.strokeRect(x0, y0, cw, ch);
      bigTxt(c, T('暫停', '暫停') + ' ' + Math.ceil(left), x0 + cw / 2, y0 + ch * 0.62, 12 * U, '#fff3a0'); }
    for (const [p, v] of S.salt) { const rc = devRect(W, v.i); if (!rc) continue; const [x0, y0, cw, ch] = rc, left = v.dur - v.t;
      c.strokeStyle = `rgba(255,255,255,${0.6 + 0.3 * Math.sin(t * 8)})`; c.setLineDash([3 * U, 3 * U]); c.lineWidth = 2 * U; c.strokeRect(x0 - 3 * U, y0 - 3 * U, cw + 6 * U, ch + 6 * U); c.setLineDash([]);
      const oy = isSealed(p) ? 18 * U : 0; c.fillStyle = 'rgba(20,24,36,0.82)'; const bw = 52 * U; c.fillRect(x0 + cw / 2 - bw / 2, y0 + ch + 2 * U + oy, bw, 13 * U); c.font = `bold ${9.5 * U}px sans-serif`; c.textAlign = 'center'; c.fillStyle = '#f4f8ff'; c.fillText(`${T('鹽米', '鹽米')} −40% ${Math.ceil(left)}`, x0 + cw / 2, y0 + ch + 12 * U + oy); }
    // 封禁：設備＝飄動黃符＋金鎖鏈＋倒數；名鬼＝頭頂黃符＋「被封印 N 秒」
    for (const s of S.seals) { const left = s.dur - s.t, pop = Math.min(1, s.t / 0.25), endBlink = left < 1.5 ? 0.6 + 0.4 * Math.sin(t * 18) : 1;
      if (s.kind === 'dev') { const rc = devRect(W, s.i); if (!rc) continue; const [x0, y0, cw, ch] = rc, cx = x0 + cw / 2;
        c.fillStyle = 'rgba(40,24,0,0.5)'; c.fillRect(x0, y0, cw, ch);
        const SI = sealIm();
        if (SI) { const H0 = Math.max(ch * 1.25, cw * 0.95) * Math.min(1.3, Math.max(0.9, 1)), sc = pop < 1 ? 1.5 - 0.5 * pop + Math.sin(pop * Math.PI) * 0.12 : 1 + Math.sin(t * 2.2 + s.seed) * 0.025, hW = H0 * SI.naturalWidth / SI.naturalHeight;
          c.save(); c.globalAlpha = Math.min(1, pop * 1.5) * endBlink; c.translate(cx, y0 + ch * 0.5); c.rotate(Math.sin(t * 1.6 + s.seed) * 0.04); c.scale(sc, sc);
          const g = c.createRadialGradient(0, 0, 4 * U, 0, 0, H0 * 0.62); g.addColorStop(0, `rgba(255,215,90,${0.32 + 0.12 * Math.sin(t * 4)})`); g.addColorStop(1, 'rgba(255,215,90,0)'); c.fillStyle = g; c.beginPath(); c.arc(0, 0, H0 * 0.62, 0, 7); c.fill();
          c.drawImage(SI, -hW / 2, -H0 / 2, hW, H0); c.restore(); }
        else { c.save(); c.globalAlpha = endBlink; chainLine(c, x0 - 4 * U, y0 + 4 * U, x0 + cw + 4 * U, y0 + ch - 4 * U, U, t); chainLine(c, x0 + cw + 4 * U, y0 + 4 * U, x0 - 4 * U, y0 + ch - 4 * U, U, t + 1); c.restore();
        const fw = Math.min(cw * 0.42, 30 * U) * pop, fh = fw * 2.5; drawFu(c, cx, y0 - fh * 0.32, fw, fh, t, s.seed, endBlink); }
        const named = s.tgt && s.tgt.staff != null && W.staffMul && W.staffMul(s.tgt).named;
        { const bx = x0 + cw + 2 * U, by = y0 + 2 * U, br = 12 * U; c.fillStyle = 'rgba(40,20,0,0.9)'; c.beginPath(); c.arc(bx, by, br, 0, 7); c.fill(); c.strokeStyle = '#ffd45a'; c.lineWidth = 2.5 * U; c.beginPath(); c.arc(bx, by, br, -Math.PI / 2, -Math.PI / 2 + 6.283 * left / s.dur); c.stroke(); bigTxt(c, String(Math.ceil(left)), bx, by + 6 * U, 17 * U, '#ffd45a', '#2a1600'); }
        bigTxt(c, named ? T(`名鬼被封印 ${Math.ceil(left)} 秒`, `名鬼被封印 ${Math.ceil(left)} 秒`) : T('封禁中', '封禁中'), cx, y0 + ch + 14 * U, 10 * U, '#ffe9a0'); }
      else if (W.bpos) { const [x, y] = W.P(...W.bpos(s.tgt)), top = y - hh * 1.55;
        c.strokeStyle = `rgba(255,212,90,${0.5 * endBlink})`; c.lineWidth = 3 * U; c.beginPath(); c.ellipse(x, y, hh * 0.8, hh * 0.26, 0, t * 2, t * 2 + 5.2); c.stroke();
        const fw = 18 * U * pop, SI = sealIm(); if (SI) { const H0 = fw * 3.2, hW = H0 * SI.naturalWidth / SI.naturalHeight; c.save(); c.globalAlpha = endBlink; c.translate(x, top - H0 * 0.42); c.rotate(Math.sin(t * 1.8 + s.seed) * 0.06); c.drawImage(SI, -hW / 2, -H0 / 2, hW, H0); c.restore(); } else drawFu(c, x, top - fw * 2.4, fw, fw * 2.4, t, s.seed, endBlink);
        bigTxt(c, T(`被封印 ${Math.ceil(left)} 秒`, `被封印 ${Math.ceil(left)} 秒`), x, top - fw * 2.6, 12 * U, '#ffd45a'); } }
    // 解封：封條左右撕開飛走＋鎖鏈碎、金光粒子
    for (const f of (S.brk || [])) { const SI = sealIm(), k = f.t / f.dur, e = 1 - Math.pow(1 - k, 2), [px, py] = W.P(f.x, f.y), rc = f.kind === 'dev' ? devRect(W, f.i) : null;
      const cx = rc ? rc[0] + rc[2] / 2 : px, cy = rc ? rc[1] + rc[3] / 2 : py - hh * 1.9, H0 = rc ? Math.max(rc[3] * 1.25, rc[2] * 0.95) : 18 * U * 3.2;
      c.save(); c.globalAlpha = 1 - k;
      if (SI) { const hW = H0 * SI.naturalWidth / SI.naturalHeight, iw = SI.naturalWidth, ih = SI.naturalHeight;
        for (const sd of [-1, 1]) { c.save(); c.translate(cx + sd * e * H0 * 0.55, cy - Math.sin(k * Math.PI) * H0 * 0.25 + e * H0 * 0.2); c.rotate(sd * e * 0.9); const sx = sd < 0 ? 0 : iw / 2; c.drawImage(SI, sx, 0, iw / 2, ih, sd < 0 ? -hW / 2 : 0, -H0 / 2, hW / 2, H0); c.restore(); } }
      for (let j = 0; j < 14; j++) { const a = j * 0.449 + f.seed, d = e * H0 * (0.4 + (j % 4) * 0.15); c.fillStyle = j % 3 ? `rgba(255,214,90,${1 - k})` : `rgba(255,250,220,${1 - k})`; c.beginPath(); c.arc(cx + Math.cos(a) * d, cy + Math.sin(a) * d * 0.7 + k * k * 20 * U, (2.6 - k * 1.5) * U, 0, 7); c.fill(); }
      c.restore(); }
    // 道士唸咒進度圈＋強敵標記
    for (const w of W.walkers) { if (!w.foe || w.gone || !W.alive(w)) continue; const F = w.foe, C = FOES[F.id], [x, y] = W.P(...W.wp(w));
      if (F.chant) { const k = Math.min(1, F.chant.t / F.chant.dur), cy = y - hh * 1.55, r = 13 * U, jx = F.chant.jolt > 0 ? (Math.random() - 0.5) * 5 * U : 0;
        c.fillStyle = 'rgba(30,18,0,0.7)'; c.beginPath(); c.arc(x + jx, cy, r + 3 * U, 0, 7); c.fill();
        c.strokeStyle = 'rgba(255,212,90,0.25)'; c.lineWidth = 4 * U; c.beginPath(); c.arc(x + jx, cy, r, 0, 7); c.stroke();
        c.strokeStyle = F.chant.jolt > 0 ? '#ff8a6a' : '#ffd45a'; c.beginPath(); c.arc(x + jx, cy, r, -Math.PI / 2, -Math.PI / 2 + k * 6.283); c.stroke();
        c.save(); c.translate(x + jx, cy); c.rotate(t * 2); c.strokeStyle = '#ffe9a0'; c.lineWidth = 1.4 * U; for (let j = 0; j < 3; j++) { c.rotate(2.094); c.beginPath(); c.arc(0, -r * 0.42, r * 0.28, 0, 4.4); c.stroke(); } c.restore();
        const tg = F.chant.kind === 'boss' ? (W.bpos ? W.P(...W.bpos(F.chant.tgt)) : null) : (() => { const sp = W.lay.posts[F.chant.i]; return sp && W.P(sp.x, sp.y); })();
        if (tg) { c.strokeStyle = `rgba(255,212,90,${0.35 + 0.3 * k})`; c.setLineDash([4 * U, 4 * U]); c.lineDashOffset = -t * 30; c.lineWidth = 2 * U; c.beginPath(); c.moveTo(x, y - hh * 0.7); c.lineTo(tg[0], tg[1]); c.stroke(); c.setLineDash([]); } }
      const used = Object.keys(F.by).filter(k => k !== 'other' && F.by[k] > 0).length;
      if (C.res && Object.keys(F.by).length) { const px = x + hh * 0.31 + 7 * U, py = y - hh - 6.5 * U; for (let j = 0; j < 3; j++) { c.beginPath(); c.arc(px + j * 8 * U, py, 3 * U, 0, 7); c.fillStyle = j < used ? C.tag : 'rgba(30,24,40,0.85)'; c.fill(); c.strokeStyle = j < used ? '#1a1208' : 'rgba(255,233,176,0.7)'; c.lineWidth = 1.3 * U; c.stroke(); } }
      if (F.retreated) bigTxt(c, T('撤符', '撤符'), x, y - hh - 26 * U, 10 * U, '#ffe9a0'); }
    c.restore();
  }

  // ---------- 佔位 Q 版角色（大頭細身）；有 SPR['foe_<id>'] 圖就用圖 ----------
  // 喺已 translate 到腳底 (0,0) 嘅 ctx 入面畫；o = { flip, t, walk, cast }
  function drawBody(c, w, hh, t, o) {
    if (!w || !w.foe) return false; o = o || {}; const id = w.foe.id;
    const im = typeof SPR !== 'undefined' && SPR['foe_' + id];
    if (im && im.naturalWidth) { const H = hh * 1.0, Wd = H * im.naturalWidth / im.naturalHeight; c.save(); c.translate(0, -Math.abs(Math.sin(t * 5 + (w.seed || 0))) * hh * (w.stay > 0 || w.block > 0 ? 0 : 0.035)); if (o.flip) c.scale(-1, 1); c.drawImage(im, -Wd / 2, -H, Wd, H); c.restore(); return true; }
    const cast = o.cast != null ? o.cast : !!(w.foe.chant || w.foe.scan > 0), walk = o.walk != null ? o.walk : !cast && !(w.block > 0) && !(w.stay > 0);
    drawQ(c, id, hh * 1.12, t + (w.seed || 0), !!o.flip, walk, cast); return true;
  }
  function drawQ(c, id, H, t, flip, walk, cast) {
    const r = H * 0.25, hy = -H + r, bodyTop = hy + r * 0.85, lw = Math.max(1.4, H * 0.028), bob = walk ? Math.abs(Math.sin(t * 8)) * H * 0.03 : 0, sw = walk ? Math.sin(t * 8) : 0;
    const OL = '#1a1208', SK = '#f3d2a8';
    c.save(); if (flip) c.scale(-1, 1); c.translate(0, -bob); c.lineJoin = 'round'; c.lineCap = 'round'; c.lineWidth = lw; c.strokeStyle = OL;
    const P = { taoist:{ body:'#e9bd3a', trim:'#8a5a12', leg:'#2b2320', shoe:'#141010' }, hunter:{ body:'#3f5a4a', trim:'#24342b', leg:'#2c3a5c', shoe:'#1a1a1a' }, streamer:{ body:'#e45a9a', trim:'#a83470', leg:'#2a2a3a', shoe:'#f4f4f4' } }[id];
    // 腳
    for (const s of [-1, 1]) { const lx = s * H * 0.07 + sw * s * H * 0.04; c.fillStyle = P.leg; c.beginPath(); c.rect(lx - H * 0.035, -H * 0.16, H * 0.07, H * 0.14); c.fill(); c.stroke(); c.fillStyle = P.shoe; c.beginPath(); c.ellipse(lx + H * 0.015, -H * 0.02, H * 0.055, H * 0.03, 0, 0, 7); c.fill(); c.stroke(); }
    // 身
    c.fillStyle = P.body; c.beginPath();
    if (id === 'taoist') { c.moveTo(-H * 0.12, bodyTop); c.lineTo(H * 0.12, bodyTop); c.lineTo(H * 0.19, -H * 0.12); c.quadraticCurveTo(0, -H * 0.09, -H * 0.19, -H * 0.12); c.closePath(); }
    else { c.moveTo(-H * 0.12, bodyTop); c.lineTo(H * 0.12, bodyTop); c.lineTo(H * 0.14, -H * 0.15); c.lineTo(-H * 0.14, -H * 0.15); c.closePath(); }
    c.fill(); c.stroke();
    if (id === 'taoist') { c.strokeStyle = P.trim; c.lineWidth = lw * 1.4; c.beginPath(); c.moveTo(-H * 0.07, bodyTop + H * 0.01); c.lineTo(H * 0.03, bodyTop + H * 0.13); c.moveTo(H * 0.07, bodyTop + H * 0.01); c.lineTo(H * 0.0, bodyTop + H * 0.09); c.stroke();
      c.fillStyle = '#7a2a1a'; c.fillRect(-H * 0.15, bodyTop + H * 0.17, H * 0.3, H * 0.035); c.strokeStyle = OL; c.lineWidth = lw; }
    else if (id === 'hunter') { c.strokeStyle = P.trim; c.beginPath(); c.moveTo(0, bodyTop + H * 0.02); c.lineTo(0, -H * 0.16); c.stroke(); c.fillStyle = '#6a4a2a'; c.fillRect(-H * 0.16, bodyTop + H * 0.02, H * 0.05, H * 0.2); c.strokeStyle = OL; c.strokeRect(-H * 0.16, bodyTop + H * 0.02, H * 0.05, H * 0.2);
      c.fillStyle = '#d8a83a'; c.beginPath(); c.arc(-H * 0.07, bodyTop + H * 0.17, H * 0.035, 0, 7); c.fill(); c.stroke(); c.strokeStyle = '#a02020'; c.beginPath(); c.moveTo(-H * 0.07, bodyTop + H * 0.17); c.lineTo(-H * 0.07 + Math.cos(t * 7) * H * 0.028, bodyTop + H * 0.17 + Math.sin(t * 7) * H * 0.028); c.stroke(); c.strokeStyle = OL; }
    else { c.fillStyle = P.trim; c.beginPath(); c.ellipse(0, bodyTop + H * 0.15, H * 0.07, H * 0.03, 0, 0, 7); c.fill(); }
    // 手＋道具
    const armY = bodyTop + H * 0.05;
    if (id === 'taoist') { const raise = cast ? 1 : 0; c.save(); c.translate(H * 0.11, armY); c.rotate(cast ? -1.9 + Math.sin(t * 6) * 0.08 : 0.5 + sw * 0.15);
      c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke(); c.fillStyle = SK; c.beginPath(); c.arc(0, H * 0.15, H * 0.032, 0, 7); c.fill(); c.stroke();
      c.translate(0, H * 0.15); c.rotate(cast ? 2.0 : 0.3); c.fillStyle = '#a5652e'; c.beginPath(); c.moveTo(-H * 0.022, -H * 0.02); c.lineTo(-H * 0.02, -H * 0.36); c.lineTo(0, -H * 0.4); c.lineTo(H * 0.02, -H * 0.36); c.lineTo(H * 0.022, -H * 0.02); c.closePath(); c.fill(); c.stroke();
      c.strokeStyle = '#d99a58'; c.beginPath(); c.moveTo(0, -H * 0.05); c.lineTo(0, -H * 0.33); c.stroke(); c.strokeStyle = OL; c.fillStyle = '#6a3a1a'; c.fillRect(-H * 0.05, -H * 0.04, H * 0.1, H * 0.025); c.strokeRect(-H * 0.05, -H * 0.04, H * 0.1, H * 0.025);
      c.strokeStyle = '#c8281e'; c.lineWidth = lw * 1.5; c.beginPath(); c.moveTo(0, 0); c.quadraticCurveTo(H * 0.03 + Math.sin(t * 5) * H * 0.02, H * 0.06, Math.sin(t * 4) * H * 0.03, H * 0.1); c.stroke(); c.restore(); c.lineWidth = lw; c.strokeStyle = OL;
      c.save(); c.translate(-H * 0.11, armY); c.rotate(cast ? 0.9 : -0.4 - sw * 0.15); c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke(); c.fillStyle = SK; c.beginPath(); c.arc(0, H * 0.15, H * 0.032, 0, 7); c.fill(); c.stroke(); c.restore(); void raise; }
    else if (id === 'hunter') { c.save(); c.translate(H * 0.11, armY); c.rotate(cast ? -1.45 : 0.35 + sw * 0.15); c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke(); c.fillStyle = SK; c.beginPath(); c.arc(0, H * 0.15, H * 0.032, 0, 7); c.fill(); c.stroke();
      c.translate(0, H * 0.15); c.rotate(-Math.PI / 2 + (cast ? 0 : 0.3)); c.fillStyle = '#5a5e66'; c.fillRect(-H * 0.02, -H * 0.03, H * 0.15, H * 0.06); c.strokeRect(-H * 0.02, -H * 0.03, H * 0.15, H * 0.06); c.fillStyle = cast ? '#fffbd0' : '#e8e0a0'; c.beginPath(); c.ellipse(H * 0.135, 0, H * 0.018, H * 0.04, 0, 0, 7); c.fill(); c.stroke();
      if (cast) { const g = c.createRadialGradient(H * 0.14, 0, 1, H * 0.14, 0, H * 0.12); g.addColorStop(0, 'rgba(255,255,220,0.9)'); g.addColorStop(1, 'rgba(255,255,220,0)'); c.fillStyle = g; c.beginPath(); c.arc(H * 0.14, 0, H * 0.12, 0, 7); c.fill(); } c.restore();
      c.save(); c.translate(-H * 0.11, armY); c.rotate(-0.35 - sw * 0.15); c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke(); c.fillStyle = SK; c.beginPath(); c.arc(0, H * 0.15, H * 0.032, 0, 7); c.fill(); c.stroke(); c.restore(); }
    else { c.save(); c.translate(H * 0.11, armY); c.rotate(-2.3 + Math.sin(t * 2) * 0.1); c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke();
      c.strokeStyle = '#888'; c.lineWidth = lw * 1.2; c.beginPath(); c.moveTo(0, H * 0.13); c.lineTo(0, H * 0.36); c.stroke(); c.strokeStyle = OL; c.lineWidth = lw;
      c.translate(0, H * 0.4); c.fillStyle = '#222'; c.fillRect(-H * 0.035, -H * 0.05, H * 0.07, H * 0.1); c.lineWidth = H * 0.02; c.strokeStyle = `rgba(255,250,250,${0.85 + 0.15 * Math.sin(t * 9)})`; c.beginPath(); c.arc(0, 0, H * 0.085, 0, 7); c.stroke();
      const g = c.createRadialGradient(0, 0, H * 0.05, 0, 0, H * 0.16); g.addColorStop(0, 'rgba(255,240,250,0.5)'); g.addColorStop(1, 'rgba(255,240,250,0)'); c.fillStyle = g; c.beginPath(); c.arc(0, 0, H * 0.16, 0, 7); c.fill(); c.restore(); c.lineWidth = lw; c.strokeStyle = OL;
      c.save(); c.translate(-H * 0.11, armY); c.rotate(-0.3 - sw * 0.15); c.fillStyle = P.body; c.beginPath(); c.rect(-H * 0.03, 0, H * 0.06, H * 0.13); c.fill(); c.stroke(); c.fillStyle = SK; c.beginPath(); c.arc(0, H * 0.15, H * 0.032, 0, 7); c.fill(); c.stroke(); c.restore(); }
    // 大頭
    c.fillStyle = SK; c.beginPath(); c.arc(0, hy, r, 0, 7); c.fill(); c.stroke();
    if (id === 'taoist') { c.fillStyle = '#1c1a1a'; c.beginPath(); c.arc(0, hy, r, Math.PI * 1.05, Math.PI * 1.95); c.quadraticCurveTo(0, hy - r * 0.45, -r * 0.98, hy - r * 0.2); c.fill(); c.stroke();
      c.fillStyle = '#1c1a1a'; c.beginPath(); c.arc(0, hy - r * 1.02, r * 0.3, 0, 7); c.fill(); c.stroke(); c.fillStyle = '#2a2a2a'; c.fillRect(-r * 0.36, hy - r * 1.32, r * 0.72, r * 0.22); c.strokeRect(-r * 0.36, hy - r * 1.32, r * 0.72, r * 0.22);
      c.fillStyle = '#d9b23a'; c.beginPath(); c.arc(0, hy - r * 1.21, r * 0.07, 0, 7); c.fill(); }
    else if (id === 'hunter') { c.fillStyle = '#26303a'; c.beginPath(); c.arc(0, hy - r * 0.08, r * 1.02, Math.PI * 1.02, Math.PI * 1.98); c.closePath(); c.fill(); c.stroke(); c.beginPath(); c.moveTo(r * 0.5, hy - r * 0.18); c.lineTo(r * 1.35, hy - r * 0.12); c.lineTo(r * 0.95, hy - r * 0.02); c.closePath(); c.fill(); c.stroke(); }
    else { c.fillStyle = '#5a2a4a'; c.beginPath(); c.arc(0, hy, r * 1.04, Math.PI * 0.95, Math.PI * 2.05); c.quadraticCurveTo(r * 0.3, hy - r * 0.35, -r * 1.0, hy + r * 0.15); c.fill(); c.stroke(); c.fillStyle = P.body; c.beginPath(); c.arc(0, hy + r * 0.1, r * 1.12, Math.PI * 0.08, Math.PI * 0.92); c.lineTo(-r * 0.9, hy + r * 0.75); c.lineTo(r * 0.9, hy + r * 0.75); c.closePath(); c.fill(); c.stroke(); }
    // 面
    const ex = r * 0.38, ey = hy + r * 0.12; c.fillStyle = OL; for (const s of [-1, 1]) { c.beginPath(); c.ellipse(s * ex + r * 0.12, ey, r * 0.09, r * (cast && id !== 'streamer' ? 0.04 : 0.13), 0, 0, 7); c.fill(); }
    c.lineWidth = lw * 0.9; c.beginPath(); if (id === 'streamer') { c.arc(r * 0.12, ey + r * 0.32, r * 0.16, 0.2, Math.PI - 0.2); } else { c.moveTo(r * 0.0, ey + r * 0.4); c.lineTo(r * 0.24, ey + r * 0.38); } c.stroke();
    if (id !== 'streamer') { c.beginPath(); c.moveTo(-ex + r * 0.0, ey - r * 0.24); c.lineTo(-ex + r * 0.24, ey - r * 0.18); c.moveTo(ex + r * 0.0, ey - r * 0.18); c.lineTo(ex + r * 0.24, ey - r * 0.24); c.stroke(); }
    c.restore();
  }

  return { FOES, RES, reset, spawnTable, roll, decorate, update, draw, drawBody, drawFu, onHit, isSealed, isPaused, blocks, devMul, get state() { return S; } };
})();
if (typeof module !== 'undefined' && module.exports) module.exports = StnFoes;
