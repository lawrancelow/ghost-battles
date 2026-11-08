// ===================== 回陽間・二十三樓全景：老闆房｜開放辦公區｜茶水間｜會議室（一張橫向背景，手指左右拖） =====================
// 世界座標：x = 源圖 px ÷ 1165（1 單位 = 舊辦公室一個畫面闊，阿Ken 路線、視線、家具半徑全部照舊用同一把尺）；y = 背景高度比例（地毯由 0.621 開始）
// 正面直視：人的大小只跟 y（離後牆幾遠）有關，同一條 y 上邊度都一樣大（scare.js persp）
// 只管：房間範圍、站位、各房間附身道具（程式畫）、玩電燈／冷氣（只影響鏡頭所在嗰間）、小地圖。分數喺 scare.js
const OFFMAP = (() => {
  const SW = 5964, SH = 1024, PXU = 1165;
  const px = (v) => v / PXU, py = (v) => v / SH, PI = Math.PI;
  const WW = SW / PXU;
  const SEAM = [1506, 2982, 4458].map(px), PILLAR = 36 / PXU;
  const ROOMS = [
    { k:'boss', name:'老闆房', x0:0, x1:SEAM[0], vent:[600, 70] },
    { k:'main', name:'開放辦公區', x0:SEAM[0], x1:SEAM[1], vent:[2474, 70] },
    { k:'pantry', name:'茶水間', x0:SEAM[1], x1:SEAM[2], vent:[3726, 120] },
    { k:'meeting', name:'會議室', x0:SEAM[2], x1:WW, vent:[5432, 66] },
  ];
  const RM = {}; ROOMS.forEach((r, i) => { r.i = i; r.cx = (r.x0 + r.x1) / 2; RM[r.k] = r; });
  // 舊辦公室（一個畫面）搬入開放辦公區：x 照搬（平移 OX，距離不變），y 由舊地板 0.5~0.95 壓到新地板 0.64~0.98
  const OX = 1.37, M = (x) => OX + x, MY = (y) => 0.64 + (y - 0.5) * 0.75;
  const roomAt = (x) => x < SEAM[0] ? RM.boss : x < SEAM[1] ? RM.main : x < SEAM[2] ? RM.pantry : RM.meeting;
  // 站位（源圖量出嚟：後牆家具前面一步）
  const SPOT = {
    bossDesk:[px(1010), 0.668], bossFront:[px(720), 0.73], golf:[px(300), 0.80], bossVisit:[px(860), 0.72],
    water:[px(4060), 0.68], coffee:[px(3770), 0.675], micro:[px(3650), 0.68], vend:[px(4300), 0.70], fridge:[px(3990), 0.69], kettle:[px(3860), 0.672], sink:[px(3470), 0.672],
    board:[px(5300), 0.672], seat1:[px(4900), 0.73], seat2:[px(5110), 0.76],
    elev:[px(2762), 0.655],
  };
  const LANE = [[1.80, 0.93], [2.24, 0.91], // 開放辦公區：只拖前面兩格（唔好擋住阿Ken、小晴張枱）
    [px(3320), 0.80], [px(3620), 0.86], [px(3960), 0.80],
    [px(4720), 0.84], [px(5120), 0.88], [px(5520), 0.83]];
  const PATROL = [[px(780), 0.80], [M(0.14), MY(0.71)], [px(3700), 0.80], [px(5150), 0.82]];
  // 附身道具的位置（源圖 px：x, y, w, h）
  const A = {
    micro:[3594, 392, 120, 72], microWin:[3606, 402, 78, 52], fridge:[3906, 256, 176, 350], fridgeDoor:[3910, 260, 168, 148],
    vend:[4202, 264, 224, 344], vendGlass:[4232, 288, 160, 186], vendSlot:[4236, 512, 124, 38], kettle:[3818, 392, 72, 72],
    tv:[4728, 195, 391, 219], speaker:[5143, 450, 94, 36], spare:[[4590, 0.79], [4700, 0.865]],
    golfBag:[0, 328, 112, 264], chair:[680, 362, 178, 120], trophy:[262, 204, 46, 96],
  };
  const R = (a) => [px(a[0]), py(a[1]), px(a[2]), py(a[3])];
  const WIN = [[368, 240, 792, 240], [1575, 200, 995, 216], [3026, 208, 296, 280]]; // 有城市燈嘅窗（夜色下保留亮度）

  let SC = null, st = null, PANO = null, CROP = {}, TC = {};
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const P = (x, y) => SC.pt(x, y), U = (y) => SC.hh(y) * (64 / (64 * 1.08));
  function pano() { // 夜色版全景（快取）
    if (PANO) return PANO; if (!ok('bg_office_pano')) return null;
    const im = SPR.bg_office_pano, c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight;
    const x = c.getContext('2d'), k = c.height / SH; x.drawImage(im, 0, 0);
    x.globalCompositeOperation = 'multiply'; x.fillStyle = 'rgb(150,140,196)'; x.fillRect(0, 0, c.width, c.height);
    const g = x.createLinearGradient(0, c.height * 0.62, 0, c.height); g.addColorStop(0, 'rgb(255,255,255)'); g.addColorStop(1, 'rgb(160,152,186)');
    x.fillStyle = g; x.fillRect(0, c.height * 0.62, c.width, c.height * 0.38);
    x.globalCompositeOperation = 'screen'; x.globalAlpha = 0.35;
    for (const w of WIN) x.drawImage(im, w[0] * k, w[1] * k, w[2] * k, w[3] * k, w[0] * k, w[1] * k, w[2] * k, w[3] * k);
    return PANO = c;
  }
  // 從夜色全景切一塊出嚟（會郁嘅家具）；fill = 原位用左右兩邊嘅顏色一行一行補返（郁開之後後面唔會穿窿）
  function crop(id, a, fill) {
    if (CROP[id]) return CROP[id]; const src = pano(); if (!src) return null; const k = src.height / SH;
    const c = document.createElement('canvas'); c.width = Math.round(a[2] * k); c.height = Math.round(a[3] * k);
    c.getContext('2d').drawImage(src, a[0] * k, a[1] * k, a[2] * k, a[3] * k, 0, 0, c.width, c.height);
    let f = null;
    if (fill) { f = document.createElement('canvas'); f.width = c.width; f.height = c.height; const fx = f.getContext('2d');
      const L = src.getContext('2d').getImageData(Math.max(0, a[0] * k - 2), a[1] * k, 1, c.height).data, Rr = src.getContext('2d').getImageData(Math.min(src.width - 1, (a[0] + a[2]) * k + 2), a[1] * k, 1, c.height).data;
      for (let y = 0; y < c.height; y++) { const g = fx.createLinearGradient(0, 0, c.width, 0); g.addColorStop(0, `rgb(${L[y * 4]},${L[y * 4 + 1]},${L[y * 4 + 2]})`); g.addColorStop(1, `rgb(${Rr[y * 4]},${Rr[y * 4 + 1]},${Rr[y * 4 + 2]})`); fx.fillStyle = g; fx.fillRect(0, y, c.width, 1); } }
    return CROP[id] = { c, f };
  }
  function tint(k) { if (TC[k]) return TC[k]; if (!ok(k)) return null; const im = SPR[k], c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; const x = c.getContext('2d'); x.drawImage(im, 0, 0); x.globalCompositeOperation = 'source-atop'; x.fillStyle = 'rgba(26,18,58,.30)'; x.fillRect(0, 0, c.width, c.height); return TC[k] = c; }
  function text(ctx, x, y, s, sz, a) { if (a <= 0.01) return; ctx.save(); ctx.globalAlpha *= Math.min(1, a); ctx.font = `900 ${Math.round(sz)}px sans-serif`; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = '#1a1020'; ctx.strokeText(s, x, y); ctx.fillStyle = '#fff3d0'; ctx.fillText(s, x, y); ctx.restore(); }
  const rect = (a) => { const [x1, y1] = P(px(a[0]), py(a[1])), [x2, y2] = P(px(a[0] + a[2]), py(a[1] + a[3])); return [x1, y1, x2 - x1, y2 - y1]; };

  function init(S) {
    SC = S; st = { t:0, micro:0, fridge:0, vend:0, can:null, kettle:0, tv:0, speaker:0, chairs:0, golf:null, bchair:0, trophy:null, lights:null, ac:null,
      spare:A.spare.map(([x, y], i) => ({ x:px(x), y, ox:0, oz:0, vx:0, vz:0, sw:i ? 0.4 : -0.3, vs:0 })) };
  }
  function tick(dt) {
    if (!st) return; st.t += dt;
    for (const k of ['micro', 'fridge', 'vend', 'kettle', 'tv', 'speaker', 'chairs', 'bchair']) st[k] = Math.max(0, st[k] - dt);
    if (st.lights) { st.lights.t += dt; if (st.lights.t > 3.6) st.lights = null; }
    if (st.ac) { st.ac.t += dt; if (st.ac.t > 2.6) st.ac = null; }
    if (st.can) { const c = st.can; c.t += dt; if (c.t > 0.35) { c.x += c.vx * dt; c.vx *= Math.exp(-dt * 0.9); c.rot += c.vx * dt * 60; } if (c.t > 9) st.can = null; }
    if (st.golf) { const g = st.golf; g.t += dt; const k = Math.min(1, g.t / 2.4), e = 1 - Math.pow(1 - k, 2.2); g.x = g.x0 + (g.x1 - g.x0) * e; g.y = g.y0 + (g.y1 - g.y0) * e; g.rot += dt * 18 * (1 - k); if (g.t > 9) st.golf = null; }
    if (st.trophy) { const T = st.trophy; T.t += dt; if (T.t > 0.35) { T.vy += 2.4 * dt; T.y += T.vy * dt; T.rot += T.vr * dt; if (T.y >= T.floor) { T.y = T.floor; if (T.b < 1 && T.vy > 0.3) { T.vy = -T.vy * 0.25; T.b++; T.land = T.t; } else { T.vy = 0; T.vr = 0; T.rest += dt; T.rot += (Math.PI / 2 - T.rot) * Math.min(1, dt * 8); } } } if (T.rest > 10) { st.trophy = null; st.trophyBack = 0.6; } }
    st.trophyBack = Math.max(0, (st.trophyBack || 0) - dt);
    for (const c of st.spare) { // 會議室嘅後備椅：自己滑去對住嗰個人、轉圈，之後慢慢滑返
      if (st.chairs > 0 && c.tgt) { const dx = c.tgt.x - (c.x + c.ox), dz = c.tgt.y + c.dy - (c.y + c.oz), d = Math.hypot(dx, dz); if (d > 0.09) { c.vx += dx / d * 0.5 * dt; c.vz += dz / d * 0.3 * dt; } c.vs = (c.vs >= 0 ? 1 : -1) * Math.max(Math.abs(c.vs), 5); }
      c.ox += c.vx * dt; c.oz += c.vz * dt; c.vx *= Math.exp(-dt * 1.6); c.vz *= Math.exp(-dt * 1.6); c.sw += c.vs * dt; c.vs *= Math.exp(-dt * 1.2);
      if (st.chairs <= 0) { c.ox += -c.ox * dt * 0.3; c.oz += -c.oz * dt * 0.3; if (Math.abs(c.vs) < 0.6) c.sw += (Math.round(c.sw / (2 * PI)) * 2 * PI + (c === st.spare[0] ? -0.3 : 0.4) - c.sw) * Math.min(1, dt * 2); }
    }
  }
  // 附身：k = SCARE_PROPS 嘅名，n = 嚇緊嗰個人
  function onProp(k, n, room) {
    if (!st) return;
    if (k === 'micro') st.micro = 2.6;
    if (k === 'fridge') st.fridge = 3.2;
    if (k === 'vend') { st.vend = 2.2; const s = A.vendSlot; st.can = { x:px(s[0] + s[2] * 0.4), y:0.645, t:0, vx:-(0.12 + Math.random() * 0.05), rot:0 }; }
    if (k === 'kettle') st.kettle = 3.0;
    if (k === 'tv') st.tv = 2.8;
    if (k === 'speaker') st.speaker = 3.0;
    if (k === 'chairs') { st.chairs = 3.2; st.spare.forEach((c, i) => { c.tgt = n || { x:px(5000), y:0.78 }; c.dy = i ? 0.05 : -0.03; c.vs = i ? 6 : -6; }); }
    if (k === 'golf') { const x0 = px(120), y0 = 0.69, x1 = n ? n.x + (n.x > x0 ? -0.08 : 0.08) : px(700), y1 = n ? n.y + 0.01 : 0.75; st.golf = { x0, y0, x1, y1, x:x0, y:y0, t:0, rot:0 }; }
    if (k === 'bchair') st.bchair = 2.8;
    if (k === 'trophy') { const a = A.trophy; st.trophy = { x:px(a[0] + a[2] / 2), y:py(a[1] + a[3]), floor:0.655, vy:-0.2, vr:3.5, rot:0, t:0, b:0, rest:0, land:-1 }; }
    if (k === 'lights') st.lights = { t:0, room:room || 'main' };
    if (k === 'ac') st.ac = { t:0, room:room || 'main' };
  }
  // 後牆上嘅道具（喺人後面畫）
  function drawBack(ctx, t) {
    const c = pano(), b = SC.bgScale();
    if (c) { const k = c.height / SH, sx = SC.camX * PXU * k, sw = SC.W / (b.s / k) * 1; ctx.drawImage(c, sx, 0, SC.W * k / b.s, c.height, 0, b.oy, SC.W, b.ih * b.s); }
    if (!st) return;
    // 微波爐：自己開，入面著燈、轉盤、叮
    if (st.micro > 0) { const [x, y, w, h] = rect(A.microWin), on = Math.sin(t * 40) > -0.6; ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = `rgba(255,200,110,${on ? 0.75 : 0.35})`; ctx.fillRect(x, y, w, h);
      ctx.strokeStyle = 'rgba(255,240,200,.7)'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.ellipse(x + w / 2, y + h * 0.75, w * 0.3, h * 0.1, 0, 0, PI * 2); ctx.stroke(); const a = t * 5; ctx.beginPath(); ctx.moveTo(x + w / 2, y + h * 0.75); ctx.lineTo(x + w / 2 + Math.cos(a) * w * 0.28, y + h * 0.75 + Math.sin(a) * h * 0.09); ctx.stroke();
      const g = ctx.createRadialGradient(x + w / 2, y + h / 2, 0, x + w / 2, y + h / 2, w * 1.3); g.addColorStop(0, 'rgba(255,190,100,.35)'); g.addColorStop(1, 'rgba(255,190,100,0)'); ctx.fillStyle = g; ctx.fillRect(x - w, y - w, w * 3, h + w * 2); ctx.restore();
      if (st.micro < 0.7) text(ctx, x + w / 2, y - h * 0.3, '叮！', h * 0.75, st.micro / 0.7); else text(ctx, x + w / 2, y - h * 0.3, '嗡——', h * 0.5, 0.8); }
    // 雪櫃：上門自己打開（門靠右邊門鉸），入面著燈、凍氣湧出嚟
    { const d = crop('fdoor', A.fridgeDoor), [x, y, w, h] = rect(A.fridgeDoor), o = st.fridge > 0 ? Math.min(1, (3.2 - st.fridge) * 3, st.fridge * 1.5) : 0;
      if (o > 0.01 && d) { ctx.save(); const g = ctx.createLinearGradient(x, y, x, y + h); g.addColorStop(0, '#eaf4ff'); g.addColorStop(1, '#bcd2e8'); ctx.fillStyle = g; ctx.fillRect(x, y, w, h); ctx.strokeStyle = 'rgba(120,140,170,.8)'; ctx.lineWidth = 2; for (let i = 1; i < 3; i++) { ctx.beginPath(); ctx.moveTo(x + 4, y + h * i / 3); ctx.lineTo(x + w - 4, y + h * i / 3); ctx.stroke(); }
        ctx.fillStyle = '#d9c06a'; ctx.fillRect(x + w * 0.2, y + h / 3 - h * 0.12, w * 0.12, h * 0.12); ctx.fillStyle = '#e88'; ctx.fillRect(x + w * 0.55, y + h * 2 / 3 - h * 0.1, w * 0.2, h * 0.1);
        const sw = Math.cos(o * PI * 0.62); ctx.translate(x + w, y); ctx.scale(-1, 1); ctx.drawImage(d.c, 0, 0, w * Math.max(0.08, sw), h); ctx.restore(); // 門轉開（右邊做軸）
        ctx.save(); ctx.globalAlpha = 0.55 * o; for (let i = 0; i < 6; i++) { const q = ((t * 0.5 + i / 6) % 1), fx = x + w * (0.2 + 0.12 * i), fy = y + h + q * h * 1.4; const r = w * (0.18 + q * 0.35); const gg = ctx.createRadialGradient(fx, fy, 0, fx, fy, r); gg.addColorStop(0, 'rgba(225,240,255,.6)'); gg.addColorStop(1, 'rgba(225,240,255,0)'); ctx.fillStyle = gg; ctx.beginPath(); ctx.arc(fx, fy, r, 0, PI * 2); ctx.fill(); } ctx.restore(); } }
    // 汽水機：燈閃、跌罐（罐喺地上畫）
    if (st.vend > 0) { const [x, y, w, h] = rect(A.vendGlass), on = Math.sin(t * 33) + Math.sin(t * 19) > 0.2; ctx.save(); ctx.globalCompositeOperation = on ? 'lighter' : 'source-over'; ctx.fillStyle = on ? 'rgba(200,240,255,.35)' : 'rgba(5,4,15,.6)'; ctx.fillRect(x, y, w, h); ctx.restore();
      const [sx, sy, sw2, sh2] = rect(A.vendSlot); if (st.vend > 1.6) text(ctx, sx + sw2 / 2, sy - sh2 * 0.4, '哐咚！', sh2 * 1.1, (st.vend - 1.6) / 0.6); }
    // 熱水壺：自己滾，震、出煙、嗚——
    if (st.kettle > 0) { const [x, y, w, h] = rect(A.kettle), e = Math.min(1, st.kettle, (3 - st.kettle) * 2); ctx.save(); ctx.lineCap = 'round';
      for (let i = 0; i < 5; i++) { const q = (t * 0.8 + i / 5) % 1, sx = x + w * 0.78 + Math.sin(t * 3 + i) * w * 0.15, sy = y + h * 0.05 - q * h * 2.4; ctx.strokeStyle = `rgba(245,245,250,${0.6 * e * (1 - q)})`; ctx.lineWidth = w * 0.12 * (1 + q); ctx.beginPath(); ctx.moveTo(sx, sy + h * 0.2); ctx.quadraticCurveTo(sx + w * 0.3 * Math.sin(t * 2 + i), sy, sx, sy - h * 0.2); ctx.stroke(); }
      ctx.strokeStyle = `rgba(255,255,255,${0.5 * e})`; ctx.lineWidth = 1.5; for (const s of [-1, 1]) { ctx.beginPath(); ctx.arc(x + w / 2, y + h / 2, w * 0.7 + Math.sin(t * 30) * 2, s > 0 ? -0.4 : PI - 0.4, s > 0 ? 0.4 : PI + 0.4); ctx.stroke(); } ctx.restore();
      text(ctx, x + w / 2 + Math.sin(t * 25) * 2, y - h * 1.6, '嗚——', h * 0.55, e); }
    // 電視：自己開，雪花，閃一閃有塊臉
    if (st.tv > 0) { const [x0, y0, w0, h0] = rect(A.tv), x = x0 + w0 * 0.035, y = y0 + h0 * 0.06, w = w0 * 0.93, h = h0 * 0.85; ctx.save(); ctx.beginPath(); ctx.rect(x, y, w, h); ctx.clip(); ctx.fillStyle = 'rgba(70,70,90,.92)'; ctx.fillRect(x, y, w, h);
      for (let i = 0; i < 260; i++) { const v = Math.random() * 255 | 0; ctx.fillStyle = `rgba(${v},${v},${v + 10},.9)`; ctx.fillRect(x + Math.random() * w, y + Math.random() * h, 2 + Math.random() * 3, 1.5); }
      for (let i = 0; i < 4; i++) { ctx.fillStyle = 'rgba(255,255,255,.25)'; ctx.fillRect(x, y + ((t * 0.7 + i / 4) % 1) * h, w, 2); }
      const face = st.tv < 1.6 && st.tv > 0.6 && Math.sin(t * 17) > -0.2; if (face && typeof ART !== 'undefined' && ART.portrait) { const pc = ART.portrait('afu', 96, { tamed:true }), sz = h * 0.9; ctx.globalAlpha = 0.55; ctx.globalCompositeOperation = 'luminosity'; ctx.drawImage(pc, x + w / 2 - sz / 2 + (Math.random() - 0.5) * 4, y + h * 0.05, sz, sz); }
      ctx.restore(); ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(x + w / 2, y + h / 2, 0, x + w / 2, y + h / 2, w * 0.8); g.addColorStop(0, 'rgba(200,210,255,.25)'); g.addColorStop(1, 'rgba(200,210,255,0)'); ctx.fillStyle = g; ctx.fillRect(x - w * 0.3, y - h * 0.3, w * 1.6, h * 1.8); ctx.restore();
      text(ctx, x + w * 0.85, y - h * 0.08, '沙沙沙', h * 0.14, Math.min(1, st.tv)); }
    // 會議電話：一圈一圈綠燈、喇叭傳出呼吸聲
    if (st.speaker > 0) { const [x, y, w, h] = rect(A.speaker), e = Math.min(1, st.speaker, (3 - st.speaker) * 3), br = 0.5 + 0.5 * Math.sin(t * 2.6); ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < 3; i++) { const q = (t * 0.6 + i / 3) % 1; ctx.strokeStyle = `rgba(140,255,170,${0.6 * e * (1 - q)})`; ctx.lineWidth = 2; ctx.beginPath(); ctx.ellipse(x + w / 2, y + h * 0.4, w * (0.3 + q * 0.9), h * (0.3 + q * 0.6), 0, 0, PI * 2); ctx.stroke(); }
      ctx.fillStyle = `rgba(140,255,170,${0.8 * e})`; ctx.beginPath(); ctx.arc(x + w / 2, y + h * 0.35, 3, 0, PI * 2); ctx.fill(); ctx.restore();
      text(ctx, x + w / 2, y - h * (1.2 + br * 0.4), br > 0.5 ? '呼……' : '……吸', h * 0.75, e * (0.5 + 0.5 * br)); }
    // 老闆嘅皮椅：自己轉（後面用左右顏色補返）
    if (st.bchair > 0) { const C = crop('bchair', A.chair, true), [x, y, w, h] = rect(A.chair); if (C) { const e = Math.min(1, st.bchair, (2.8 - st.bchair) * 3), a = (2.8 - st.bchair) * 7 * e, sc = Math.cos(a);
      ctx.drawImage(C.f, x, y, w, h); ctx.save(); ctx.translate(x + w / 2, y + h); ctx.scale(Math.max(0.25, Math.abs(sc)), 1); if (sc < 0) ctx.filter = 'brightness(0.6)'; ctx.drawImage(C.c, -w / 2, -h, w, h); ctx.restore();
      text(ctx, x + w / 2, y - h * 0.15, '吱——', h * 0.32, e); } }
    // 獎盃：由書架跌落地（原位補返）；跌咗之後喺地上畫
    if (st.trophy || st.trophyBack > 0) { const C = crop('trophy', A.trophy, true), [x, y, w, h] = rect(A.trophy); if (C) { ctx.drawImage(C.f, x, y, w, h); if (!st.trophy && st.trophyBack > 0) { ctx.save(); ctx.globalAlpha = 1 - st.trophyBack / 0.6; ctx.drawImage(C.c, x, y, w, h); ctx.restore(); } } }
  }
  // 地上嘅嘢：同人一齊排前後
  function drawables() {
    const out = []; if (!st) return out;
    if (st.can) out.push([0.645, (ctx) => { const c = st.can, [x, y] = P(c.x, c.y), u = U(c.y), r = u * 0.035, hgt = u * 0.075, drop = c.t < 0.35 ? (1 - c.t / 0.35) * u * 0.08 : 0;
      ctx.save(); ctx.translate(x, y - r - drop); ctx.rotate(c.t > 0.35 ? c.rot : 0); ctx.fillStyle = '#d23a3a'; ctx.fillRect(-hgt / 2, -r, hgt, r * 2); ctx.fillStyle = '#eee'; ctx.fillRect(-hgt * 0.15, -r, hgt * 0.3, r * 2); ctx.fillStyle = '#aaa'; ctx.fillRect(-hgt / 2 - 1, -r, 2, r * 2); ctx.fillRect(hgt / 2 - 1, -r, 2, r * 2); ctx.restore();
      if (c.t > 0.3 && c.t < 1.2) text(ctx, x, y - u * 0.18, '咕碌咕碌', u * 0.08, 1 - (c.t - 0.3) / 0.9); }]);
    if (st.golf) out.push([st.golf.y, (ctx) => { const g = st.golf, [x, y] = P(g.x, g.y), u = U(g.y), r = u * 0.022; ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.3)'; ctx.beginPath(); ctx.ellipse(x, y, r * 1.3, r * 0.4, 0, 0, PI * 2); ctx.fill();
      ctx.fillStyle = '#fafafa'; ctx.strokeStyle = '#555'; ctx.lineWidth = 1; ctx.beginPath(); ctx.arc(x, y - r, r, 0, PI * 2); ctx.fill(); ctx.stroke(); ctx.fillStyle = '#bbb'; ctx.beginPath(); ctx.arc(x + Math.cos(g.rot) * r * 0.5, y - r + Math.sin(g.rot) * r * 0.3, r * 0.18, 0, PI * 2); ctx.fill(); ctx.restore();
      if (g.t < 2.4) { ctx.save(); ctx.strokeStyle = 'rgba(255,255,255,.35)'; ctx.lineWidth = 1.5; for (let i = 1; i < 4; i++) { ctx.beginPath(); ctx.moveTo(x - Math.sign(g.x1 - g.x0) * u * (0.05 + i * 0.05), y - r - i * 2 + 4); ctx.lineTo(x - Math.sign(g.x1 - g.x0) * u * (0.1 + i * 0.05), y - r - i * 2 + 4); ctx.stroke(); } ctx.restore(); text(ctx, x, y - u * 0.12, '咕碌——', u * 0.07, 1 - g.t / 2.4); } }]);
    if (st.trophy) out.push([st.trophy.y > 0.64 ? 0.656 : 0.6, (ctx) => { const T = st.trophy, C = crop('trophy', A.trophy, true); if (!C) return; const [x, y] = P(T.x, T.y), w = rect(A.trophy)[2], h = rect(A.trophy)[3];
      ctx.save(); ctx.translate(x, y - (T.y >= T.floor ? w * 0.5 : h * 0.5)); ctx.rotate(T.rot); ctx.drawImage(C.c, -w / 2, -h / 2, w, h); ctx.restore(); if (T.land >= 0 && T.t - T.land < 0.6) text(ctx, x, y - h * 0.9, '哐啷！', h * 0.35, 1 - (T.t - T.land) / 0.6); }]);
    const ch = tint('of_chair_back');
    if (ch) for (const c of st.spare) { const y = c.y + c.oz; out.push([y, (ctx) => { const [x, yy] = P(c.x + c.ox, y), u = U(y), h = 0.62 * u, w = h * ch.width / ch.height, s = Math.cos(c.sw);
      ctx.save(); ctx.fillStyle = 'rgba(6,4,18,.3)'; ctx.beginPath(); ctx.ellipse(x, yy, w * 0.42, w * 0.1, 0, 0, PI * 2); ctx.fill(); ctx.translate(x, yy); ctx.scale(Math.max(0.35, Math.abs(s)) * (s < 0 ? -1 : 1), 1); ctx.drawImage(ch, -w / 2, -h, w, h); ctx.restore();
      if (st.chairs > 0) text(ctx, x, yy - h * 1.05, '吱——', u * 0.1, Math.min(1, st.chairs)); }]); }
    return out;
  }
  // 玩電燈、冷氣：只喺嗰間房（畫面上嗰間房嘅範圍）
  function roomScreen(r) { const [x1] = P(r.x0, 0), [x2] = P(r.x1, 0); return [Math.max(0, x1), Math.min(SC.W, x2)]; }
  function drawOver(ctx, t) {
    if (!st) return; const H = SC.H;
    if (st.lights) { const L = st.lights, r = RM[L.room], [a, b] = roomScreen(r); if (b > a) { const q = L.t, fl = Math.sin(q * 37) + Math.sin(q * 23) > 0.6 ? 0.55 : 0.08, [r0] = P(r.x0, 0), [r1] = P(r.x1, 0), bw = (r1 - r0) / 3;
      ctx.save(); ctx.beginPath(); ctx.rect(a, 0, b - a, H); ctx.clip();
      for (let i = 0; i < 3; i++) { const t0 = 0.9 + i * 0.3, v = q < 0.9 ? fl : q < 2.7 ? (q < t0 ? fl : Math.min(0.74, 0.2 + (q - t0) * 3)) : 0; if (v > 0) { ctx.fillStyle = `rgba(4,3,14,${v})`; ctx.fillRect(r0 + bw * i - 1, 0, bw + 2, H); } }
      if (q >= 2.7 && q < 3.1) { ctx.fillStyle = `rgba(255,250,230,${0.35 * (1 - (q - 2.7) / 0.4)})`; ctx.fillRect(a, 0, b - a, H); }
      ctx.restore(); if (q > 0.95 && q < 2.6) { const i = Math.min(2, Math.floor((q - 0.9) / 0.3)); text(ctx, Math.max(a + 20, Math.min(b - 20, r0 + bw * (i + 0.5))), H * 0.16, '啪', H * 0.035, 1 - ((q - 0.9) % 0.3) / 0.3); } } }
    if (st.ac) { const A0 = st.ac, r = RM[A0.room], [a, b] = roomScreen(r); if (b > a) { const e = Math.min(1, A0.t * 3, (2.6 - A0.t) * 3), [vx, vy] = P(px(r.vent[0]), py(r.vent[1]));
      ctx.save(); ctx.beginPath(); ctx.rect(a, 0, b - a, H); ctx.clip(); ctx.fillStyle = `rgba(150,200,255,${0.14 * e})`; ctx.fillRect(a, 0, b - a, H); ctx.lineCap = 'round';
      for (let i = 0; i < 9; i++) { const q = (t * 0.9 + i / 9) % 1, sx = vx + (i - 4) * 9, ex = sx + (i - 4) * 14 * q - 10 * q, ey = vy + q * H * 0.5; ctx.strokeStyle = `rgba(210,235,255,${0.5 * e * (1 - q)})`; ctx.lineWidth = 2.2 * (1 - q * 0.5); ctx.beginPath(); ctx.moveTo(sx, vy); ctx.quadraticCurveTo(sx + Math.sin(t * 6 + i) * 8, (vy + ey) / 2, ex, ey); ctx.stroke(); }
      ctx.restore(); } }
  }
  // ---------- 小地圖（畫面頂）：四間房、每個人一粒（恐懼顏色）、點中嘅人金圈、望緊佢嘅人紅圈；點一下跳過去 ----------
  function mapHTML() {
    return `<div id="sc-map">${ROOMS.map(r => `<div class="scm-r" data-r="${r.k}" style="left:${r.x0 / WW * 100}%;width:${(r.x1 - r.x0) / WW * 100}%"><span>${r.name}</span></div>`).join('')}<i id="scm-view"></i><div id="scm-dots"></div></div><button id="sc-follow" class="on" title="鏡頭跟住點中嘅人">跟</button>`;
  }
  const DOTCH = { ken:'K', it:'晴', mis:'美', boss:'陳', auntie:'娣', guard:'伯', daoshi:'道', kol:'網' };
  function mapTick(S) {
    const box = document.getElementById('scm-dots'); if (!box) return;
    const v = document.getElementById('scm-view'); v.style.left = (S.camX / WW * 100) + '%'; v.style.width = (S.viewW() / WW * 100) + '%';
    const sel = S.sel && !S.sel.gone && !S.sel.out ? S.sel : null, wit = sel ? new Set(S.witnesses(sel)) : new Set(), cr = S.camRoom();
    document.querySelectorAll('#sc-map .scm-r').forEach(e => e.classList.toggle('cur', e.dataset.r === cr.k));
    const want = S.npcs.filter(n => !n.gone && !n.out);
    S._dots = S._dots || {};
    for (const n of want) { let d = S._dots[n.d.k]; if (!d) { d = S._dots[n.d.k] = document.createElement('b'); d.textContent = DOTCH[n.d.k] || n.d.name[0]; box.appendChild(d); }
      const f = n.fear, col = n.fleeing ? '#c070ff' : f >= 50 ? '#ff5a4a' : f >= 25 ? '#ffb84a' : n.d.guard ? '#8ab0d0' : n.d.daoshi ? '#ffd36a' : '#7fd6a0';
      const sm = Math.max(0.6, Math.min(WW - 0.06, n.x)) / WW * 100, lane = Math.round((n.y - 0.64) / 0.34 * 4) * 0; // 一條線排開
      d.style.left = sm + '%'; d.style.background = col; d.className = (n === sel ? 'sel' : wit.has(n) ? 'wit' : '') + (n.act === 'walk' ? ' walk' : ''); d.style.display = ''; d._seen = true; }
    { const B = S.bryan, on = B && B.st !== 'wait' && B.st !== 'gone'; let d = S._dots.__bryan; if (on) { if (!d) { d = S._dots.__bryan = document.createElement('b'); d.textContent = 'B'; box.appendChild(d); } d.style.left = (Math.max(0.6, Math.min(WW - 0.06, B.x)) / WW * 100) + '%'; d.style.background = '#b07aff'; d.style.top = '8px'; d.className = 'bry'; d._seen = true; } } // 死對頭 Bryan
    for (const k in S._dots) { const d = S._dots[k]; if (!d._seen) d.style.display = 'none'; else d.style.display = ''; d._seen = false; }
    // 同一間房、位置太近嘅點：上下錯開
    const vis = want.slice().sort((a, b) => a.x - b.x); let last = -9, row = 0; for (const n of vis) { const d = S._dots[n.d.k]; const p = n.x / WW * 100; row = p - last < 4.2 ? (row + 1) % 2 : 0; last = p; d.style.top = row ? '15px' : '1px'; }
  }
  return { PXU, WW, SW, SH, SEAM, PILLAR, ROOMS, RM, OX, M, MY, px, py, roomAt, SPOT, LANE, PATROL, A, R, init, tick, onProp, drawBack, drawables, drawOver, mapHTML, mapTick,
    WINMAIN:[px(1575), py(200), px(995), py(216)], ELEV:{ x0:px(2652), x1:px(2872), seam:px(2762), top:py(248), bot:py(570), btn:[px(2910), py(380)] } };
})();
