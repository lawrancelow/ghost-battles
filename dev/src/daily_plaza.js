// 平日動作：廣場閒逛與互動（daily_plaza.js）
// 閒著的鬼怪不再繞圈：每隻有自己的目的地、停下、做自己的小動作；兩隻碰到會停下來聊兩句。
// 身體一律用原圖：網格變形（MeshAnim）或原圖拆出的手（餓鬼王的包子手、黃總的球桿）；天花姐倒掛用她自己的倒掛原圖。
// 泡泡、Zzz、星星、蒸氣、碎屑、水滴是程式畫的蠟筆線。
// DAILY['plaza_*'] 只畫身體＋貼身特效；頭上的泡泡等由 PlazaLife.drawAgent 疊上去。遊戲：Village.draw → PlazaLife.frame(...)
const PlazaLife = (() => {
  const PI = Math.PI, TAU = PI * 2, D = PI / 180;
  const cl = (v, a = 0, b = 1) => v < a ? a : v > b ? b : v, lerp = (a, b, k) => a + (b - a) * k;
  const eo = (t) => 1 - (1 - t) * (1 - t), ei = (t) => t * t, eio = (t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t), eo3 = (t) => 1 - Math.pow(1 - t, 3);
  const seg = (g, a, b) => cl((g - a) / (b - a));
  const env = (g, a, b, c, d) => eio(seg(g, a, b)) * (1 - eio(seg(g, c, d))); // 進場 a→b、退場 c→d
  const hash = (i) => { const v = Math.sin(i * 127.1 + 311.7) * 43758.5453; return v - Math.floor(v); };
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const R = Math.random;
  const HOPPER = { laojiang:1, zombie:1 };
  const PAPER = { xiaozhi:1, zhiren:1 };
  const SOLID = { laojiang:1, zombie:1, pocong:1, xiaozhi:1, zhiren:1, penanggal:1 };
  const CH = { xiaozhi:54, egui:54, eguiking:66, xiaogui:46, toyol:46, laojiang:58, zombie:54, shuigui:56, pontianak:60, pocong:54, penanggal:52, mengpo:56, youhun:46, baiwu:76, heiwu:76, niutou:64, mamian:64, huang:62, zhiren:54, tianhua:60 };
  const FACEV = { heiwu:0.5, baiwu:0.45, niutou:0.3, mamian:0.3, eguiking:0.28, huang:0.3, laojiang:0.35, zombie:0.35, toyol:0.3 }; // 臉在原圖的高度（給 Zzz 定位）
  const SC = 0.58; // 廣場上的角色大小（跟原本一樣）

  // ======================= 身體姿勢（MeshAnim 的 ANIM 座標：正 = 往前）=======================
  function basePose(o, type) {
    const A = MeshAnim.ANIM, t = o.t || 0, w = cl(o.w || 0), I = A.idle(t);
    if (HOPPER[type] || w <= 0.001) return I;
    const run = o.run || 0, Wk = A.walk(o.wph || 0);
    if (run) { Wk.legF *= 1 + 0.5 * run; Wk.legB *= 1 + 0.5 * run; Wk.armF *= 1 + 0.7 * run; Wk.armB *= 1 + 0.7 * run; Wk.body += 0.07 * run; }
    if (o.stiff) { Wk.armF *= 0.35; Wk.armB *= 0.35; Wk.body = 0.03; Wk.head = 0; }
    const P = {}; for (const k in I) P[k] = I[k];
    for (const k in Wk) P[k] = lerp(I[k] != null ? I[k] : 0, Wk[k], w);
    return P;
  }
  function add(p, d) { for (const k in d) { if (k === 'sx' || k === 'sy') p[k] = (p[k] == null ? 1 : p[k]) * d[k]; else p[k] = (p[k] || 0) + d[k]; } return p; }
  const floatY = (a) => a.solid ? 0 : (3 + Math.sin((a.o.t || 0) * 2.4) * 2) * a.s * (a.o.sit ? 0.25 : 1);
  function shadowAt(ctx, a, lift, k) {
    const sk = (a.solid ? 1 : 0.8) * (k == null ? 1 : k) * (1 - 0.5 * cl(lift / (a.H * 0.9)));
    ctx.save(); if (!a.solid) ctx.globalAlpha *= 0.55; ctx.globalAlpha *= 1 - 0.4 * cl(lift / (a.H * 0.9)); a.shadow(a.x, sk); ctx.restore();
  }
  function drawM(ctx, a, P, lift, shK) {
    lift = lift || 0; shadowAt(ctx, a, lift, shK);
    MeshAnim.draw(ctx, a.type, a.x, a.y - floatY(a) - lift, a.H, P, a.faceRight);
  }
  // 原圖上某一點（0~1）在世界的位置（不算變形，給特效定位用）
  function npt(a, u, v, lift) {
    const img = SPR[a.type], W = a.H * img.naturalWidth / img.naturalHeight, nr = !!MeshAnim.NATIVE_R[a.type], flip = a.faceRight !== nr;
    return [a.x + (flip ? -1 : 1) * (u - 0.5) * W, a.y - floatY(a) - (lift || 0) - a.H + v * a.H];
  }

  // ======================= 蠟筆特效 =======================
  function crayon(ctx, pts, w, col) {
    ctx.save(); ctx.lineCap = 'round'; ctx.lineJoin = 'round'; ctx.strokeStyle = col; const g0 = ctx.globalAlpha;
    for (let p = 0; p < 2; p++) {
      ctx.globalAlpha = g0 * (p ? 0.5 : 1); ctx.lineWidth = w * (p ? 0.55 : 1); ctx.beginPath();
      pts.forEach(([x, y], i) => { const j = p ? w * 0.35 : 0, jx = (hash(i * 3.1 + p) - 0.5) * j, jy = (hash(i * 5.7 + p) - 0.5) * j; i ? ctx.lineTo(x + jx, y + jy) : ctx.moveTo(x + jx, y + jy); });
      ctx.stroke();
    }
    ctx.restore();
  }
  function steam(ctx, x, y, t, s, n, k, push) {
    for (let i = 0; i < n; i++) {
      const ph = (t * 0.5 + i / n + hash(i) * 0.2) % 1, al = Math.sin(ph * PI) * 0.6 * k; if (al <= 0.02) continue;
      const pts = [], x0 = x + (i - (n - 1) / 2) * 3 * s;
      for (let j = 0; j <= 6; j++) { const q = j / 6, h = (ph * 20 + q * 9) * s; pts.push([x0 + Math.sin(q * 5 + t * 2.3 + i * 2) * 2 * s * (0.4 + q) + (push || 0) * h * 0.9, y - h]); }
      ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 1.4 * s, '#f3eee4'); ctx.restore();
    }
  }
  function txt(ctx, x, y, str, size, col, k, wob) {
    if (k <= 0) return;
    ctx.save(); const sc = 0.55 + 0.45 * eo(cl(k * 2.2)); ctx.globalAlpha *= cl(k * 3);
    ctx.translate(x, y); ctx.rotate((wob || 0) * 0.12); ctx.scale(sc, sc);
    ctx.font = `900 ${size}px "PingFang TC","Noto Sans TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.lineJoin = 'round'; ctx.lineWidth = size * 0.28; ctx.strokeStyle = 'rgba(28,18,30,.92)'; ctx.strokeText(str, 0, 0); ctx.fillStyle = col; ctx.fillText(str, 0, 0);
    ctx.restore();
  }
  function zzz(ctx, x, y, t, s, k) {
    for (let i = 0; i < 3; i++) {
      const ph = (t * 0.42 + i / 3) % 1, al = Math.sin(ph * PI) * k; if (al <= 0.02) continue;
      ctx.save(); ctx.globalAlpha *= al; txt(ctx, x + ph * 11 * s + Math.sin(ph * 6 + i) * 2 * s, y - ph * 24 * s, 'z', (8 + ph * 7) * s * 1.4, '#d6e6ff', 1, Math.sin(ph * 4)); ctx.restore();
    }
  }
  function star(ctx, x, y, r, rot) {
    ctx.save(); ctx.translate(x, y); ctx.rotate(rot); ctx.beginPath();
    for (let i = 0; i < 10; i++) { const rr = i % 2 ? r * 0.45 : r, an = i * PI / 5 - PI / 2; ctx.lineTo(Math.cos(an) * rr, Math.sin(an) * rr); }
    ctx.closePath(); ctx.fillStyle = '#ffe27a'; ctx.fill(); ctx.lineWidth = r * 0.3; ctx.strokeStyle = '#6a4a20'; ctx.stroke(); ctx.restore();
  }
  function stars(ctx, x, y, t, s, k) {
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= k;
    for (let i = 0; i < 3; i++) { const an = t * 5.5 + i * TAU / 3; star(ctx, x + Math.cos(an) * 11 * s, y + Math.sin(an) * 3.5 * s, (2.2 + Math.sin(an) * 0.6) * s * 1.3, t * 3 + i); }
    ctx.restore();
  }
  function bubble(ctx, x, y, ch, s, k) { // 小對話泡泡（顏色跟碎碎念泡泡一樣）
    if (k <= 0) return;
    ctx.save(); ctx.globalAlpha *= cl(k * 4); const sc = (0.6 + 0.4 * eo(cl(k * 3))) * s * 1.7;
    ctx.translate(x, y); ctx.scale(sc, sc);
    ctx.beginPath(); ctx.ellipse(0, 0, 8.5, 6.5, 0, 0, TAU); ctx.fillStyle = '#ecd9a4'; ctx.fill(); ctx.lineWidth = 1.1; ctx.strokeStyle = '#5a4030'; ctx.stroke();
    ctx.beginPath(); ctx.moveTo(-2.5, 5.6); ctx.lineTo(-4.5, 10); ctx.lineTo(1, 6.2); ctx.fillStyle = '#ecd9a4'; ctx.fill(); ctx.stroke();
    ctx.beginPath(); ctx.ellipse(0, 0, 7.6, 5.6, 0, 0, TAU); ctx.fillStyle = '#ecd9a4'; ctx.fill();
    ctx.fillStyle = ch === '!' ? '#c2362b' : ch === '♪' ? '#3a6aa8' : '#2b1d12';
    if (ch === '…') { for (let i = -1; i <= 1; i++) { ctx.beginPath(); ctx.arc(i * 3, 0.5, 1.05, 0, TAU); ctx.fill(); } }
    else { ctx.font = '900 9px "PingFang TC","Noto Sans TC",sans-serif'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(ch, 0, 0.6); }
    ctx.restore();
  }
  function crumbs(ctx, x, y, tb, s, seed, fwd) {
    if (tb < 0 || tb > 0.65) return;
    for (let i = 0; i < 6; i++) {
      const vx = fwd * (6 + hash(seed + i) * 26) * s * 1.6 * (hash(seed + i * 2) > 0.3 ? 1 : -0.6), vy = (-26 - hash(seed + i * 3) * 24) * s * 1.6;
      const px = x + vx * tb, py = y + vy * tb + 170 * s * tb * tb, al = 1 - tb / 0.65;
      ctx.save(); ctx.globalAlpha *= al; ctx.translate(px, py); ctx.rotate(tb * 9 + i);
      ctx.fillStyle = '#f4e7c6'; ctx.strokeStyle = '#8a6a44'; ctx.lineWidth = 0.35; const r = (0.7 + hash(i + seed) * 0.6) * s * 1.6;
      ctx.beginPath(); ctx.ellipse(0, 0, r, r * 0.75, 0, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore();
    }
  }
  function drop(ctx, x, y, r, al) {
    ctx.save(); ctx.globalAlpha *= al; ctx.fillStyle = '#9fd0e6'; ctx.strokeStyle = '#2c5566'; ctx.lineWidth = r * 0.35;
    ctx.beginPath(); ctx.moveTo(x, y - r * 1.6); ctx.quadraticCurveTo(x + r, y - r * 0.2, x, y + r * 0.6); ctx.quadraticCurveTo(x - r, y - r * 0.2, x, y - r * 1.6); ctx.fill(); ctx.stroke(); ctx.restore();
  }
  function dustPuff(ctx, x, y, k, s, seed) { // 小團灰
    if (k <= 0 || k >= 1) return;
    for (let i = 0; i < 5; i++) {
      const an = PI + (i / 4) * PI + (hash(seed + i) - 0.5) * 0.5, r = (4 + 10 * eo(k)) * s * (0.7 + hash(seed + i * 2) * 0.6);
      ctx.save(); ctx.globalAlpha *= (1 - k) * 0.55; ctx.fillStyle = '#cdbfa8';
      ctx.beginPath(); ctx.arc(x + Math.cos(an) * r * 1.4, y + Math.sin(an) * r * 0.35, (1.6 + 2.2 * k) * s, 0, TAU); ctx.fill(); ctx.restore();
    }
  }
  function sniffLines(ctx, x, y, t, s, fwd) {
    for (let i = 0; i < 2; i++) {
      const ph = (t * 1.6 + i * 0.5) % 1, al = Math.sin(ph * PI) * 0.8; const pts = [];
      for (let j = 0; j <= 5; j++) { const q = j / 5; pts.push([x + fwd * (14 - ph * 10 - q * 6) * s, y + (i * 4 - 2 + Math.sin(q * 6 + t * 8) * 1.2) * s]); }
      ctx.save(); ctx.globalAlpha *= al; crayon(ctx, pts, 0.9 * s, '#e9e2cf'); ctx.restore();
    }
  }

  // ======================= 殭屍跳：真正一下一下跳 =======================
  // hp：0~1 一跳；0~0.22 蹲（預備）、0.22~0.9 騰空、0.9~1 落地壓扁
  function hopPose(hp, H, P) {
    const c = Math.max(Math.sin(PI * seg(hp, 0, 0.24)) * (hp < 0.24 ? 1 : 0), 0), air = seg(hp, 0.22, 0.9), land = hp > 0.9 ? Math.sin(PI * seg(hp, 0.9, 1)) : 0;
    const up = Math.sin(PI * air) * (hp >= 0.22 && hp <= 0.9 ? 1 : 0);
    add(P, { sy:1 - 0.1 * c - 0.09 * land + 0.06 * up * (1 - air), sx:1 + 0.06 * c + 0.06 * land - 0.03 * up, body:0.04 * up, head:-0.05 * up + 0.06 * land, armF:0.08 * up - 0.06 * land, armB:-0.08 * up + 0.06 * land });
    return up * H * 0.2;
  }

  // ======================= 各動作的身體 =======================
  function body(ctx, a) {
    const o = a.o, type = a.type, at = o.at || 0, t = o.t || 0, fwd = a.faceRight ? 1 : -1, s = a.s, H = a.H, pl = o.pl || {};
    if (!MeshAnim.has(type)) return false;
    if (o.act === 'plaza_eat' && type === 'eguiking' && eatDraw(ctx, a) !== false) return;
    if (o.act === 'plaza_golf' && type === 'huang' && golfDraw(ctx, a) !== false) return;
    if (o.act === 'plaza_hang' && type === 'tianhua' && hangDraw(ctx, a) !== false) return;
    const P = basePose(o, type); let lift = 0, shK = 1;
    if (HOPPER[type] && o.hp != null && o.hp >= 0 && (!o.act || o.act === 'plaza_walk')) lift += hopPose(o.hp, H, P);
    const w = cl(o.w || 0);
    // 走路的個性
    if (PAPER[type] && w > 0) { add(P, { armF:Math.sin(t * 31) * 0.05 * w, armB:Math.sin(t * 27 + 1) * 0.05 * w, sx:1 + Math.sin(t * 23) * 0.012 * w, body:0.04 * (o.run || 0) }); }
    if (type === 'youhun') { P.rot = (P.rot || 0) + Math.sin(t * 1.7) * 0.05 * fwd; lift += (Math.sin(t * 1.1) + 1) * 1.2 * s; }
    if (type === 'shuigui') add(P, { head:0.07 });
    if (o.sniff) { const sn = Math.pow(Math.max(0, Math.sin(t * 2.6)), 6); add(P, { head:0.2 + Math.sin(t * 24) * 0.05 * sn, body:0.1 }); }
    if (o.sneak) { add(P, { body:0.2, head:0.06, sy:0.9, sx:1.05, armF:-0.32, armB:0.3 }); }
    let after = null;
    switch (o.act) {
      case 'plaza_talk': {
        if (pl.spk) { const b = Math.max(0, Math.sin(at * 2.1)); add(P, { head:0.02 + Math.sin(at * 8.5) * 0.05 * b, armF:-0.22 * (0.5 + 0.5 * Math.sin(at * 3.2)) * b, body:0.03 * b }); }
        else { const n = Math.sin(PI * seg((at % 1.5), 0.2, 0.75)); add(P, { head:0.08 * n, body:0.01 * n }); }
        break;
      }
      case 'plaza_argue': {
        if (pl.spk) add(P, { body:0.09, head:0.07 + Math.sin(at * 12) * 0.06, armF:-0.32 + Math.sin(at * 6.5) * 0.18, sx:1 + Math.abs(Math.sin(at * 6.5)) * 0.015 });
        else add(P, { body:-0.06, head:-0.09 + Math.sin(at * 1.3) * 0.02 });
        break;
      }
      case 'plaza_wave': {
        const k = env(at, 0, 0.28, (pl.d || 1.4) - 0.35, pl.d || 1.4);
        add(P, { armF:(-0.5 + Math.sin(at * 11) * 0.16) * k, body:-0.03 * k, head:0.05 * k * Math.sin(at * 5.5) });
        break;
      }
      case 'plaza_bow': {
        const d = pl.d || 1.2, k = env(at, 0, d * 0.3, d * 0.62, d), deep = pl.deep == null ? 1 : pl.deep;
        add(P, { body:0.3 * k * deep, head:0.22 * k * deep, armF:0.08 * k, armB:-0.08 * k, sy:1 - 0.02 * k });
        break;
      }
      case 'plaza_doze': {
        const d = pl.d || 8, k = env(at, 0, 1.4, d - 0.7, d), j = at % 5.6, wake = (j > 4.3 && j < 4.9) ? Math.sin(PI * seg(j, 4.3, 4.9)) : 0, br = Math.sin(t * 1.1);
        add(P, { head:(0.28 * (1 - wake * 1.3) + br * 0.03) * k, body:0.07 * k, armF:0.06 * k, armB:-0.06 * k, sy:1 + br * 0.018 * k, hairL:0.08 * k, hairR:0.08 * k });
        o._z = k * (1 - wake);
        break;
      }
      case 'plaza_look': {
        const k = env(at, 0, 0.3, (pl.d || 2) - 0.3, pl.d || 2);
        add(P, { head:(-0.06 + Math.sin(at * 2.2) * 0.04) * k, body:-0.02 * k });
        break;
      }
      case 'plaza_stretch': {
        const d = pl.d || 2, k = env(at, 0, 0.6, d - 0.6, d), q = Math.sin(t * 30) * 0.012 * (at > 0.6 && at < d - 0.6 ? 1 : 0);
        add(P, { armF:-0.5 * k, armB:0.5 * k, body:-0.1 * k + q, head:-0.12 * k, sy:1 + 0.05 * k, sx:1 - 0.025 * k });
        break;
      }
      case 'plaza_sniff': {
        const sn = Math.pow(Math.max(0, Math.sin(at * 3.1)), 4);
        add(P, { head:0.24 + Math.sin(at * 24) * 0.06 * sn, body:0.12, sy:1 - 0.02 * sn });
        after = () => { const [nx, ny] = npt(a, PAPER[type] ? 0.5 : 0.62, 0.28); sniffLines(ctx, nx, ny + 4 * s, at, s, fwd); };
        break;
      }
      case 'plaza_backrub': {
        const d = pl.d || 2.6, k = env(at, 0, 0.25, d - 0.7, d - 0.25), st = bump3(at, d - 0.75, d - 0.45, d);
        add(P, { body:0.14 * k + Math.sin(at * 11) * 0.015 * k - 0.12 * st, head:0.06 * k - 0.1 * st, armB:Math.sin(at * 11) * 0.11 * k, sy:1 - 0.03 * k + 0.04 * st, sx:1 + Math.sin(at * 22) * 0.01 * k });
        after = () => { const [hx, hy] = npt(a, 0.45, 0.02); txt(ctx, hx + fwd * 8 * s, hy - 8 * s, '哎喲', 12 * s * 1.3, '#ffd2d2', env(at, 0.1, 0.25, 1.3, 1.6), Math.sin(at * 9) * 0.5); };
        break;
      }
      case 'plaza_soup': {
        const d = pl.d || 10, k = env(at, 0, 0.7, d - 0.7, d), c = (at - 0.7) % 4.4, blow = at > 0.7 ? Math.sin(PI * seg(c, 0, 1.0)) : 0, stir = at > 0.7 ? env(c, 1.2, 1.5, 3.6, 4.0) : 0;
        o.sit = 1;
        add(P, { y:0.07 * k, sy:1 - 0.07 * k, sx:1 + 0.04 * k, tail1:0.3 * k, tail2:0.45 * k, head:0.12 * blow, body:0.05 * blow + Math.sin(at * 5) * 0.015 * stir, armB:(Math.sin(at * 5) * 0.09 + 0.05) * stir });
        after = () => { const [bx, by] = npt(a, 0.25, 0.47, 0); steam(ctx, bx, by + H * 0.07 * k, t, s, 3, 0.55 + 0.6 * blow, fwd * blow * 0.8); };
        break;
      }
      case 'plaza_hair': {
        const c = at % 2.3, up = eio(seg(c, 0, 0.35)), down = eio(seg(c, 0.35, 1.25)), rel = eio(seg(c, 1.25, 2.0));
        const arm = -0.75 * up * (1 - down) + 0.15 * down * (1 - rel), pull = Math.sin(PI * seg(c, 0.35, 1.5));
        add(P, { armF:arm, head:0.16 * up * (1 - rel) + 0.04, hairL:0.38 * pull - 0.12 * Math.sin(PI * seg(c, 1.4, 2.3)), hairR:Math.sin(at * 1.7) * 0.1 + 0.08 * pull, body:-0.04 * pull + 0.03 * up * (1 - rel) });
        break;
      }
      case 'plaza_shake': {
        const sh = seg(at, 0.25, 1.25), amp = at > 0.25 && at < 1.25 ? (1 - sh) * Math.sin(PI * Math.min(1, sh * 6)) : 0, cr = Math.sin(PI * seg(at, 0, 0.3)) * (at < 0.3 ? 1 : 0);
        add(P, { rot:Math.sin(at * 30) * 0.1 * amp, head:-Math.sin(at * 30) * 0.12 * amp + 0.1 * seg(at, 1.25, 1.6), hairL:Math.sin(at * 30 + 1) * 0.35 * amp, hairR:Math.sin(at * 30 + 2) * 0.35 * amp, sy:1 - 0.08 * cr, sx:1 + 0.04 * cr + 0.03 * amp });
        after = () => { const [hx, hy] = npt(a, 0.5, 0.3); for (let i = 0; i < 12; i++) { const e = at - (0.3 + i * 0.07); if (e < 0 || e > 0.5) continue; const an = -PI * (0.1 + 0.8 * hash(i * 7.7)), v = (36 + hash(i) * 34) * s; drop(ctx, hx + Math.cos(an) * v * e * (i % 2 ? 1 : -1), hy + Math.sin(an) * v * e + 140 * s * e * e, 1.6 * s, 1 - e / 0.5); } };
        break;
      }
      case 'plaza_spin': {
        const q = seg(at, 0.25, 1.35), cr = Math.sin(PI * seg(at, 0, 0.25)) * (at < 0.25 ? 1 : 0), land = Math.sin(PI * seg(at, 1.35, 1.75)) * (at > 1.35 ? 1 : 0);
        const c = Math.cos(q * TAU * 2); P.sx = (P.sx || 1) * Math.sign(c || 1) * Math.max(0.07, Math.abs(c)) * (1 + 0.06 * cr);
        add(P, { sy:1 - 0.1 * cr - 0.06 * land + 0.05 * Math.sin(PI * q), tail1:Math.sin(at * 12) * 0.3 * Math.sin(PI * q), tail2:Math.sin(at * 12 - 1) * 0.45 * Math.sin(PI * q), head:-0.08 * Math.sin(PI * q) });
        lift += Math.sin(PI * q) * 8 * s;
        after = () => { if (at > 1.3) { const [hx, hy] = npt(a, 0.5, 0.0); bubble(ctx, hx + fwd * 10 * s, hy - 16 * s, '♪', s, env(at, 1.3, 1.45, 2.0, 2.2)); } };
        break;
      }
      case 'plaza_boo': {
        const cr = at < 0.15 ? Math.sin(PI * seg(at, 0, 0.15)) : 0, k = env(at, 0.12, 0.26, 0.72, 0.95), tr = at > 0.26 && at < 0.72 ? Math.sin(at * 42) * 0.03 : 0;
        add(P, { sy:1 - 0.13 * cr + 0.12 * k, sx:1 + 0.06 * cr - 0.05 * k, armF:-0.6 * k + tr, armB:0.6 * k - tr, head:-0.12 * k, body:0.12 * k + 0.08 * cr, x:0.05 * k });
        lift += 6 * s * k;
        after = () => { const [hx, hy] = npt(a, 0.5, 0.0); txt(ctx, hx + fwd * 12 * s, hy - 6 * s, '哇！', 13 * s * 1.4, '#ffe9a8', env(at, 0.15, 0.25, 0.8, 1.0), Math.sin(at * 30)); };
        break;
      }
      case 'plaza_laugh': {
        const d = pl.d || 1.6, k = env(at, 0, 0.15, d - 0.3, d), b = Math.abs(Math.sin(at * 15));
        add(P, { body:(0.16 + b * 0.05) * k, head:(0.06 + Math.sin(at * 15) * 0.08) * k, sy:1 - b * 0.04 * k, armB:0.25 * k, armF:0.2 * k });
        after = () => { const [hx, hy] = npt(a, 0.5, 0.05); txt(ctx, hx - fwd * 10 * s, hy - 4 * s - b * 2 * s, '嘻嘻', 10 * s * 1.4, '#c8f5b8', k, Math.sin(at * 15)); };
        break;
      }
      case 'plaza_startle': case 'plaza_eek': {
        const d = pl.d || (o.act === 'plaza_eek' ? 0.75 : 1.3), cr = at < 0.08 ? Math.sin(PI * seg(at, 0, 0.08)) : 0, j = Math.sin(PI * seg(at, 0.06, 0.32)) * (at > 0.06 && at < 0.32 ? 1 : 0), tr = at > 0.3 ? Math.sin(at * 45) * 0.03 * (1 - seg(at, 0.3, d)) : 0, k = 1 - eio(seg(at, d * 0.65, d));
        add(P, { sy:1 - 0.1 * cr + 0.06 * j, armF:(-0.55 * j - 0.2) * k + tr, armB:(0.55 * j + 0.2) * k - tr, head:(-0.2 * j - 0.06) * k + tr * 2, body:(-0.1 * j - 0.04) * k + tr, hairL:-0.25 * j, hairR:-0.25 * j });
        lift += j * 7 * s;
        break;
      }
      case 'plaza_reach': {
        const k = env(at, 0, 0.12, 0.3, 0.5);
        add(P, { body:0.18 * k, armF:-0.55 * k, head:0.05 * k, x:0.05 * k });
        break;
      }
      case 'plaza_bump': {
        const im = at < 0.12 ? Math.sin(PI * seg(at, 0, 0.12)) : 0, back = Math.sin(PI * seg(at, 0.1, 0.55)) * (at > 0.1 && at < 0.55 ? 1 : 0), land = at > 0.55 ? Math.sin(PI * seg(at, 0.55, 0.75)) : 0;
        add(P, { sx:1 - 0.14 * im + 0.08 * land, sy:1 + 0.07 * im - 0.1 * land, body:-0.22 * im - 0.12 * back, head:-0.2 * im - 0.1 * back, armF:0.25 * im, armB:-0.25 * im });
        lift += back * 7 * s;
        after = () => { const [hx, hy] = npt(a, 0.3, 0.2); txt(ctx, hx + fwd * 10 * s, hy - 4 * s, '咚！', 11 * s * 1.4, '#ffe9a8', env(at, 0.0, 0.06, 0.45, 0.7), 0.4); };
        break;
      }
      case 'plaza_dizzy': {
        const d = pl.d || 2.2, k = 1 - eio(seg(at, d - 0.6, d));
        add(P, { rot:Math.sin(at * 6) * 0.08 * k, head:Math.cos(at * 6) * 0.12 * k, body:Math.sin(at * 6 + 1) * 0.05 * k, armF:Math.sin(at * 6) * 0.1 * k, armB:Math.cos(at * 6) * 0.1 * k });
        o._stars = k;
        break;
      }
    }
    drawM(ctx, a, P, lift, shK);
    if (after) after();
  }
  function bump3(g, a, m, b) { return g <= a || g >= b ? 0 : g < m ? eio((g - a) / (m - a)) : 1 - eio((g - m) / (b - m)); }

  // ---- 餓鬼王：邊走邊吃包子（原圖拆出的「拿包子的手」繞肩膀轉到嘴邊）----
  function eatDraw(ctx, a) {
    const c = typeof LIMBS_DATA !== 'undefined' && LIMBS_DATA.chars.eguiking;
    if (!c || !ok('eguiking__body') || !ok('eguiking__arm')) return false;
    const o = a.o, t = o.t || 0, H = a.H, s = a.s, fwd = a.faceRight ? 1 : -1, body = SPR.eguiking__body, arm = SPR.eguiking__arm;
    const W = H * body.naturalWidth / body.naturalHeight;
    const P = basePose(o, 'eguiking');
    const cyc = 3.6, ph = ((o.at || 0) + 0.15) % cyc;
    const raise = eio(seg(ph, 0.1, 0.62)), away = eio(seg(ph, 0.86, 1.3)), lk = raise * (1 - away);
    const chomp = bump3(ph, 0.6, 0.67, 0.86), ck = seg(ph, 1.3, 2.7), chew = ph > 1.3 && ph < 2.7 ? Math.sin(ck * PI * 6) * (1 - ck * 0.4) : 0;
    add(P, { head:-0.07 * raise * (1 - seg(ph, 0.55, 0.62)) + 0.1 * chomp + 0.035 * chew, body:0.04 * chomp, sy:1 - 0.025 * chomp - 0.012 * Math.abs(chew), sx:1 + 0.015 * Math.abs(chew) });
    const th = 58 * lk + 4 * chomp, hx = 0.06 * lk, hy = 0.045 * lk;
    // 換到「原圖朝左」的座標畫
    const mp = {}; for (const k in P) mp[k] = (typeof P[k] === 'number' && k !== 'y' && k !== 'sx' && k !== 'sy') ? -P[k] : P[k];
    const fy = (3 + Math.sin(t * 2.4) * 2) * s;
    shadowAt(ctx, a, 0, 1);
    ctx.save(); ctx.translate(a.x, a.y - fy); if (a.faceRight) ctx.scale(-1, 1);
    ctx.translate((mp.x || 0) * W, (mp.y || 0) * H); ctx.scale(mp.sx || 1, mp.sy || 1);
    const bA = mp.body || 0, bp = [0.48 * W - W / 2, 0.70 * H - H], pv = [c.pivot[0] * W - W / 2, c.pivot[1] * H - H];
    const rx = pv[0] - bp[0], ry = pv[1] - bp[1], px = bp[0] + Math.cos(bA) * rx - Math.sin(bA) * ry + hx * W, py = bp[1] + Math.sin(bA) * rx + Math.cos(bA) * ry - hy * H;
    const m2 = Object.assign({}, mp, { x:0, y:0, sx:1, sy:1, rot:0, armF:0 });
    MeshAnim.drawBody(ctx, 'eguiking', 'eguiking__body', H, m2);
    ctx.save(); ctx.translate(px, py); ctx.rotate(bA + th * D); ctx.drawImage(arm, -c.pivot[0] * W, -c.pivot[1] * H, W, H); ctx.restore();
    ctx.restore();
    // 碎屑：咬下去那一刻從嘴邊噴出
    const mx = a.x - fwd * 0.03 * W, my = a.y - fy - 0.66 * H;
    crumbs(ctx, mx, my, ph - 0.66, s, Math.floor(((o.at || 0) + 0.15) / cyc) * 13 + 3, fwd);
  }

  // ---- 黃總：練高爾夫（原圖拆出的球桿手）----
  function golfDraw(ctx, a) {
    if (typeof Limbs === 'undefined' || !Limbs.has('huang')) return false;
    const o = a.o, t = o.t || 0, H = a.H, s = a.s, fwd = a.faceRight ? 1 : -1, at = o.at || 0, d = (o.pl && o.pl.d) || 9.6;
    // 進場 0.9 秒（收著的桿 → 送桿位 → 桿頭放到球後面），每一桿 4 秒，最後一桿送完收回肩上
    const IN = 0.9, L = 4.0, n = Math.max(1, Math.floor((d - IN - 0.7) / L + 0.01)), last = at >= IN + (n - 1) * L;
    let pose = 'recover', pt = 0, c = -1, ball = 0;
    if (at < IN) { if (at < 0.5) { pose = 'recover'; pt = 1 - eio(seg(at, 0, 0.5)); } else { pose = 'follow'; pt = 1 - eio(seg(at, 0.5, IN)); } ball = seg(at, 0.3, 0.8); }
    else {
      c = Math.min((at - IN) % L + (at >= IN + n * L ? L : 0), last ? 99 : L - 1e-6); if (last) c = at - IN - (n - 1) * L;
      if (c < 1.0) { pose = 'strike'; pt = 0.42 - 0.035 * (0.5 - 0.5 * Math.cos(c * TAU * 1.5)) * (c < 0.95 ? 1 : 0); ball = 1; }   // 瞄球、晃桿
      else if (c < 1.9) { pose = 'strike'; pt = 0.42 * (1 - eio(seg(c, 1.0, 1.9))); ball = 1; }                                    // 慢慢上桿
      else if (c < 2.1) { pose = 'strike'; pt = 0; ball = 1; }                                                                      // 頂點停一下
      else if (c < 2.24) { pose = 'strike'; pt = 0.42 * ei(seg(c, 2.1, 2.24)); ball = 1; }                                           // 下桿（加速）
      else if (c < 2.55) { pose = 'follow'; pt = eo3(seg(c, 2.24, 2.55)); }                                                         // 送桿
      else if (c < 3.3 || last && c < 3.4) { pose = 'follow'; pt = 1; }                                                              // 收桿看球飛
      else if (!last) { pose = 'follow'; pt = 1 - eio(seg(c, 3.3, 4.0)); ball = seg(c, 3.5, 3.9); }                                  // 再擺一顆，桿頭放回球後
      else { pose = 'recover'; pt = eio(seg(c, 3.4, 4.1)); }                                                                        // 收回肩上
    }
    const mp = MeshAnim.ANIM.idle(t); if (c > 2.4) { mp.head = -0.1 * env(c, 2.4, 2.7, 3.1, 3.5); }
    const fy = (3 + Math.sin(t * 2.4) * 2) * s;
    shadowAt(ctx, a, 0, 1);
    Limbs.draw(ctx, 'huang', a.x, a.y - fy, H, { pose, pt, t, walk:false }, a.faceRight, mp);
    // 小白球：放在腳前，打出去飛走
    const bx = a.x + fwd * H * 0.42, by = a.y;
    if (ball > 0) { ctx.save(); ctx.globalAlpha *= ball; ctx.fillStyle = '#fbfbf4'; ctx.strokeStyle = '#555'; ctx.lineWidth = 0.4; ctx.beginPath(); ctx.arc(bx, by - 1.2 * s, 1.5 * s, 0, TAU); ctx.fill(); ctx.stroke(); ctx.restore(); }
    if (c >= 2.24 && c < 3.3) {
      const e = c - 2.24, x = bx + fwd * 150 * s * e, y = by - 1.2 * s - 120 * s * e + 70 * s * e * e;
      ctx.save(); ctx.globalAlpha *= 1 - seg(e, 0.6, 1); ctx.fillStyle = '#fbfbf4'; ctx.beginPath(); ctx.arc(x, y, 1.5 * s * (1 - 0.4 * e), 0, TAU); ctx.fill();
      crayon(ctx, [[x - fwd * 8 * s, y + 5 * s], [x - fwd * 2 * s, y + 1 * s]], 0.8 * s, 'rgba(255,255,255,.6)'); ctx.restore();
      dustPuff(ctx, bx, by, seg(e, 0, 0.5), s, 4);
    }
  }

  // ---- 天花姐：翻身上屋簷倒掛休息（用她自己的倒掛原圖）----
  // pl.eh = 屋簷離地多高（世界單位），pl.hd = 掛多久
  function hangTimes(pl) { const hd = pl.hd || 6; const T1 = 0.85, T2 = T1 + hd, T3 = T2 + 0.4, T4 = T3 + 1.6; return { T1, T2, T3, T4 }; }
  function hangDraw(ctx, a) {
    if (!ok('tianhua_hang')) return false;
    const o = a.o, at = o.at || 0, t = o.t || 0, H = a.H, s = a.s, fwd = a.faceRight ? 1 : -1, pl = o.pl || {}, eh = pl.eh || H * 2.2;
    const { T1, T2, T3, T4 } = hangTimes(pl);
    const hang = SPR.tianhua_hang, hh = H * 645 / 577, hw = hh * hang.naturalWidth / hang.naturalHeight;
    const ax = a.x, ay = a.y - eh;
    const stand = (lift, rot, P) => { // 站姿原圖（可整個翻轉）
      const cy = a.y - floatY(a) - lift - H * 0.5;
      ctx.save(); ctx.translate(a.x, cy); ctx.rotate(rot); ctx.translate(-a.x, -cy);
      MeshAnim.draw(ctx, 'tianhua', a.x, a.y - floatY(a) - lift, H, P, a.faceRight); ctx.restore();
    };
    const hangImg = (y, ang, sy) => {
      ctx.save(); ctx.translate(ax, y); ctx.rotate(ang); ctx.scale(1, sy || 1); if (!a.faceRight) ctx.scale(-1, 1);
      ctx.drawImage(hang, -0.72 * hw, 0, hw, hh); ctx.restore();
    };
    if (at < T1) { // 蹲（扶腰哎喲）→ 跳起翻身
      const cr = eo(seg(at, 0, 0.36)) * (1 - seg(at, 0.4, 0.5)), j = seg(at, 0.45, T1), up = eo3(j);
      const P = add(MeshAnim.ANIM.idle(t), { body:0.2 * cr, head:0.12 * cr, sy:1 - 0.12 * cr + 0.16 * Math.sin(PI * j) * (1 - j), sx:1 + 0.06 * cr - 0.08 * Math.sin(PI * j), armB:Math.sin(at * 14) * 0.08 * cr, hairL:-0.3 * Math.sin(PI * j), hairR:-0.3 * Math.sin(PI * j) });
      const lift = (eh - H * 0.55) * up, rot = -fwd * PI * eio(seg(at, 0.58, T1));
      shadowAt(ctx, a, lift, 1);
      stand(lift, rot, P);
      if (at > 0.45 && at < 0.7) { ctx.save(); ctx.globalAlpha *= 1 - seg(at, 0.5, 0.7); for (let i = -1; i <= 1; i++) crayon(ctx, [[a.x + i * 6 * s, a.y - lift + 4 * s], [a.x + i * 6 * s, a.y - lift + 22 * s]], 0.8 * s, '#e8dfd0'); ctx.restore(); }
      dustPuff(ctx, a.x, a.y, seg(at, 0.45, 0.9), s, 2);
      const [hx, hy] = npt(a, 0.45, 0.0); txt(ctx, hx + fwd * 9 * s, hy - 6 * s, '哎喲', 12 * s * 1.3, '#ffd2d2', env(at, 0.05, 0.15, 0.4, 0.5), 0.3);
      return;
    }
    if (at < T2) { // 倒掛：抓到屋簷一下盪、慢慢停，呼吸
      const e = at - T1, amp = 22 * Math.exp(-e * 1.7) * Math.cos(e * 4.6), sway = Math.sin(t * 1.25) * 2.2, br = 1 + Math.sin(t * 1.6) * 0.012;
      ctx.save(); ctx.globalAlpha *= 0.35; a.shadow(a.x, 0.5); ctx.restore();
      hangImg(ay, (amp + sway) * D * fwd, br);
      dustPuff(ctx, ax, ay + 2 * s, seg(e, 0, 0.7), s, 9);
      for (let i = 0; i < 4; i++) { const f = e - i * 0.12; if (f < 0 || f > 0.8) continue; ctx.save(); ctx.globalAlpha *= 1 - f / 0.8; ctx.fillStyle = '#bfb29c'; ctx.beginPath(); ctx.arc(ax + (hash(i) - 0.5) * 14 * s, ay + 2 * s + 60 * s * f * f, 0.8 * s, 0, TAU); ctx.fill(); ctx.restore(); }
      o._z = e > 1.8 ? seg(e, 1.8, 2.4) * (1 - seg(at, T2 - 0.5, T2)) : 0; o._zpos = [ax - fwd * hw * 0.35, ay + hh * 0.75];
      return;
    }
    if (at < T3) { // 鬆手：翻回來落地
      const q = seg(at, T2, T3), fall = ei(q), lift = (eh - H * 0.55) * (1 - fall);
      const P = add(MeshAnim.ANIM.idle(t), { hairL:0.3, hairR:0.3, sy:1.05, sx:0.96 });
      shadowAt(ctx, a, lift, 1);
      if (q < 0.18) hangImg(ay + 30 * s * q, 0, 1);
      else stand(lift, -fwd * PI * (1 - eio(seg(q, 0.18, 1))), P);
      return;
    }
    // 落地壓扁 → 扶腰揉一揉「哎喲」
    const e = at - T3, sq = Math.sin(PI * seg(e, 0, 0.3)) * (e < 0.3 ? 1 : 0), k = env(e, 0.15, 0.4, T4 - T3 - 0.4, T4 - T3);
    const P = add(MeshAnim.ANIM.idle(t), { sy:1 - 0.16 * sq, sx:1 + 0.1 * sq, body:0.2 * sq + 0.13 * k, head:0.12 * sq + 0.06 * k, armB:Math.sin(e * 11) * 0.11 * k });
    shadowAt(ctx, a, 0, 1);
    MeshAnim.draw(ctx, 'tianhua', a.x, a.y - floatY(a), H, P, a.faceRight);
    dustPuff(ctx, a.x, a.y, seg(e, 0, 0.5), s, 5);
    const [hx, hy] = npt(a, 0.45, 0.0); txt(ctx, hx + fwd * 9 * s, hy - 8 * s, '哎喲', 12 * s * 1.3, '#ffd2d2', env(e, 0.1, 0.25, 1.1, 1.4), Math.sin(e * 9) * 0.5);
  }

  const NAMES = ['walk', 'eat', 'golf', 'hang', 'talk', 'argue', 'wave', 'bow', 'doze', 'look', 'stretch', 'sniff', 'backrub', 'soup', 'hair', 'shake', 'spin', 'boo', 'laugh', 'startle', 'eek', 'reach', 'bump', 'dizzy'];
  if (typeof DAILY !== 'undefined') NAMES.forEach(n => { DAILY['plaza_' + n] = body; });

  // ======================= 沒有網格骨架的角色（Toyol、Pocong、Penanggal）：整張原圖做整體動作 =======================
  function drawSpecial(ctx, ag, t) {
    const k = ag.k, s = SC, H = (CH[k] || 50) * s, at = ag.at, fwd = ag.face ? 1 : -1, act = ag.act, pl = ag.pl || {};
    let dx = 0, dy = 0, rot = 0, sx = 1, sy = 1, walk = ag.w > 0.3;
    switch (act) {
      case 'plaza_talk': case 'plaza_argue': if (pl.spk) { dy = -Math.abs(Math.sin(at * 8)) * 1.6 * s; rot = Math.sin(at * 4.2) * 0.05; } else rot = 0.05 * Math.sin(PI * seg(at % 1.5, 0.2, 0.75)) * fwd; break;
      case 'plaza_wave': rot = Math.sin(at * 9) * 0.07 * env(at, 0, 0.2, 1.1, 1.4); dy = -Math.abs(Math.sin(at * 9)) * 1.2 * s; break;
      case 'plaza_bow': { const d = pl.d || 1.2, kk = env(at, 0, d * 0.3, d * 0.62, d); rot = 0.22 * kk * fwd; sy = 1 - 0.04 * kk; break; }
      case 'plaza_doze': { const d = pl.d || 8, kk = env(at, 0, 1.4, d - 0.7, d); rot = 0.1 * kk * fwd + Math.sin(t * 1.1) * 0.015; sy = 1 + Math.sin(t * 1.1) * 0.015 * kk; ag._z = kk; break; }
      case 'plaza_look': rot = -0.05 * fwd * env(at, 0, 0.3, 1.6, 2); break;
      case 'plaza_startle': case 'plaza_eek': { const j = Math.sin(PI * seg(at, 0.06, 0.32)) * (at > 0.06 && at < 0.32 ? 1 : 0); dy = -j * 7 * s; sy = 1 + 0.08 * j; rot = at > 0.3 ? Math.sin(at * 45) * 0.03 * (1 - seg(at, 0.3, 1.2)) : 0; break; }
      case 'plaza_dizzy': rot = Math.sin(at * 6) * 0.09 * (1 - seg(at, 1.6, 2.2)); ag._stars = 1 - seg(at, 1.6, 2.2); break;
      case 'plaza_stretch': { const kk = env(at, 0, 0.6, 1.4, 2); sy = 1 + 0.07 * kk; sx = 1 - 0.035 * kk; rot = -0.05 * kk * fwd; break; }
      case 'plaza_hop': walk = true; break; // Pocong 原地跳
      case 'plaza_coins': { const c = at % 1.1; rot = (0.07 + 0.03 * Math.sin(PI * seg(c, 0, 0.3))) * fwd * env(at, 0, 0.3, (pl.d || 5) - 0.3, pl.d || 5); dy = Math.sin(PI * seg(c, 0, 0.3)) * 0.8 * s; break; }
      case 'plaza_spin': { const q = seg(at, 0.25, 1.35), c = Math.cos(q * TAU * 2); sx = Math.sign(c || 1) * Math.max(0.07, Math.abs(c)); dy = -Math.sin(PI * q) * 8 * s; break; }
    }
    ctx.save(); ctx.translate(ag.x, ag.y); ctx.rotate(rot); ctx.scale(sx, sy); ctx.translate(-ag.x, -ag.y);
    const nr = !!(MeshAnim.NATIVE_R[k]);
    ART.drawChar(ctx, k, ag.x + dx, ag.y + dy, s, { t:t + ag.seed, walk, tamed:true, untied:true, flip:ag.face === nr, key:'plz' + ag.id });
    ctx.restore();
    if (act === 'plaza_coins') coinsFx(ctx, ag, at, s, H, fwd, pl);
  }
  // Toyol 數錢：錢袋裡一枚一枚彈出來、翻轉、掉回去，旁邊冒數字；數到一半忘了，「？」重來
  function coinsFx(ctx, ag, at, s, H, fwd, pl) {
    const px = ag.x + fwd * 0.27 * H * 337 / 586, py = ag.y - 0.58 * H;
    const n = Math.floor(at / 1.1), c = at % 1.1, lost = (n % 5) === 4;
    if (!lost && at < (pl.d || 5) - 0.4) {
      const e = seg(c, 0.05, 0.75), x = px + fwd * Math.sin(PI * e) * 3 * s, y = py - Math.sin(PI * e) * 15 * s;
      if (c > 0.05 && c < 0.75) {
        const sp = Math.cos(e * TAU * 2); ctx.save(); ctx.translate(x, y); ctx.scale(Math.max(0.15, Math.abs(sp)), 1);
        ctx.beginPath(); ctx.arc(0, 0, 2.6 * s, 0, TAU); ctx.fillStyle = sp > 0 ? '#f2c94c' : '#d9a62e'; ctx.fill(); ctx.lineWidth = 0.7 * s; ctx.strokeStyle = '#6a4a14'; ctx.stroke();
        ctx.fillStyle = '#6a4a14'; ctx.fillRect(-0.7 * s, -0.7 * s, 1.4 * s, 1.4 * s); ctx.restore();
        if (c > 0.5) { ctx.save(); ctx.globalAlpha *= 1 - seg(c, 0.5, 0.75); star(ctx, x + 3 * s, y - 2 * s, 1.6 * s, c * 5); ctx.restore(); }
      }
      txt(ctx, px + fwd * 12 * s, py - 14 * s - seg(c, 0.4, 1.1) * 6 * s, String(n % 5 + 1), 10 * s * 1.4, '#ffe9a8', env(c, 0.4, 0.5, 0.9, 1.1), 0);
    } else if (lost) bubble(ctx, ag.x + fwd * 6 * s, ag.y - H - 10 * s, '?', s, env(c, 0, 0.15, 0.9, 1.1));
  }

  // ======================= 廣場模擬 =======================
  // 能走的地方（世界座標）：A = 伐木場和糯米田中間那塊（含石板路），B = 兩棟房子前面、圍牆裡面那一長條
  const ZA = [158, 232, 534, 676], ZB = [24, 366, 636, 676];
  const SPOTS = {
    eave: { x:124, y:640, ey:556 },                               // 伐木場正面橫樑（天花姐倒掛）
    banana: [[368, 590, -1], [34, 640, 1]],                        // 香蕉樹下（Pontianak）
    bumps: [[160, 600, -1], [234, 606, 1], [172, 674, -1], [218, 674, 1]], // 殭屍撞到：伐木場牆角、糯米田籬笆、兩根燈柱
  };
  function zonePt() {
    const aA = (ZA[1] - ZA[0]) * (ZA[3] - ZA[2]), aB = (ZB[1] - ZB[0]) * (ZB[3] - ZB[2]);
    const Z = R() * (aA + aB) < aA ? ZA : ZB;
    return [Z[0] + R() * (Z[1] - Z[0]), Z[2] + R() * (Z[3] - Z[2])];
  }
  function nearZ(x, y) { // 兩塊能走的區域裡，離 (x,y) 最近的點
    const pa = [cl(x, ZA[0], ZA[1]), cl(y, ZA[2], ZA[3])], pb = [cl(x, ZB[0], ZB[1]), cl(y, ZB[2], ZB[3])];
    return Math.hypot(pa[0] - x, pa[1] - y) <= Math.hypot(pb[0] - x, pb[1] - y) ? pa : pb;
  }
  function clampZ(a) {
    const inA = a.x > ZA[0] - 4 && a.x < ZA[1] + 4 && a.y > ZA[2] - 4, inB = a.y > ZB[2] - 4 && a.x > ZB[0] - 4 && a.x < ZB[1] + 4;
    if (!inA && !inB) return; // 在香蕉樹下等特別的位置：不管
    const p = nearZ(a.x, a.y); a.x = p[0]; a.y = p[1];
  }
  const sideX = (x) => x < ZA[0] - 2 || x > ZA[1] + 2;
  function route(ax, ay, bx, by) { // 需要的話先走到兩區重疊的地方，免得穿過房子
    const sa = nearZ(ax, ay); if (Math.hypot(sa[0] - ax, sa[1] - ay) > 3) { const q = nearZ(ax, ay + 40); return [[q[0], q[1]]].concat(route(q[0], q[1], bx, by)); } // 從樹下、屋簷下這種地方出發：先直直走回廣場
    if ((ay < ZB[2] - 2 && sideX(bx)) || (by < ZB[2] - 2 && sideX(ax))) { const mx = cl(ay < ZB[2] - 2 ? ax : bx, ZA[0] + 6, ZA[1] - 6); return [[mx, 652 + R() * 14], [bx, by]]; }
    return [[bx, by]];
  }
  function freePt(W, me, near) {
    let best = null, bs = -1e9;
    for (let i = 0; i < 9; i++) {
      const p = zonePt(); let sc = 0;
      for (const o of W.list) { if (o === me) continue; const d1 = Math.hypot(o.x - p[0], o.y - p[1]), d2 = o.tx != null ? Math.hypot(o.tx - p[0], o.ty - p[1]) : 99; sc += -Math.max(0, 26 - Math.min(d1, d2)) * 3; }
      if (me) { const d = Math.hypot(me.x - p[0], me.y - p[1]); sc += near ? -Math.abs(d - near) * 0.5 : Math.min(d, 90) * 0.15; }
      if (sc > bs) { bs = sc; best = p; }
    }
    return best;
  }
  const VMAX = { eguiking:13, egui:17, xiaozhi:20, zhiren:20, laojiang:15, zombie:15, tianhua:14, mengpo:12, heiwu:15, baiwu:16, niutou:17, mamian:17, huang:14, pontianak:14, shuigui:13, youhun:11, xiaogui:19, toyol:17, pocong:14, penanggal:15 };
  function mkAgent(g, i, W) {
    const p = freePt(W, null);
    const ag = { id:g.id, g, k:g.k, x:p[0], y:p[1], face:R() < 0.5, want:null, turnT:9, sp:0, w:0, wph:R() * 9, hp:-1, seed:R() * 50,
      vmax:VMAX[g.k] || 15, q:[], cur:null, st:'idle', at:0, dur:0.3 + R() * 3.5 + i * 0.37, act:null, pl:{}, style:{}, cd:{ talk:2 + R() * 6, hero:0, prank:6 + R() * 10, tag:4 + R() * 8 }, lock:null, eatT:0, wetT:0, iconT:9, icon:null };
    ag.want = ag.face; ag.tx = ag.x; ag.ty = ag.y; ag.W = W;
    return ag;
  }
  const isFree = (ag) => !ag.lock && (ag.st === 'idle' || (ag.st === 'go' && !ag.style.purpose));
  function setPlan(ag, steps) { ag.q = steps.slice(); next(ag); }
  function next(ag) {
    const c = ag.cur = ag.q.shift() || null; ag.at = 0;
    if (!c) { ag.st = 'idle'; ag.act = null; ag.pl = {}; ag.style = {}; ag.dur = 0.8 + R() * 2.6; return; }
    if (c.fn) { c.fn(ag); return next(ag); }
    if (c.go) { ag.st = 'go'; ag.style = c.style || {}; ag.act = ag.style.act || null; ag.pl = {}; ag.tx = c.go[0]; ag.ty = c.go[1]; return; }
    ag.st = c.act ? 'act' : 'idle'; ag.act = c.act || null; ag.dur = c.d; ag.pl = Object.assign({ d:c.d }, c.p || {}); ag.style = c.style || {};
    if (c.face != null) ag.want = typeof c.face === 'object' ? c.face.x > ag.x : !!c.face;
  }
  function goSteps(ag, x, y, style) { return route(ag.x, ag.y, x, y).map(p => ({ go:p, style })); }
  function pickW(arr) { let tot = 0; for (const e of arr) tot += e[0]; let r = R() * tot; for (const e of arr) { if ((r -= e[0]) <= 0) return e[1]; } return arr[arr.length - 1][1]; }
  const night = () => { const h = new Date().getHours(); return h >= 22 || h < 6; };

  // 自己決定接下來做什麼
  function choose(ag, W) {
    const k = ag.k, opts = [];
    const busy = (n) => Math.pow(0.25, W.list.filter(o => o !== ag && o.act === n).length); // 別人正在做的，少做（不要同步）
    const wander = (style, after) => () => { const p = freePt(W, ag); setPlan(ag, goSteps(ag, p[0], p[1], style).concat(after || [])); };
    opts.push([5, wander()]);
    opts.push([1.4 * busy('plaza_look'), () => setPlan(ag, [{ act:'plaza_look', d:1.8 + R() }])]);
    opts.push([0.9 * busy('plaza_stretch'), () => setPlan(ag, [{ act:'plaza_stretch', d:2 }])]);
    opts.push([(night() ? 2.4 : 0.7) * busy('plaza_doze'), () => setPlan(ag, [{ act:'plaza_doze', d:6 + R() * 5 }])]);
    const mate = W.list.filter(o => o !== ag && isFree(o) && o.cd.talk <= 0);
    if (mate.length && ag.cd.talk <= 0 && W.games.filter(G => G.kind === 'talk').length < Math.max(1, Math.round(W.list.length / 7))) opts.push([1.6, () => { const o = mate[Math.floor(R() * mate.length)]; const dx = ag.x < o.x ? -1 : 1; { const q = nearZ(o.x + dx * 20, o.y + (R() - 0.5) * 6); setPlan(ag, goSteps(ag, q[0], q[1], { seek:o })); } }]);
    const free = (kk) => W.list.find(o => o !== ag && o.k === kk && isFree(o));
    switch (k) {
      case 'eguiking': opts.push([5, wander({ eat:1, act:'plaza_eat' }, [{ act:'plaza_eat', d:3.6 + R() * 3.6 }])], [2, () => setPlan(ag, [{ act:'plaza_eat', d:5 + R() * 4 }])]); break;
      case 'egui': {
        const king = W.list.find(o => o.k === 'eguiking' && (o.act === 'plaza_eat'));
        if (king) opts.push([5, () => setPlan(ag, [{ go:[king.x, king.y], style:{ follow:king, sniff:1, purpose:1 } }, { act:'plaza_sniff', d:1.6 + R() }])]);
        opts.push([2, () => setPlan(ag, [{ act:'plaza_sniff', d:2 + R() * 2 }])], [1.5, wander({ sniff:1 })]);
        break;
      }
      case 'xiaozhi': case 'zhiren': { const o = W.list.find(x => x !== ag && PAPER[x.k] && isFree(x) && x.cd.tag <= 0); if (o && ag.cd.tag <= 0) opts.push([4, () => startTag(W, ag, o)]); break; }
      case 'laojiang': case 'zombie': opts.push([1.8, () => { const b = SPOTS.bumps[Math.floor(R() * SPOTS.bumps.length)]; setPlan(ag, goSteps(ag, b[0] - b[2] * 30, b[1], {}).concat([{ go:[b[0], b[1]], style:{ purpose:1 } }, { fn:(a) => { a.want = b[2] > 0; } }, { act:'plaza_bump', d:0.75, p:{ dir:b[2] } }, { act:'plaza_dizzy', d:2.2 }])); }]); break;
      case 'tianhua': {
        opts.push([2.5, () => setPlan(ag, [{ act:'plaza_backrub', d:2.6 }])]);
        if (W.bld.wood && !W.list.some(o => o !== ag && Math.hypot(o.x - SPOTS.eave.x, o.y - SPOTS.eave.y) < 18)) { const hd = 5 + R() * 5, pl = { eh:SPOTS.eave.y - SPOTS.eave.ey, hd }, T = hangTimes(pl); opts.push([2.2, () => setPlan(ag, goSteps(ag, SPOTS.eave.x, SPOTS.eave.y, { purpose:1 }).concat([{ act:'plaza_hang', d:T.T4, p:pl, face:R() < 0.5 }]))]); }
        break;
      }
      case 'mengpo': opts.push([4, wander({ purpose:1 }, [{ act:'plaza_soup', d:9 + R() * 6 }])]); break;
      case 'heiwu': case 'baiwu': { const o = free(k === 'heiwu' ? 'baiwu' : 'heiwu'); if (o && ag.cd.talk <= 0 && o.cd.talk <= 0) opts.push([4, () => startTalk(W, ag, o, true)]); break; }
      case 'niutou': case 'mamian': { const o = free(k === 'niutou' ? 'mamian' : 'niutou'); if (o) opts.push([4, () => startPatrol(W, ag, o)]); break; }
      case 'huang': opts.push([4, () => setPlan(ag, [{ act:'plaza_golf', d:0.9 + 4 * (1 + Math.floor(R() * 2)) + 0.7 }])]); break;
      case 'pontianak': { const b = SPOTS.banana[Math.floor(R() * 2)]; opts.push([3, () => setPlan(ag, goSteps(ag, b[0], b[1], { purpose:1 }).concat([{ act:'plaza_hair', d:4.6 + R() * 4, face:b[2] > 0 }]))], [1.5, () => setPlan(ag, [{ act:'plaza_hair', d:4.6 }])]); break; }
      case 'shuigui': opts.push([2, () => setPlan(ag, [{ act:'plaza_shake', d:1.8 }])]); break;
      case 'youhun': opts.push([2.2, () => setPlan(ag, [{ act:'plaza_spin', d:2.2 }])], [2, wander()]); break;
      case 'xiaogui': { const v = prankVictim(W, ag); if (v && ag.cd.prank <= 0) opts.push([4, () => startPrank(W, ag, v)]); break; }
      case 'toyol': opts.push([4, () => setPlan(ag, [{ act:'plaza_coins', d:5.5 + R() * 3.3 }])]); break;
      case 'pocong': opts.push([2, () => setPlan(ag, [{ act:'plaza_hop', d:1.3 + R() * 1.5 }])]); break;
    }
    pickW(opts)();
  }

  // ---- 兩隻碰面聊天（黑白無常是吵架）----
  function startTalk(W, a, b, argue) {
    const G = { kind:'talk', a, b, argue, spk:R() < 0.5 ? a : b, sw:0.8, T:argue ? 6 + R() * 4 : 3.5 + R() * 3 };
    a.lock = b.lock = G; a.cd.talk = b.cd.talk = 99;
    const d = Math.hypot(a.x - b.x, a.y - b.y);
    const act = argue ? 'plaza_argue' : 'plaza_talk';
    const g1 = R() < 0.5 ? 'plaza_wave' : 'plaza_bow', g2 = R() < 0.5 ? 'plaza_wave' : 'plaza_bow';
    let pre = [];
    if (argue && d > 30) { const mx = (a.x + b.x) / 2, my = (a.y + b.y) / 2; const q = nearZ(mx + (a.x < b.x ? -11 : 11), my); pre = goSteps(a, q[0], q[1], { purpose:1 }); }
    else if (d < 18 || Math.abs(a.y - b.y) > 6) { // 站到對方旁邊（同一排），面對面
      let side = a.x < b.x ? -1 : 1, q = nearZ(b.x + side * 21, b.y + (R() - 0.5) * 3);
      if (Math.abs(q[0] - b.x) < 15) { side = -side; q = nearZ(b.x + side * 21, b.y); }
      pre = goSteps(a, q[0], q[1], { purpose:1 });
    }
    G.t = 0; G.act = act;
    setPlan(a, pre.concat([{ fn:(x) => { x.want = b.x > x.x; } }, argue ? { act:'plaza_look', d:0.5 } : { act:g1, d:1.3, p:{ deep:0.7 } }, { act, d:60, p:{} }]));
    setPlan(b, [{ fn:(x) => { x.want = a.x > x.x; } }, { d:argue ? 0.3 : 0.35 }, argue ? { act:'plaza_look', d:0.5 } : { act:g2, d:1.3, p:{ deep:0.7 } }, { act, d:60, p:{} }]);
    W.games.push(G);
  }
  function endSocial(W, ag) {
    ag.lock = null; ag.cd.talk = 10 + R() * 12;
    const p = freePt(ag.W, ag); ag.q = goSteps(ag, p[0], p[1]); // 說完各走各的
  }

  // ---- 紙人追逐（小紙、紙人偶）----
  function startTag(W, a, b) {
    const G = { kind:'tag', ch:a, ru:b, T:9 + R() * 5, t:0, pause:0 };
    a.lock = b.lock = G; a.cd.tag = b.cd.tag = 99;
    a.q = []; b.q = []; a.cur = b.cur = null;
    W.games.push(G);
  }
  function tagTick(W, G, dt) {
    G.t += dt; const { ch, ru } = G;
    if (G.pause > 0) { G.pause -= dt; if (G.pause <= 0) { const x = G.ch; G.ch = G.ru; G.ru = x; } return; }
    if (G.t > G.T) { // 玩累了：喘一下
      for (const x of [ch, ru]) { x.lock = null; x.cd.tag = 18 + R() * 14; setPlan(x, [{ act:'plaza_bow', d:1.4, p:{ deep:0.6 } }]); }
      G.done = 1; return;
    }
    if (ru.st !== 'go' || Math.hypot(ru.x - ru.tx, ru.y - ru.ty) < 6) { // 往離鬼遠的地方跑
      let best = null, bs = -1; for (let i = 0; i < 6; i++) { const p = zonePt(); const sc = Math.hypot(p[0] - ch.x, p[1] - ch.y) - Math.hypot(p[0] - ru.x, p[1] - ru.y) * 0.3; if (sc > bs) { bs = sc; best = p; } }
      setPlan(ru, goSteps(ru, best[0], best[1], { run:1, spd:1.55, purpose:1 }));
    }
    if (!ch.cur || !ch.cur.go || ch.style.follow !== ru) setPlan(ch, [{ go:[ru.x, ru.y], style:{ follow:ru, chase:1, run:1, spd:1.7, purpose:1 } }]);
    if (Math.hypot(ch.x - ru.x, (ch.y - ru.y) * 1.4) < 11) { // 抓到！
      ch.want = ru.x > ch.x; ru.want = ch.x > ru.x;
      setPlan(ch, [{ act:'plaza_reach', d:0.5 }, { d:0.5 }]); setPlan(ru, [{ act:'plaza_eek', d:0.75 }, { d:0.25 }]);
      ch.fxTxt = { s:'抓到！', t:0 }; G.pause = 1.0;
    }
  }

  // ---- 小鬼惡作劇：躡手躡腳走到別人背後「哇！」----
  function prankVictim(W, x) {
    const c = W.list.filter(o => o !== x && !o.lock && o.k !== 'xiaogui' && o.act !== 'plaza_hang' && ((o.st === 'act' && o.dur - o.at > 3) || (o.st === 'idle' && o.dur - o.at > 1.5)));
    return c.length ? c[Math.floor(R() * c.length)] : null;
  }
  function startPrank(W, x, v) {
    const G = { kind:'prank', x, v, vx:v.x, vy:v.y };
    x.lock = v.lock = G; x.cd.prank = 99;
    const [bx, by] = nearZ(v.x - (v.face ? 1 : -1) * 17, v.y + 1);
    const dist = Math.hypot(bx - x.x, by - x.y), tt = dist / (x.vmax * 0.45) + 1.5;
    if (v.st === 'act') v.dur = Math.max(v.dur, v.at + tt + 1.2); else { v.dur = Math.max(v.dur, v.at + tt + 1.2); }
    setPlan(x, goSteps(x, bx, by, { sneak:1, spd:0.45, purpose:1 }).concat([{ fn:(a) => { a.want = v.x > a.x; } }, { d:0.35 }, { fn:() => { G.boo = 1; } }, { act:'plaza_boo', d:0.95 }, { act:'plaza_laugh', d:1.7 }, { fn:(a) => { a.lock = null; a.cd.prank = 22 + R() * 20; const p = freePt(W, a); a.q = goSteps(a, p[0], p[1], { run:1, spd:1.5 }); } }]));
    W.games.push(G);
  }
  function prankTick(W, G) {
    const { x, v } = G;
    if (!G.boo && Math.hypot(v.x - G.vx, v.y - G.vy) > 10) { // 對方走掉了：算了
      x.lock = v.lock = null; x.cd.prank = 10; setPlan(x, [{ act:'plaza_look', d:1.6 }]); G.done = 1; return;
    }
    if (G.boo === 1 && x.act === 'plaza_boo' && x.at > 0.2) {
      G.boo = 2; v.want = x.x > v.x;
      setPlan(v, [{ act:'plaza_startle', d:1.3 }, { act:'plaza_look', d:1.2 }, { fn:(a) => { a.lock = null; } }]);
      v.icon = '!'; v.iconT = 0; G.done = 1;
    }
  }

  // ---- 牛頭馬面：一前一後巡邏 ----
  function startPatrol(W, a, b) {
    const G = { kind:'patrol', a, b };
    a.lock = b.lock = G;
    const pts = [[170, 560], [226, 650], [340, 656], [200, 668], [50, 656], [190, 600]], st = Math.floor(R() * pts.length), steps = [];
    for (let i = 0; i < 4; i++) { const p = pts[(st + i) % pts.length]; steps.push({ go:p, style:{ stiff:1, purpose:1 } }, { act:'plaza_look', d:1.6 }); }
    steps.push({ fn:(x) => { x.lock = null; b.lock = null; b.q = []; G.done = 1; } });
    setPlan(a, steps);
    setPlan(b, [{ go:[a.x, a.y], style:{ follow:a, stiff:1, side:1, purpose:1, keep:1 } }]);
    W.games.push(G);
  }

  // ======================= 每幀更新 =======================
  const TURN = 0.22;
  function tick(ag, dt, W) {
    ag.at += dt; for (const k in ag.cd) ag.cd[k] -= dt; ag.iconT += dt; if (ag.fxTxt) ag.fxTxt.t += dt;
    const hopper = HOPPER[ag.k];
    if (ag.st === 'go') {
      const st = ag.style; let tx = ag.tx, ty = ag.ty, stopD = 1.2;
      if (st.follow) { const f = st.follow, fd = f.face ? 1 : -1; if (st.chase) { tx = f.x; ty = f.y; stopD = 0; } else if (st.side) { tx = f.x - fd * 8; ty = f.y + 12; stopD = 3; } else { tx = f.x - fd * 24; ty = f.y + 3; stopD = 4; } }
      if (st.seek) { const f = st.seek; if (f.lock || ag.at > 7) { next(ag); return; } tx = f.x + (ag.x < f.x ? -20 : 20); ty = f.y; }
      if ((st.seek || (st.follow && !st.chase)) && !(st.follow && st.follow.act === 'plaza_hang')) { const q = nearZ(tx, ty); tx = q[0]; ty = q[1]; }
      const dx = tx - ag.x, dy = ty - ag.y, d = Math.hypot(dx, dy), vm = ag.vmax * (st.spd || 1);
      let tsp = d <= stopD ? 0 : Math.min(vm, (d - stopD) * 2.4 + 2);
      if (st.follow && !st.chase && !st.keep && (ag.at > 9 || st.follow.act !== 'plaza_eat')) { next(ag); return; }
      ag.sp += (tsp - ag.sp) * Math.min(1, dt * (tsp < ag.sp ? 6 : 3.5));
      let mv = ag.sp * dt;
      if (hopper) { // 只在騰空時前進
        if (ag.hp < 0) ag.hp = 0;
        const air = ag.hp >= 0.22 && ag.hp <= 0.9; mv = air ? Math.min(d, (ag.sp > 0.5 ? 1 : 0) * 13 * dt / (0.68 * 0.62)) : 0;
      }
      if (d > 0.01) {
        const nx = ag.x + dx / d * Math.min(mv, d), ny = ag.y + dy / d * Math.min(mv, d), z0 = nearZ(ag.x, ag.y), z1 = nearZ(tx, ty);
        if (Math.hypot(z0[0] - ag.x, z0[1] - ag.y) < 0.5 && Math.hypot(z1[0] - tx, z1[1] - ty) < 0.5) { const q = nearZ(nx, ny); ag.x = q[0]; ag.y = q[1]; } // 在廣場裡走：貼著邊滑，不切過房角
        else { ag.x = nx; ag.y = ny; }
      }
      if (Math.abs(dx) > 2.5 && ag.sp > 2) ag.want = dx > 0;
      if (!st.follow && d < 1.5) { ag.sp = hopper ? 0 : ag.sp; next(ag); }
      if (st.follow && st.side && !st.follow.lock) { next(ag); }
    } else {
      ag.sp = Math.max(0, ag.sp - dt * ag.vmax * 3.2);
      if (ag.st === 'act' || ag.cur) { if (ag.at >= ag.dur) next(ag); }
      else if (ag.at >= ag.dur) { if (ag.q.length) next(ag); else choose(ag, W); }
      if (ag.act === 'plaza_bump') { if (ag._bkC !== ag.cur) { ag._bkC = ag.cur; ag._bk = 0; } const k = eo(seg(ag.at, 0.1, 0.55)), dir = ag.pl.dir || 1; ag.x -= dir * 10 * (k - ag._bk); ag._bk = k; }
      if (ag.act === 'plaza_look' && ag.at > 0.75 && !ag._lk) { ag._lk = 1; if (!ag.lock) ag.want = !ag.face; }
      if (ag.act !== 'plaza_look') ag._lk = 0;
    }
    // 跳的：一跳要跳完
    if (hopper) { if (ag.st === 'go' || ag.hp >= 0) { ag.hp += dt / 0.62; if (ag.hp >= 1) ag.hp = ag.st === 'go' ? ag.hp - 1 : -1; } }
    ag.w = hopper ? 0 : cl(ag.sp / (ag.vmax * 0.85));
    ag.wph += dt * (ag.sp / ag.vmax) * (ag.style.run ? 1.6 : ag.style.sneak ? 0.55 : 1);
    if (ag.act === 'plaza_eat' || ag.style.eat) ag.eatT += dt;
    // 聊天的：面對面
    const G = ag.lock;
    if (G && G.kind === 'talk') { const o = G.a === ag ? G.b : G.a; if (ag.st !== 'go') ag.want = o.x > ag.x; }
    // 轉身：像紙片翻面
    if (ag.want !== ag.face && ag.turnT >= TURN) ag.turnT = 0;
    if (ag.turnT < TURN) { ag.turnT += dt; if (ag.turnT >= TURN / 2 && !ag._flipped) { ag.face = ag.want; ag._flipped = 1; } if (ag.turnT >= TURN) ag._flipped = 0; }
    // 水鬼：滴水
    if (ag.k === 'shuigui') { ag.wetT -= dt; if (ag.wetT <= 0) { ag.wetT = ag.sp > 3 ? 0.32 : 0.9 + R() * 0.6; W.wet.push({ x:ag.x + (R() - 0.5) * 8, y:ag.y + (R() - 0.5) * 3, t:0, life:4 + R() * 2, r:1.8 + R() * 1.6, d:0 }); } }
  }
  function talkTick(G, dt) {
    const { a, b } = G; G.sw -= dt;
    const on = a.act === 'plaza_talk' || a.act === 'plaza_argue' || b.act === 'plaza_talk' || b.act === 'plaza_argue';
    if (on && G.sw <= 0) {
      G.spk = R() < 0.75 ? (G.spk === a ? b : a) : G.spk; G.sw = G.argue ? 0.6 + R() * 0.9 : 0.9 + R() * 0.8;
      const pool = G.argue ? (G.spk.k === 'heiwu' ? ['…', '…', '!'] : ['!', '?', '!', '…']) : ['…', '♪', '?', '!', '…'];
      G.spk.icon = pool[Math.floor(R() * pool.length)]; G.spk.iconT = 0;
    }
    for (const x of [a, b]) if (x.act === 'plaza_talk' || x.act === 'plaza_argue') x.pl.spk = G.spk === x;
    if (a.act === G.act && b.act === G.act) G.t += dt;
    if (G.t >= G.T || a.lock !== G || b.lock !== G) { // 聊完：點個頭，各走各的
      G.done = 1;
      [a, b].forEach((x, i) => { if (x.lock === G) setPlan(x, [{ d:i * 0.25 }, { act:'plaza_bow', d:0.9, p:{ deep:0.45 } }, { fn:(y) => endSocial(null, y) }]); });
    }
  }
  function update(W, dt, hero) {
    for (const ag of W.list) tick(ag, dt, W);
    for (const G of W.games) { if (G.done) continue; if (G.kind === 'tag') tagTick(W, G, dt); else if (G.kind === 'prank') prankTick(W, G); else if (G.kind === 'talk') talkTick(G, dt); else if (G.kind === 'patrol' && !G.a.lock) G.done = 1; }
    W.games = W.games.filter(G => !G.done);
    // 走著走著碰到了：停下來聊
    W.socT -= dt;
    const talks = W.games.filter(G => G.kind === 'talk').length, maxTalk = Math.max(1, Math.round(W.list.length / 7));
    if (W.socT <= 0 && talks < maxTalk) {
      W.socT = 0.25;
      const L = W.list;
      for (let i = 0; i < L.length; i++) for (let j = i + 1; j < L.length; j++) {
        const a = L[i], b = L[j]; if (!isFree(a) || !isFree(b) || a.cd.talk > 0 || b.cd.talk > 0) continue;
        if (Math.hypot(a.x - b.x, (a.y - b.y) * 1.6) < 30 && (a.st === 'go' || b.st === 'go' || (a.style.seek === b || b.style.seek === a)) && (a.style.seek === b || b.style.seek === a || R() < 0.12)) { startTalk(W, a, b, (a.k === 'heiwu' && b.k === 'baiwu') || (a.k === 'baiwu' && b.k === 'heiwu')); i = L.length; break; }
      }
    }
    // 別擠在一起
    for (const a of W.list) for (const b of W.list) {
      if (a === b || a.st === 'go' || a.act === 'plaza_hang' || (a.lock && a.lock === b.lock && a.lock.kind !== 'talk')) continue;
      const dx = a.x - b.x, dy = (a.y - b.y) * 1.8, d = Math.hypot(dx, dy), rr = a.lock && a.lock === b.lock ? 15 : 19; if (d > rr || d < 0.01) continue;
      const k = (rr - d) * dt * 1.2; a.x += dx / d * k; a.y += dy / d * k * 0.4; clampZ(a);
    }
    // 阿福經過：揮手打招呼
    W.heroT -= dt;
    if (hero && hero.walking && W.heroT <= 0) {
      const c = W.list.filter(o => o.st === 'idle' && !o.lock && !o.q.length && o.cd.hero <= 0 && Math.hypot(o.x - hero.x, (o.y - hero.y) * 1.5) < 46);
      if (c.length) { const o = c[Math.floor(R() * c.length)]; o.cd.hero = 25 + R() * 20; W.heroT = 4; setPlan(o, [{ act:R() < 0.7 ? 'plaza_wave' : 'plaza_bow', d:1.4, face:hero, p:{ deep:0.6 } }]); }
    }
    for (const w of W.wet) w.t += dt; W.wet = W.wet.filter(w => w.t < w.life);
  }

  // ======================= 畫 =======================
  function headY(ag) { return ag.y - (CH[ag.k] || 50) * SC - (SOLID[ag.k] ? 0 : 4); }
  function drawAgent(ctx, ag, t, opt) {
    const k = ag.k, T = t + ag.seed;
    const tk = ag.turnT < TURN ? Math.max(0.08, Math.abs(Math.cos(PI * ag.turnT / TURN))) : 1;
    ctx.save(); ctx.translate(ag.x, 0); ctx.scale(tk, 1); ctx.translate(-ag.x, 0);
    const act = ag.act || (ag.style.eat ? 'plaza_eat' : 'plaza_walk');
    ag._z = 0; ag._stars = 0;
    if (MeshAnim.has(k) && !(typeof SPECIAL !== 'undefined' && SPECIAL.has(k))) {
      const o = { t:T, act, at:act === 'plaza_eat' ? ag.eatT : ag.at, w:ag.w, wph:ag.wph, hp:ag.hp, run:ag.style.run ? cl(ag.w) : 0, sniff:ag.style.sniff, sneak:ag.style.sneak, stiff:ag.style.stiff, pl:ag.pl, flip:!ag.face, tamed:true, untied:true };
      ART.drawChar(ctx, k, ag.x, ag.y, SC, o);
      ag._z = o._z || 0; ag._stars = o._stars || 0; ag._zpos = o._zpos;
    } else drawSpecial(ctx, ag, T);
    ctx.restore();
    // 頭上的東西
    const hy = headY(ag), s = SC, fwd = ag.face ? 1 : -1;
    if (ag._z > 0.05) { const H = (CH[k] || 50) * SC, p = ag._zpos || [ag.x + fwd * 9, ag.y - H * (1 - (FACEV[k] || 0.3)) - (SOLID[k] ? 2 : 6)]; zzz(ctx, p[0], p[1], T, s, ag._z); }
    if (ag._stars > 0) stars(ctx, ag.x, hy + 2, T, s, ag._stars);
    if (ag.icon && ag.iconT < 1.25 && !(opt && opt.noIcon)) { const k2 = Math.min(1, ag.iconT * 6, (1.25 - ag.iconT) * 5); bubble(ctx, ag.x + fwd * 7, hy - 7 - Math.sin(Math.min(1, ag.iconT * 3) * PI) * 2, ag.icon, s, k2); }
    if (ag.fxTxt && ag.fxTxt.t < 1) txt(ctx, ag.x, hy - 6 - ag.fxTxt.t * 8, ag.fxTxt.s, 10 * s * 1.4, '#ffe9a8', Math.min(1, (1 - ag.fxTxt.t) * 3), 0.2);
  }
  function drawWet(ctx, w) {
    const k = 1 - w.t / w.life, g = Math.min(1, w.t * 6);
    ctx.save(); ctx.globalAlpha *= 0.5 * k; ctx.fillStyle = '#1d3440'; ctx.beginPath(); ctx.ellipse(w.x, w.y, w.r * (0.6 + 0.4 * g), w.r * 0.42 * (0.6 + 0.4 * g), 0, 0, TAU); ctx.fill();
    ctx.globalAlpha *= 0.8; ctx.fillStyle = '#6fa6bd'; ctx.beginPath(); ctx.ellipse(w.x - w.r * 0.25, w.y - w.r * 0.1, w.r * 0.3, w.r * 0.1, 0, 0, TAU); ctx.fill();
    if (w.t < 0.35) { ctx.globalAlpha = 0.7 * (1 - w.t / 0.35); ctx.strokeStyle = '#9fd0e6'; ctx.lineWidth = 0.6; ctx.beginPath(); ctx.ellipse(w.x, w.y, w.r * (1 + w.t * 6), w.r * 0.42 * (1 + w.t * 6), 0, 0, TAU); ctx.stroke(); }
    ctx.restore();
  }
  // 水鬼身上一直滴水（從衣服、頭髮掉到地上）
  function drawDrips(ctx, ag, t) {
    const H = (CH.shuigui) * SC;
    for (let i = 0; i < 3; i++) { const ph = (t * 0.9 + i * 0.37 + ag.seed) % 1, x = ag.x + (hash(i + Math.floor(t * 0.9 + i * 0.37 + ag.seed)) - 0.5) * H * 0.5, y0 = ag.y - H * (0.35 + 0.2 * hash(i * 3)); drop(ctx, x, y0 + (ag.y - y0) * ei(ph), 1.1, 0.8 * (1 - seg(ph, 0.85, 1))); }
  }

  function newWorld() { return { list:[], games:[], wet:[], socT:1, heroT:2, last:null, bld:{ wood:1 } }; }
  // 遊戲接口：Village.draw 每幀呼叫
  function frame(V, ghosts, items, vis, ctx, t) {
    const W = V.plaza || (V.plaza = newWorld());
    let dt = W.last == null ? 0 : t - W.last; W.last = t; dt = cl(dt, 0, 0.1);
    W.bld = (typeof S !== 'undefined' && S.bld) || W.bld;
    // 名單同步：新來的找空位出現，被派去打工的離開
    const ids = new Set(ghosts.map(g => g.id));
    W.list = W.list.filter(a => { if (ids.has(a.id)) return true; for (const G of W.games) if (G.a === a || G.b === a || G.ch === a || G.ru === a || G.x === a || G.v === a) { G.done = 1; for (const o of [G.a, G.b, G.ch, G.ru, G.x, G.v]) if (o && o !== a) { o.lock = null; o.q = []; o.cur = null; o.st = 'idle'; o.act = null; o.at = 0; o.dur = 0.5; o.style = {}; } } return false; });
    const have = new Set(W.list.map(a => a.id));
    ghosts.forEach((g, i) => { if (!have.has(g.id)) W.list.push(mkAgent(g, W.list.length, W)); });
    for (const a of W.list) a.g = ghosts.find(g => g.id === a.id) || a.g;
    update(W, dt, V.hero);
    for (const w of W.wet) items.push({ y:w.y - 40, f:() => drawWet(ctx, w) });
    for (const ag of W.list) {
      vis.push({ g:ag.g, x:ag.x, y:ag.y });
      const mute = V.bubble && V.bubble.id === ag.g.id && !V.bubble.hero;
      items.push({ y:ag.y, f:() => { drawAgent(ctx, ag, t, { noIcon:mute }); if (ag.k === 'shuigui') drawDrips(ctx, ag, t + ag.seed); } });
    }
  }
  return { frame, newWorld, update, drawAgent, drawWet, drawDrips, mkAgent, setPlan, choose, startTalk, startTag, startPrank, startPatrol, hangTimes, SPOTS, ZA, ZB, SC };
})();
