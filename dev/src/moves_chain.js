// 專屬招式
// ===================== 專屬招式工具（moves_chain.js / moves_beast.js 共用）=====================
// 座標系「F」：原點 = 角色腳底（地面），+x = 角色面向的那一邊（往敵人），y 往下。單位 = 世界單位（跟 a.x/a.y 一樣）。
// 身體、拆出來的手都是原圖（MeshAnim.drawBody / 原圖整張畫布的切塊），只做移動、旋轉、縮放、網格變形；特效才是程序畫的蠟筆線。
const MoveKit = (() => {
  // 戰鬥節奏（battle.js）：蓄力 0.22 → 出手 0.12（第 0.42 命中）→ 收招 0.25
  const TW = 0.22, TS = 0.12, TR = 0.25, TC = TW + 0.42 * TS, TE = TW + TS + TR;
  const cl = (v, a = 0, b = 1) => v < a ? a : v > b ? b : v;
  const E = {
    o:(t) => 1 - (1 - t) * (1 - t), i:(t) => t * t, io:(t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t),
    o3:(t) => 1 - Math.pow(1 - t, 3), i3:(t) => t * t * t, sin:(t) => 0.5 - 0.5 * Math.cos(Math.PI * t),
    back:(t) => { const c = 1.6; return 1 + (c + 1) * Math.pow(t - 1, 3) + c * Math.pow(t - 1, 2); },
  };
  const seg = (t, a, b) => cl((t - a) / (b - a));
  const lerp = (a, b, k) => a + (b - a) * k;
  const rnd = (i) => { const v = Math.sin(i * 127.1 + 311.7) * 43758.5453; return v - Math.floor(v); };
  // 姿勢 + 進度 → 招式時間（秒，0 ~ TE）
  function tau(o) {
    const p = cl(o.pt || 0);
    switch (o.pose) {
      case 'windup': return p * TW;
      case 'strike': return TW + p * TS;
      case 'follow': return TW + (0.42 + 0.58 * p) * TS;
      case 'recover': return TW + TS + p * TR;
    }
    return 0;
  }
  // battle.js poseOf 在出手時把整個人往前推 ox（畫的 x 已經含它）；招式要對準敵人，就把它扣回來
  function lungeOf(o, s) {
    if (o.tdx == null) return 0;
    const p = cl(o.pt || 0), eo = (q) => 1 - Math.pow(1 - cl(q), 3), io = (q) => { q = cl(q); return q < 0.5 ? 4 * q * q * q : 1 - Math.pow(-2 * q + 2, 3) / 2; };
    const L = s > 1.5 ? 12 : s < 1 ? 6 : 9;
    if (o.pose === 'windup') return -2 * eo(p);
    if (o.pose === 'strike') return L * eo(p * 2.4);
    if (o.pose === 'follow') return L;
    if (o.pose === 'recover') return L * (1 - io(p));
    return 0;
  }
  // 對手被打中之後往後退多少（battle.js：擊退約 9、0.3 秒；受擊姿勢身體再往後縮一點）。纏住、咬住的東西要跟著它
  function tgtBack(tt, th) {
    const p = (tt - TC) / 0.3; if (p <= 0) return 0;
    let kb = 0;
    if (p < 1) { const eo = (q) => 1 - Math.pow(1 - q, 3), io = (q) => q < 0.5 ? 4 * q * q * q : 1 - Math.pow(-2 * q + 2, 3) / 2; kb = p < 0.25 ? eo(p / 0.25) : 1 - io((p - 0.25) / 0.75); }
    const p2 = (tt - TC) / 0.25, k = p2 >= 1 ? 0 : p2 < 0.15 ? p2 / 0.15 : Math.max(0, 1 - (p2 - 0.15) / 0.85);
    return kb * 9 + 0.07 * th * k;
  }
  // 2D 仿射矩陣（同時拿來設定畫布、算點的位置）
  class M {
    constructor(a = 1, b = 0, c = 0, d = 1, e = 0, f = 0) { this.a = a; this.b = b; this.c = c; this.d = d; this.e = e; this.f = f; }
    clone() { return new M(this.a, this.b, this.c, this.d, this.e, this.f); }
    mul(n) { const { a, b, c, d, e, f } = this; this.a = a * n.a + c * n.b; this.b = b * n.a + d * n.b; this.c = a * n.c + c * n.d; this.d = b * n.c + d * n.d; this.e = a * n.e + c * n.f + e; this.f = b * n.e + d * n.f + f; return this; }
    t(x, y) { return this.mul(new M(1, 0, 0, 1, x, y)); }
    r(an) { const c = Math.cos(an), s = Math.sin(an); return this.mul(new M(c, s, -s, c, 0, 0)); }
    s(x, y) { return this.mul(new M(x, 0, 0, y == null ? x : y, 0, 0)); }
    pt(x, y) { return [this.a * x + this.c * y + this.e, this.b * x + this.d * y + this.f]; }
    set(ctx) { ctx.transform(this.a, this.b, this.c, this.d, this.e, this.f); }
  }
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  // 準備：角色資料、招式時間、敵人位置（F 座標）
  function setup(a) {
    const id = a.type, o = a.o, img = SPR[id + '__body'];
    if (!ok(id + '__body') || !ok(id + '__arm') || typeof MeshAnim === 'undefined' || typeof LIMBS_DATA === 'undefined' || !LIMBS_DATA.chars[id]) return null;
    const fw = a.faceRight ? 1 : -1, s = a.s, H = a.H, W = H * img.naturalWidth / img.naturalHeight;
    const nr = !!((MeshAnim.NATIVE_R || {})[id] || LIMBS_DATA.chars[id].nativeR);
    const tt = tau(o), lg = lungeOf(o, s), th = 58 * s;
    const tx = (o.tdx != null ? o.tdx * fw : 44 * s) - lg, ty = o.tdy || 0;
    const fl = a.solid ? 0 : (3 + Math.sin((o.t || 0) * 2.4) * 2) * s;
    return { a, id, o, fw, s, H, W, nr, tt, tx, ty, th, fl, t:o.t || 0, C:LIMBS_DATA.chars[id], solid:a.solid };
  }
  // 進入 F 座標（呼叫者負責 save/restore）
  function enter(ctx, K) { ctx.translate(K.a.x, K.a.y); ctx.scale(K.fw, 1); }
  // 原圖比例 (u,v) → 身體座標（原點腳底中央）
  const ip = (K, u, v) => [(K.nr ? 1 : -1) * (u - 0.5) * K.W, (v - 1) * K.H];
  // 身體的網格姿勢：跟 Limbs.draw 一樣的待機底子（手臂骨、身體骨歸零），再疊上 extra（F 座標語意：正 = 往前轉）
  const KEEP = { y:1, sx:1, sy:1 };
  function pose(K, extra, idleK) {
    const z = MeshAnim.ANIM.idle(K.t);
    if (idleK != null) for (const k in z) if (typeof z[k] === 'number') z[k] = (k === 'sx' || k === 'sy') ? 1 + (z[k] - 1) * idleK : z[k] * idleK; // idleK < 1：待機的晃動收小（殭屍硬邦邦）
    z.armF = 0; z.axe = 0; z.body = 0; z.x = 0;
    if (K.C.still) for (const b of K.C.still) z[b] = 0;
    if (extra) for (const k in extra) { const v = extra[k]; z[k] = KEEP[k] ? (k === 'y' ? (z[k] || 0) + v : v) : (z[k] || 0) + (K.nr ? v : -v); }
    return z;
  }
  function body(ctx, K, m, mp, key) {
    ctx.save(); m.set(ctx); if (!K.nr) ctx.scale(-1, 1);
    MeshAnim.drawBody(ctx, K.id, key || K.id + '__body', K.H, mp); ctx.restore();
  }
  // 原圖整張畫布的切塊（__arm、__bun…）：m 已經移到支點、轉好角度；(pu,pv) = 支點在原圖的位置
  function piece(ctx, K, key, m, pu, pv, alpha) {
    if (!ok(key)) return; ctx.save(); m.set(ctx); if (!K.nr) ctx.scale(-1, 1);
    if (alpha != null) ctx.globalAlpha *= alpha;
    ctx.drawImage(SPR[key], -pu * K.W, -pv * K.H, K.W, K.H); ctx.restore();
  }
  // 切塊上原圖 (u,v) 那一點，經過 m 之後在 F 座標的位置
  const ppt = (K, m, pu, pv, u, v) => m.pt((K.nr ? 1 : -1) * (u - pu) * K.W, (v - pv) * K.H);
  function shadow(ctx, K, x, y, k) {
    if (K.o.shadow === false) return; ctx.save(); if (!K.solid) ctx.globalAlpha *= 0.55;
    ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.beginPath(); ctx.ellipse(x, y + K.s, 14 * K.s * (k || (K.solid ? 1 : 0.8)), 4 * K.s * (k || (K.solid ? 1 : 0.8)), 0, 0, 7); ctx.fill(); ctx.restore();
  }
  // 敵人身體的大概輪廓（F 座標）：給「繞到後面」用的遮罩
  const tgtBody = (K, back) => ({ x:K.tx + (back || 0), y:K.ty - 0.5 * K.th, rx:0.25 * K.th, ry:0.5 * K.th });
  function clipOut(ctx, e) { ctx.beginPath(); ctx.rect(-5000, -5000, 10000, 10000); ctx.ellipse(e.x, e.y, e.rx, e.ry, 0, 0, 7); ctx.clip('evenodd'); }
  // ---------- 蠟筆風特效 ----------
  // 抖一點的線，畫兩次（像蠟筆來回塗）
  function crayon(ctx, pts, col, w, seed, alpha) {
    if (pts.length < 2) return; ctx.save(); ctx.lineCap = 'round'; ctx.lineJoin = 'round'; ctx.strokeStyle = col;
    for (let pass = 0; pass < 2; pass++) {
      ctx.globalAlpha *= pass ? 0.55 : 1; ctx.lineWidth = w * (pass ? 0.55 : 1); ctx.beginPath();
      pts.forEach((p, i) => { const j = (rnd(seed + i * 7 + pass * 31) - 0.5) * w * 0.5; i ? ctx.lineTo(p[0] + j, p[1] - j) : ctx.moveTo(p[0] + j, p[1] + j); });
      ctx.stroke();
    }
    ctx.restore();
  }
  // 命中星（放射短線 + 小點）
  function burst(ctx, x, y, r, k, col, seed, n) {
    if (k <= 0) return; n = n || 9; ctx.save(); ctx.globalAlpha *= cl(k);
    for (let i = 0; i < n; i++) {
      const an = i / n * 6.283 + rnd(seed + i) * 0.5, r0 = r * (0.25 + 0.35 * (1 - k)), r1 = r * (0.7 + 0.5 * rnd(seed + i + 9)) * (1.2 - 0.4 * k);
      crayon(ctx, [[x + Math.cos(an) * r0, y + Math.sin(an) * r0], [x + Math.cos(an) * r1, y + Math.sin(an) * r1]], col, Math.max(1, r * 0.09), seed + i);
    }
    ctx.restore();
  }
  // 速度線（一束平行短線，沿 dir）
  function speed(ctx, x, y, dx, dy, len, spread, k, col, seed, n) {
    if (k <= 0) return; const l = Math.hypot(dx, dy) || 1, ux = dx / l, uy = dy / l; n = n || 4; ctx.save(); ctx.globalAlpha *= cl(k);
    for (let i = 0; i < n; i++) {
      const o = (i - (n - 1) / 2) * spread / n + (rnd(seed + i) - 0.5) * spread * 0.2, L = len * (0.6 + 0.4 * rnd(seed + i + 4)), b = len * 0.3 * rnd(seed + i + 8);
      const px = x - uy * o - ux * b, py = y + ux * o - uy * b;
      crayon(ctx, [[px, py], [px - ux * L, py - uy * L]], col, Math.max(1, len * 0.06), seed + i);
    }
    ctx.restore();
  }
  return { TW, TS, TR, TC, TE, cl, E, seg, lerp, rnd, tau, lungeOf, tgtBack, M, ok, setup, enter, ip, pose, body, piece, ppt, shadow, tgtBody, clipOut, crayon, burst, speed };
})();

// ===================== 黑無常：鎖魂鏈 =====================
// ① 手往後上一甩，鏈子在背後繞一圈（蓄力）→ ② 從頭頂甩出去，一直伸到敵人身上 → ③ 鏈尾在敵人身上纏兩圈半（鎖住）
// → ④ 身子往後一仰，用力扯（鏈子拉直、抖）→ ⑤ 鬆開、鏈子甩回手上，垂回原本的樣子
// 鏈子：原圖那段鏈子（heiwu__wpn）一節一節照原樣接長，沿著路徑一小片一小片貼上去（不重畫）
MOVES.heiwu = function (ctx, a) {
  const K = MoveKit; const S = K.setup(a); if (!S || !K.ok('heiwu__wpn')) return false;
  const { E, seg, lerp, M } = K, tt = S.tt, H = S.H, th = S.th;
  const wp = LIMBS_DATA.weapons.iron_chain; if (!wp) return false;
  const PV = S.C.pivot, GR = S.C.grip, TP = S.C.tip; // 拳頭支點、鏈子握點、鏈尾（原圖比例）
  // ---- 身體：蓄力往後仰、甩出往前、扯的時候大力往後仰 ----
  const kW = E.o(seg(tt, 0, 0.15)), kL = E.o3(seg(tt, 0.15, 0.22)), kY = E.back(seg(tt, 0.345, 0.40)), kR = E.io(seg(tt, 0.46, 0.59));
  let lean = -9 * kW, bdx = -0.03 * kW;
  lean = lerp(lean, 8, kL); bdx = lerp(bdx, 0.035, kL);
  lean = lerp(lean, -13, kY); bdx = lerp(bdx, -0.05, kY);
  lean *= 1 - kR; bdx *= 1 - kR;
  const shake = tt > 0.36 && tt < 0.46 ? Math.sin(tt * 260) * 0.004 * H : 0;
  const bp = K.ip(S, 0.5, 0.78);
  const bm = new M().t(bdx * H + shake, -S.fl).t(bp[0], bp[1]).r(lean * Math.PI / 180).t(-bp[0], -bp[1]);
  // ---- 拳頭：蓄力舉到肩後、甩出往前送、扯的時候拉回腰邊 ----
  let fx = lerp(0, -0.05, kW), fy = lerp(0, -0.11, kW), fr = lerp(0, -25, kW);
  fx = lerp(fx, 0.05, kL); fy = lerp(fy, -0.05, kL); fr = lerp(fr, 15, kL);
  fx = lerp(fx, -0.06, kY); fy = lerp(fy, 0.03, kY); fr = lerp(fr, -10, kY);
  fx *= 1 - kR; fy *= 1 - kR; fr *= 1 - kR;
  const pv = K.ip(S, PV[0], PV[1]);
  const fm = bm.clone().t(pv[0] + fx * H, pv[1] + fy * H).r(fr * Math.PI / 180);
  const G = K.ppt(S, fm, PV[0], PV[1], GR[0], GR[1]); // 鏈子從這裡出來
  // ---- 鏈子路徑 ----
  const img = SPR.heiwu__wpn, ih = img.naturalHeight, upx = wp.h * H / ih; // 每個原圖像素 = 幾個世界單位
  const R0 = 0.098 * ih, RH = 0.4126 * ih, RT = 0.6084 * ih, RE = 0.979 * ih, PER = RT - RH; // 鏈頭｜重複的一節｜鏈尾
  const Lr = (RE - R0) * upx;                                   // 原本垂著的長度
  const restTip = K.ip(S, TP[0], TP[1]), restG = K.ip(S, GR[0], GR[1]);
  const a0 = Math.atan2(restTip[1] - restG[1], restTip[0] - restG[0]);
  const back = K.tgtBack(tt, th);
  const tight = 1 - 0.16 * E.sin(seg(tt, 0.345, 0.40)) * (1 - seg(tt, 0.44, 0.48));
  const cx = S.tx + back, yc0 = S.ty - 0.60 * th, rx = 0.205 * th * tight, ry = 0.06 * th * tight, pitch = 0.075 * th;
  const Tn = [cx + rx, yc0]; // 鏈尾甩過敵人，打到敵人另一側，再從正面繞過來纏
  const aT = Math.atan2(Tn[1] - G[1], Tn[0] - G[0]) + 2 * Math.PI, dT = Math.hypot(Tn[0] - G[0], Tn[1] - G[1]);
  const pts = []; let umax = 0; const behind = false; // 鏈子一直在身前甩（在背後會被大帽子、袍子整個擋住，看不到）
  const polar = (an, R, lag, wave) => { // 從握點出發、帶一點落後彎曲的鏈子
    const N = 26;
    for (let i = 0; i <= N; i++) {
      const f = i / N, A = an - lag * Math.pow(f, 1.4), w = wave * Math.sin(f * 9 - tt * 70) * f * (1 - f) * 4;
      pts.push([G[0] + Math.cos(A) * R * f - Math.sin(A) * w, G[1] + Math.sin(A) * R * f + Math.cos(A) * w, 0]);
    }
  };
  if (tt < 0.15) { // ① 背後繞：從垂下（a0）往後、往上轉（畫面順時針）
    const q = E.io(seg(tt, 0, 0.15)), an = lerp(a0, a0 + 2.65, q);
    polar(an, Lr, 0.9 * Math.sin(q * Math.PI), 0.02 * H);
  } else if (tt < 0.27) { // ② 從頭頂甩出去，一路伸到敵人身上
    // 鏈尾走一條高高的弧線：從背後上方 → 往前上方甩過敵人頭頂 → 落到敵人另一側（距離很近、敵人跟他重疊時也一樣成立）
    const q = E.o(seg(tt, 0.15, 0.27)), qa = E.sin(seg(tt, 0.15, 0.27)) * 0.5 + q * 0.5;
    const s0 = [G[0] + Math.cos(a0 + 2.65) * Lr, G[1] + Math.sin(a0 + 2.65) * Lr];
    const c1 = [Math.max(G[0], Tn[0]) + 0.22 * H, Math.min(G[1], Tn[1]) - 0.75 * H];
    const bz = (a, b, c, k) => (1 - k) * (1 - k) * a + 2 * (1 - k) * k * b + k * k * c;
    const tip = [bz(s0[0], c1[0], Tn[0], qa), bz(s0[1], c1[1], Tn[1], qa)];
    const mid = [(G[0] + tip[0]) / 2, (G[1] + tip[1]) / 2], ctl = [lerp(mid[0], c1[0], 0.55 * (1 - q)), lerp(mid[1], c1[1], 0.55 * (1 - q))];
    const N = 30;
    for (let i = 0; i <= N; i++) { const f = i / N, w = 0.03 * H * (1 - q) * Math.sin(f * 10 - tt * 80) * Math.sin(f * Math.PI); pts.push([bz(G[0], ctl[0], tip[0], f), bz(G[1], ctl[1], tip[1], f) + w, 0]); }
  } else if (tt < 0.53) { // ③ 纏 ④ 扯 ⑤a 鬆開（圈圈倒著退）
    const sag = 0.05 * H * (1 - E.o(seg(tt, 0.33, 0.37))) + (tt > 0.46 ? 0.06 * H * seg(tt, 0.46, 0.53) : 0);
    const vib = tt > 0.355 && tt < 0.47 ? 0.006 * H * Math.sin(tt * 300) : 0;
    const N = 22;
    for (let i = 0; i <= N; i++) { const f = i / N; pts.push([lerp(G[0], Tn[0], f), lerp(G[1], Tn[1], f) + sag * 4 * f * (1 - f) + vib * Math.sin(f * Math.PI * 3), 0]); }
    umax = 2.5 * 2 * Math.PI * (tt < 0.46 ? E.o(seg(tt, 0.27, 0.345)) : 1 - E.i(seg(tt, 0.46, 0.53)));
    const n = Math.ceil(umax / (Math.PI / 12));
    for (let i = 1; i <= n; i++) {
      const u = Math.min(umax, i * Math.PI / 12), ph = u, j = tt > 0.36 && tt < 0.45 ? Math.sin(tt * 220 + i) * 0.006 * th : 0;
      pts.push([cx + Math.cos(ph) * rx + j, yc0 + u / (2 * Math.PI) * pitch + Math.sin(ph) * ry, Math.sin(ph) < -0.05 ? 1 : 0]);
    }
  } else { // ⑤b 鏈子甩回手上，垂回原位
    const q = E.o3(seg(tt, 0.53, 0.59)), an = lerp(aT - 2 * Math.PI, a0, q), R = lerp(dT, Lr, q);
    polar(an, R, -0.8 * Math.sin(q * Math.PI), 0.04 * H * (1 - q));
  }
  // ---- 畫 ----
  ctx.save(); K.enter(ctx, S);
  K.shadow(ctx, S, bdx * H, 0);
  const drawChain = () => chain(ctx, S, pts, img, upx, [R0, RH, RT, RE, PER], K.tgtBody(S, back));
  if (behind) drawChain();
  K.body(ctx, S, bm, K.pose(S, { head:lean * -0.004 }));
  if (!behind) drawChain();
  K.piece(ctx, S, 'heiwu__arm', fm, PV[0], PV[1]);
  // 特效：甩出去的風線、纏上去那一下的火花、扯的時候的拉力線
  if (tt > 0.17 && tt < 0.27) { const p = pts[pts.length - 1], q = pts[pts.length - 4]; K.speed(ctx, p[0], p[1], p[0] - q[0], p[1] - q[1], 0.16 * H, 0.06 * H, 1, 'rgba(235,235,245,.8)', 3); }
  const hk = 1 - seg(tt, K.TC, K.TC + 0.12);
  if (tt >= K.TC && hk > 0) K.burst(ctx, Tn[0], Tn[1], 0.16 * th, hk, '#fff2c0', 11);
  if (tt > 0.345 && tt < 0.47) {
    const k = Math.sin(seg(tt, 0.345, 0.47) * Math.PI);
    for (let i = 0; i < 3; i++) { const yy = yc0 + (i - 1) * 0.12 * th; K.speed(ctx, cx - rx * 1.2, yy, -1, 0.05 * (i - 1), 0.12 * H, 0.03 * H, k * 0.9, 'rgba(255,240,200,.85)', 20 + i, 2); }
    K.burst(ctx, cx, yc0 + pitch, 0.30 * th, k * 0.6, 'rgba(210,230,255,.9)', 41, 7);
  }
  if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * Tn[0], y:S.a.y + Tn[1] };
  ctx.restore();
  // 沿路徑貼原圖鏈節：每一小片從原圖切一橫條，轉到路徑方向貼上；在敵人背後的那幾段被敵人身體擋住
  function chain(ctx, S, P, img, upx, R, tb) {
    const [R0, RH, RT, RE, PER] = R, iw = img.naturalWidth, cxp = 0.43 * iw;
    const cum = [0]; for (let i = 1; i < P.length; i++) cum.push(cum[i - 1] + Math.hypot(P[i][0] - P[i - 1][0], P[i][1] - P[i - 1][1]));
    const Lu = cum[cum.length - 1]; if (Lu < 1) return;
    const Lpx = Lu / upx, head = RH - R0, tail = RE - RT, n = Math.max(0, Math.round((Lpx - head - tail) / PER)), texL = head + tail + n * PER, k = texL / Lpx;
    const step = PER / 6; let j = 0;
    const at = (s) => { while (j < cum.length - 2 && cum[j + 1] < s) j++; while (j > 0 && cum[j] > s) j--; const l = cum[j + 1] - cum[j] || 1, f = Math.max(0, Math.min(1, (s - cum[j]) / l)); return [P[j][0] + (P[j + 1][0] - P[j][0]) * f, P[j][1] + (P[j + 1][1] - P[j][1]) * f, f < 0.5 ? P[j][2] : P[j + 1][2]]; };
    let clipped = false;
    ctx.save();
    for (let tx = 0; tx < texL - 0.01; tx += step) {
      const st = Math.min(step, texL - tx), row = tx < head ? R0 + tx : tx < head + n * PER ? RH + ((tx - head) % PER) : RT + (tx - head - n * PER);
      const s0 = tx / k * upx, s1 = (tx + st) / k * upx, p0 = at(s0), p1 = at(s1);
      const bk = !!(p0[2] || p1[2]);
      if (bk !== clipped) { ctx.restore(); ctx.save(); if (bk) MoveKit.clipOut(ctx, tb); clipped = bk; }
      const an = Math.atan2(p1[1] - p0[1], p1[0] - p0[0]), len = Math.hypot(p1[0] - p0[0], p1[1] - p0[1]);
      ctx.save(); ctx.translate(p0[0], p0[1]); ctx.rotate(an - Math.PI / 2);
      ctx.drawImage(img, 0, row, iw, Math.min(st + 0.8, ih - row), -cxp * upx, 0, iw * upx, len + 0.8 * upx);
      ctx.restore();
    }
    ctx.restore();
  }
};
