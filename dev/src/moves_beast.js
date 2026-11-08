// 專屬招式
// ===================== 餓鬼王、餓鬼、小鬼、老殭、殭屍兵 =====================
// 全部用 MoveKit（moves_chain.js）。F 座標：+x = 往敵人。S.tx/S.ty = 敵人腳底；S.th = 敵人大約身高。

// ---------- 餓鬼王：丟包子 ----------
// ① 手往後收（包子舉到頭後）→ ② 甩手丟出去，包子拋物線飛到敵人身上 → ③ 啪：壓扁、碎屑、熱氣
// → ④ 手空著揮到底 → ⑤ 手伸到肚子後面（腰帶）掏，拿出一顆新包子，回到原本的姿勢
// 包子 = eguiking__bun（從他手上那顆切下來的原圖，被手指擋住的一小角用同一顆包子另一邊鏡射補上，art/cutpiece.py）
// 空手 = eguiking__hand（手 − 包子）。拿著的時候「包子 + 手」疊起來 = 原本的 eguiking__arm
MOVES.eguiking = function (ctx, a) {
  const K = MoveKit; const S = K.setup(a); if (!S || !K.ok('eguiking__bun') || !K.ok('eguiking__hand')) return false;
  const { E, seg, lerp, M, cl } = K, tt = S.tt, H = S.H, th = S.th, D = Math.PI / 180;
  const PV = S.C.pivot, BC = [0.1329, 0.2928]; // 手腕支點、包子中心（原圖比例；cutpiece.py 印出來的）
  const REL = 0.145; // 包子離手
  // 身體 + 手在某一刻的樣子（丟出去那一刻要拿來算包子的起點）
  function rig(t) {
    const kB = E.o(seg(t, 0, 0.11)), kT = E.i(seg(t, 0.11, 0.18)), kF = E.o(seg(t, 0.20, 0.30)), kG = E.io(seg(t, 0.34, 0.44)), kU = E.io(seg(t, 0.44, 0.59));
    let lean = -10 * kB, bdx = -0.035 * kB, rot = -32 * kB, wx = -0.02 * kB, wy = -0.045 * kB, head = -0.10 * kB; // 手是從肩膀整條切下來的：只繞肩膀轉，不亂移（不然會跟身體脫開）
    lean = lerp(lean, 10, kT); bdx = lerp(bdx, 0.045, kT); rot = lerp(rot, 95, kT); wx = lerp(wx, 0.015, kT); wy = lerp(wy, 0, kT); head = lerp(head, 0.10, kT);
    rot = lerp(rot, 120, kF);
    // 伸到肚子後面掏
    lean = lerp(lean, 3, kG); bdx = lerp(bdx, 0.01, kG); rot = lerp(rot, 172, kG); wx = lerp(wx, 0.01, kG); wy = lerp(wy, 0.01, kG); head = lerp(head, 0.06, kG);
    lean *= 1 - kU; bdx *= 1 - kU; rot *= 1 - kU; wx *= 1 - kU; wy *= 1 - kU; head *= 1 - kU;
    const bp = K.ip(S, 0.5, 0.8);
    const bm = new M().t(bdx * H, -S.fl).t(bp[0], bp[1]).r(lean * D).t(-bp[0], -bp[1]);
    const pv = K.ip(S, PV[0], PV[1]);
    const hm = bm.clone().t(pv[0] + wx * H, pv[1] + wy * H).r(rot * D);
    return { bm, hm, head, behind:t > 0.37 && t < 0.455 };
  }
  const R = rig(tt);
  const back = K.tgtBack(tt, th);
  const Tp = [S.tx - 0.06 * th, S.ty - 0.80 * th]; // 高高拋過去，砸在頭上
  const R0 = K.ppt(S, rig(REL).hm, PV[0], PV[1], BC[0], BC[1]);
  const bunAt = (m, sc) => { // 手上的包子（跟著手）
    const c = K.ppt(S, m, PV[0], PV[1], BC[0], BC[1]);
    return { c, m:m.clone().t((S.nr ? 1 : -1) * (BC[0] - PV[0]) * S.W, (BC[1] - PV[1]) * S.H).s(sc) };
  };
  ctx.save(); K.enter(ctx, S);
  K.shadow(ctx, S, 0, 0);
  // 手上有沒有包子：丟出去之前有；掏出來之後慢慢出現（從肚子後面拿出來）
  const grow = tt < REL ? 1 : tt < 0.44 ? 0 : E.back(seg(tt, 0.44, 0.53));
  const drawHand = () => {
    if (grow > 0.01) { const b = bunAt(R.hm, grow); K.piece(ctx, S, 'eguiking__bun', b.m, BC[0], BC[1]); }
    K.piece(ctx, S, 'eguiking__hand', R.hm, PV[0], PV[1]);
  };
  if (R.behind) drawHand();
  K.body(ctx, S, R.bm, K.pose(S, { head:R.head }));
  if (!R.behind) drawHand();
  // 新包子冒出來那一下的熱氣
  if (tt > 0.45 && tt < 0.59) { const b = bunAt(R.hm, 1); steam(ctx, b.c[0], b.c[1] - 0.05 * H, 0.10 * H, seg(tt, 0.45, 0.59), 5); }
  // ---- 飛出去的包子 ----
  const bunPiece = (x, y, rot, sx, sy, al) => { const m = new M().t(x, y).r(rot).s(sx, sy); K.piece(ctx, S, 'eguiking__bun', m, BC[0], BC[1], al); };
  if (tt >= REL && tt < K.TC) {
    const q = E.sin(seg(tt, REL, K.TC)) * 0.3 + seg(tt, REL, K.TC) * 0.7, x = lerp(R0[0], Tp[0], q), y = lerp(R0[1], Tp[1], q) - 0.42 * H * 4 * q * (1 - q);
    const q2 = Math.max(0, q - 0.12), x2 = lerp(R0[0], Tp[0], q2), y2 = lerp(R0[1], Tp[1], q2) - 0.42 * H * 4 * q2 * (1 - q2);
    K.speed(ctx, x, y, x - x2, y - y2, 0.13 * H, 0.07 * H, 0.9, 'rgba(255,248,230,.75)', 7, 3);
    bunPiece(x, y, q * 7.5, 1, 1);
  } else if (tt >= K.TC && tt < 0.47) {
    const p = tt - K.TC, bx = Tp[0] + back;
    if (p < 0.035) { const k = Math.sin(p / 0.035 * Math.PI * 0.5); bunPiece(bx, Tp[1] + 0.02 * H * k, 0, 1 + 0.32 * k, 1 - 0.45 * k); } // 啪：壓扁在頭上
    else { const q = p - 0.035; bunPiece(bx - q * 0.35 * H, Tp[1] + 0.02 * H + q * q * 9 * H - q * 0.5 * H, -q * 9, 1.32 - Math.min(0.3, q * 3), 0.55 + Math.min(0.4, q * 4), 1 - seg(tt, 0.40, 0.47)); } // 彈開掉下去
    // 碎屑（包子皮的米白、餡的褐色），熱氣
    const k = 1 - seg(tt, K.TC + 0.15, K.TC + 0.26);
    ctx.save(); ctx.globalAlpha *= k;
    for (let i = 0; i < 14; i++) {
      const an = -2.7 + K.rnd(i) * 3.6, sp = (0.5 + K.rnd(i + 30)) * 1.25 * H, px = bx + Math.cos(an) * sp * p - 0.15 * H * p, py = Tp[1] + Math.sin(an) * sp * p + 2.6 * H * p * p;
      ctx.fillStyle = i % 4 === 3 ? '#8a5a3a' : i % 2 ? '#f6ead6' : '#eedcc0'; ctx.strokeStyle = 'rgba(90,60,40,.7)'; ctx.lineWidth = 0.5;
      ctx.beginPath(); ctx.ellipse(px, py, 0.014 * H * (1 + K.rnd(i + 5)), 0.01 * H * (1 + K.rnd(i + 6)), i, 0, 7); ctx.fill(); ctx.stroke();
    }
    ctx.restore();
    if (p < 0.12) K.burst(ctx, bx, Tp[1], 0.17 * th, 1 - p / 0.12, '#fff3d6', 23, 10);
    steam(ctx, bx, Tp[1] - 0.04 * H, 0.16 * H, seg(tt, K.TC, 0.5), 17);
  }
  if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * Tp[0], y:S.a.y + Tp[1] };
  ctx.restore();
  // 熱氣：幾條往上飄的白色蠟筆波浪線
  function steam(ctx, x, y, h, q, seed) {
    if (q <= 0 || q >= 1) return; const al = Math.sin(q * Math.PI) * 0.8;
    for (let i = 0; i < 3; i++) {
      const ox = (i - 1) * h * 0.28, pts = [];
      for (let j = 0; j <= 8; j++) { const f = j / 8; pts.push([x + ox + Math.sin(f * 6 + i * 2 + q * 8) * h * 0.08 * (0.4 + f), y - f * h * (0.5 + q * 0.7) - q * h * 0.3]); }
      ctx.save(); ctx.globalAlpha *= al * (0.6 + 0.4 * K.rnd(seed + i)); K.crayon(ctx, pts, 'rgba(250,250,250,.85)', h * 0.07, seed + i * 5); ctx.restore();
    }
  }
};

// ---------- 餓鬼：撲上去咬 ----------
// ① 頭往後縮、身體往後蓄力 → ② 撲到敵人身上，嘴對準敵人的肩頸 → ③ 咬下去、甩頭，連咬三口（牙印）
// → ④ 鬆口，往後彈回原位。頭 = egui__arm（原圖切下來的整顆頭）
MOVES.egui = function (ctx, a) {
  const K = MoveKit; const S = K.setup(a); if (!S) return false;
  const { E, seg, lerp, M } = K, tt = S.tt, H = S.H, th = S.th, D = Math.PI / 180;
  const PV = S.C.pivot, MO = [0.76, 0.27]; // 脖子支點、嘴巴
  const CH = [K.TC, 0.315, 0.36];           // 三口
  const back = K.tgtBack(tt, th);
  const Bp = [S.tx - 0.12 * th, S.ty - 0.70 * th]; // 咬在敵人靠我這邊的肩膀
  function rig(t, dx, dy) {
    const kC = E.o(seg(t, 0, 0.15)), kL = E.i(seg(t, 0.15, K.TC)), kO = E.io(seg(t, 0.40, 0.59));
    let lean = -14 * kC, hr = -38 * kC, hs = 1;
    lean = lerp(lean, 16, kL); hr = lerp(hr, 14, kL);
    // 咬：每一口頭往下一壓、壓扁一點，接著左右甩
    let chomp = 0; for (const c of CH) { const p = (t - c) / 0.045; if (p >= 0 && p < 1) chomp = Math.max(chomp, Math.sin(p * Math.PI)); }
    const shakeA = t > K.TC && t < 0.40 ? Math.sin((t - K.TC) * 95) * 7 * (1 - seg(t, 0.36, 0.40)) : 0;
    hr += chomp * 12 + shakeA; hs = 1 - 0.09 * chomp;
    lean *= 1 - kO; hr *= 1 - kO;
    const bp = K.ip(S, 0.5, 0.85);
    const bm = new M().t(dx, dy - S.fl).t(bp[0], bp[1]).r(lean * D).t(-bp[0], -bp[1]).t(bp[0], bp[1]).s(1 - 0.05 * kC + 0.04 * kL * (1 - kO), 1 + 0.06 * kC - 0.05 * kL * (1 - kO)).t(-bp[0], -bp[1]);
    const pv = K.ip(S, PV[0], PV[1]);
    const hm = bm.clone().t(pv[0], pv[1] + 0.015 * H * chomp).r(hr * D).s(1 + 0.05 * chomp, hs);
    return { bm, hm, chomp };
  }
  // 撲到哪：先算「沒位移」時嘴巴在哪，再把整個人移過去讓嘴巴對到 Bp
  const m0 = rig(K.TC, 0, 0), mo = K.ppt(S, m0.hm, PV[0], PV[1], MO[0], MO[1]);
  const Dx = Math.max(0, Bp[0] - mo[0]), Dy = Bp[1] - mo[1];
  let dx, dy;
  if (tt < 0.15) { const k = E.o(seg(tt, 0, 0.15)); dx = -0.07 * H * k; dy = 0.01 * H * k; }
  else if (tt < K.TC) { const q = E.i(seg(tt, 0.15, K.TC)); dx = lerp(-0.07 * H, Dx, q); dy = lerp(0.01 * H, Dy, q) - 0.10 * H * Math.sin(q * Math.PI); }
  else if (tt < 0.40) { dx = Dx + back + Math.sin(tt * 120) * 0.006 * H; dy = Dy; }
  else { const q = E.io(seg(tt, 0.40, 0.59)); dx = lerp(Dx + back, 0, q); dy = lerp(Dy, 0, q) - 0.12 * H * Math.sin(q * Math.PI); }
  const R = rig(tt, dx, dy);
  ctx.save(); K.enter(ctx, S);
  K.shadow(ctx, S, dx, 0, 0.8 - 0.15 * Math.min(1, Math.max(0, -dy) / (0.15 * H)));
  if (tt > 0.15 && tt < K.TC) K.speed(ctx, dx - 0.15 * S.W, -0.55 * H + dy, 1, 0.1, 0.22 * H, 0.35 * H, seg(tt, 0.15, 0.22), 'rgba(235,245,225,.6)', 3, 4);
  K.body(ctx, S, R.bm, K.pose(S, { tail1:-0.25 * seg(tt, 0.15, 0.27) * (1 - seg(tt, 0.4, 0.59)), tail2:-0.35 * seg(tt, 0.15, 0.27) * (1 - seg(tt, 0.4, 0.59)) }));
  K.piece(ctx, S, 'egui__arm', R.hm, PV[0], PV[1]);
  // 牙：每口上下兩排白牙合起來；牙印留在敵人身上，跟著敵人退
  const bx = Bp[0] + back, by = Bp[1];
  CH.forEach((c, i) => {
    const p = (tt - c) / 0.06; if (p < 0 || p > 1) return;
    const close = Math.min(1, p * 2.2), al = 1 - Math.max(0, p - 0.5) * 2, w = 0.20 * th, gap = 0.08 * th * (1 - close) + 0.012 * th;
    for (const sg of [-1, 1]) {
      const pts = []; for (let j = 0; j <= 6; j++) pts.push([bx - w / 2 + j * w / 6 + sg * 0.01 * th, by + sg * gap + (j % 2 ? -sg : 0) * 0.035 * th]);
      ctx.save(); ctx.globalAlpha *= al; K.crayon(ctx, pts, '#fffaf0', 0.022 * th, 50 + i * 9 + sg); ctx.restore();
    }
    if (i === 0) K.burst(ctx, bx, by, 0.2 * th, 1 - p, '#ffe9c8', 61, 9);
    else K.burst(ctx, bx, by, 0.13 * th, (1 - p) * 0.8, '#ffd6c8', 61 + i, 6);
  });
  if (tt > K.TC && tt < 0.55) { // 牙印：兩排小弧
    const k = 1 - seg(tt, 0.42, 0.55); ctx.save(); ctx.globalAlpha *= k * 0.9;
    for (const sg of [-1, 1]) for (let j = 0; j < 4; j++) { const x = bx - 0.06 * th + j * 0.04 * th, y = by + sg * 0.03 * th; K.crayon(ctx, [[x - 0.012 * th, y], [x, y + sg * 0.014 * th], [x + 0.012 * th, y]], '#a23a3a', 0.012 * th, 80 + j + sg); }
    ctx.restore();
  }
  if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * bx, y:S.a.y + by };
  ctx.restore();
};

// ---------- 小鬼：飛過去繞一圈抓 ----------
// ① 縮身 → ② 衝到敵人旁邊，從敵人背後繞過去（被敵人身體擋住，尾巴拖著）→ 從另一邊出來、轉身
// → ③ 從敵人前面掠過，一爪抓下去（三道爪痕）→ 繞回這一邊 → ④ 飛回原位
MOVES.xiaogui = function (ctx, a) {
  const K = MoveKit; const S = K.setup(a); if (!S) return false;
  const { E, seg, lerp, M, cl } = K, tt = S.tt, H = S.H, th = S.th, D = Math.PI / 180;
  const PV = S.C.pivot, BC = [0.45, 0.52]; // 爪子支點、身體中心（原圖比例）
  const bc0 = K.ip(S, BC[0], BC[1]);           // 身體中心相對腳底
  const back = K.tgtBack(tt, th);
  const cx = S.tx + back, cy = S.ty - 0.55 * th, Rx = 0.46 * th, Ry = 0.13 * th;
  const home = [bc0[0], bc0[1] - S.fl];
  // 身體中心在 τ 時的位置、繞圈的角度（φ：π = 靠我這邊、1.5π = 背後、2π = 另一邊、2.5π = 正前面）
  function at(t) {
    if (t < 0.08) { const k = E.o(seg(t, 0, 0.08)); return { p:[home[0] - 0.06 * H * k, home[1] + 0.02 * H * k], ph:null }; }
    if (t < 0.15) { const q = E.io(seg(t, 0.08, 0.15)), e = [cx - Rx, cy]; return { p:[lerp(home[0] - 0.06 * H, e[0], q), lerp(home[1] + 0.02 * H, e[1], q) - 0.08 * H * Math.sin(q * Math.PI)], ph:null }; }
    if (t < 0.33) { const ph = t < K.TC ? lerp(Math.PI, 2.5 * Math.PI, E.sin(seg(t, 0.15, K.TC)) * 0.15 + seg(t, 0.15, K.TC) * 0.85) : lerp(2.5 * Math.PI, 3 * Math.PI, E.o(seg(t, K.TC, 0.33))); return { p:[cx + Math.cos(ph) * Rx, cy + Math.sin(ph) * Ry], ph }; }
    const q = E.io(seg(t, 0.33, 0.59)), s = [cx - Rx, cy]; return { p:[lerp(s[0], home[0], q), lerp(s[1], home[1], q) - 0.10 * H * Math.sin(q * Math.PI)], ph:null };
  }
  const A = at(tt), A2 = at(Math.max(0, tt - 0.012)), vx = A.p[0] - A2.p[0], vy = A.p[1] - A2.p[1];
  const ph = A.ph;
  // 面向：繞到另一邊時轉身（x 縮到 0 再翻過來 = 轉身），回到這邊再轉回來
  let face = 1;
  if (ph != null) { const sg = -Math.sin(ph); face = Math.max(-1, Math.min(1, sg * 3.2)); if (Math.abs(face) < 0.15) face = 0.15 * (sg >= 0 ? 1 : -1); }
  const depth = ph != null ? Math.sin(ph) : 0, sc = 1 + 0.10 * depth;
  const hidden = ph != null && depth < -0.15;
  const bank = cl(vx / (0.05 * H), -1, 1) * 14 * Math.sign(face || 1);
  // 爪：衝過去時收在胸前，到正前面一爪抓下
  const kU = E.o(seg(tt, 0.20, 0.255)), kS = E.i(seg(tt, 0.255, K.TC)), kF = E.o(seg(tt, K.TC, 0.31)), kR = E.io(seg(tt, 0.31, 0.40));
  let crot = lerp(0, -70, kU); crot = lerp(crot, 35, kS); crot = lerp(crot, 75, kF); crot *= 1 - kR;
  if (tt < 0.08) crot = -20 * E.o(seg(tt, 0, 0.08)); else if (tt < 0.20) crot = lerp(-20, 0, seg(tt, 0.08, 0.2));
  // 身體矩陣：身體中心放在 A.p，再翻面、傾斜、遠近縮放
  const m = new M().t(A.p[0], A.p[1]).s(face * sc, sc).r((bank + (tt < 0.08 ? -8 * E.o(seg(tt, 0, 0.08)) : 0)) * D).t(-bc0[0], -bc0[1]);
  const pv = K.ip(S, PV[0], PV[1]);
  const cm = m.clone().t(pv[0], pv[1]).r(crot * D);
  const vxl = vx * Math.sign(face || 1);
  const tail = cl(-vxl / (0.04 * H), -1, 1);
  ctx.save(); K.enter(ctx, S);
  const trav = K.cl((A.p[0] - home[0]) / ((cx - Rx - home[0]) || 1)); K.shadow(ctx, S, A.p[0] - bc0[0], S.ty * trav + (ph != null ? Math.sin(ph) * Ry : 0), 0.8 * sc);
  // 拖尾：走過的路徑上幾道淡淡的鬼氣
  ctx.save(); ctx.globalAlpha *= 0.5; if (hidden) K.clipOut(ctx, K.tgtBody(S, back));
  if (tt > 0.08 && tt < 0.5) for (let w = 0; w < 3; w++) { // 三縷鬼氣，越後面越淡
    for (let i = 0; i < 7; i++) {
      const q0 = at(Math.max(0, tt - 0.01 - i * 0.007)), q1 = at(Math.max(0, tt - 0.01 - (i + 1) * 0.007)), o = (w - 1) * 0.07 * H, yo = (0.18 + 0.05 * w) * H;
      ctx.save(); ctx.globalAlpha *= (1 - i / 7) * 0.7; K.crayon(ctx, [[q0.p[0], q0.p[1] + yo + o * 0.3], [q1.p[0], q1.p[1] + yo + o * 0.3]], '#e6f7ee', 0.018 * H * (1 - i / 9), 9 + w * 13 + i); ctx.restore();
    }
  }
  ctx.restore();
  ctx.save(); if (hidden) K.clipOut(ctx, K.tgtBody(S, back));
  K.body(ctx, S, m, K.pose(S, { tail1:0.45 * tail, tail2:0.7 * tail, body:0 }));
  K.piece(ctx, S, 'xiaogui__arm', cm, PV[0], PV[1]);
  ctx.restore();
  // 抓：三道爪痕劃過敵人身體，留一下
  const hx = cx, hy = cy;
  if (tt > 0.255 && tt < 0.45) {
    const p = seg(tt, 0.255, 0.30), k = 1 - seg(tt, 0.34, 0.45);
    ctx.save(); ctx.globalAlpha *= k;
    for (let i = 0; i < 3; i++) {
      const o = (i - 1) * 0.07 * th, pts = [];
      for (let j = 0; j <= 6; j++) { const f = j / 6 * p; pts.push([hx + 0.16 * th - f * 0.30 * th + o * 0.4, hy - 0.16 * th + o + f * 0.30 * th]); }
      K.crayon(ctx, pts, '#6e1820', 0.042 * th * (1 - 0.3 * Math.abs(i - 1)), 70 + i);
      K.crayon(ctx, pts, i === 1 ? '#fff6ea' : '#ffd0c4', 0.022 * th * (1 - 0.3 * Math.abs(i - 1)), 90 + i);
    }
    ctx.restore();
  }
  const hk = 1 - seg(tt, K.TC, K.TC + 0.12); if (tt >= K.TC && hk > 0) K.burst(ctx, hx, hy, 0.2 * th, hk, '#f2fff0', 33, 9);
  if (tt > 0.08 && tt < 0.15) K.speed(ctx, A.p[0] - 0.1 * H, A.p[1], vx, vy, 0.2 * H, 0.25 * H, 0.8, 'rgba(225,245,235,.7)', 5, 4);
  if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * hx, y:S.a.y + hy };
  ctx.restore();
};

// ---------- 老殭、殭屍兵：跳過去、雙手一戳 ----------
// 身體一直直挺挺（不彎、不晃），雙手一直往前伸直；跳：起跳前蹲扁、空中拉長、落地再扁。
// ① 第一跳 → ② 第二跳靠近，落地同時雙手往前一戳（整個人往前一頂）→ ③ 戳到底停一下 → ④ 跳兩下回原位
function jiangshiMove(ctx, a) {
  const K = MoveKit; const S = K.setup(a); if (!S) return false;
  const { E, seg, lerp, M } = K, tt = S.tt, H = S.H, th = S.th, D = Math.PI / 180;
  const PV = S.C.pivot, TIP = S.C.tip;
  const tip0 = K.ip(S, TIP[0], TIP[1]);
  const EXT = 0.17 * S.W;                                    // 戳的時候手再往前送
  const Jx = S.tx - 0.06 * th;                                 // 戳到敵人身體靠我這半邊
  const Dx = Math.max(-0.04 * H, Jx - (tip0[0] + EXT + 0.04 * H)), Dy = S.ty;
  // 每一跳：[開始, 起跳, 落地, 結束, 從, 到, 高]
  const HOPS = [[0, 0.03, 0.11, 0.13, 0, 0.5, 0.20], [0.13, 0.155, 0.25, 0.2704, 0.5, 1, 0.16], [0.355, 0.375, 0.455, 0.47, 1, 0.45, 0.14], [0.47, 0.49, 0.565, 0.59, 0.45, 0, 0.12]];
  let f = tt < 0.13 ? 0 : tt < 0.355 ? (tt < 0.2704 ? 0.5 : 1) : tt < 0.47 ? 1 : tt < 0.59 ? 0.45 : 0, hy = 0, sx = 1, sy = 1;
  for (const [t0, t1, t2, t3, f0, f1, hh] of HOPS) {
    if (tt < t0 || tt >= t3) continue;
    if (tt < t1) { const k = Math.sin(seg(tt, t0, t1) * Math.PI * 0.5); sx = 1 + 0.08 * k; sy = 1 - 0.10 * k; f = f0; }
    else if (tt < t2) { const q = seg(tt, t1, t2); f = lerp(f0, f1, q); hy = -hh * H * 4 * q * (1 - q); const st = Math.sin(q * Math.PI); sx = 1 - 0.05 * st; sy = 1 + 0.07 * st; }
    else { const k = Math.sin(seg(tt, t2, t3) * Math.PI); sx = 1 + 0.09 * k; sy = 1 - 0.11 * k; f = f1; }
  }
  // 戳：最後一跳落地前雙手往前送、整個人往前一頂（硬硬地，以腳為軸轉一點點）
  const kJ = E.o3(seg(tt, 0.235, K.TC)), kH = 1 - E.io(seg(tt, 0.33, 0.37));
  const jab = kJ * kH, jit = tt > K.TC && tt < 0.33 ? Math.sin(tt * 210) * 0.004 * H : 0;
  const lean = 7 * jab, push = 0.03 * H * jab;
  const dx = Dx * f + push + jit, dy = Dy * f;
  const stiff = 1 - seg(tt, 0, 0.04) * (1 - seg(tt, 0.55, 0.59)); // 招式中間完全不晃
  const bm = new M().t(dx, dy + hy).r(lean * D).s(sx, sy);
  const pv = K.ip(S, PV[0], PV[1]);
  const am = bm.clone().t(pv[0] + EXT * jab, pv[1] - 0.01 * H * jab).r((-4 * jab + (hy < 0 ? -3 : 0)) * D);
  ctx.save(); K.enter(ctx, S);
  K.shadow(ctx, S, dx, dy, 1 - 0.4 * Math.min(1, -hy / (0.2 * H)));
  if (jab > 0.2) { const tp = K.ppt(S, am, PV[0], PV[1], TIP[0], TIP[1]); K.speed(ctx, tp[0] - 0.08 * H, tp[1], 1, 0, 0.18 * H, 0.10 * H, jab * (1 - seg(tt, 0.29, 0.33)), 'rgba(240,235,220,.8)', 13, 3); }
  K.body(ctx, S, bm, K.pose(S, null, stiff));
  K.piece(ctx, S, S.id + '__arm', am, PV[0], PV[1]);
  const tp = K.ppt(S, am, PV[0], PV[1], TIP[0], TIP[1]);
  const hk = 1 - seg(tt, K.TC, K.TC + 0.12);
  if (tt >= K.TC && hk > 0) { K.burst(ctx, tp[0] + 0.02 * H, tp[1], 0.2 * th, hk, '#fff0c8', 44, 10); }
  if (tt >= K.TC - 0.01 && tt < 0.33) { // 戳到的兩下衝擊圈
    const k = seg(tt, K.TC - 0.01, 0.33); ctx.save(); ctx.globalAlpha *= 1 - k; ctx.strokeStyle = '#fff6dc'; ctx.lineWidth = 0.02 * th;
    for (const o of [-0.07, 0.03]) { ctx.beginPath(); ctx.ellipse(tp[0] + 0.03 * H, tp[1] + o * H, 0.03 * th + k * 0.12 * th, 0.08 * th + k * 0.1 * th, 0, -1.2, 1.2); ctx.stroke(); }
    ctx.restore();
  }
  if (tt > 0.13 && tt < 0.25 && hy < -0.02 * H) K.speed(ctx, dx - 0.25 * S.W, dy + hy - 0.5 * H, 1, 0.3, 0.12 * H, 0.4 * H, 0.6, 'rgba(230,225,215,.5)', 21, 3);
  if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * tp[0], y:S.a.y + tp[1] };
  ctx.restore();
}
MOVES.laojiang = jiangshiMove;
MOVES.zombie = jiangshiMove;
