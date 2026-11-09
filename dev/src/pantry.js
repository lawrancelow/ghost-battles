// ===================== 茶水間：電器浮出嚟（剪影＋接觸陰影＋邊光）、待機小動作、用／嚇嘅效果、休息區圓枱 =====================
// 座標：全部用新全景 px（x）同背景 px（y，0~1024），畫嘅時候經 Scare.pt 轉做畫面座標
// 只係 monkeypatch OFFMAP.drawBack / drawables / tick / onProp，唔改 rooms.js
const Pantry = (() => {
  const PXU = 1165, SH = 1024, PI = Math.PI;
  const D = (yue, zh) => { if (typeof LANG !== 'undefined') LANG.add({ [yue]:zh }); return yue; };
  const LINES = {
    fridge:[D('雪櫃門……自己開咗？', '冰箱門……自己開了？'), D('喂，邊個開咗雪櫃唔閂啊？', '喂，誰打開冰箱沒關啊？')],
    vend:[D('我都未入錢……點解會跌嘢出嚟？', '我都還沒投錢……怎麼會掉東西出來？')],
    water:[D('水機漏水呀？成地都係……', '飲水機漏水啊？滿地都是……')],
    coffee:[D('咖啡機自己沖咖啡？我冇撳掣喎……', '咖啡機自己沖咖啡？我沒按按鈕啊……')],
    micro:[D('入面冇嘢……佢叮乜嘢啊？', '裡面沒東西……它在叮什麼啊？')],
  };
  // ---- 電器形狀（背景 px）：r = 圓角；多塊 = 合併 ----
  const AP = {
    cab:   { sh:[[6514, 206, 552, 132, 6]], floor:false },
    micro: { sh:[[6757, 392, 132, 79, 9]], floor:false },
    coffee:{ sh:[[6899, 365, 88, 106, 9]], floor:false },
    fridge:{ sh:[[7073, 249, 186, 366, 13]], floor:true },
    water: { sh:[[7268, 300, 92, 116, 16], [7263, 405, 102, 210, 10]], floor:true },
    vend:  { sh:[[7371, 262, 227, 353, 9]], floor:true },
  };
  const ORDER = ['cab', 'micro', 'coffee', 'fridge', 'water', 'vend'];
  const box = (sh) => { let x0 = 1e9, y0 = 1e9, x1 = -1e9, y1 = -1e9; for (const [x, y, w, h] of sh) { x0 = Math.min(x0, x); y0 = Math.min(y0, y); x1 = Math.max(x1, x + w); y1 = Math.max(y1, y + h); } return [x0, y0, x1 - x0, y1 - y0]; };
  for (const k in AP) AP[k].b = box(AP[k].sh);
  // 休息區（同 OFFMAP.SPOT 一致）
  const table = OFFMAP.SPOT.restTable, seats = OFFMAP.SPOT.restSeats;

  let NIGHT = null, CUT = {}, st = null, last = null;
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const sc = () => Scare.bgScale().s;
  const Q = (x, y) => Scare.pt(x / PXU, y / SH);
  const rr = (c, x, y, w, h, r) => { c.beginPath(); c.moveTo(x + r, y); c.arcTo(x + w, y, x + w, y + h, r); c.arcTo(x + w, y + h, x, y + h, r); c.arcTo(x, y + h, x, y, r); c.arcTo(x, y, x + w, y, r); c.closePath(); };
  function night() { // 只做茶水間嗰段夜色（同 rooms.js 嘅 pano() 一樣嘅調色）
    if (NIGHT) return NIGHT; if (!ok('bg_office_pano')) return null;
    const im = SPR.bg_office_pano, k = im.naturalHeight / SH, X0 = 6480, X1 = 7620, c = document.createElement('canvas');
    c.width = Math.round((X1 - X0) * k); c.height = im.naturalHeight; const x = c.getContext('2d');
    x.drawImage(im, X0 * k, 0, (X1 - X0) * k, c.height, 0, 0, c.width, c.height);
    x.globalCompositeOperation = 'multiply'; x.fillStyle = 'rgb(150,140,196)'; x.fillRect(0, 0, c.width, c.height);
    const g = x.createLinearGradient(0, c.height * 0.62, 0, c.height); g.addColorStop(0, 'rgb(255,255,255)'); g.addColorStop(1, 'rgb(160,152,186)'); x.fillStyle = g; x.fillRect(0, c.height * 0.62, c.width, c.height * 0.38);
    return NIGHT = { c, k, X0 };
  }
  const SHC = {}, DIMC = {};
  function cut(id) { // 按形狀剪出嚟（透明背景，邊位跟返黑色描邊）
    if (CUT[id]) return CUT[id]; const N = night(); if (!N) return null; const A = AP[id], [bx, by, bw, bh] = A.b, k = N.k;
    const c = document.createElement('canvas'); c.width = Math.ceil(bw * k); c.height = Math.ceil(bh * k); const x = c.getContext('2d');
    x.drawImage(N.c, (bx - N.X0) * k, by * k, bw * k, bh * k, 0, 0, c.width, c.height);
    x.globalCompositeOperation = 'destination-in'; x.fillStyle = '#000'; for (const [sx, sy, sw, shh, r] of A.sh) { rr(x, (sx - bx) * k, (sy - by) * k, sw * k, shh * k, r * k); x.fill(); }
    return CUT[id] = c;
  }
  function cutRect(id, rx, ry, rw, rh) { // 長方一塊（雪櫃門）
    if (CUT[id]) return CUT[id]; const N = night(); if (!N) return null; const k = N.k, c = document.createElement('canvas'); c.width = Math.ceil(rw * k); c.height = Math.ceil(rh * k);
    const x = c.getContext('2d'); x.drawImage(N.c, (rx - N.X0) * k, ry * k, rw * k, rh * k, 0, 0, c.width, c.height);
    x.globalCompositeOperation = 'destination-in'; rr(x, 0, 0, c.width, c.height, 10 * k); x.fill(); return CUT[id] = c;
  }
  const visible = () => { const [a] = Q(6480, 0), [b] = Q(7640, 0); return b > -40 && a < (Scare.W || 390) + 40; };

  // ---- 狀態 ----
  function reset() { st = { t:0, micro:null, coffee:null, fridge:null, water:null, vend:null, items:[], puddles:[], drips:[], mist:[], bub:[], flick:0, nextFlick:3, nextBub:4, use:{} }; }
  const EV = { // 每樣效果幾長（秒）
    micro:{ use:4.0, scare:4.5 }, coffee:{ use:5.0, scare:5.0 }, fridge:{ use:3.0, scare:3.4 }, water:{ use:2.6, scare:7.0 },
  };
  function fx(k, n, use) { // k：fridge / fridgeloop / vend / snack / water / coffee / micro / kettle / lights
    if (!st) reset(); const s = !use;
    const say = () => { if (s && n && Scare.bubble && LINES[k.replace('loop', '').replace('snack', 'vend')]) setTimeout(() => { if (Scare.active && !n.gone && !n.fleeing) { n.bubT = 0; Scare.bubble(n, L(pick(LINES[k.replace('loop', '').replace('snack', 'vend')])), 2.6); } }, 2200); };
    const snd = (x) => { try { if (!Scare.headless) Sound.play(x); } catch (e) {} };
    if (k === 'micro') { st.micro = { t:0, dur:s ? 4.5 : 4.0 }; snd('click'); }
    else if (k === 'coffee') { st.coffee = { t:0, dur:5.0 }; snd('click'); }
    else if (k === 'fridge' || k === 'fridgeloop') { st.fridge = { t:0, dur:k === 'fridgeloop' ? 7.2 : (s ? 3.4 : 3.0), loop:k === 'fridgeloop', bang:0 }; snd('whoosh'); }
    else if (k === 'water') { st.water = { t:0, dur:s ? 7.0 : 2.6, leak:s }; if (s) st.puddles.push({ x:7314, y:0.655, r:0, rmax:0.07 + Math.random() * 0.015, t:0, grow:7.0, life:32 }); }
    else if (k === 'vend' || k === 'snack') { const col = Math.floor(Math.random() * 4), row = k === 'snack' ? 0 : 3; st.vend = { t:0, dur:2.8, kind:k === 'snack' ? 'snack' : 'can', col, row, hue:[8, 35, 95, 200][col] }; st.flick = 1.4; snd('paper'); }
    else if (k === 'kettle' || k === 'lights') { ORIG.onProp(k, n, 'pantry'); return; }
    say();
  }
  const pick = (a) => a[Math.floor(Math.random() * a.length)];

  // ---- tick ----
  function tick(dt) {
    if (!st) reset(); st.t += dt;
    for (const k of ['micro', 'coffee', 'fridge', 'water']) { const e = st[k]; if (e) { e.t += dt; if (k === 'micro' && !e.ding && e.t > e.dur - 0.8) { e.ding = 1; try { if (!Scare.headless) Sound.play('click'); } catch (er) {} } if (e.t > e.dur) st[k] = null; } }
    const V = st.vend; if (V) { V.t += dt; if (!V.out && V.t > 1.15) { V.out = 1; st.items.push({ kind:V.kind, hue:V.hue, x:7450 + Math.random() * 40, y:0.62, t:0, vx:V.kind === 'can' ? -(70 + Math.random() * 30) : -(30 + Math.random() * 15), rot:0, dist:0 }); try { if (!Scare.headless) Sound.play('hit'); } catch (er) {} } if (V.t > V.dur) st.vend = null; }
    for (const it of st.items) { it.t += dt; if (it.t > 0.25) { const f = it.kind === 'can' ? 0.8 : 2.6; it.x += it.vx * dt; it.vx *= Math.exp(-dt * f); it.y = Math.min(0.69, it.y + dt * 0.06 * Math.exp(-it.t)); if (it.kind === 'can') it.rot += it.vx * dt / 9; } }
    st.items = st.items.filter(it => it.t < 14);
    for (const p of st.puddles) { p.t += dt; const g = Math.min(1, p.t / p.grow); p.r = p.rmax * (1 - Math.pow(1 - g, 2)) * (p.t > p.life * 0.55 ? Math.max(0.35, 1 - (p.t - p.life * 0.55) / (p.life * 0.45) * 0.65) : 1); }
    st.puddles = st.puddles.filter(p => p.t < p.life);
    // 冷氣霧：雪櫃開門嗰陣湧出嚟、沉落地
    const F = st.fridge; if (F && fridgeOpen(F) > 0.4) if (Math.random() < dt * 14) st.mist.push({ x:7095 + Math.random() * 140, y:330 + Math.random() * 60, vx:-10 + Math.random() * 30, vy:25 + Math.random() * 30, r:8 + Math.random() * 8, t:0, life:1.6 + Math.random() });
    for (const m of st.mist) { m.t += dt; m.x += m.vx * dt; m.y += m.vy * dt; if (m.y > 600) { m.y = 600; m.vy = 0; m.vx += (m.vx >= 0 ? 1 : -1) * 18 * dt; } m.r += dt * 10; }
    st.mist = st.mist.filter(m => m.t < m.life);
    // 水滴
    const W = st.water; if (W && Math.random() < dt * (W.leak ? 6 : 9)) st.drips.push({ x:W.leak ? 7330 : 7329, y:487, vy:0, t:0, fl:W.leak && W.t > 1.4 });
    for (const d of st.drips) { d.t += dt; d.vy += 900 * dt; d.y += d.vy * dt; } st.drips = st.drips.filter(d => d.y < (d.fl ? 640 : 508));
    // 水樽泡泡（待機偶然一串；用緊／漏水時密啲）
    st.nextBub -= dt * (W ? 6 : 1); if (st.nextBub <= 0) { st.nextBub = 5 + Math.random() * 7; for (let i = 0; i < 4; i++) st.bub.push({ x:7300 + Math.random() * 28, y:404 + i * 6, r:2 + Math.random() * 3.5, t:-i * 0.15 }); }
    for (const b of st.bub) { b.t += dt; if (b.t > 0) b.y -= dt * (55 + b.r * 6); } st.bub = st.bub.filter(b => b.y > 318);
    // 販賣機光管閃
    st.flick = Math.max(0, st.flick - dt); st.nextFlick -= dt; if (st.nextFlick <= 0) { st.nextFlick = 4 + Math.random() * 8; st.flick = 0.5 + Math.random() * 0.5; }
    npcUse(dt);
  }
  // 同事去茶水間：企定喺邊部機前面，就真係「用」佢
  const USE = { micro:'micro', coffee:'coffee', water:'water', fridge:'fridge', vend:'vend' };
  function npcUse(dt) {
    if (!Scare.npcs || !Scare.site || !Scare.site.pano) return; const SP = OFFMAP.SPOT;
    for (const n of Scare.npcs) {
      if (n.gone || n.out || n.fleeing || n.d.guard) { n._pu = null; continue; }
      let hit = null; for (const k in USE) { const s = SP[k]; if (s && Math.abs(n.x - s[0]) < 0.05 && Math.abs(n.y - s[1]) < 0.035) { hit = k; break; } }
      if (!hit || n.act === 'walk') { if (!hit) n._pu = null; continue; }
      if (!n._pu || n._pu.k !== hit) n._pu = { k:hit, t:0, done:false };
      n._pu.t += dt;
      if (!n._pu.done && n._pu.t > 0.8 && !(hit === 'vend' ? st.vend : st[hit])) { n._pu.done = true; if (hit !== 'vend' || Math.random() < 0.7) fx(hit === 'vend' && Math.random() < 0.5 ? 'snack' : hit, n, true); }
    }
  }
  const ease = (x) => x < 0 ? 0 : x > 1 ? 1 : x * x * (3 - 2 * x);
  function fridgeOpen(F) { // 0 = 閂，1 = 開到盡
    if (!F) return 0; const t = F.t;
    if (F.loop) { const c = 1.8, ph = t % c, i = Math.floor(t / c); if (i >= 4) return 0; return ph < 0.45 ? ease(ph / 0.45) : ph < 1.1 ? 1 : ease(1 - (ph - 1.1) / 0.3); }
    return Math.min(ease(t / 0.6), ease((F.dur - t) / 0.5));
  }

  // ---- 畫：電器浮出嚟 ----
  function popOut(ctx, id, t) {
    const A = AP[id], img = cut(id); if (!img) return; const s = sc(), [bx, by, bw, bh] = A.b, [x, y] = Q(bx, by), w = bw * s, h = bh * s;
    if (A.floor) { // 地上接觸陰影
      const [cx, cy] = Q(bx + bw / 2, by + bh - 2); ctx.save(); const g = ctx.createRadialGradient(cx, cy, 0, cx, cy, w * 0.62); g.addColorStop(0, 'rgba(8,4,22,.55)'); g.addColorStop(0.6, 'rgba(8,4,22,.25)'); g.addColorStop(1, 'rgba(8,4,22,0)');
      ctx.fillStyle = g; ctx.translate(cx, cy); ctx.scale(1, 0.16); ctx.beginPath(); ctx.arc(0, 0, w * 0.62, 0, PI * 2); ctx.fill(); ctx.restore(); }
    const f = A.floor ? 1.018 : 1.012, dw = w * f, dh = h * f, dx = x + (w - dw) / 2, dy = y + h - dh; // 向鏡頭行前少少（底部對齊）
    { // 投影預先烘好（以前每格對五部電器即場 shadowBlur，手機 GPU 最食力）
      const M = ctx.getTransform(), k = Math.hypot(M.a, M.b) * dw / img.width, b = 27 * s / k, ox = 6 * s / k, oy = 4 * s / k, key = id + '|' + Math.round(b * 2);
      let c = SHC[key]; if (!c) { const pad = Math.ceil(b * 2 + Math.max(ox, oy)); c = document.createElement('canvas'); c.width = img.width + pad * 2; c.height = img.height + pad * 2; const g = c.getContext('2d'); g.shadowColor = 'rgba(6,2,20,.55)'; g.shadowBlur = b; g.shadowOffsetX = ox; g.shadowOffsetY = oy; g.imageSmoothingQuality = 'high'; g.drawImage(img, pad, pad); c.pad = pad; SHC[key] = c; }
      const u = dw / img.width; ctx.save(); ctx.imageSmoothingQuality = 'high'; ctx.drawImage(c, dx - c.pad * u, dy - c.pad * u, c.width * u, c.height * u); ctx.restore(); }
    // 邊光：左上一條淡紫藍光（夜光由窗嗰邊嚟）
    ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.lineWidth = Math.max(1, 2.2 * s); const g = ctx.createLinearGradient(dx, dy, dx + dw * 0.6, dy + dh * 0.6); g.addColorStop(0, 'rgba(170,160,255,.42)'); g.addColorStop(1, 'rgba(170,160,255,0)'); ctx.strokeStyle = g;
    for (const [sx, sy, sw, shh, r] of A.sh) { const [px0, py0] = Q(bx + (sx - bx) * f - (bw * (f - 1)) / 2, by + bh - (by + bh - sy) * f); rr(ctx, px0 + 1.5 * s, py0 + 1.5 * s, sw * s * f - 3 * s, shh * s * f - 3 * s, r * s); ctx.stroke(); }
    ctx.restore();
  }
  const R = (x, y, w, h) => { const [a, b] = Q(x, y), s = sc(); return [a, b, w * s, h * s]; };
  function glowAt(ctx, x, y, r, col, a) { const [X, Y] = Q(x, y), s = sc(), g = ctx.createRadialGradient(X, Y, 0, X, Y, r * s); g.addColorStop(0, `rgba(${col},${a})`); g.addColorStop(1, `rgba(${col},0)`); ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.fillRect(X - r * s, Y - r * s, r * s * 2, r * s * 2); ctx.restore(); }
  function led(ctx, x, y, col, a) { const [X, Y] = Q(x, y), s = sc(); ctx.save(); ctx.fillStyle = `rgba(${col},${a})`; ctx.beginPath(); ctx.arc(X, Y, Math.max(1.3, 3 * s), 0, PI * 2); ctx.fill(); ctx.restore(); glowAt(ctx, x, y, 14, col, a * 0.5); }
  function sfx(ctx, x, y, s0, sz, a) { if (a <= 0.01) return; const [X, Y] = Q(x, y), s = sc(); ctx.save(); ctx.globalAlpha *= Math.min(1, a); ctx.font = `900 ${Math.round(Math.max(13, sz * s))}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = '#1a1020'; ctx.strokeText(s0, X, Y); ctx.fillStyle = '#fff3d0'; ctx.fillText(s0, X, Y); ctx.restore(); }

  function drawFridge(ctx, t) {
    const F = st.fridge, o = fridgeOpen(F), s = sc();
    led(ctx, 7238, 268, '120,255,170', 0.55 + 0.25 * Math.sin(t * 2.2)); // 待機燈（嗡嗡）
    if (o <= 0.005) return;
    const [x, y, w, h] = R(7081, 256, 170, 138);
    ctx.save(); const g = ctx.createLinearGradient(x, y, x, y + h); g.addColorStop(0, '#f2f8ff'); g.addColorStop(1, '#b7cbe4'); ctx.fillStyle = g; rr(ctx, x, y, w, h, 8 * s); ctx.fill(); ctx.clip();
    ctx.strokeStyle = 'rgba(110,130,165,.8)'; ctx.lineWidth = Math.max(1, 2 * s); for (let i = 1; i < 3; i++) { ctx.beginPath(); ctx.moveTo(x, y + h * i / 3); ctx.lineTo(x + w, y + h * i / 3); ctx.stroke(); }
    const it = [[0.12, 1, 0.14, 0.2, '#e3c25a'], [0.32, 1, 0.1, 0.24, '#7fc28a'], [0.55, 2, 0.24, 0.13, '#e98a8a'], [0.15, 2, 0.16, 0.16, '#f4f0e0'], [0.62, 1, 0.12, 0.18, '#8aaee8'], [0.4, 3, 0.3, 0.12, '#d9a46b']];
    for (const [ix, sh, iw, ih, c] of it) { ctx.fillStyle = c; ctx.strokeStyle = '#3b2c3a'; ctx.lineWidth = Math.max(1, 1.5 * s); rr(ctx, x + w * ix, y + h * sh / 3 - h * ih - 2 * s, w * iw, h * ih, 3 * s); ctx.fill(); ctx.stroke(); }
    ctx.restore();
    glowAt(ctx, 7166, 330, 190, '200,230,255', 0.55 * o); // 入面燈照出嚟
    // 門：右邊門鉸，轉開
    const d = cutRect('fdoor', 7079, 254, 174, 141); if (d) { const cw = Math.cos(o * PI * 0.46), dw = Math.max(0.06, cw) * w * 1.02; ctx.save(); ctx.drawImage(d, x + w * 1.01 - dw, y - 2 * s, dw, h + 4 * s);
      ctx.fillStyle = `rgba(20,14,40,${0.35 * o})`; ctx.fillRect(x + w * 1.01 - dw, y - 2 * s, dw, h + 4 * s); // 門轉開背光變暗
      ctx.fillStyle = '#d8d4e8'; ctx.strokeStyle = '#2b2033'; ctx.lineWidth = Math.max(1, 1.5 * s); const th = 9 * s * o; ctx.fillRect(x + w * 1.01 - dw - th, y - 2 * s, th, h + 4 * s); ctx.strokeRect(x + w * 1.01 - dw - th, y - 2 * s, th, h + 4 * s); ctx.restore(); }
    // 地上冷光
    const [fx0, fy0] = Q(7090, 612), [fx1] = Q(7250, 612); ctx.save(); ctx.globalCompositeOperation = 'lighter'; const lg = ctx.createLinearGradient(0, fy0, 0, fy0 + 90 * s); lg.addColorStop(0, `rgba(170,210,255,${0.28 * o})`); lg.addColorStop(1, 'rgba(170,210,255,0)'); ctx.fillStyle = lg;
    ctx.beginPath(); ctx.moveTo(fx0, fy0); ctx.lineTo(fx1, fy0); ctx.lineTo(fx1 + 60 * s, fy0 + 90 * s); ctx.lineTo(fx0 - 60 * s, fy0 + 90 * s); ctx.closePath(); ctx.fill(); ctx.restore();
    if (F.loop) { const ph = F.t % 1.8; if (ph > 1.35 && ph < 1.75 && F.t < 7.2) sfx(ctx, 7166, 236, '砰！', 34, 1 - (ph - 1.35) / 0.4); }
  }
  function drawMist(ctx) { if (!st.mist.length) return; const s = sc(); ctx.save(); for (const m of st.mist) { const [X, Y] = Q(m.x, m.y), a = Math.sin(Math.min(1, m.t / m.life) * PI) * 0.13, r = m.r * s, g = ctx.createRadialGradient(X, Y, 0, X, Y, r); g.addColorStop(0, `rgba(225,240,255,${a})`); g.addColorStop(1, 'rgba(225,240,255,0)'); ctx.fillStyle = g; ctx.fillRect(X - r, Y - r, r * 2, r * 2); } ctx.restore(); }
  function drawMicro(ctx, t) {
    const M = st.micro, s = sc();
    { const [X, Y] = Q(6864, 416); ctx.save(); ctx.font = `700 ${Math.max(6, Math.round(9 * s))}px monospace`; ctx.textAlign = 'center'; ctx.fillStyle = M ? 'rgba(255,190,90,.95)' : `rgba(120,255,170,${Math.sin(t * 3) > 0 ? 0.9 : 0.45})`; ctx.fillText(M ? '0:' + String(Math.max(0, Math.ceil(M.dur - M.t))).padStart(2, '0') : '12:00', X + 5 * s, Y); ctx.restore(); }
    if (!M) return; const [x, y, w, h] = R(6770, 406, 84, 52), on = M.t < M.dur - 0.8;
    ctx.save(); rr(ctx, x, y, w, h, 4 * s); ctx.clip();
    if (on) { ctx.fillStyle = 'rgba(255,196,110,.85)'; ctx.fillRect(x, y, w, h); const a = M.t * 3.2;
      ctx.strokeStyle = 'rgba(120,70,30,.7)'; ctx.lineWidth = Math.max(1, 1.5 * s); ctx.beginPath(); ctx.ellipse(x + w / 2, y + h * 0.8, w * 0.36, h * 0.1, 0, 0, PI * 2); ctx.stroke(); // 轉盤
      const bx = x + w / 2 + Math.cos(a) * w * 0.16, bz = Math.sin(a); ctx.fillStyle = bz > 0 ? '#9a5a3a' : '#7d4a32'; ctx.beginPath(); ctx.ellipse(bx, y + h * 0.72, w * 0.13 * (0.85 + 0.15 * Math.abs(Math.cos(a))), h * 0.13, 0, 0, PI * 2); ctx.fill(); // 碗
      ctx.fillStyle = '#c87a4a'; ctx.fillRect(bx - w * 0.12, y + h * 0.6, w * 0.24, h * 0.1); }
    ctx.restore();
    if (on) glowAt(ctx, 6812, 432, 110, '255,180,90', 0.35 + 0.1 * Math.sin(t * 30));
    if (on) sfx(ctx, 6812, 386, '嗡——', 20, 0.75); else sfx(ctx, 6812, 386, '叮！', 34, (M.dur - M.t) / 0.8);
  }
  function drawCoffee(ctx, t) {
    const C = st.coffee, s = sc();
    led(ctx, 6973, 381, C ? '255,90,70' : '120,255,170', C ? 0.9 : (Math.sin(t * 1.6) > 0.3 ? 0.8 : 0.25)); // 待機燈慢閃；沖緊＝紅燈
    if (!C) return; const k = Math.min(1, C.t / (C.dur - 0.6));
    if (C.t < C.dur - 0.6) { const [X0, Y0] = Q(6940, 409), [, Y1] = Q(6940, 452 - k * 30); ctx.save(); ctx.strokeStyle = 'rgba(70,35,18,.95)'; ctx.lineWidth = Math.max(1, 2.2 * s); ctx.setLineDash([4 * s, 3 * s]); ctx.lineDashOffset = -t * 60; ctx.beginPath(); ctx.moveTo(X0, Y0); ctx.lineTo(X0, Y1); ctx.stroke(); ctx.restore(); }
    // 咖啡壺水位升
    { const [x, y, w, h] = R(6914, 415, 52, 42); ctx.save(); ctx.beginPath(); ctx.ellipse(x + w / 2, y + h * 0.58, w * 0.5, h * 0.48, 0, 0, PI * 2); ctx.clip(); ctx.fillStyle = 'rgba(80,40,20,.92)'; const lv = h * (0.25 + 0.7 * k); ctx.fillRect(x, y + h - lv, w, lv); ctx.fillStyle = 'rgba(255,220,180,.25)'; ctx.fillRect(x, y + h - lv, w, 2 * s); ctx.restore(); }
    // 蒸氣
    ctx.save(); ctx.lineCap = 'round'; for (let i = 0; i < 3; i++) { const ph = (t * 0.7 + i / 3) % 1, [X, Y] = Q(6930 + i * 10 + Math.sin(t * 2 + i) * 4, 366 - ph * 60); ctx.strokeStyle = `rgba(240,235,255,${0.45 * (1 - ph)})`; ctx.lineWidth = Math.max(1, 4 * s * (1 - ph * 0.5)); ctx.beginPath(); ctx.moveTo(X, Y); ctx.quadraticCurveTo(X + 8 * s, Y - 10 * s, X, Y - 20 * s); ctx.stroke(); } ctx.restore();
    if (C.t < 1.0) sfx(ctx, 6942, 350, '嘀', 22, 1 - C.t); else if (C.t < C.dur - 0.6) sfx(ctx, 6942, 350, '咕嚕咕嚕', 18, 0.7);
  }
  function drawWater(ctx, t) {
    const W = st.water, s = sc();
    led(ctx, 7344, 462, '255,120,90', 0.35 + 0.15 * Math.sin(t * 1.3));
    ctx.save(); for (const b of st.bub) { if (b.t < 0) continue; const [X, Y] = Q(b.x + Math.sin(b.t * 9 + b.r) * 2, b.y); ctx.strokeStyle = 'rgba(220,240,255,.75)'; ctx.lineWidth = Math.max(1, 1.3 * s); ctx.beginPath(); ctx.arc(X, Y, b.r * s, 0, PI * 2); ctx.stroke(); } ctx.restore();
    ctx.save(); ctx.fillStyle = 'rgba(160,210,255,.95)'; for (const d of st.drips) { const [X, Y] = Q(d.x, d.y); ctx.beginPath(); ctx.ellipse(X, Y, 2.2 * s + 0.6, 3.6 * s + 0.8, 0, 0, PI * 2); ctx.fill(); } ctx.restore();
    if (W && W.leak && W.t > 1.0) { const [X, Y0] = Q(7300, 512), [, Y1] = Q(7300, 612); ctx.save(); ctx.strokeStyle = 'rgba(150,200,255,.5)'; ctx.lineWidth = Math.max(1, 2 * s); ctx.setLineDash([6 * s, 8 * s]); ctx.lineDashOffset = -t * 120; ctx.beginPath(); ctx.moveTo(X, Y0); ctx.lineTo(X, Y1); ctx.stroke(); ctx.restore(); }
    if (W && W.leak) sfx(ctx, 7314, 290, '滴…滴…', 18, Math.min(1, W.t, (W.dur - W.t)));
    if (W && !W.leak) { const [x, y, w, h] = R(7319, 486, 22, 22); ctx.save(); ctx.fillStyle = 'rgba(240,240,250,.9)'; ctx.strokeStyle = '#2b2033'; ctx.lineWidth = Math.max(1, 1.4 * s); ctx.fillRect(x, y, w, h); ctx.strokeRect(x, y, w, h); ctx.fillStyle = 'rgba(150,200,255,.8)'; const lv = h * Math.min(0.85, W.t / W.dur); ctx.fillRect(x + 1, y + h - lv, w - 2, lv); ctx.restore(); }
  }
  function drawVend(ctx, t) {
    const V = st.vend, s = sc(), fl = st.flick > 0 && Math.sin(t * 47) + Math.sin(t * 29) > 0.3;
    const [x, y, w, h] = R(7398, 289, 141, 211);
    ctx.save(); ctx.globalCompositeOperation = fl ? 'source-over' : 'lighter'; ctx.fillStyle = fl ? 'rgba(6,4,18,.5)' : `rgba(150,215,255,${0.16 + 0.03 * Math.sin(t * 5)})`; rr(ctx, x, y, w, h, 4 * s); ctx.fill();
    if (!fl) { const g = ctx.createLinearGradient(x, y, x + w, y + h); g.addColorStop(0, 'rgba(255,255,255,0)'); g.addColorStop(0.45, 'rgba(255,255,255,.14)'); g.addColorStop(0.55, 'rgba(255,255,255,0)'); ctx.fillStyle = g; ctx.fillRect(x, y, w, h); }
    ctx.restore();
    if (!fl) glowAt(ctx, 7468, 400, 200, '120,190,255', 0.16);
    { const [fx0, fy0] = Q(7380, 614), [fx1] = Q(7590, 614); ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createLinearGradient(0, fy0, 0, fy0 + 70 * s); g.addColorStop(0, `rgba(120,190,255,${fl ? 0.03 : 0.16})`); g.addColorStop(1, 'rgba(120,190,255,0)'); ctx.fillStyle = g; ctx.fillRect(fx0 - 30 * s, fy0, fx1 - fx0 + 60 * s, 70 * s); ctx.restore(); }
    if (!V) return;
    const cx = 7420 + V.col * 35, ry = 322 + V.row * 50, k = Math.min(1, V.t / 1.1), yy = ry + (505 - ry) * k * k;
    if (V.t < 1.15) { ctx.save(); ctx.beginPath(); ctx.rect(x, y, w, h + 50 * s); ctx.clip(); item(ctx, V.kind, V.hue, cx, yy, 0, k * 2.5); ctx.restore(); }
    if (V.t > 1.1 && V.t < 2.2) sfx(ctx, 7474, 515, '哐咚！', 30, 1 - (V.t - 1.1) / 1.1);
  }
  function item(ctx, kind, hue, bx, by, rot, spin) { // bx,by：背景 px，物件底部中間
    const [X, Y] = Q(bx, by), s = sc() * 1.5; ctx.save(); ctx.translate(X, Y - 12 * s); ctx.rotate(rot + (spin || 0)); ctx.strokeStyle = '#2b2033'; ctx.lineWidth = Math.max(1, 1.6 * s);
    if (kind === 'can') { const cw = 16 * s, ch = 26 * s; ctx.fillStyle = `hsl(${hue},62%,48%)`; rr(ctx, -cw / 2, -ch / 2, cw, ch, 3 * s); ctx.fill(); ctx.stroke(); ctx.fillStyle = 'rgba(255,255,255,.85)'; ctx.fillRect(-cw / 2 + 1, -ch * 0.1, cw - 2, ch * 0.2); ctx.fillStyle = '#cfd2da'; ctx.fillRect(-cw / 2 + 1, -ch / 2 + 1, cw - 2, 3 * s); }
    else { const cw = 24 * s, ch = 30 * s; ctx.fillStyle = `hsl(${hue},70%,58%)`; ctx.beginPath(); ctx.moveTo(-cw / 2, -ch / 2); ctx.lineTo(cw / 2, -ch / 2); ctx.lineTo(cw / 2 - 2 * s, ch / 2); ctx.lineTo(-cw / 2 + 2 * s, ch / 2); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.fillStyle = 'rgba(255,255,255,.6)'; ctx.fillRect(-cw / 2 + 2 * s, -ch / 2, cw - 4 * s, 4 * s); ctx.fillRect(-cw / 2 + 3 * s, ch / 2 - 4 * s, cw - 6 * s, 3 * s); ctx.fillStyle = 'rgba(255,255,255,.75)'; ctx.beginPath(); ctx.arc(0, 0, 5 * s, 0, PI * 2); ctx.fill(); }
    ctx.restore();
  }
  function drawBack(ctx, t) {
    ORIG.drawBack(ctx, t);
    if (!Scare.site || !Scare.site.pano || !st || !visible()) return;
    for (const id of ORDER) popOut(ctx, id, t);
    drawMicro(ctx, t); drawCoffee(ctx, t); drawFridge(ctx, t); drawWater(ctx, t); drawVend(ctx, t); drawMist(ctx);
  }

  // ---- 跟人排前後：地上嘅嘢＋休息區 ----
  function drawables() {
    const out = ORIG.drawables(); if (!st || !Scare.site || !Scare.site.pano) return out;
    for (const p of st.puddles) out.push([0.625, (ctx) => { const [X, Y] = Q(p.x, p.y * SH), rx = p.r * PXU * sc(), a = p.t > p.life * 0.55 ? Math.max(0, 1 - (p.t - p.life * 0.55) / (p.life * 0.45)) : 1; if (rx < 1) return;
      ctx.save(); ctx.globalAlpha = a; ctx.fillStyle = 'rgba(110,150,220,.32)'; ctx.beginPath(); ctx.ellipse(X, Y, rx, rx * 0.16, 0, 0, PI * 2); ctx.ellipse(X - rx * 0.35, Y + rx * 0.05, rx * 0.55, rx * 0.11, 0, 0, PI * 2); ctx.fill();
      ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = 'rgba(200,225,255,.35)'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.ellipse(X + rx * 0.15, Y - rx * 0.03, rx * 0.5, rx * 0.06, 0, PI * 1.1, PI * 1.8); ctx.stroke();
      const rp = (Scare.t || 0) * 0.8 % 1; ctx.strokeStyle = `rgba(200,225,255,${0.3 * (1 - rp)})`; ctx.beginPath(); ctx.ellipse(X + rx * 0.2, Y, rx * 0.3 * rp, rx * 0.05 * rp, 0, 0, PI * 2); ctx.stroke(); ctx.restore(); }]);
    for (const it of st.items) { const yy = it.y; out.push([yy, (ctx) => { const a = it.t > 12 ? 1 - (it.t - 12) / 2 : 1, inSlot = it.t < 0.25; const [X, Y] = Q(it.x, yy * SH), s = sc();
      ctx.save(); ctx.globalAlpha = a; if (!inSlot) { ctx.fillStyle = 'rgba(6,4,18,.35)'; ctx.beginPath(); ctx.ellipse(X, Y, 14 * s, 3.5 * s, 0, 0, PI * 2); ctx.fill(); }
      if (inSlot) { ctx.beginPath(); const [sx, sy] = Q(7414, 518); ctx.rect(sx, sy, 120 * s, 36 * s); ctx.clip(); item(ctx, it.kind, it.hue, it.x, 552, 0); } else item(ctx, it.kind, it.hue, it.x, yy * SH, it.kind === 'can' ? it.rot : -0.15 + Math.min(it.t, 1) * -1.25);
      ctx.restore(); if (it.t > 0.25 && it.t < 1.3) sfx(ctx, it.x, yy * SH - 50, it.kind === 'can' ? '咕碌咕碌' : '啪', 16, 1 - (it.t - 0.25)); }]); }
    // 休息區：三張櫈（喺人後面）、一張圓枱（喺人前面）
    for (const [sx, sy] of seats) out.push([sy - 0.004, (ctx) => chair(ctx, sx, sy)]);
    out.push([table[1], (ctx) => drawTable(ctx, t0())]);
    return out;
  }
  const t0 = () => Scare.t || 0;
  function chair(ctx, x, y) {
    if (!ok('of_chair_front')) return; const im = SPR.of_chair_front, [X, Y] = Scare.pt(x, y), H = Scare.hh(y) * 0.6, W = H * im.naturalWidth / im.naturalHeight;
    ctx.save(); ctx.fillStyle = 'rgba(6,4,18,.3)'; ctx.beginPath(); ctx.ellipse(X, Y, W * 0.42, W * 0.09, 0, 0, PI * 2); ctx.fill(); if (!DIMC.chair) { const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; const g = c.getContext('2d'); g.filter = 'brightness(.78) saturate(.9)'; g.drawImage(im, 0, 0); DIMC.chair = c; } ctx.drawImage(DIMC.chair, X - W / 2, Y - H, W, H); ctx.restore(); // 調暗嘅櫈預先做好（每格 filter 好食力）
  }
  function drawTable(ctx) { // 小圓枱：同背景一樣嘅粗黑描邊
    const [x, y] = table, [X, Y] = Scare.pt(x, y), u = Scare.hh(y), R0 = u * 0.36, top = Y - u * 0.4, lw = Math.max(1.5, u * 0.012);
    ctx.save(); ctx.lineJoin = 'round'; ctx.strokeStyle = '#2a1f2e'; ctx.lineWidth = lw;
    ctx.fillStyle = 'rgba(6,4,18,.38)'; ctx.beginPath(); ctx.ellipse(X, Y, R0 * 0.75, R0 * 0.16, 0, 0, PI * 2); ctx.fill();
    ctx.fillStyle = '#7b6878'; ctx.beginPath(); ctx.ellipse(X, Y - u * 0.012, R0 * 0.42, R0 * 0.09, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); // 底座
    ctx.fillStyle = '#8c7a88'; ctx.fillRect(X - u * 0.022, top, u * 0.044, Y - top - u * 0.012); ctx.strokeRect(X - u * 0.022, top, u * 0.044, Y - top - u * 0.012); // 枱腳
    ctx.fillStyle = '#9f8079'; ctx.beginPath(); ctx.ellipse(X, top + u * 0.03, R0, R0 * 0.26, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); // 枱邊厚度
    ctx.fillStyle = '#c9a99a'; ctx.beginPath(); ctx.ellipse(X, top, R0, R0 * 0.26, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); // 枱面
    ctx.strokeStyle = 'rgba(255,240,230,.25)'; ctx.lineWidth = lw * 0.8; ctx.beginPath(); ctx.ellipse(X, top, R0 * 0.78, R0 * 0.18, 0, PI * 1.1, PI * 1.6); ctx.stroke();
    if (ok('op_mug')) { const im = SPR.op_mug, mh = u * 0.09, mw = mh * im.naturalWidth / im.naturalHeight; ctx.drawImage(im, X - R0 * 0.45 - mw / 2, top - mh * 0.85, mw, mh); }
    if (ok('op_phone')) { const im = SPR.op_phone, mh = u * 0.05, mw = mh * im.naturalWidth / im.naturalHeight; ctx.drawImage(im, X + R0 * 0.3 - mw / 2, top - mh * 0.6, mw, mh); }
    ctx.restore();
  }

  // ---- 接駁 ----
  const ORIG = { drawBack:OFFMAP.drawBack, drawables:OFFMAP.drawables, tick:OFFMAP.tick, onProp:OFFMAP.onProp, init:OFFMAP.init };
  OFFMAP.init = function (S) { reset(); return ORIG.init.apply(this, arguments); };
  OFFMAP.tick = function (dt) { const r = ORIG.tick.apply(this, arguments); try { tick(dt); } catch (e) { console.warn(e); } return r; };
  OFFMAP.drawBack = function (ctx, t) { drawBack(ctx, t); };
  OFFMAP.drawables = function () { return drawables(); };
  OFFMAP.onProp = function (k, n, room) { // 茶水間電器附身：用新效果（唔再畫舊嗰套，免得重疊）
    const m = { micro:'micro', fridge:'fridge', vend:'vend', water:'water', coffee:'coffee' }[k];
    if (m) return fx(m, n, false);
    return ORIG.onProp.apply(this, arguments);
  };
  return { table, seats, fx:(k, n) => fx(k, n, false), use:(k, n) => fx(k, n, true), state:() => st && { micro:!!st.micro, coffee:!!st.coffee, fridge:!!st.fridge, water:!!st.water, vend:!!st.vend, items:st.items.length, puddles:st.puddles.length }, AP };
})();
