const { chromium } = require('/opt/npm-tools/node_modules/playwright');
(async () => {
  const br = await chromium.launch({ executablePath:'/usr/bin/google-chrome', args:['--no-sandbox'] });
  const pg = await br.newPage({ viewport:{ width:840, height:620 }, deviceScaleFactor:1.5 });
  const errs = []; pg.on('pageerror', e => errs.push(String(e))); pg.on('console', m => { if (m.type() === 'error') errs.push(m.text()); });
  await pg.goto('file:///home/claude/gb/tools/foes_test.html');
  const shot = (n) => pg.screenshot({ path:`/tmp/claude-0/out/foes_${n}.png` });
  const R = {};

  // ---- 1. 道士：念咒 → 封禁（設備＋名鬼）→ 倒數 → 解封 ----
  R.seal = await pg.evaluate(() => {
    const { W, sim, mkWalker, resetWorld, render } = T; resetWorld();
    W.bosses.push({ pos:[0.42, 0.25], hid:false }); mkWalker(null, 0.3); const tw = mkWalker('taoist', 0.17, 100);
    const out = { chantSeen:false, seals:[], stuckOk:true, log:null };
    let firstSeal = null, p0 = W.sd.posts[0];
    // 跑到開始唸咒並讀到 ~60%
    sim(12, () => { const ch = tw.foe.chant; if (ch && !out.chantSeen && ch.t / ch.dur > 0.6) { out.chantSeen = true; out.chantAt = T.TIME; out.chantTgt = ch.kind + ':' + ch.i; window.CAP = '道士唸咒中'; render(); window.__stop = 1; } });
    return out;
  });
  // 重新跑一次並喺唸咒中截圖（render 喺 evaluate 入面已畫，直接截）
  await pg.evaluate(() => { const { W, step, mkWalker, resetWorld, render } = T; resetWorld(); W.bosses.push({ pos:[0.42, 0.25], hid:false }); mkWalker(null, 0.3); window.TW = mkWalker('taoist', 0.17, 100);
    for (let i = 0; i < 30 * 15; i++) { step(1 / 30); const ch = TW.foe.chant; if (ch && ch.t / ch.dur > 0.6) break; } window.CAP = '① 道士停低唸咒（頭頂進度圈）'; render(); });
  await shot('1_chant');
  R.seal2 = await pg.evaluate(() => {
    const { W, step, render } = T, S = StnFoes.state, out = { events:[] }; let snapped = false;
    const p0 = W.sd.posts[0]; let onBefore = null, frozenOk = true, sealDur = null, sealStart = null;
    for (let i = 0; i < 30 * 30; i++) {
      const before = p0.on; step(1 / 30);
      const s = S.seals.find(q => q.tgt === p0);
      if (s && sealStart == null) { sealStart = T.TIME; sealDur = s.dur; }
      if (s && s.t > 0.05 && p0.on !== before) frozenOk = false;
      if (S.seals.length >= 2 && !snapped && S.seals.every(q => q.t > 1.2)) { snapped = true; out.twoSeals = S.seals.map(q => q.kind + ':' + q.i + ' dur=' + q.dur.toFixed(2)); out.maxAtOnce = S.seals.length; window.CAP = '② 設備被封（黃符＋鎖鏈＋倒數）／名鬼被封印'; render(); break; }
    }
    out.sealStart = sealStart; out.sealDur = sealDur; out.frozenOk = frozenOk; out.isSealedNow = StnFoes.isSealed(p0);
    return out;
  });
  await shot('2_sealed');
  R.seal3 = await pg.evaluate(() => {
    const { W, step, render } = T, S = StnFoes.state, p0 = W.sd.posts[0]; let maxSeals = 0, unsealAt = null, onAtUnseal = null;
    for (let i = 0; i < 30 * 14; i++) { step(1 / 30); maxSeals = Math.max(maxSeals, S.seals.filter(q => q.by === TW).length); if (unsealAt == null && !StnFoes.isSealed(p0)) { unsealAt = T.TIME; onAtUnseal = p0.on; } if (S.seals.some(q => q.kind === 'boss' && q.t > 1.2)) break; }
    window.CAP = '③ 左邊設備已解封恢復運作；名鬼被封印'; render();
    return { unsealAt, maxSealsByOne:maxSeals, resumed:p0.on > onAtUnseal, onGain:+(p0.on - onAtUnseal).toFixed(2), log:T.LOG.slice(0, 12) };
  });
  await shot('3_unsealed');

  // ---- 1b. 撤符＋抗性 ----
  R.resist = await pg.evaluate(() => {
    const { W, step, mkWalker, resetWorld } = T; resetWorld(); mkWalker(null, 0.05); const tw = mkWalker('taoist', 0.17, 100);
    for (let i = 0; i < 30 * 15 && !StnFoes.state.seals.length; i++) step(1 / 30);
    const hadSeal = StnFoes.state.seals.length; const max = tw.max;
    W._foeRole = 'scare'; let a = 0; for (let k = 0; k < 10; k++) a += StnFoes.onHit(tw, max * 0.1, {}, W); // 單一類設備打足 100%
    const oneType = a / max; tw.hp = max - a;
    W._foeRole = 'trap'; let b = StnFoes.onHit(tw, max * 0.3, {}, W); tw.hp -= b; W._foeRole = null;
    step(1 / 30); return { hpMul:max / 100, oneTypeShare:+oneType.toFixed(3), secondTypeFull:+(b / max).toFixed(3), hadSeal, sealsAfterRetreat:StnFoes.state.seals.length, retreated:tw.foe.retreated, say:tw.say && tw.say.s };
  });

  // ---- 2. 捉鬼師扇形電筒 ----
  R.beam = await pg.evaluate(() => {
    const { W, step, mkWalker, resetWorld, render } = T; resetWorld(); const h = mkWalker('hunter', 0.42, 100); h.foe.scd = 99; h.foe.bcd = 0.2;
    let hit = null, shotDone = false;
    for (let i = 0; i < 30 * 10; i++) { step(1 / 30); const S = StnFoes.state; if (!hit && S.pause.size) hit = { at:T.TIME, devs:[...S.pause.values()].map(v => v.i), dur:[...S.pause.values()].map(v => v.dur) };
      if (hit && !shotDone && T.TIME - hit.at > 0.45) { shotDone = true; window.CAP = '④ 捉鬼師強光電筒：扇形內設備暫停 4 秒'; render(); break; } }
    return { hit, pausedNow:W.sd.posts.map(p => +StnFoes.isPaused(p).toFixed(2)) };
  });
  await shot('4_beam');
  R.beam2 = await pg.evaluate(() => { const { W, step } = T; const ps = W.sd.posts, ons = ps.map(p => p.on); let firstFree = null; for (let i = 0; i < 30 * 5; i++) { step(1 / 30); if (firstFree == null && ps.every(p => !StnFoes.isPaused(p))) firstFree = T.TIME; } return { allFreeAt:firstFree, gain:ps.map((p, i) => +(p.on - ons[i]).toFixed(2)) }; });

  // ---- 3. 鹽米減益 ----
  R.salt = await pg.evaluate(() => {
    const { W, step, mkWalker, resetWorld, render } = T; resetWorld(); const h = mkWalker('hunter', 0.5, 100); h.foe.bcd = 99; h.foe.scd = 0.1; h.spd = 0;
    let at = null, snapped = false; const S = StnFoes.state;
    for (let i = 0; i < 30 * 3; i++) { step(1 / 30); if (!at && S.salt.size) at = T.TIME; if (at && !snapped && T.TIME - at > 1.0) { snapped = true; window.CAP = '⑤ 鹽米：範圍內設備效果 −40%（6 秒）'; render(); break; } }
    const muls = W.sd.posts.map(p => StnFoes.devMul(p)); h.foe.scd = 99;
    const salted = W.sd.posts.filter(p => StnFoes.devMul(p) < 1), on0 = salted.map(p => p.on); for (let i = 0; i < 30; i++) step(1 / 30); const rate = salted.map((p, i) => +(p.on - on0[i]).toFixed(3));
    let endAt = null; for (let i = 0; i < 30 * 8; i++) { step(1 / 30); if (endAt == null && salted.every(p => StnFoes.devMul(p) === 1)) endAt = T.TIME; }
    return { saltAt:at, mulsAt1s:muls, ratePerSecWhileSalted:rate, endAt, durObserved:endAt && at ? +(endAt - at).toFixed(2) : null };
  });
  // 截圖要喺減益生效時：重做一次只截圖
  await pg.evaluate(() => { const { W, step, mkWalker, resetWorld, render } = T; resetWorld(); const h = mkWalker('hunter', 0.5, 100); h.foe.bcd = 99; h.foe.scd = 0.1; h.spd = 0; for (let i = 0; i < 30 * 1.5; i++) step(1 / 30); window.CAP = '⑤ 鹽米：範圍內設備效果 −40%（6 秒）'; render(); });
  await shot('5_salt');

  // ---- 4. 直播主光環 ----
  R.stream = await pg.evaluate(() => {
    const { W, step, mkWalker, resetWorld, render } = T; resetWorld(); const s = mkWalker('streamer', 0.5, 100); s.spd = 0; const near = mkWalker(null, 0.56); near.spd = 0; const far = mkWalker(null, 0.95); far.spd = 0;
    for (let i = 0; i < 60; i++) step(1 / 30); W._foeRole = 'scare';
    const dn = StnFoes.onHit(near, 100, {}, W), df = StnFoes.onHit(far, 100, {}, W), ds = StnFoes.onHit(s, 100, {}, W); W._foeRole = null;
    window.CAP = '⑥ 靈異直播主環形燈：附近路人膽量 +30%'; render(); return { nearDmg:+dn.toFixed(2), farDmg:df, streamerTakes:ds, hpMul:s.max / 100 };
  });
  await shot('6_streamer');

  // ---- 5. 佔位 Q 版角色表 ----
  await pg.evaluate(() => { const c = document.getElementById('cv').getContext('2d'); c.fillStyle = '#1d1828'; c.fillRect(0, 0, 840, 620); const t = performance.now() / 1000;
    const L = [['taoist', '茅山道士・行', 0], ['taoist', '茅山道士・唸咒', 1], ['hunter', '捉鬼師・行', 0], ['hunter', '捉鬼師・照電筒', 1], ['streamer', '直播主', 0]];
    L.forEach(([id, n, cast], k) => { const x = 90 + k * 165, y = 430, w = { foe:{ id, chant:null, scan:0 }, seed:k }; c.save(); c.translate(x, y); StnFoes.drawBody(c, w, 230, t, { walk:!cast, cast:!!cast, flip:false }); c.restore(); c.fillStyle = '#fff'; c.font = 'bold 16px sans-serif'; c.textAlign = 'center'; c.fillText(n, x, y + 40); });
    StnFoes.drawFu(c, 420, 470, 44, 110, t, 1); c.fillStyle = '#ffe9a0'; c.font = '13px sans-serif'; c.fillText('黃符（抽象符紋）', 420, 600);
    document.getElementById('log').textContent = '佔位 Q 版剪影（之後換 SPR.foe_taoist / foe_hunter / foe_streamer）'; });
  await shot('7_cast');

  R.errors = errs; console.log(JSON.stringify(R, null, 1)); await br.close();
})();
