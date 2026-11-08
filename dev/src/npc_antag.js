// ===================== 三個反派 NPC：籃球仔（npc_rival）、HR 姐（npc_hr）、陰間大老闆（npc_kpiboss）=====================
// 只動原圖：每人 4 張原畫（站、走、招牌動作、嚇親），網格變形 ＋ 原圖剪出來的籃球（art/n30cut.py，art/new30/cuts.json）。
// 蠟筆小特效（字、印章紅印、KPI 跌勢圖、聲波）是程式畫的。注意：npc_boss 是舊公司的陳總，跟 npc_kpiboss 是兩個人。
//
// ---------------------------------------------------------------- API（給 skits.js 用）----------------------------------------------------------------
// 1) 最簡單：Antag.draw(ctx, id, x, y, h, state, t, opt)
//      id    = 'npc_rival' | 'npc_hr' | 'npc_kpiboss'
//      x, y  = 腳底中央（世界座標）；h = 角色身高（像素／世界單位）
//      state = 下面 STATES 其中一個字串；t = 這個狀態已經做了幾秒（循環的會自己循環）
//      opt   = { faceRight:true/false（預設 true）, alpha, shadow:false, tdx, tdy（attack 時：對手相對自己的位置，同一個單位）, time（全域時間，給呼吸用）}
//    STATES（每人都有）：idle 待機、walk 走路、jump 嚇一跳、hurt 受擊、scared 驚、down 倒地、die 倒下、attack 出招（t 0~0.59 秒一次完整五段，之後回待機）
//      籃球仔：spin 指尖轉波、dribble 胯下運波、jumpshot 假跳投「三分！」、gossip 掩嘴講是非
//      HR 姐：clip 睇文件夾、glasses 托眼鏡、stamp 蓋印
//      大老闆：inspect 揹手巡視、tap 撳平板、sigh 嘆氣、yell 拍平板大鬧「KPI 呢？！」
//    Antag.STATES[id] 列出該角色可用的狀態；Antag.dur(id, state) = 一輪秒數（循環動作）。
// 2) 也是普通角色：ART.drawChar(ctx, id, x, y, s, o) 照用（CHAR_H：rival 66、hr 60、kpiboss 66）
//      o.pose：idle / move（走路）/ windup·strike·follow·recover（戰鬥五段，o.pt 0~1，o.tdx/o.tdy 對手位置）/ hurt / scared / die / down
//      o.act = 'ag_<狀態>'（例如 'ag_spin'、'ag_stamp'、'ag_yell'、'ag_jump'），o.at = 做了幾秒
//    戰鬥招式：籃球仔「入波！」（跳起入樽）、HR 姐「警告」大紅印、大老闆拍平板＋KPI 跌勢圖＋聲波。
// -------------------------------------------------------------------------------------------------------------------------------------------------------
const Antag = (() => {
  const N = N30K, A = () => MeshAnim.ANIM, D = Math.PI / 180, TAU = Math.PI * 2;
  const { E, seg, lerp, cl, rnd } = N;
  const sw = (g, n, ph) => Math.sin(g * TAU * (n || 1) + (ph || 0));
  const bump = (g, a, b) => Math.sin(seg(g, a, b) * Math.PI);
  // 各人的原畫：k = 跟站姿比的大小（讓頭一樣大），nr = 原畫面朝右
  const P = {
    npc_rival: { h:66, solid:0, zh:'籃球仔', poses:{
      stand:{ img:'npc_rival', k:1, nr:0, rig:{ c:0.55, n:0.38, h:0.58, ht:0.03, hr:0.24, L:[0.45, 0.43, 0.25, 0.30], R:[0.72, 0.43, 0.74, 0.70], tail:0.72 } },
      walk: { img:'npc_rival_walk', k:0.91, nr:0, rig:{ c:0.55, n:0.38, h:0.48, ht:0.03, hr:0.24, L:[0.45, 0.46, 0.25, 0.58], R:[0.72, 0.46, 0.92, 0.76], tail:0.75 } },
      gossip:{ img:'npc_rival_gossip', k:0.88, nr:0, rig:{ c:0.55, n:0.42, h:0.35, ht:0.03, hr:0.26, L:[0.42, 0.46, 0.24, 0.36], R:[0.74, 0.44, 0.70, 0.30], tail:0.40 } },
      jump: { img:'npc_rival_jump', k:0.74, nr:0, rig:{ c:0.45, n:0.46, h:0.42, ht:0.05, hr:0.24, L:[0.38, 0.52, 0.10, 0.32], R:[0.55, 0.52, 0.50, 0.45], tail:0.62 } },
    } },
    npc_hr: { h:60, solid:0, zh:'HR 姐', poses:{
      stand:{ img:'npc_hr', k:1, nr:0, rig:{ c:0.52, n:0.46, h:0.42, ht:0.02, hr:0.32, L:[0.30, 0.52, 0.12, 0.60], R:[0.72, 0.52, 0.55, 0.52], tail:0.88 } },
      walk: { img:'npc_hr_walk', k:0.81, nr:0, rig:{ c:0.50, n:0.46, h:0.45, ht:0.02, hr:0.30, L:[0.35, 0.52, 0.08, 0.53], R:[0.72, 0.54, 0.55, 0.62], tail:0.75 } },
      stamp:{ img:'npc_hr_stamp', k:0.83, nr:0, rig:{ c:0.55, n:0.50, h:0.45, ht:0.04, hr:0.30, L:[0.40, 0.56, 0.38, 0.76], R:[0.74, 0.60, 0.62, 0.76], tail:0.80 } },
      jump: { img:'npc_hr_jump', k:0.75, nr:0, rig:{ c:0.60, n:0.50, h:0.55, ht:0.03, hr:0.28, L:[0.45, 0.55, 0.22, 0.55], R:[0.80, 0.56, 0.80, 0.66], tail:0.45 } },
    } },
    npc_kpiboss: { h:66, solid:0, zh:'陰間大老闆', poses:{
      stand:{ img:'npc_kpiboss', k:1, nr:1, rig:{ c:0.50, n:0.43, h:0.52, ht:0.04, hr:0.32, L:[0.22, 0.46, 0.12, 0.64], R:[0.80, 0.46, 0.90, 0.64], tail:0.32 } },
      walk: { img:'npc_kpiboss_walk', k:1.03, nr:1, rig:{ c:0.45, n:0.43, h:0.48, ht:0.04, hr:0.30, L:[0.30, 0.46, 0.55, 0.55], R:[0.74, 0.50, 0.86, 0.48], tail:0.12 } },
      yell: { img:'npc_kpiboss_yell', k:0.90, nr:1, rig:{ c:0.40, n:0.46, h:0.52, ht:0.04, hr:0.30, L:[0.18, 0.50, 0.14, 0.66], R:[0.60, 0.55, 0.70, 0.86], tail:0.10 } },
      jump: { img:'npc_kpiboss_jump', k:1.0, nr:1, rig:{ c:0.45, n:0.43, h:0.48, ht:0.04, hr:0.30, L:[0.30, 0.50, 0.26, 0.56], R:[0.76, 0.50, 0.86, 0.44], tail:0.20 } },
    } },
  };
  // 剪出來的件：拿走件的身體（_nb）
  const CUTS = { npc_rival:['ball', 'swoosh', 'swoosh2'], npc_rival_walk:['ball', 'fx'] }; // npc_rival_walk__ball 是按顏色挖的（保住手指），只用來挖身體；畫球一律用站姿那顆完整的 npc_rival__ball
  const BALL = { npc_rival:[0.228, 0.158], npc_rival_walk:[0.205, 0.71] }; // 波心（原圖比例）
  // ---------- 登記 ----------
  for (const id in P) {
    const d = P[id];
    for (const k in d.poses) {
      const p = d.poses[k], R = MeshAnim.mk(p.rig);
      MeshAnim.RIG[p.img] = R; if (p.nr) MeshAnim.NATIVE_R[p.img] = 1;
    }
    MeshAnim.RIG[id].custom = (ctx, a) => custom(ctx, a);
    ART.CHAR_H[id] = d.h; if (d.solid) ART.SOLID[id] = 1;
  }
  const nb = (img) => CUTS[img] ? N30.cutBody(img, CUTS[img], img + '__nb') : img;
  // 某張原畫的「S」（N30K 的座標工具都吃這個）
  function poseS(S, id, pk) {
    const p = P[id].poses[pk], im = SPR[p.img]; if (!im || !N.ok(p.img)) return null;
    const H = S.H * p.k; return Object.assign({}, S, { id:p.img, nr:!!p.nr, H, W:H * im.naturalWidth / im.naturalHeight, k:p.k });
  }
  // 網格姿勢：底子 = 待機（或走路），extra 正 = 往前
  function mp(S2, extra, walkT, idleK) {
    let z;
    if (walkT != null) { z = A().walk(walkT); for (const n in z) if (typeof z[n] === 'number' && !['y', 'sx', 'sy'].includes(n) && !S2.nr) z[n] = -z[n]; z.x = 0; z.rot = 0; }
    else z = N.pose(S2, {}, idleK == null ? 0.7 : idleK);
    if (extra) for (const n in extra) if (!['x', 'y', 'r', 'px', 'py', 'sx', 'sy', 'a'].includes(n)) z[n] = (z[n] || 0) + (S2.nr ? extra[n] : -extra[n]);
    return z;
  }
  function drawPose(ctx, S, id, pk, f, opt) {
    const S2 = poseS(S, id, pk); if (!S2) return null; opt = opt || {};
    const m = N.bm(S2, f); N.body(ctx, S2, m, mp(S2, f, opt.walkT, opt.idleK), opt.cut ? nb(S2.id) : S2.id, f.a != null ? f.a : null);
    return { S2, m };
  }
  function setup(a) { const S = N.setup(a); return S; }
  function begin(ctx, S, f, sk) { ctx.save(); N.K.enter(ctx, S); N.shadow(ctx, S, (f && f.x) || 0, 0, sk); }
  const end = (ctx) => ctx.restore();
  // 籃球（件）放在 F 座標
  function ball(ctx, S2, x, y, rot, sc) { // 一律用站姿原畫剪出來那顆完整的波；換算成同一個大小
    const st = Object.assign({}, S2, { id:'npc_rival', nr:false }), im = SPR.npc_rival; if (!im) return;
    st.H = S2.H / S2.k; st.W = st.H * im.naturalWidth / im.naturalHeight; const c = BALL.npc_rival;
    N.pieceAt(ctx, st, 'ball', x, y, rot, c[0], c[1], sc || 1);
  }
  const ballRest = (S2, m) => N.at(S2, m, BALL[S2.id][0], BALL[S2.id][1]);
  const ballR = (S2) => 0.192 * (S2.H / S2.k) * SPR.npc_rival.naturalWidth / SPR.npc_rival.naturalHeight;
  // 蠟筆印章：方框＋兩個字，紅色，蓋下去先大後縮、有點斜
  function seal(ctx, S, x, y, size, txt, k, al) {
    if (al <= 0) return; const z = k < 1 ? 1.6 - 0.6 * E.o(k) : 1;
    ctx.save(); ctx.translate(x, y); ctx.scale(S.fw, 1); ctx.rotate(-0.18); ctx.scale(z, z); ctx.globalAlpha *= cl(al);
    ctx.strokeStyle = '#d0141e'; ctx.lineWidth = size * 0.09; ctx.lineJoin = 'round';
    ctx.strokeRect(-size * 0.55, -size * 0.32, size * 1.1, size * 0.64); ctx.strokeRect(-size * 0.48, -size * 0.25, size * 0.96, size * 0.5);
    ctx.fillStyle = '#d0141e'; ctx.font = `900 ${size * 0.42}px "PingFang TC","Noto Sans TC","Noto Sans CJK TC",serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(txt, 0, size * 0.02);
    ctx.restore();
  }
  // 紅色 KPI 跌勢圖（一條往下跌的鋸齒線＋箭咀）
  function crash(ctx, x, y, w, k, seed) {
    if (k <= 0) return; const pts = [], n = 6;
    for (let i = 0; i <= n; i++) { const q = i / n; if (q > k) break; pts.push([x - w / 2 + q * w, y - w * 0.35 + q * w * 0.7 + (i % 2 ? -w * 0.14 : w * 0.06)]); }
    if (pts.length < 2) return; N.crayon(ctx, pts, '#ffffff', w * 0.1, seed); N.crayon(ctx, pts, '#e0202a', w * 0.06, seed + 1);
    const e = pts[pts.length - 1], p0 = pts[pts.length - 2], an = Math.atan2(e[1] - p0[1], e[0] - p0[0]);
    ctx.save(); ctx.translate(e[0], e[1]); ctx.rotate(an); ctx.fillStyle = '#e0202a'; ctx.beginPath(); ctx.moveTo(w * 0.12, 0); ctx.lineTo(-w * 0.04, -w * 0.08); ctx.lineTo(-w * 0.04, w * 0.08); ctx.closePath(); ctx.fill(); ctx.restore();
  }
  function rings(ctx, x, y, r, k, col) { for (let i = 0; i < 3; i++) { const q = cl(k * 1.4 - i * 0.2); if (q > 0 && q < 1) N.ring(ctx, x, y, r * (0.3 + q), r * (0.3 + q) * 0.8, col, r * 0.06 * (1 - q) + 1, 1 - q); } }

  // ======================= 狀態（待機、走路、嚇親、各人的小動作）=======================
  // 每個 = function(ctx, S, g（0~1 一輪）, t（秒）) → 畫在 F 座標（已 begin）
  const ACT = {
    // ---- 籃球仔 ----
    rival_idle(ctx, S, g, t) { const r = drawPose(ctx, S, 'npc_rival', 'stand', {}, { cut:true, idleK:0.8 }); if (!r) return; const c = ballRest(r.S2, r.m); ball(ctx, r.S2, c[0], c[1] + Math.sin(t * 6) * 0.004 * S.H, t * 360); },
    spin(ctx, S, g, t) {
      const r = drawPose(ctx, S, 'npc_rival', 'stand', { head:sw(g, 2) * 0.05, body:sw(g) * 0.02 }, { cut:true }); if (!r) return; const c = ballRest(r.S2, r.m);
      ball(ctx, r.S2, c[0], c[1] - Math.abs(sw(g, 4)) * 0.006 * S.H, t * 900);
      const sw2 = r.S2; ctx.save(); ctx.translate(c[0], c[1]); ctx.rotate(t * 6); ctx.translate(-c[0], -c[1]); N.piece(ctx, sw2, 'swoosh', r.m, 0.5, 1); N.piece(ctx, sw2, 'swoosh2', r.m, 0.5, 1); ctx.restore();
    },
    dribble(ctx, S, g, t, walk) {
      const ph = (t * 2.4) % 1, r = drawPose(ctx, S, 'npc_rival', 'walk', walk ? { body:0.05, y:-Math.abs(Math.sin(t * 3)) * 0.02 * S.H, armF:-0.12 * Math.cos(ph * TAU), tail1:-0.2 + Math.sin(t * 5) * 0.1, tail2:-0.3 + Math.sin(t * 5 - 1) * 0.15 } : { body:0.04 + 0.03 * Math.abs(sw(ph)), armF:-0.12 * Math.cos(ph * TAU) }, { cut:true, idleK:1 }); if (!r) return;
      const top = ballRest(r.S2, r.m), R = ballR(r.S2), floor = -R, q = Math.abs(Math.cos(ph * Math.PI)); // 1 在手、0 在地
      const by = lerp(floor, top[1], q), squash = q < 0.08 ? 1 - (0.08 - q) * 2 : 1;
      ball(ctx, r.S2, top[0] + (walk ? 0 : Math.sin(t * 1.2) * 0.04 * S.H), by, t * 120, 1); if (squash < 1) N.puff(ctx, top[0], -0.01 * S.H, 0.05 * S.H, (ph * 2) % 1, 'rgba(200,190,170,.45)', 3, 3);
      if (q < 0.15) N.piece(ctx, r.S2, 'fx', r.m, 0.5, 1, 1 - q / 0.15);
    },
    jumpshot(ctx, S, g, t) {
      const f = N.kf(g, [[0, {}], [0.18, { sy:0.9, sx:1.04, armF:-0.2 }], [0.32, { y:-0.28 * S.H, sy:1.05, armF:-0.6, armB:-0.4, head:-0.1 }, 'o'], [0.48, { y:0, sy:0.94 }, 'i'], [0.6, {}]]);
      const r = drawPose(ctx, S, 'npc_rival', 'stand', f, { cut:true }); if (!r) return; const c0 = ballRest(r.S2, r.m);
      let bx = c0[0], by = c0[1], rot = t * 300;
      if (g > 0.3 && g < 0.9) { const q = seg(g, 0.3, 0.9); bx = c0[0] + Math.sin(q * Math.PI) * 0.6 * S.H; by = c0[1] - Math.sin(q * Math.PI) * 0.75 * S.H; rot = q * 900; }
      ball(ctx, r.S2, bx, by, rot);
      N.pop(ctx, { ...S, tt:g }, 0.25 * S.H, -1.15 * S.H, '三分！', 0.13 * S.H, '#ffb347', 0.5, 0.45);
    },
    gossip(ctx, S, g, t) {
      const r = drawPose(ctx, S, 'npc_rival', 'gossip', { head:sw(g, 3) * 0.04, body:0.03 + sw(g, 1.5) * 0.02, armF:sw(g, 6) * 0.03 }); if (!r) return;
      const mo = N.at(r.S2, r.m, 0.20, 0.30), lines = ['聽講……', '佢呀……', '咪講畀人知'];
      const i = Math.floor(g * 3) % 3, q = (g * 3) % 1; N.txt(ctx, S, mo[0] - S.fw * 0 - 0.12 * S.H, mo[1] - 0.1 * S.H - q * 0.06 * S.H, 0.085 * S.H, lines[i], '#f0e0ff', Math.sin(q * Math.PI));
    },
    rival_walk(ctx, S, g, t) { ACT.dribble(ctx, S, g, t, true); },
    // 三個都係鬼：冇腳，飄住行（身體微微前傾、上下浮、尾巴擺）
    rival_jump(ctx, S, g, t) { const j = bump(g, 0, 0.35); drawPose(ctx, S, 'npc_rival', 'jump', { y:-0.12 * S.H * j, x:Math.sin(t * 50) * 0.006 * S.H * (1 - j), sy:1 + 0.04 * j }); },
    // ---- HR 姐 ----
    hr_idle(ctx, S, g, t) { drawPose(ctx, S, 'npc_hr', 'stand', {}, { idleK:0.8 }); },
    clip(ctx, S, g, t) {
      const k = N.E.io(seg(g, 0.05, 0.2)) * (1 - N.E.io(seg(g, 0.85, 1)));
      const r = drawPose(ctx, S, 'npc_hr', 'stand', { head:0.18 * k, body:0.04 * k, armB:-0.12 * k + sw(g, 6) * 0.03 * k }); if (!r) return;
      const cb = N.at(r.S2, r.m, 0.55, 0.52); for (let i = 0; i < 3; i++) { const q = seg(g, 0.25 + i * 0.18, 0.45 + i * 0.18); if (q > 0 && q < 1) N.txt(ctx, S, cb[0] + (i - 1) * 0.06 * S.H, cb[1] - 0.05 * S.H - q * 0.06 * S.H, 0.07 * S.H, i === 2 ? '✗' : '✓', i === 2 ? '#ff5050' : '#9ff0a0', Math.sin(q * Math.PI)); }
    },
    glasses(ctx, S, g, t) {
      const k = bump(g, 0.1, 0.7), r = drawPose(ctx, S, 'npc_hr', 'stand', { head:-0.1 * k, armB:-0.35 * k }); if (!r) return;
      if (g > 0.35 && g < 0.6) { const p = N.at(r.S2, r.m, 0.35, 0.3); N.burst(ctx, p[0], p[1], 0.08 * S.H, 1 - seg(g, 0.35, 0.6), '#ffffff', 5, 6); }
      N.txt(ctx, S, 0.15 * S.H, -1.05 * S.H, 0.08 * S.H, '嗯哼～', '#ffd0e0', bump(g, 0.4, 0.95));
    },
    stamp(ctx, S, g, t) {
      const ph = (g * 2) % 1, hit = ph > 0.45 && ph < 0.6, k = ph < 0.4 ? -E.o(ph / 0.4) : ph < 0.5 ? -1 + 2 * E.i((ph - 0.4) / 0.1) : 1 - E.io(seg(ph, 0.5, 1));
      const r = drawPose(ctx, S, 'npc_hr', 'stamp', { armF:-0.25 * k, body:0.05 * k, head:0.04 * k, x:hit ? Math.sin(t * 90) * 0.004 * S.H : 0, sy:1 - 0.03 * Math.max(0, k) }); if (!r) return;
      const sp = N.at(r.S2, r.m, 0.40, 0.86);
      if (ph > 0.48) { seal(ctx, S, sp[0] - S.fw * 0, sp[1] - 0.01 * S.H, 0.12 * S.H, '批', seg(ph, 0.48, 0.55), 1 - seg(ph, 0.85, 1)); N.burst(ctx, sp[0], sp[1] - 0.05 * S.H, 0.12 * S.H, 1 - seg(ph, 0.48, 0.65), '#ffe14a', 7, 7); }
    },
    hr_walk(ctx, S, g, t) { drawPose(ctx, S, 'npc_hr', 'walk', { body:0.05, y:-Math.abs(Math.sin(t * 3)) * 0.02 * S.H, tail1:-0.2 + Math.sin(t * 5) * 0.1, tail2:-0.3 + Math.sin(t * 5 - 1) * 0.15 }, { idleK:1 }); },
    hr_jump(ctx, S, g, t) { const j = bump(g, 0, 0.35); drawPose(ctx, S, 'npc_hr', 'jump', { y:-0.1 * S.H * j, x:Math.sin(t * 50) * 0.006 * S.H * (1 - j) }); },
    // ---- 陰間大老闆 ----
    kpi_idle(ctx, S, g, t) { drawPose(ctx, S, 'npc_kpiboss', 'stand', { y:-Math.sin(t * 1.6) * 0.01 * S.H }, { idleK:0.8 }); },
    inspect(ctx, S, g, t) { drawPose(ctx, S, 'npc_kpiboss', 'stand', { head:sw(g) * 0.12, body:sw(g, 1, 0.5) * 0.03, x:sw(g) * 0.04 * S.H }); N.txt(ctx, S, 0.25 * S.H, -1.1 * S.H, 0.085 * S.H, '嗯……', '#e8e8f0', bump(g, 0.3, 0.8)); },
    tap(ctx, S, g, t) {
      const r = drawPose(ctx, S, 'npc_kpiboss', 'walk', { armF:Math.max(0, sw(g, 4)) * 0.08, head:0.06 }); if (!r) return;
      const tb = N.at(r.S2, r.m, 0.80, 0.42); crash(ctx, tb[0], tb[1] - 0.32 * S.H, 0.22 * S.H, seg(g, 0.1, 0.6), 11); N.txt(ctx, S, tb[0], tb[1] - 0.55 * S.H, 0.08 * S.H, '又跌？', '#ff7070', bump(g, 0.5, 0.95));
    },
    sigh(ctx, S, g, t) { const k = bump(g, 0.15, 0.9); drawPose(ctx, S, 'npc_kpiboss', 'stand', { head:0.15 * k, sy:1 - 0.04 * k, y:0.02 * S.H * k }); N.puff(ctx, 0.2 * S.H, -0.75 * S.H, 0.06 * S.H, seg(g, 0.3, 0.9), 'rgba(220,220,230,.55)', 13, 4); N.txt(ctx, S, 0.25 * S.H, -1.05 * S.H, 0.09 * S.H, '唉……', '#e0e0ea', bump(g, 0.3, 0.9)); },
    yell(ctx, S, g, t) {
      const sh = Math.sin(t * 70) * 0.006 * S.H, r = drawPose(ctx, S, 'npc_kpiboss', 'yell', { x:sh, head:sw(g, 3) * 0.04 }); if (!r) return;
      const mo = N.at(r.S2, r.m, 0.62, 0.36); rings(ctx, mo[0] + 0.1 * S.H, mo[1], 0.3 * S.H, (g * 2) % 1, 'rgba(255,240,240,.9)');
      N.txt(ctx, S, 0.15 * S.H, -1.15 * S.H, 0.11 * S.H, 'KPI 呢？！', '#ff5050', 0.95);
    },
    kpi_walk(ctx, S, g, t) { drawPose(ctx, S, 'npc_kpiboss', 'walk', { body:0.05, y:-Math.abs(Math.sin(t * 3)) * 0.02 * S.H, tail1:-0.2 + Math.sin(t * 5) * 0.1, tail2:-0.3 + Math.sin(t * 5 - 1) * 0.15 }, { idleK:1 }); },
    kpi_jump(ctx, S, g, t) { const j = bump(g, 0, 0.35); drawPose(ctx, S, 'npc_kpiboss', 'jump', { y:-0.12 * S.H * j, x:Math.sin(t * 50) * 0.006 * S.H * (1 - j) }); },
  };
  const PRE = { npc_rival:'rival', npc_hr:'hr', npc_kpiboss:'kpi' };
  const DUR = { spin:2.4, dribble:2.5, jumpshot:2.2, gossip:3.6, clip:3.2, glasses:2.6, stamp:2.0, inspect:4.0, tap:3.0, sigh:3.2, yell:2.2, jump:1.4, idle:4, walk:2 };
  const STATES = {
    npc_rival:['idle', 'walk', 'spin', 'dribble', 'jumpshot', 'gossip', 'jump', 'attack', 'hurt', 'scared', 'down', 'die'],
    npc_hr:['idle', 'walk', 'clip', 'glasses', 'stamp', 'jump', 'attack', 'hurt', 'scared', 'down', 'die'],
    npc_kpiboss:['idle', 'walk', 'inspect', 'tap', 'sigh', 'yell', 'jump', 'attack', 'hurt', 'scared', 'down', 'die'],
  };
  // 找狀態的畫法：通用名（idle/walk/jump）轉成每人自己的
  function actFn(id, st) { const p = PRE[id]; return ACT[p + '_' + st] || (STATES[id].includes(st) ? ACT[st] : null); }
  function run(ctx, a, st, at) {
    const S = setup(a); if (!S) return false; const fn = actFn(a.type, st); if (!fn) return false;
    const dur = DUR[st] || 2, g = ((at || 0) % dur) / dur;
    begin(ctx, S, null, a.solid ? 1 : 0.8); fn(ctx, S, g, at || 0, false); end(ctx); return true;
  }
  // drawMesh 的掛鉤：待機、走路、嚇親用各自的原畫
  function custom(ctx, a) {
    const o = a.o, ps = o.pose;
    if (o.hurt || ['hurt', 'die', 'down', 'air', 'cast', 'faint'].includes(ps)) return false; // 這些用站姿原圖＋共用動作
    if (['scared', 'startle', 'tremble', 'cower'].includes(ps)) return run(ctx, a, 'jump', o.t);
    if (o.walk || ps === 'move' || ps === 'walk' || ps === 'run') return run(ctx, a, 'walk', o.t);
    return run(ctx, a, 'idle', o.t);
  }
  // DAILY：o.act = 'ag_<狀態>'
  for (const st of ['spin', 'dribble', 'jumpshot', 'gossip', 'clip', 'glasses', 'stamp', 'inspect', 'tap', 'sigh', 'yell', 'jump', 'walk', 'idle'])
    DAILY['ag_' + st] = (ctx, a) => P[a.type] ? run(ctx, a, st, a.o.at || 0) : false;

  // ======================= 戰鬥招式（五段）=======================
  MOVES.npc_rival = function (ctx, a) { // 入波：蹲低抱波 → 跳起 → 對住頭一下入樽 → 波彈地 → 彈返手指
    const S = setup(a); if (!S) return false; const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.45 * th - 0.25 * H);
    const f = N.kf(t, [[0, {}], [0.16, { sy:0.88, sx:1.05, armF:0.3, armB:0.3, head:0.06 }], [0.22, { y:-0.35 * H, x:D2 * 0.6, sy:1.06, armF:-0.8, armB:-0.5, head:-0.1 }, 'o'], [N.TC, { y:-0.18 * H, x:D2, armF:-0.2, armB:-0.1, r:10, head:0.12 }, 'i'], [0.36, { y:0, x:D2, sy:0.93 }, 'i'], [0.59, {}]]);
    begin(ctx, S, f, 1 - cl(-(f.y || 0) / H) * 0.6);
    const r = drawPose(ctx, S, 'npc_rival', 'stand', f, { cut:true }); if (!r) { end(ctx); return false; }
    const c0 = ballRest(r.S2, r.m), hd = N.tgt(S, 0.95), chest = N.at(r.S2, r.m, 0.45, 0.42), R = ballR(r.S2);
    let bx, by, rot = t * 600;
    if (t < 0.16) { const q = E.io(seg(t, 0.02, 0.16)); bx = lerp(c0[0], chest[0], q); by = lerp(c0[1], chest[1], q); }
    else if (t < 0.22) { const up = N.at(r.S2, r.m, 0.30, 0.0); bx = lerp(chest[0], up[0], E.o(seg(t, 0.16, 0.22))); by = lerp(chest[1], up[1], E.o(seg(t, 0.16, 0.22))); }
    else if (t < N.TC) { const up = N.at(r.S2, r.m, 0.30, 0.0), q = E.i(seg(t, 0.22, N.TC)); bx = lerp(up[0], hd[0], q); by = lerp(up[1], hd[1] - R, q); }
    else if (t < 0.40) { const q = seg(t, N.TC, 0.40); bx = hd[0] + q * 0.1 * th; by = lerp(hd[1] - R, -R, E.i(q)); }
    else { const q = seg(t, 0.40, 0.59), rest = ballRest(r.S2, N.bm(r.S2, {})); bx = lerp(hd[0] + 0.1 * th, rest[0], E.io(q)); by = lerp(-R, rest[1], E.o(q)) - Math.sin(q * Math.PI) * 0.3 * H; }
    ball(ctx, r.S2, bx, by, rot);
    if (t > 0.2 && t < N.TC) N.speed(ctx, bx, by - R, 0.3, 1, 0.3 * H, 0.15 * H, 0.8, 'rgba(255,240,220,.7)', 21, 4);
    const p = t - N.TC; if (p >= 0 && p < 0.14) N.burst(ctx, hd[0], hd[1], 0.4 * th, 1 - p / 0.14, '#ffd27a', 23, 11);
    if (t > 0.36 && t < 0.42) N.puff(ctx, bx, -0.02 * H, 0.06 * H, seg(t, 0.36, 0.42), 'rgba(200,190,170,.5)', 25, 3);
    N.pop(ctx, S, hd[0], hd[1] - 0.35 * th, '入波！', 0.26 * th, '#ffb347', N.TC, 0.3);
    N.hit(S, hd[0], hd[1]); end(ctx);
  };
  MOVES.npc_hr = function (ctx, a) { // 蓋印：抽出印章往後舉 → 撲前（換蓋印原畫）→ 一下蓋落對手身上：大紅「警告」→ 企返好
    const S = setup(a); if (!S) return false; const t = S.tt, H = S.H, th = S.th;
    const T = N.tgt(S, 0.55), D2 = Math.max(0, S.tx - 0.42 * th - 0.18 * H);
    begin(ctx, S, null, 1);
    if (t < 0.2 || t > 0.46) {
      const k = t < 0.2 ? E.o(seg(t, 0, 0.18)) : 1 - E.io(seg(t, 0.46, 0.59));
      drawPose(ctx, S, 'npc_hr', 'stand', t < 0.2 ? { r:-8 * k, armF:0.6 * k, head:-0.1 * k, x:-0.03 * H * k } : { x:D2 * 0.3 * k, r:3 * k });
    } else {
      const f = N.kf(t, [[0.2, { x:D2 * 0.6, y:-0.04 * H, armF:0.35, sy:1.03 }], [N.TC, { x:D2, armF:-0.25, sy:0.95, body:0.05 }, 'i'], [0.36, { x:D2, armF:-0.2, sy:0.97 }], [0.46, { x:D2 * 0.6 }]]);
      if (t > N.TC && t < 0.34) f.x += Math.sin(t * 120) * 0.004 * H;
      drawPose(ctx, S, 'npc_hr', 'stamp', f);
    }
    const p = t - N.TC;
    if (p >= 0) seal(ctx, S, T[0], T[1], 0.36 * th, '警告', seg(p, 0, 0.06), 1 - seg(t, 0.5, 0.59));
    if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.38 * th, 1 - p / 0.14, '#ffd0d0', 31, 11);
    N.pop(ctx, S, T[0], T[1] - 0.6 * th, '扣你假！', 0.2 * th, '#ff6060', N.TC + 0.02, 0.3);
    N.hit(S, T[0], T[1]); end(ctx);
  };
  MOVES.npc_kpiboss = function (ctx, a) { // 拍平板：睇住平板臉色一沉 → 飄過去（換拍平板原畫）→ 平板一拍：KPI 跌勢圖撞落對手頭頂＋聲波 → 飄返
    const S = setup(a); if (!S) return false; const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.45 * th - 0.25 * H);
    const T = N.tgt(S, 0.6);
    begin(ctx, S, null, 0.9);
    if (t < 0.2) drawPose(ctx, S, 'npc_kpiboss', 'walk', { head:0.1 * E.o(seg(t, 0, 0.18)), y:-0.04 * H * E.o(seg(t, 0, 0.18)), x:Math.sin(t * 80) * 0.004 * H * seg(t, 0.08, 0.2) });
    else if (t < 0.46) { const f = N.kf(t, [[0.2, { x:D2 * 0.5, y:-0.08 * H }], [N.TC, { x:D2, y:0.02 * H, sy:0.94, r:6 }, 'i'], [0.36, { x:D2, sy:0.97, r:4 }], [0.46, { x:D2 * 0.6 }]]); if (t > N.TC && t < 0.36) f.x += Math.sin(t * 110) * 0.005 * H; drawPose(ctx, S, 'npc_kpiboss', 'yell', f); }
    else drawPose(ctx, S, 'npc_kpiboss', 'stand', { x:D2 * 0.6 * (1 - E.io(seg(t, 0.46, 0.59))) });
    const p = t - N.TC;
    if (p >= -0.06 && t < 0.5) { const k = seg(t, N.TC - 0.06, N.TC), y0 = T[1] - 0.85 * th, y = lerp(y0, T[1] - 0.25 * th, E.i(k)); ctx.save(); ctx.globalAlpha *= 1 - seg(t, 0.42, 0.5); crash(ctx, T[0] + 0.05 * th, y, 0.36 * th, 1, 41); ctx.restore(); }
    if (p >= 0) rings(ctx, T[0] - 0.2 * th, S.ty - 0.05 * th, 0.6 * th, seg(p, 0, 0.3), 'rgba(255,220,220,.9)');
    if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.4 * th, 1 - p / 0.14, '#ffb0b0', 43, 12);
    N.pop(ctx, S, T[0] - 0.15 * th, T[1] - 0.95 * th, 'KPI 呢？！', 0.2 * th, '#ff5050', N.TC, 0.32);
    N.hit(S, T[0], T[1]); end(ctx);
  };

  // ======================= 對外 =======================
  // Antag.draw：一行畫一個反派（見最上面的說明）
  function draw(ctx, id, x, y, h, state, t, opt) {
    if (!P[id]) return false; opt = opt || {}; const s = h / P[id].h;
    const o = { t:opt.time != null ? opt.time : (t || 0), flip:opt.faceRight === false, alpha:opt.alpha, shadow:opt.shadow, tamed:true };
    if (state === 'attack') {
      const q = t || 0, W = 0.22, Sx = 0.12, R = 0.25;
      if (q < W) { o.pose = 'windup'; o.pt = q / W; } else if (q < W + Sx) { o.pose = 'strike'; o.pt = (q - W) / Sx; } else if (q < W + Sx + R) { o.pose = 'recover'; o.pt = (q - W - Sx) / R; } else o.pose = 'idle';
      o.tdx = opt.tdx != null ? opt.tdx : (opt.faceRight === false ? -0.75 * h : 0.75 * h); o.tdy = opt.tdy || 0;
    } else if (['hurt', 'die', 'down', 'scared'].includes(state)) { o.pose = state; o.pt = state === 'hurt' ? cl((t || 0) / 0.25) : state === 'die' ? cl((t || 0) / 0.8) : cl((t || 0) / 1.8); }
    else if (state === 'walk') { o.pose = 'move'; o.walk = true; o.t = t || 0; }
    else if (state === 'idle' || !state) { o.pose = 'idle'; o.t = opt.time != null ? opt.time : (t || 0); }
    else { o.act = 'ag_' + state; o.at = t || 0; }
    ART.drawChar(ctx, id, x, y, s, o); return true;
  }
  return { draw, STATES, ZH:{ npc_rival:'籃球仔', npc_hr:'HR 姐', npc_kpiboss:'陰間大老闆' }, dur:(id, st) => DUR[st] || (st === 'attack' ? 0.59 : 2), P };
})();
