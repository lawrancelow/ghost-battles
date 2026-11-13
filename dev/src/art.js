// ===================== 美術（Canvas 程序繪製的 Q 版角色與建築）=====================
const ART = (() => {
  const TAU = Math.PI * 2;
  function el(ctx, x, y, rx, ry, fill, stroke, lw) {
    ctx.beginPath(); ctx.ellipse(x, y, Math.max(0.1,rx), Math.max(0.1,ry), 0, 0, TAU);
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (stroke) { ctx.lineWidth = lw || 1.5; ctx.strokeStyle = stroke; ctx.stroke(); }
  }
  function rr(ctx, x, y, w, h, r, fill, stroke, lw) {
    ctx.beginPath(); ctx.roundRect(x, y, w, h, r);
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (stroke) { ctx.lineWidth = lw || 1.5; ctx.strokeStyle = stroke; ctx.stroke(); }
  }
  function poly(ctx, pts, fill, stroke, lw) {
    ctx.beginPath(); ctx.moveTo(pts[0], pts[1]);
    for (let i = 2; i < pts.length; i += 2) ctx.lineTo(pts[i], pts[i + 1]);
    ctx.closePath();
    if (fill) { ctx.fillStyle = fill; ctx.fill(); }
    if (stroke) { ctx.lineWidth = lw || 1.5; ctx.strokeStyle = stroke; ctx.stroke(); }
  }
  const OUT = '#1a1426';
  // 眼睛
  function eyes(ctx, hx, hy, s, kind) {
    const dx = 5 * s, ey = hy + 1 * s;
    if (kind === 'tired') {
      el(ctx, hx - dx, ey, 2.6 * s, 2.6 * s, '#fff'); el(ctx, hx + dx, ey, 2.6 * s, 2.6 * s, '#fff');
      el(ctx, hx - dx, ey + 0.6 * s, 1.4 * s, 1.6 * s, OUT); el(ctx, hx + dx, ey + 0.6 * s, 1.4 * s, 1.6 * s, OUT);
      ctx.strokeStyle = '#7a5a9a'; ctx.lineWidth = 1.2 * s;
      ctx.beginPath(); ctx.arc(hx - dx, ey + 1.5 * s, 3 * s, 0.2, Math.PI - 0.2); ctx.stroke();
      ctx.beginPath(); ctx.arc(hx + dx, ey + 1.5 * s, 3 * s, 0.2, Math.PI - 0.2); ctx.stroke();
      ctx.fillStyle = OUT; ctx.fillRect(hx - dx - 3 * s, ey - 2.4 * s, 6 * s, 1.2 * s); ctx.fillRect(hx + dx - 3 * s, ey - 2.4 * s, 6 * s, 1.2 * s);
    } else if (kind === 'red') {
      el(ctx, hx - dx, ey, 2.4 * s, 2 * s, '#ff3355'); el(ctx, hx + dx, ey, 2.4 * s, 2 * s, '#ff3355');
      el(ctx, hx - dx, ey, 0.9 * s, 1.6 * s, '#300'); el(ctx, hx + dx, ey, 0.9 * s, 1.6 * s, '#300');
    } else if (kind === 'paper') {
      ctx.fillStyle = OUT; ctx.fillRect(hx - dx - 2 * s, ey - 0.5 * s, 4 * s, 1.4 * s); ctx.fillRect(hx + dx - 2 * s, ey - 0.5 * s, 4 * s, 1.4 * s);
    } else if (kind === 'closed') {
      ctx.strokeStyle = OUT; ctx.lineWidth = 1.4 * s;
      ctx.beginPath(); ctx.arc(hx - dx, ey - 0.5 * s, 2.4 * s, 0.1, Math.PI - 0.1); ctx.stroke();
      ctx.beginPath(); ctx.arc(hx + dx, ey - 0.5 * s, 2.4 * s, 0.1, Math.PI - 0.1); ctx.stroke();
    } else if (kind === 'big') {
      el(ctx, hx - dx, ey, 3.4 * s, 3.8 * s, '#fff'); el(ctx, hx + dx, ey, 3.4 * s, 3.8 * s, '#fff');
      el(ctx, hx - dx, ey + 0.5 * s, 2.3 * s, 2.8 * s, '#1a1a1a'); el(ctx, hx + dx, ey + 0.5 * s, 2.3 * s, 2.8 * s, '#1a1a1a');
      el(ctx, hx - dx + 1 * s, ey - 1 * s, 0.8 * s, 0.8 * s, '#fff'); el(ctx, hx + dx + 1 * s, ey - 1 * s, 0.8 * s, 0.8 * s, '#fff');
    } else if (kind === 'dot') {
      el(ctx, hx - dx, ey, 1.5 * s, 1.8 * s, OUT); el(ctx, hx + dx, ey, 1.5 * s, 1.8 * s, OUT);
    } else if (kind === 'angry') {
      el(ctx, hx - dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT); el(ctx, hx + dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT);
      ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.beginPath();
      ctx.moveTo(hx - dx - 3 * s, ey - 3.5 * s); ctx.lineTo(hx - dx + 2.5 * s, ey - 1.8 * s);
      ctx.moveTo(hx + dx + 3 * s, ey - 3.5 * s); ctx.lineTo(hx + dx - 2.5 * s, ey - 1.8 * s); ctx.stroke();
    } else { // normal
      el(ctx, hx - dx, ey, 2 * s, 2.4 * s, OUT); el(ctx, hx + dx, ey, 2 * s, 2.4 * s, OUT);
      el(ctx, hx - dx + 0.7 * s, ey - 0.8 * s, 0.7 * s, 0.7 * s, '#fff'); el(ctx, hx + dx + 0.7 * s, ey - 0.8 * s, 0.7 * s, 0.7 * s, '#fff');
    }
  }
  function mouth(ctx, hx, hy, s, kind) {
    const my = hy + 7 * s;
    ctx.strokeStyle = OUT; ctx.lineWidth = 1.2 * s;
    if (kind === 'smile') { ctx.beginPath(); ctx.arc(hx, my - 1.5 * s, 2.2 * s, 0.3, Math.PI - 0.3); ctx.stroke(); }
    else if (kind === 'flat') { ctx.beginPath(); ctx.moveTo(hx - 2 * s, my); ctx.lineTo(hx + 2 * s, my); ctx.stroke(); }
    else if (kind === 'open') { el(ctx, hx, my, 2.2 * s, 1.8 * s, '#5a1020'); }
    else if (kind === 'red') { el(ctx, hx, my - 0.5 * s, 1.6 * s, 1.1 * s, '#d0102a'); }
    else if (kind === 'fang') { el(ctx, hx, my, 2.6 * s, 1.6 * s, '#3a0510'); poly(ctx, [hx - 1.6 * s, my - 1.2 * s, hx - 0.8 * s, my + 0.8 * s, hx, my - 1.2 * s], '#fff'); poly(ctx, [hx + 1.6 * s, my - 1.2 * s, hx + 0.8 * s, my + 0.8 * s, hx, my - 1.2 * s], '#fff'); }
    else if (kind === 'wavy') { ctx.beginPath(); ctx.moveTo(hx - 3 * s, my); ctx.quadraticCurveTo(hx - 1.5 * s, my - 1.5 * s, hx, my); ctx.quadraticCurveTo(hx + 1.5 * s, my + 1.5 * s, hx + 3 * s, my); ctx.stroke(); }
  }
  function blush(ctx, hx, hy, s, c) {
    el(ctx, hx - 8 * s, hy + 4 * s, 2.6 * s, 1.6 * s, c || 'rgba(255,110,140,.45)');
    el(ctx, hx + 8 * s, hy + 4 * s, 2.6 * s, 1.6 * s, c || 'rgba(255,110,140,.45)');
  }
  function shadow(ctx, x, y, s) { el(ctx, x, y, 14 * s, 4 * s, 'rgba(0,0,0,.35)'); }

  // 共用 Q 版身形：短身體 + 大頭
  function body(ctx, x, y, s, col, w, h) {
    w = (w || 18) * s; h = (h || 18) * s;
    rr(ctx, x - w / 2, y - h, w, h, 6 * s, col, OUT, 1.6 * s);
  }
  function legs(ctx, x, y, s, col, ph) {
    const a = Math.sin(ph || 0) * 3 * s;
    rr(ctx, x - 6 * s + a, y - 6 * s, 5 * s, 6 * s, 2 * s, col, OUT, 1.2 * s);
    rr(ctx, x + 1 * s - a, y - 6 * s, 5 * s, 6 * s, 2 * s, col, OUT, 1.2 * s);
  }
  // 鬼的下半身：一縷往下收尖、會飄的魂尾（沒有腳）
  function wisp(ctx, x, y, s, col, t, w) {
    const sw = Math.sin(t * 3) * 3 * s, top = y - 9 * s;
    ctx.beginPath(); ctx.moveTo(x - w * s, top);
    ctx.bezierCurveTo(x - w * 0.95 * s, y - 2 * s, x - 3 * s + sw * 0.5, y + 1 * s, x + 2 * s + sw, y + 5 * s);
    ctx.quadraticCurveTo(x + 7 * s + sw * 1.3, y + 6 * s, x + 6 * s + sw, y + 2 * s);
    ctx.bezierCurveTo(x + w * 0.7 * s, y - 1 * s, x + w * s, y - 4 * s, x + w * s, top);
    ctx.closePath(); ctx.fillStyle = col; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.4 * s; ctx.stroke();
  }
  function ghostTail(ctx, x, y, s, col, t) {
    ctx.beginPath(); ctx.moveTo(x - 9 * s, y - 16 * s);
    ctx.quadraticCurveTo(x - 10 * s, y - 4 * s, x - 4 * s + Math.sin(t * 4) * 2 * s, y);
    ctx.quadraticCurveTo(x, y - 5 * s, x + 4 * s + Math.sin(t * 4 + 1) * 2 * s, y + 1 * s);
    ctx.quadraticCurveTo(x + 10 * s, y - 4 * s, x + 9 * s, y - 16 * s); ctx.closePath();
    ctx.fillStyle = col; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.stroke();
  }
  function arm(ctx, x1, y1, x2, y2, s, col) {
    ctx.strokeStyle = OUT; ctx.lineCap = 'round'; ctx.lineWidth = 5.4 * s;
    ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
    ctx.strokeStyle = col; ctx.lineWidth = 3.4 * s; ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
  }

  // ---------------- 各角色 ----------------
  const DRAW = {
    afu(ctx, x, y, s, o) {
      const t = o.t, hy = y - 34 * s;
      wisp(ctx, x, y, s, '#2b2f45', t, 8);
      body(ctx, x, y - 5 * s, s, '#eef1f8');
      poly(ctx, [x - 1.5 * s, y - 22 * s, x + 1.5 * s, y - 22 * s, x + 2.5 * s, y - 10 * s, x, y - 8 * s, x - 2.5 * s, y - 10 * s], '#c0283c', OUT, 1 * s); // 鬆掉的領帶
      rr(ctx, x + 3 * s, y - 15 * s, 5 * s, 6 * s, 1 * s, '#4a8ad8', OUT, 1 * s); // 工作證
      const sw = o.work ? Math.sin(t * 12) : 0;
      arm(ctx, x - 8 * s, y - 19 * s, x - 12 * s, y - 10 * s, s, '#eef1f8');
      const ax = x + 12 * s + sw * 3 * s, ay = y - 14 * s - sw * 6 * s;
      arm(ctx, x + 8 * s, y - 19 * s, ax, ay, s, '#eef1f8');
      if (o.tool !== false) { // 斧頭
        ctx.save(); ctx.translate(ax, ay); ctx.rotate(-0.9 + sw * 0.9);
        rr(ctx, -1.2 * s, -14 * s, 2.4 * s, 16 * s, 1 * s, '#8a5a2b', OUT, 1 * s);
        poly(ctx, [1 * s, -14 * s, 8 * s, -16 * s, 8 * s, -8 * s, 1 * s, -10 * s], '#b8c2d0', OUT, 1 * s);
        ctx.restore();
      }
      el(ctx, x, hy, 14 * s, 13 * s, '#dfe6f5', OUT, 1.8 * s);
      ctx.fillStyle = '#20232f'; ctx.beginPath(); ctx.ellipse(x, hy - 6 * s, 14.5 * s, 8.5 * s, 0, Math.PI, TAU); ctx.fill();
      poly(ctx, [x - 14 * s, hy - 6 * s, x - 6 * s, hy - 4 * s, x - 2 * s, hy - 9 * s, x + 4 * s, hy - 4 * s, x + 14 * s, hy - 6 * s, x + 12 * s, hy - 12 * s, x - 12 * s, hy - 12 * s], '#20232f');
      eyes(ctx, x, hy + 1 * s, s, 'tired'); mouth(ctx, x, hy, s, o.mood === 'happy' ? 'smile' : 'wavy');
      // 魂火
      el(ctx, x + 12 * s, hy - 13 * s + Math.sin(t * 3) * 1.5 * s, 2.5 * s, 3.5 * s, 'rgba(140,220,255,.75)');
    },
    xiaozhi(ctx, x, y, s, o) {
      const t = o.t, hy = y - 33 * s;
      legs(ctx, x, y, s, '#f6efe3', o.walk ? t * 10 : 0);
      poly(ctx, [x - 10 * s, y - 5 * s, x + 10 * s, y - 5 * s, x + 7 * s, y - 23 * s, x - 7 * s, y - 23 * s], '#e84a5f', OUT, 1.5 * s);
      ctx.fillStyle = '#ffd25a'; ctx.fillRect(x - 10 * s, y - 9 * s, 20 * s, 2 * s);
      const sw = o.work ? Math.sin(t * 10) * 3 * s : 0;
      arm(ctx, x - 7 * s, y - 20 * s, x - 11 * s, y - 12 * s + sw, s, '#f6efe3');
      arm(ctx, x + 7 * s, y - 20 * s, x + 11 * s, y - 12 * s - sw, s, '#f6efe3');
      el(ctx, x, hy, 13 * s, 12.5 * s, '#fbf6ec', OUT, 1.8 * s);
      ctx.fillStyle = '#16131c'; ctx.beginPath(); ctx.ellipse(x, hy - 4 * s, 13.5 * s, 9 * s, 0, Math.PI, TAU); ctx.fill();
      el(ctx, x - 11 * s, hy - 10 * s, 5 * s, 5 * s, '#16131c'); el(ctx, x + 11 * s, hy - 10 * s, 5 * s, 5 * s, '#16131c');
      el(ctx, x - 11 * s, hy - 10 * s, 1.8 * s, 1.8 * s, '#e84a5f'); el(ctx, x + 11 * s, hy - 10 * s, 1.8 * s, 1.8 * s, '#e84a5f');
      eyes(ctx, x, hy + 1 * s, s, 'paper'); blush(ctx, x, hy, s, '#ff6f8a'); mouth(ctx, x, hy, s, 'red');
    },
    zhiren(ctx, x, y, s, o) {
      const t = o.t, hy = y - 32 * s;
      legs(ctx, x, y, s, '#f6efe3', o.walk ? t * 10 : 0);
      poly(ctx, [x - 10 * s, y - 5 * s, x + 10 * s, y - 5 * s, x + 7 * s, y - 22 * s, x - 7 * s, y - 22 * s], '#3a8ad6', OUT, 1.5 * s);
      ctx.fillStyle = '#ffd25a'; ctx.fillRect(x - 10 * s, y - 9 * s, 20 * s, 2 * s);
      arm(ctx, x - 7 * s, y - 19 * s, x - 11 * s, y - 11 * s, s, '#f6efe3');
      arm(ctx, x + 7 * s, y - 19 * s, x + 11 * s, y - 11 * s, s, '#f6efe3');
      el(ctx, x, hy, 12.5 * s, 12 * s, '#fbf6ec', OUT, 1.8 * s);
      ctx.fillStyle = '#16131c'; ctx.beginPath(); ctx.ellipse(x, hy - 5 * s, 13 * s, 7.5 * s, 0, Math.PI, TAU); ctx.fill();
      el(ctx, x, hy - 13 * s, 4 * s, 3 * s, '#16131c');
      eyes(ctx, x, hy + 1 * s, s, 'paper'); blush(ctx, x, hy, s, '#ff6f8a'); mouth(ctx, x, hy, s, 'red');
    },
    youhun(ctx, x, y, s, o) {
      const t = o.t, hy = y - 26 * s - Math.sin(t * 3) * 2 * s;
      ctx.globalAlpha *= 0.88;
      ghostTail(ctx, x, y - Math.sin(t * 3) * 2 * s, s, '#dfeaff', t);
      el(ctx, x, hy, 12 * s, 12 * s, '#e9f1ff', OUT, 1.6 * s);
      eyes(ctx, x, hy + 1 * s, s, o.enemy ? 'angry' : 'dot'); mouth(ctx, x, hy, s, 'open');
      el(ctx, x + 10 * s, hy - 10 * s, 2 * s, 3 * s, 'rgba(160,230,255,.8)');
    },
    egui(ctx, x, y, s, o) {
      const t = o.t, hy = y - 34 * s;
      wisp(ctx, x, y, s, '#9cb38a', t, 7);
      el(ctx, x, y - 13 * s, 12 * s, 10 * s, '#9cb38a', OUT, 1.6 * s); // 大肚
      ctx.strokeStyle = '#6a7d5c'; ctx.lineWidth = 1 * s; ctx.beginPath(); ctx.arc(x, y - 13 * s, 2 * s, 0, TAU); ctx.stroke();
      rr(ctx, x - 1.2 * s, y - 25 * s, 2.4 * s, 5 * s, 1 * s, '#9cb38a', OUT, 1 * s); // 細頸
      arm(ctx, x - 9 * s, y - 16 * s, x - 13 * s, y - 22 * s + Math.sin(t * 6) * 2 * s, s, '#9cb38a');
      arm(ctx, x + 9 * s, y - 16 * s, x + 13 * s, y - 22 * s - Math.sin(t * 6) * 2 * s, s, '#9cb38a');
      el(ctx, x, hy, 11 * s, 10 * s, '#a9c196', OUT, 1.6 * s);
      eyes(ctx, x, hy, s, 'big'); mouth(ctx, x, hy - 1 * s, s, 'open');
    },
    eguiking(ctx, x, y, s, o) {
      const t = o.t, hy = y - 42 * s;
      wisp(ctx, x, y, s, '#7f9c6e', t, 11);
      el(ctx, x, y - 17 * s, 17 * s, 14 * s, '#7f9c6e', OUT, 1.8 * s);
      ctx.fillStyle = '#c33'; ctx.fillRect(x - 17 * s, y - 20 * s, 34 * s, 3 * s); // 腰帶
      rr(ctx, x - 1.5 * s, y - 34 * s, 3 * s, 5 * s, 1 * s, '#7f9c6e', OUT, 1 * s);
      arm(ctx, x - 14 * s, y - 22 * s, x - 20 * s, y - 30 * s + Math.sin(t * 5) * 2 * s, s * 1.3, '#7f9c6e');
      arm(ctx, x + 14 * s, y - 22 * s, x + 20 * s, y - 30 * s, s * 1.3, '#7f9c6e');
      el(ctx, x + 22 * s, y - 33 * s, 5 * s, 4 * s, '#fff', OUT, 1 * s); // 手上的包子
      el(ctx, x, hy, 13 * s, 12 * s, '#8eae7b', OUT, 1.8 * s);
      poly(ctx, [x - 9 * s, hy - 9 * s, x - 6 * s, hy - 17 * s, x - 2 * s, hy - 10 * s, x + 2 * s, hy - 17 * s, x + 6 * s, hy - 10 * s, x + 9 * s, hy - 17 * s, x + 10 * s, hy - 8 * s], '#e0b23a', OUT, 1.2 * s); // 皇冠
      eyes(ctx, x, hy, s, 'angry'); mouth(ctx, x, hy, s, 'fang');
    },
    xiaogui(ctx, x, y, s, o) {
      const t = o.t, hy = y - 24 * s;
      wisp(ctx, x, y, s, '#7da59a', t, 6);
      el(ctx, x, y - 9 * s, 7 * s, 6 * s, '#7da59a', OUT, 1.4 * s);
      el(ctx, x, hy, 11 * s, 10.5 * s, '#8fb8ac', OUT, 1.6 * s);
      poly(ctx, [x - 10 * s, hy - 2 * s, x - 17 * s, hy - 5 * s, x - 10 * s, hy + 3 * s], '#8fb8ac', OUT, 1.2 * s);
      poly(ctx, [x + 10 * s, hy - 2 * s, x + 17 * s, hy - 5 * s, x + 10 * s, hy + 3 * s], '#8fb8ac', OUT, 1.2 * s);
      eyes(ctx, x, hy, s, o.enemy ? 'red' : 'big'); mouth(ctx, x, hy - 1 * s, s, 'smile');
    },
    toyol(ctx, x, y, s, o) {
      const t = o.t, hy = y - 26 * s;
      wisp(ctx, x, y, s, '#5e9b7c', t, 6.5);
      el(ctx, x, y - 10 * s, 8 * s, 7 * s, '#5e9b7c', OUT, 1.4 * s);
      rr(ctx, x - 7 * s, y - 12 * s, 14 * s, 6 * s, 2 * s, '#f2f2f2', OUT, 1 * s); // 尿布
      arm(ctx, x + 7 * s, y - 13 * s, x + 12 * s, y - 18 * s, s, '#5e9b7c');
      el(ctx, x + 14 * s, y - 20 * s, 4 * s, 3 * s, '#e6c25a', OUT, 1 * s); // 偷來的錢袋
      el(ctx, x, hy, 12 * s, 11.5 * s, '#6cad8b', OUT, 1.6 * s);
      poly(ctx, [x - 11 * s, hy - 1 * s, x - 18 * s, hy - 7 * s, x - 11 * s, hy + 4 * s], '#6cad8b', OUT, 1.2 * s);
      poly(ctx, [x + 11 * s, hy - 1 * s, x + 18 * s, hy - 7 * s, x + 11 * s, hy + 4 * s], '#6cad8b', OUT, 1.2 * s);
      eyes(ctx, x, hy + 1 * s, s, o.enemy ? 'red' : 'big'); mouth(ctx, x, hy, s, 'smile');
    },
    zombie(ctx, x, y, s, o) { DRAW.laojiang(ctx, x, y, s * 0.88, Object.assign({}, o, { minor: true })); },
    laojiang(ctx, x, y, s, o) {
      const t = o.t, hop = Math.abs(Math.sin(t * 5)) * (o.walk || o.enemy ? 5 : 1.5) * s;
      y -= hop; const hy = y - 36 * s;
      rr(ctx, x - 6 * s, y - 6 * s, 5 * s, 6 * s, 1 * s, '#222', OUT, 1 * s); rr(ctx, x + 1 * s, y - 6 * s, 5 * s, 6 * s, 1 * s, '#222', OUT, 1 * s);
      const rob = o.minor ? '#3b5d8a' : '#26386b';
      poly(ctx, [x - 11 * s, y - 5 * s, x + 11 * s, y - 5 * s, x + 9 * s, y - 25 * s, x - 9 * s, y - 25 * s], rob, OUT, 1.6 * s);
      rr(ctx, x - 6 * s, y - 21 * s, 12 * s, 9 * s, 1 * s, '#c79a3a', OUT, 1 * s); // 補子
      el(ctx, x, y - 16.5 * s, 2.5 * s, 2.5 * s, '#fff');
      arm(ctx, x - 8 * s, y - 22 * s, x - 6 * s, y - 24 * s - 0, s, rob);
      ctx.strokeStyle = OUT; ctx.lineWidth = 5 * s; ctx.lineCap = 'round';
      ctx.beginPath(); ctx.moveTo(x - 6 * s, y - 23 * s); ctx.lineTo(x + 14 * s, y - 24 * s); ctx.moveTo(x + 6 * s, y - 21 * s); ctx.lineTo(x + 16 * s, y - 21 * s); ctx.stroke();
      ctx.strokeStyle = rob; ctx.lineWidth = 3 * s;
      ctx.beginPath(); ctx.moveTo(x - 6 * s, y - 23 * s); ctx.lineTo(x + 14 * s, y - 24 * s); ctx.moveTo(x + 6 * s, y - 21 * s); ctx.lineTo(x + 16 * s, y - 21 * s); ctx.stroke();
      el(ctx, x + 15.5 * s, y - 24 * s, 2 * s, 1.8 * s, '#b8d0b0', OUT, 0.8 * s); el(ctx, x + 17 * s, y - 21 * s, 2 * s, 1.8 * s, '#b8d0b0', OUT, 0.8 * s);
      el(ctx, x, hy, 12.5 * s, 12 * s, '#b8d0b0', OUT, 1.8 * s);
      // 清朝官帽
      el(ctx, x, hy - 9 * s, 15 * s, 4 * s, '#1c1c1c', OUT, 1.2 * s);
      ctx.fillStyle = '#1c1c1c'; ctx.beginPath(); ctx.ellipse(x, hy - 10 * s, 10 * s, 7 * s, 0, Math.PI, TAU); ctx.fill();
      ctx.strokeStyle = '#b22'; ctx.lineWidth = 1.2 * s; for (let i = -3; i <= 3; i++) { ctx.beginPath(); ctx.moveTo(x, hy - 17 * s); ctx.lineTo(x + i * 3 * s, hy - 10 * s); ctx.stroke(); }
      el(ctx, x, hy - 17.5 * s, 2 * s, 2 * s, o.minor ? '#2a7' : '#d22', OUT, 0.8 * s);
      // 符
      const fl = Math.sin(t * 6) * 1.5 * s;
      poly(ctx, [x - 3 * s, hy - 6 * s, x + 3 * s, hy - 6 * s, x + 3.5 * s + fl, hy + 9 * s, x - 2.5 * s + fl, hy + 9 * s], '#f3d24a', '#a5741a', 0.8 * s);
      ctx.strokeStyle = '#c41'; ctx.lineWidth = 0.9 * s; ctx.beginPath(); ctx.moveTo(x, hy - 4 * s); ctx.lineTo(x + fl * 0.6, hy + 7 * s); ctx.moveTo(x - 1.5 * s, hy); ctx.lineTo(x + 1.5 * s, hy); ctx.stroke();
      el(ctx, x - 6 * s, hy + 1 * s, 1.4 * s, 1.4 * s, OUT); el(ctx, x + 6 * s, hy + 1 * s, 1.4 * s, 1.4 * s, OUT);
      mouth(ctx, x, hy + 1 * s, s, 'flat');
    },
    shuigui(ctx, x, y, s, o) {
      const t = o.t, hy = y - 32 * s;
      wisp(ctx, x, y, s, '#4c7c8a', t, 8);
      body(ctx, x, y - 5 * s, s, '#4c7c8a');
      for (let i = 0; i < 3; i++) el(ctx, x - 6 * s + i * 6 * s, y - 2 * s + ((t * 30 + i * 9) % 8) * s, 1 * s, 1.5 * s, 'rgba(140,200,230,.8)');
      arm(ctx, x - 8 * s, y - 18 * s, x - 13 * s, y - 9 * s, s, '#6aa0ae'); arm(ctx, x + 8 * s, y - 18 * s, x + 13 * s, y - 9 * s, s, '#6aa0ae');
      el(ctx, x, hy, 12 * s, 12 * s, '#8cc0cc', OUT, 1.6 * s);
      ctx.fillStyle = '#163238'; ctx.beginPath(); ctx.ellipse(x, hy - 3 * s, 13 * s, 10 * s, 0, Math.PI, TAU); ctx.fill();
      for (let i = -2; i <= 2; i++) rr(ctx, x + i * 4.5 * s - 1.5 * s, hy - 4 * s, 3 * s, 9 * s + Math.abs(i) * 2 * s, 1.5 * s, '#163238');
      eyes(ctx, x, hy + 2 * s, s, o.enemy ? 'red' : 'dot'); mouth(ctx, x, hy + 1 * s, s, 'wavy');
    },
    pontianak(ctx, x, y, s, o) {
      const t = o.t, fl = Math.sin(t * 2.5) * 2 * s; y -= 3 * s + fl; const hy = y - 36 * s;
      ctx.fillStyle = '#0d0a12'; ctx.beginPath(); ctx.moveTo(x - 13 * s, hy - 2 * s);
      ctx.quadraticCurveTo(x - 17 * s, y - 10 * s, x - 12 * s + Math.sin(t * 3) * 2 * s, y - 2 * s); ctx.lineTo(x + 12 * s + Math.sin(t * 3 + 1) * 2 * s, y - 2 * s);
      ctx.quadraticCurveTo(x + 17 * s, y - 10 * s, x + 13 * s, hy - 2 * s); ctx.fill(); // 長髮
      poly(ctx, [x - 9 * s, y - 25 * s, x + 9 * s, y - 25 * s, x + 13 * s, y + 2 * s, x - 13 * s, y + 2 * s], '#f4f2f6', OUT, 1.6 * s);
      ctx.strokeStyle = '#cfcbe0'; ctx.lineWidth = 1 * s; for (let i = -2; i <= 2; i++) { ctx.beginPath(); ctx.moveTo(x + i * 3 * s, y - 20 * s); ctx.lineTo(x + i * 4.5 * s, y + 1 * s); ctx.stroke(); }
      const sw = o.atk ? 6 * s : 0;
      arm(ctx, x - 8 * s, y - 22 * s, x - 13 * s, y - 13 * s, s, '#f4f2f6'); arm(ctx, x + 8 * s, y - 22 * s, x + 14 * s + sw, y - 16 * s - sw, s, '#f4f2f6');
      ctx.strokeStyle = '#b8b0c8'; ctx.lineWidth = 1 * s; for (let i = 0; i < 3; i++) { ctx.beginPath(); ctx.moveTo(x + 14 * s + sw, y - 16 * s - sw + i * s); ctx.lineTo(x + 19 * s + sw, y - 18 * s - sw + i * 2 * s); ctx.stroke(); }
      el(ctx, x, hy, 12 * s, 12.5 * s, '#efe9f2', OUT, 1.8 * s);
      ctx.fillStyle = '#0d0a12'; ctx.beginPath(); ctx.ellipse(x, hy - 2 * s, 13 * s, 11 * s, 0, Math.PI, TAU); ctx.fill();
      rr(ctx, x - 13 * s, hy - 3 * s, 5 * s, 15 * s, 2 * s, '#0d0a12'); rr(ctx, x + 8 * s, hy - 3 * s, 5 * s, 15 * s, 2 * s, '#0d0a12');
      if (o.tamed) { eyes(ctx, x, hy + 2 * s, s, 'closed'); blush(ctx, x, hy + 1 * s, s); mouth(ctx, x, hy + 1 * s, s, 'smile'); }
      else { eyes(ctx, x, hy + 2 * s, s, 'red'); mouth(ctx, x, hy + 1 * s, s, 'fang'); }
    },
    pocong(ctx, x, y, s, o) {
      const t = o.t, hop = Math.abs(Math.sin(t * 5)) * 6 * s; y -= hop; const hy = y - 34 * s;
      el(ctx, x, y - 14 * s, 11 * s, 16 * s, '#f1efe8', OUT, 1.8 * s);
      ctx.strokeStyle = '#c9c4b4'; ctx.lineWidth = 1.2 * s;
      for (let i = 0; i < 3; i++) { ctx.beginPath(); ctx.moveTo(x - 10 * s, y - 22 * s + i * 7 * s); ctx.quadraticCurveTo(x, y - 18 * s + i * 7 * s, x + 10 * s, y - 22 * s + i * 7 * s); ctx.stroke(); }
      ctx.strokeStyle = '#9b927a'; ctx.lineWidth = 1.6 * s; ctx.beginPath(); ctx.moveTo(x - 9 * s, y - 4 * s); ctx.lineTo(x + 9 * s, y - 4 * s); ctx.stroke();
      el(ctx, x, hy, 12 * s, 12.5 * s, '#f1efe8', OUT, 1.8 * s);
      el(ctx, x, hy + 2 * s, 7.5 * s, 8 * s, '#cfd6c9', OUT, 1 * s);
      if (!o.untied) { poly(ctx, [x, hy - 12 * s, x - 5 * s, hy - 20 * s, x + 1 * s, hy - 16 * s], '#f1efe8', OUT, 1.2 * s); poly(ctx, [x, hy - 12 * s, x + 6 * s, hy - 20 * s, x + 1 * s, hy - 16 * s], '#f1efe8', OUT, 1.2 * s); }
      else { el(ctx, x, hy - 12 * s, 3 * s, 2 * s, '#f1efe8', OUT, 1 * s); arm(ctx, x + 9 * s, y - 20 * s, x + 14 * s, y - 34 * s, s, '#f1efe8'); }
      eyes(ctx, x, hy + 2.5 * s, s * 0.8, o.enemy ? 'red' : 'dot'); mouth(ctx, x, hy - 0.5 * s, s * 0.8, 'open');
    },
    penanggal(ctx, x, y, s, o) {
      const t = o.t; const hy = y - 40 * s + Math.sin(t * 2.5) * 3 * s;
      for (let i = 0; i < 4; i++) { // 下垂的「彩帶」（Q 版化處理）
        ctx.strokeStyle = ['#e0607a', '#c84466', '#f08aa0', '#b8385a'][i]; ctx.lineWidth = 3 * s; ctx.lineCap = 'round'; ctx.beginPath();
        const bx = x - 6 * s + i * 4 * s; ctx.moveTo(bx, hy + 8 * s);
        ctx.bezierCurveTo(bx + Math.sin(t * 3 + i) * 5 * s, hy + 18 * s, bx - Math.sin(t * 3 + i) * 5 * s, hy + 26 * s, bx + Math.sin(t * 2 + i) * 3 * s, hy + 34 * s); ctx.stroke();
      }
      el(ctx, x, hy, 13 * s, 12.5 * s, '#e8d4c4', OUT, 1.8 * s);
      ctx.fillStyle = '#1b0f14'; ctx.beginPath(); ctx.ellipse(x, hy - 3 * s, 14 * s, 11 * s, 0, Math.PI, TAU); ctx.fill();
      for (let i = -3; i <= 3; i++) { ctx.strokeStyle = '#1b0f14'; ctx.lineWidth = 2.5 * s; ctx.beginPath(); ctx.moveTo(x + i * 4 * s, hy - 6 * s); ctx.quadraticCurveTo(x + i * 6 * s + Math.sin(t * 4 + i) * 3 * s, hy - 16 * s, x + i * 7 * s, hy - 22 * s); ctx.stroke(); }
      rr(ctx, x - 14 * s, hy - 3 * s, 4 * s, 10 * s, 2 * s, '#1b0f14'); rr(ctx, x + 10 * s, hy - 3 * s, 4 * s, 10 * s, 2 * s, '#1b0f14');
      eyes(ctx, x, hy + 1 * s, s, o.enemy ? 'red' : 'normal'); mouth(ctx, x, hy, s, o.enemy ? 'fang' : 'smile');
    },
    mengpo(ctx, x, y, s, o) {
      const t = o.t, hy = y - 32 * s;
      wisp(ctx, x, y, s, '#6b4a7a', t, 9);
      poly(ctx, [x - 11 * s, y - 5 * s, x + 11 * s, y - 5 * s, x + 8 * s, y - 23 * s, x - 8 * s, y - 23 * s], '#6b4a7a', OUT, 1.6 * s);
      rr(ctx, x - 8 * s, y - 16 * s, 16 * s, 11 * s, 2 * s, '#e9e1d2', OUT, 1 * s); // 圍裙
      arm(ctx, x - 8 * s, y - 20 * s, x - 12 * s, y - 12 * s, s, '#6b4a7a');
      const sw = o.work ? Math.sin(t * 8) * 3 * s : 0;
      arm(ctx, x + 8 * s, y - 20 * s, x + 13 * s, y - 16 * s + sw, s, '#6b4a7a');
      el(ctx, x + 15 * s, y - 13 * s + sw, 5 * s, 3 * s, '#c9b38a', OUT, 1 * s); // 碗
      el(ctx, x + 15 * s, y - 14 * s + sw, 3.5 * s, 1.4 * s, '#7a6a9a');
      el(ctx, x, hy, 12.5 * s, 12 * s, '#e8d8c8', OUT, 1.8 * s);
      ctx.fillStyle = '#d8d8d8'; ctx.beginPath(); ctx.ellipse(x, hy - 4 * s, 13 * s, 9 * s, 0, Math.PI, TAU); ctx.fill();
      el(ctx, x, hy - 13 * s, 6 * s, 5 * s, '#d8d8d8', OUT, 1 * s); ctx.fillStyle = '#c33'; ctx.fillRect(x - 1 * s, hy - 18 * s, 2 * s, 6 * s);
      eyes(ctx, x, hy + 1 * s, s, 'closed'); mouth(ctx, x, hy, s, 'smile');
      ctx.strokeStyle = 'rgba(80,60,40,.5)'; ctx.lineWidth = 0.8 * s; ctx.beginPath(); ctx.moveTo(x - 9 * s, hy + 6 * s); ctx.lineTo(x - 6 * s, hy + 7 * s); ctx.moveTo(x + 9 * s, hy + 6 * s); ctx.lineTo(x + 6 * s, hy + 7 * s); ctx.stroke();
    },
    wuchang(ctx, x, y, s, o, white) {
      const t = o.t, hy = y - 36 * s, col = white ? '#f2f2f6' : '#22222c', skin = white ? '#f4f4fa' : '#5a5a6a';
      wisp(ctx, x, y, s, col, t, 10);
      poly(ctx, [x - 12 * s, y - 5 * s, x + 12 * s, y - 5 * s, x + 9 * s, y - 26 * s, x - 9 * s, y - 26 * s], col, OUT, 1.6 * s);
      arm(ctx, x - 8 * s, y - 22 * s, x - 13 * s, y - 12 * s, s, col);
      arm(ctx, x + 8 * s, y - 22 * s, x + 14 * s, y - 16 * s, s, col);
      if (white) { rr(ctx, x + 13 * s, y - 34 * s, 2 * s, 24 * s, 1 * s, '#8a6a3a', OUT, 0.8 * s); el(ctx, x + 14 * s, y - 35 * s, 5 * s, 4 * s, '#f8f8ff', OUT, 1 * s); } // 哭喪棒
      else { ctx.strokeStyle = '#8890a0'; ctx.lineWidth = 2 * s; ctx.setLineDash([2.5 * s, 1.5 * s]); ctx.beginPath(); ctx.moveTo(x + 14 * s, y - 16 * s); ctx.quadraticCurveTo(x + 20 * s, y - 6 * s, x + 12 * s, y - 2 * s); ctx.stroke(); ctx.setLineDash([]); } // 鎖鏈
      el(ctx, x, hy, 12.5 * s, 12 * s, skin, OUT, 1.8 * s);
      // 高帽
      poly(ctx, [x - 10 * s, hy - 8 * s, x + 10 * s, hy - 8 * s, x + 5 * s, hy - 36 * s, x - 5 * s, hy - 36 * s], col, OUT, 1.6 * s);
      ctx.save(); ctx.fillStyle = white ? '#c41a2a' : '#e8e8f0'; ctx.font = `bold ${5.2 * s}px "PingFang TC","Noto Sans TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
      const txt = white ? '一見生財' : '天下太平'; for (let i = 0; i < 4; i++) ctx.fillText(txt[i], x, hy - 31 * s + i * 5.6 * s); ctx.restore();
      if (white) { eyes(ctx, x, hy + 2 * s, s, 'closed'); poly(ctx, [x - 1.5 * s, hy + 6 * s, x + 1.5 * s, hy + 6 * s, x + 1 * s, hy + 16 * s, x - 1 * s, hy + 16 * s], '#d22', OUT, 0.8 * s); } // 長舌
      else { eyes(ctx, x, hy + 2 * s, s, 'angry'); mouth(ctx, x, hy + 1 * s, s, 'flat'); }
    },
    baiwu(ctx, x, y, s, o) { DRAW.wuchang(ctx, x, y, s, o, true); },
    heiwu(ctx, x, y, s, o) { DRAW.wuchang(ctx, x, y, s, o, false); },
    niutou(ctx, x, y, s, o) {
      const t = o.t, hy = y - 36 * s;
      wisp(ctx, x, y, s, '#7a4a32', t, 10);
      body(ctx, x, y - 5 * s, s * 1.15, '#7a4a32');
      rr(ctx, x - 9 * s, y - 20 * s, 18 * s, 8 * s, 2 * s, '#9a9aa8', OUT, 1 * s); // 甲
      arm(ctx, x - 10 * s, y - 20 * s, x - 15 * s, y - 10 * s, s * 1.2, '#7a4a32'); arm(ctx, x + 10 * s, y - 20 * s, x + 16 * s, y - 13 * s, s * 1.2, '#7a4a32');
      rr(ctx, x + 15 * s, y - 40 * s, 2.5 * s, 34 * s, 1 * s, '#5a3a1a', OUT, 0.8 * s); poly(ctx, [x + 16 * s, y - 46 * s, x + 21 * s, y - 38 * s, x + 11 * s, y - 38 * s], '#bfc8d6', OUT, 1 * s);
      el(ctx, x, hy, 14 * s, 12 * s, '#8a5a3c', OUT, 1.8 * s);
      poly(ctx, [x - 12 * s, hy - 6 * s, x - 22 * s, hy - 16 * s, x - 9 * s, hy - 10 * s], '#efe6cf', OUT, 1.2 * s);
      poly(ctx, [x + 12 * s, hy - 6 * s, x + 22 * s, hy - 16 * s, x + 9 * s, hy - 10 * s], '#efe6cf', OUT, 1.2 * s);
      el(ctx, x, hy + 6 * s, 8 * s, 5 * s, '#c09078', OUT, 1 * s); el(ctx, x - 3 * s, hy + 6 * s, 1.2 * s, 1.5 * s, OUT); el(ctx, x + 3 * s, hy + 6 * s, 1.2 * s, 1.5 * s, OUT);
      el(ctx, x, hy + 10 * s, 2.5 * s, 1.5 * s, null, '#e0c040', 1 * s);
      eyes(ctx, x, hy - 3 * s, s, 'angry');
    },
    mamian(ctx, x, y, s, o) {
      const t = o.t, hy = y - 36 * s;
      wisp(ctx, x, y, s, '#3c4a6a', t, 10);
      body(ctx, x, y - 5 * s, s * 1.1, '#3c4a6a');
      rr(ctx, x - 9 * s, y - 20 * s, 18 * s, 8 * s, 2 * s, '#9a9aa8', OUT, 1 * s);
      arm(ctx, x - 10 * s, y - 20 * s, x - 15 * s, y - 10 * s, s * 1.2, '#3c4a6a'); arm(ctx, x + 10 * s, y - 20 * s, x + 16 * s, y - 13 * s, s * 1.2, '#3c4a6a');
      rr(ctx, x + 15 * s, y - 42 * s, 2.5 * s, 36 * s, 1 * s, '#5a3a1a', OUT, 0.8 * s); poly(ctx, [x + 13 * s, y - 42 * s, x + 22 * s, y - 46 * s, x + 20 * s, y - 38 * s], '#bfc8d6', OUT, 1 * s);
      el(ctx, x, hy, 11 * s, 13 * s, '#e8e0d8', OUT, 1.8 * s);
      el(ctx, x, hy + 9 * s, 8 * s, 6 * s, '#d0c4b8', OUT, 1.2 * s);
      el(ctx, x - 3 * s, hy + 9 * s, 1.2 * s, 1.6 * s, OUT); el(ctx, x + 3 * s, hy + 9 * s, 1.2 * s, 1.6 * s, OUT);
      poly(ctx, [x - 8 * s, hy - 9 * s, x - 10 * s, hy - 19 * s, x - 3 * s, hy - 12 * s], '#e8e0d8', OUT, 1.2 * s);
      poly(ctx, [x + 8 * s, hy - 9 * s, x + 10 * s, hy - 19 * s, x + 3 * s, hy - 12 * s], '#e8e0d8', OUT, 1.2 * s);
      ctx.fillStyle = '#2a2a3a'; for (let i = 0; i < 4; i++) rr(ctx, x - 2 * s, hy - 14 * s + i * 4 * s, 4 * s + i * 0.5 * s, 4 * s, 1 * s, '#2a2a3a');
      eyes(ctx, x, hy - 2 * s, s * 0.9, 'angry');
    },
    huang(ctx, x, y, s, o) {
      const t = o.t, hy = y - 40 * s;
      wisp(ctx, x, y, s, '#2a2f48', t, 11);
      el(ctx, x, y - 16 * s, 16 * s, 13 * s, '#2a2f48', OUT, 1.8 * s);
      poly(ctx, [x - 4 * s, y - 28 * s, x + 4 * s, y - 28 * s, x, y - 16 * s], '#f2f2f2');
      poly(ctx, [x - 1.5 * s, y - 27 * s, x + 1.5 * s, y - 27 * s, x + 2 * s, y - 17 * s, x - 2 * s, y - 17 * s], '#c4a020', OUT, 0.8 * s);
      arm(ctx, x - 14 * s, y - 22 * s, x - 18 * s, y - 12 * s, s * 1.2, '#2a2f48');
      el(ctx, x - 18 * s, y - 13 * s, 2.5 * s, 1.6 * s, '#e0b030'); // 金錶
      const sw = o.atk ? -1.2 : Math.sin(t * 2) * 0.2;
      arm(ctx, x + 14 * s, y - 22 * s, x + 19 * s, y - 14 * s, s * 1.2, '#2a2f48');
      ctx.save(); ctx.translate(x + 19 * s, y - 14 * s); ctx.rotate(sw);
      rr(ctx, -1 * s, -24 * s, 2 * s, 24 * s, 1 * s, '#c8ccd8', OUT, 0.8 * s); rr(ctx, -2 * s, -27 * s, 8 * s, 4 * s, 1.5 * s, '#9aa0b0', OUT, 0.8 * s); ctx.restore();
      el(ctx, x, hy, 14 * s, 13 * s, '#d8c0a8', OUT, 1.8 * s);
      ctx.fillStyle = '#2a2a2a'; ctx.beginPath(); ctx.ellipse(x, hy - 7 * s, 14 * s, 6 * s, 0, Math.PI, TAU); ctx.fill();
      ctx.strokeStyle = '#2a2a2a'; ctx.lineWidth = 1.5 * s; for (let i = -2; i <= 2; i++) { ctx.beginPath(); ctx.moveTo(x - 10 * s, hy - 9 * s + i); ctx.quadraticCurveTo(x, hy - 14 * s, x + 11 * s, hy - 8 * s + i); ctx.stroke(); }
      rr(ctx, x - 10 * s, hy - 2 * s, 8 * s, 5 * s, 1.5 * s, 'rgba(20,20,30,.85)', '#c4a020', 1 * s); rr(ctx, x + 2 * s, hy - 2 * s, 8 * s, 5 * s, 1.5 * s, 'rgba(20,20,30,.85)', '#c4a020', 1 * s);
      mouth(ctx, x, hy + 1 * s, s, o.enemy ? 'open' : 'smile');
      el(ctx, x - 10 * s, hy + 6 * s, 3 * s, 2 * s, 'rgba(255,120,120,.35)'); el(ctx, x + 10 * s, hy + 6 * s, 3 * s, 2 * s, 'rgba(255,120,120,.35)');
    },
  };

  // 有實體的不算「飄」：殭屍、Pocong 是屍體，紙紮人是紙，Penanggal 只有頭
  const SOLID = { npc_it:1, npc_mis:1, npc_ken:1, npc_boss:1, npc_guard:1, npc_auntie:1, laojiang:1, zombie:1, pocong:1, xiaozhi:1, zhiren:1, penanggal:1 };
  const HOP = { laojiang:1, zombie:1, pocong:1 };
  // 蠟筆畫素材的角色高度（世界單位，s=1 時）
  const CHAR_H = { npc_it:60, npc_mis:62, npc_ken:64, npc_boss:64, npc_guard:64, npc_auntie:60, afu:58, xiaozhi:54, egui:54, eguiking:66, xiaogui:46, toyol:46, laojiang:58, zombie:54, shuigui:56, pontianak:60, pocong:54, penanggal:52, mengpo:56, youhun:46, baiwu:76, heiwu:76, niutou:64, mamian:64, huang:62, zhiren:54, tianhua:60 };
  const sprKey = (type) => type === 'afu' ? 'afu_body' : type;
  const hasSpr = (type) => typeof sprOk === 'function' && CHAR_H[type] && sprOk(sprKey(type));
  // 阿福的領帶（原圖 953×1263 座標）
  const TIE = { x0:618, x1:946, y0:462, y1:648, ow:953 };
  function drawSprite(ctx, type, x, y, s, o) {
    if (typeof SPECIAL !== 'undefined' && SPECIAL.has(type)) return SPECIAL.draw(ctx, type, x, y, s, o);
    const img = SPR[sprKey(type)], iw = img.naturalWidth, ih = img.naturalHeight;
    const t = o.t || 0, H = CHAR_H[type] * s, Wd = H * iw / ih;
    let sy = 1 + Math.sin(t * 2.2) * 0.02, sx = 1 - (sy - 1) * 0.5, r = 0, dy = 0;
    if (o.walk) { r += Math.sin(t * 9) * 0.07; dy -= Math.abs(Math.sin(t * 9)) * 1.5 * s; }
    if (o.work) r += Math.sin(t * 12) * 0.12;
    if (HOP[type] && (o.walk || o.enemy)) dy -= Math.abs(Math.sin(t * 5)) * 5 * s;
    if (o.atk) { sx *= 1.08; sy *= 1.08; }
    ctx.save(); ctx.translate(x, y + dy); ctx.rotate(r); ctx.scale(sx, sy);
    ctx.drawImage(img, -Wd / 2, -H, Wd, H);
    if (type === 'afu' && sprOk('afu_tie')) { // 領帶：分成直條，像在風裡飄
      const tie = SPR.afu_tie, p = tie.naturalWidth / TIE.ow, kx = Wd / tie.naturalWidth, ky = H / tie.naturalHeight;
      const sx0 = TIE.x0 * p, sx1 = Math.min(tie.naturalWidth, TIE.x1 * p), sy0 = TIE.y0 * p, sh = (TIE.y1 - TIE.y0) * p;
      const len = sx1 - sx0, step = Math.max(1, 2 * p), amp = H * 0.032;
      for (let cx = sx0; cx < sx1; cx += step) {
        const d = (cx - sx0) / p, fr = (cx - sx0) / len;
        const off = Math.sin(t * 6 - d * 0.016) * amp * Math.pow(fr, 1.3) + Math.sin(t * 2.7) * amp * 0.45 * fr;
        const w = Math.min(step, sx1 - cx);
        ctx.drawImage(tie, cx, sy0, w, sh, -Wd / 2 + cx * kx, -H + sy0 * ky + off, w * kx + 0.6, sh * ky);
      }
    }
    ctx.restore();
  }
  const buf = document.createElement('canvas'), bctx = buf.getContext('2d');
  // 木偶角色：有分件圖的，動作交給 Puppet
  const PUPPET_ANIM = { walk:1, run:1, startle:1, cower:1, tremble:1, phone:1, look:1, mop:1, faint:1, sip:1, stand:1, hold:1, shrug:1, windup:1, strike:1, recover:1, hurt:1, cast:1, die:1, chop:1, hammer:1, knead:1, reap:1, proud:1 };
  function drawPuppet(ctx, type, x, y, s, o) {
    const A = Puppet.ANIMS; let name = o.pose && A[o.pose] ? o.pose : o.walk ? 'move' : 'idle';
    if (!Puppet.armed(type) && A[name + 'C']) name = name + 'C';
    if (o.hurt && A.hurt) name = 'hurt';
    const R = Puppet.RIGS[type], human = !!(R && R.lF);
    if (human && name === 'idle') name = 'stand'; if (human && name === 'move') name = 'walk';
    const T1 = { idle:1, move:1, walk:1, run:1, look:1, mop:1, sip:1, stand:1, hold:1 };
    const pz = T1[name] ? A[name](o.t) : A[name](o.pt || 0, o.t);
    if (o.face) pz.hk = o.face;
    if (o.weapon) { pz.wpn = o.weapon; if (!pz.tool && type === 'afu') { pz.tool = '_W'; pz.tr = -(pz.aF + pz.eF) + 0.25; } } // 巡陰裝備：手上一直拿住武器
    if (o.cloth) pz.cloth = o.cloth; if (o.badge) pz.badge = o.badge;
    if (!pz.tool && type !== 'afu' && !human && Puppet.armed(type)) { pz.tool = '_W'; pz.tr = -(pz.aF + pz.eF) + 0.15; }
    if (!PUPPET_ANIM[name] && o.atk) Object.assign(pz, { aF:1.6, eF:0.1 });
    if (HOP[type] && (name === 'idle' || name === 'move')) { Object.assign(pz, { aF:1.5, eF:0.05, aB:1.4, eB:0.05, lean:0 }); if (name === 'move' || o.enemy) pz.dy = -Math.abs(Math.sin(o.t * 5)) * 7; }
    const SOLIDP = SOLID[type];
    if (o.shadow !== false) shadow(ctx, x, y + 1 * s, s * (SOLIDP ? 1 : 0.8));
    Puppet.draw(ctx, type, x, y - (SOLIDP ? 0 : (3 + Math.sin(o.t * 2.4) * 2) * s), CHAR_H[type] * s * 1.08, pz, !o.flip);
  }
  // 原圖變形動畫：把動作名稱換成骨頭姿勢
  function meshPose(type, o) {
    const A = MeshAnim.ANIM, t = o.t, p = Math.max(0, Math.min(1, o.pt || 0));
    const atk = (q) => q < 0.72 ? A.windup(q / 0.72, t, type) : A.strike((q - 0.72) / 0.28, t, type);
    switch (o.pose) {
      case 'windup': case 'strike': case 'follow': case 'recover': return A[o.pose](p, t, type);
      case 'cast': case 'die': case 'air': case 'down': return A[o.pose](p, t, type);
      case 'faint': return A.die(p, t);
      case 'hurt': return A.hurtP(p, t);
      case 'scared': case 'startle': case 'tremble': case 'cower': return A.scared(t);
      case 'chop': return atk(p);
      case 'hammer': return atk((p * 2) % 1);
      case 'reap': return A.strike(Math.abs(Math.sin(p * Math.PI * 3)), t, type);
      case 'knead': { const z = A.idle(t); z.body = 0.15 + Math.sin(p * Math.PI * 4) * 0.05; z.y = (z.y || 0) + Math.abs(Math.sin(p * Math.PI * 4)) * 0.02; z.armF = 0.3; z.armB = -0.3; return z; }
      case 'proud': { const z = A.idle(t); z.head = -0.12; z.body = -0.05; return z; }
      case 'run': case 'move': case 'walk': return A.walk(t * (o.pose === 'run' ? 1.8 : 1));
    }
    if (o.hurt) return A.hurtP(0.3, t);
    if (o.atk) return A.strike(0.6, t, type);
    if (o.walk) return A.walk(t);
    return A.idle(t);
  }
  const LIMB_POSES = { undefined:1, null:1, idle:1, move:1, walk:1, run:1, windup:1, strike:1, follow:1, recover:1, chop:1, hammer:1, proud:1 };
  function drawMesh(ctx, type, x, y, s, o) {
    const solid = SOLID[type], H = CHAR_H[type] * s;
    // 平日動作：o.act = 動作名（如 'yawn'、'saw'、'chat'），o.at = 這個動作已經做了幾秒；DAILY[act] 回傳 false 就照一般畫法
    if (o.act && typeof DAILY !== 'undefined' && DAILY[o.act]) {
      ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha;
      const done = DAILY[o.act](ctx, { type, x, y, s, H, o, faceRight:!o.flip, solid, shadow:(cx, k) => shadow(ctx, cx, y + 1 * s, s * (k || (solid ? 1 : 0.8))) });
      ctx.restore(); if (done !== false) return;
    }
    // 專屬招式：有自己動作的角色（丟東西、飛過去、倒掛……），o.tdx/o.tdy = 對手相對自己的位置（世界單位）
    if (typeof MOVES !== 'undefined' && MOVES[type] && (o.pose === 'windup' || o.pose === 'strike' || o.pose === 'follow' || o.pose === 'recover')) {
      ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha;
      const done = MOVES[type](ctx, { type, x, y, s, H, o, faceRight:!o.flip, solid, shadow:(cx, k) => shadow(ctx, cx, y + 1 * s, s * (k || (solid ? 1 : 0.8))) });
      ctx.restore(); if (done !== false) return;
    }
    if (MeshAnim.RIG[type].custom) { // 有幾張原畫的角色（npc_antag.js 的反派）：待機、走路、嚇親換用自己的原畫
      ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha;
      const done = MeshAnim.RIG[type].custom(ctx, { type, x, y, s, H, o, faceRight:!o.flip, solid, shadow:(cx, k) => shadow(ctx, cx, y + 1 * s, s * (k || (solid ? 1 : 0.8))) });
      ctx.restore(); if (done !== false) return;
    }
    if (typeof Limbs !== 'undefined' && Limbs.has(type) && LIMB_POSES[o.pose] && !o.hurt) { // 拿武器的手是原圖拆出來的，可以大幅揮
      const A = MeshAnim.ANIM, mp = (o.walk || o.pose === 'move' || o.pose === 'walk' || o.pose === 'run') ? A.walk(o.t) : A.idle(o.t);
      ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha;
      if (o.shadow !== false) { ctx.save(); if (!solid) ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * (solid ? 1 : 0.8)); ctx.restore(); }
      const tip = Limbs.draw(ctx, type, x, y - (solid ? 0 : (3 + Math.sin(o.t * 2.4) * 2) * s), H, o, !o.flip, mp);
      ctx.restore(); if (o.tipOut) o.tipOut.p = tip; return;
    }
    const pz = meshPose(type, o);
    if (MeshAnim.RIG[type].tweak) MeshAnim.RIG[type].tweak(pz, o); // 個別角色的走路／待機方式（n30_rigs.js：飄、單腳跳、長腿跨步…）
    if (MeshAnim.RIG[type].hop && (o.walk || o.enemy || o.pose === 'move')) pz.y = (pz.y || 0) - Math.abs(Math.sin(o.t * 5)) * 0.09;
    ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha;
    if (o.shadow !== false) { ctx.save(); if (!solid) ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * (solid ? 1 : 0.8)); ctx.restore(); }
    MeshAnim.draw(ctx, type, x, y - (solid ? 0 : (3 + Math.sin(o.t * 2.4) * 2) * s), H, pz, !o.flip);
    ctx.restore();
  }
  function drawChar(ctx, type, x, y, s, o) {
    o = o || {}; o.t = o.t || 0;
    if (typeof MeshAnim !== 'undefined' && CHAR_H[type] && MeshAnim.has(type) && !(typeof SPECIAL !== 'undefined' && SPECIAL.has(type)) && !o.noMesh) return drawMesh(ctx, type, x, y, s, o);
    if (typeof Puppet !== 'undefined' && Puppet.has(type) && !o.noPuppet) { ctx.save(); if (o.alpha != null) ctx.globalAlpha = o.alpha; if (o.rot) { ctx.translate(x, y - 15 * s); ctx.rotate(o.rot); ctx.translate(-x, -(y - 15 * s)); } drawPuppet(ctx, type, x, y, s, o); ctx.restore(); return; }
    const spr = hasSpr(type);
    const f = spr ? ((c, xx, yy, ss, oo) => drawSprite(c, type, xx, yy, ss, oo)) : (DRAW[type] || DRAW.youhun);
    const ghost = !SOLID[type];
    ctx.save();
    if (o.alpha != null) ctx.globalAlpha = o.alpha;
    if (o.shadow !== false) { if (ghost) { ctx.save(); ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore(); } else shadow(ctx, x, y + 1 * s, s); }
    if (o.flip) { ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0); }
    if (o.rot) { ctx.translate(x, y - 15 * s); ctx.rotate(o.rot); ctx.translate(-x, -(y - 15 * s)); }
    if (!ghost) { f(ctx, x, y, s, o); ctx.restore(); return; }
    // 飄浮
    const fy = y - (3 + Math.sin(o.t * 2.4) * 2) * s;
    // 先畫到暫存畫布，再把下半身漸隱（蠟筆圖的尾巴本來就淡，遮罩減弱）
    const m = ctx.getTransform(); const k = Math.min(4, Math.max(1, Math.hypot(m.a, m.b)));
    const L = 48 * s, T = 96 * s, Wd = 96 * s, Ht = 106 * s;
    const pw = Math.ceil(Wd * k), ph = Math.ceil(Ht * k);
    if (buf.width < pw || buf.height < ph) { buf.width = Math.max(buf.width, pw); buf.height = Math.max(buf.height, ph); }
    bctx.setTransform(1, 0, 0, 1, 0, 0); bctx.clearRect(0, 0, pw, ph);
    bctx.setTransform(k, 0, 0, k, (L - x) * k, (T - fy) * k);
    bctx.globalCompositeOperation = 'source-over'; bctx.globalAlpha = 1;
    f(bctx, x, fy, s, o);
    bctx.globalCompositeOperation = 'destination-out';
    const g = bctx.createLinearGradient(0, fy - 13 * s, 0, fy + 6 * s);
    if (spr) { g.addColorStop(0, 'rgba(0,0,0,0)'); g.addColorStop(0.6, 'rgba(0,0,0,.22)'); g.addColorStop(1, 'rgba(0,0,0,.55)'); }
    else { g.addColorStop(0, 'rgba(0,0,0,0)'); g.addColorStop(0.55, 'rgba(0,0,0,.55)'); g.addColorStop(1, 'rgba(0,0,0,.92)'); }
    bctx.fillStyle = g; bctx.fillRect(x - L, fy - 13 * s, Wd, 30 * s);
    bctx.globalCompositeOperation = 'source-over';
    ctx.drawImage(buf, 0, 0, pw, ph, x - L, fy - T, pw / k, ph / k);
    ctx.restore();
  }

  // 頭像（給 UI 用）：畫在一個小 canvas 上
  const portraitCache = {};
  // 頭像裁切：從圖片頂端算起的起點與方框大小（以圖寬為單位）
  const PCROP = { baiwu:[0.30, 0.95], heiwu:[0.30, 0.95], penanggal:[0.02, 0.85], eguiking:[0.0, 0.8], huang:[0.0, 0.8], niutou:[0.04, 0.82], mamian:[0.04, 0.82], afu:[0.0, 0.72], tree:[0, 1] };
  function portrait(type, size, opt) {
    const spr = hasSpr(type);
    const key = type + '_' + size + '_' + JSON.stringify(opt || {}) + (spr ? '_s' : '');
    if (portraitCache[key]) return portraitCache[key];
    const c = document.createElement('canvas'); const dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = size * dpr; c.height = size * dpr; const ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
    if (spr) {
      const img = SPR[sprKey(type)], iw = img.naturalWidth, ih = img.naturalHeight;
      const [top, fr] = PCROP[type] || [0.0, 0.86];
      const S = Math.min(iw * fr, ih), sx = (iw - S) / 2 + (type === 'afu' ? iw * 0.1 : 0), sy = Math.min(ih - S, iw * top);
      ctx.imageSmoothingQuality = 'high';
      ctx.drawImage(img, Math.max(0, Math.min(iw - S, sx)), Math.max(0, sy), S, S, size * 0.04, size * 0.04, size * 0.92, size * 0.92);
      portraitCache[key] = c; return c;
    }
    const s = size / 52;
    drawChar(ctx, type, size / 2, size * 0.98 + (['penanggal'].includes(type) ? -size * 0.05 : 0) + (['baiwu', 'heiwu'].includes(type) ? size * 0.3 : 0) + (['eguiking', 'huang', 'niutou', 'mamian'].includes(type) ? size * 0.12 : 0), s * (['baiwu', 'heiwu'].includes(type) ? 0.85 : 1), Object.assign({ shadow: false, t: 0.3 }, opt || {}));
    if (typeof SPR === 'undefined' || !CHAR_H[type]) portraitCache[key] = c; // 素材還沒載入時不快取
    return c;
  }
  // 系統頭像：發光的工牌
  function sysIcon(size) {
    const c = document.createElement('canvas'); const dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = size * dpr; c.height = size * dpr; const ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
    const g = ctx.createRadialGradient(size / 2, size / 2, 2, size / 2, size / 2, size / 2);
    g.addColorStop(0, 'rgba(120,255,220,.9)'); g.addColorStop(1, 'rgba(120,255,220,0)');
    ctx.fillStyle = g; ctx.fillRect(0, 0, size, size);
    rr(ctx, size * 0.24, size * 0.18, size * 0.52, size * 0.64, size * 0.08, '#0e2a2a', '#6ff0d0', 2);
    ctx.fillStyle = '#6ff0d0'; ctx.font = `bold ${size * 0.2}px sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText('KPI', size / 2, size * 0.42); ctx.fillRect(size * 0.34, size * 0.6, size * 0.32, size * 0.05);
    return c;
  }

  // ---------------- 建築 ----------------
  function roof(ctx, x, y, w, h, col, edge) {
    ctx.beginPath(); ctx.moveTo(x - w / 2 - 8, y + h); ctx.quadraticCurveTo(x - w / 2, y + h * 0.4, x - w / 4, y); ctx.lineTo(x + w / 4, y);
    ctx.quadraticCurveTo(x + w / 2, y + h * 0.4, x + w / 2 + 8, y + h); ctx.closePath();
    ctx.fillStyle = col; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 2; ctx.stroke();
    ctx.strokeStyle = edge || 'rgba(255,255,255,.12)'; ctx.lineWidth = 1;
    for (let i = 1; i < 6; i++) { const yy = y + h * i / 6; ctx.beginPath(); ctx.moveTo(x - w / 2 + 2 - 8 * i / 6, yy); ctx.lineTo(x + w / 2 - 2 + 8 * i / 6, yy); ctx.stroke(); }
    poly(ctx, [x - w / 2 - 10, y + h, x - w / 2 - 14, y + h - 7, x - w / 2 - 4, y + h - 2], col, OUT, 1.5);
    poly(ctx, [x + w / 2 + 10, y + h, x + w / 2 + 14, y + h - 7, x + w / 2 + 4, y + h - 2], col, OUT, 1.5);
  }
  function lantern(ctx, x, y, t, col) {
    ctx.strokeStyle = '#222'; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(x, y - 6); ctx.lineTo(x, y - 2); ctx.stroke();
    const g = ctx.createRadialGradient(x, y + 5, 1, x, y + 5, 16); g.addColorStop(0, 'rgba(255,90,70,.35)'); g.addColorStop(1, 'rgba(255,90,70,0)');
    ctx.fillStyle = g; ctx.fillRect(x - 16, y - 11, 32, 32);
    el(ctx, x + Math.sin(t * 2 + x) * 0.8, y + 5, 5, 7, col || '#d8343c', OUT, 1.2);
    ctx.fillStyle = '#f2c14a'; ctx.fillRect(x - 3, y - 2, 6, 1.5); ctx.fillRect(x - 3, y + 11, 6, 1.5);
  }
  function plaque(ctx, x, y, text, lv) {
    ctx.save(); ctx.font = '900 13px "Songti TC","Noto Serif CJK TC","Noto Serif TC",serif';
    const w = ctx.measureText(text).width + 16;
    rr(ctx, x - w / 2 - 2, y - 11, w + 4, 22, 2, '#1a0e08');
    rr(ctx, x - w / 2, y - 9, w, 18, 1, '#3a1a10', '#c99a3e', 1.2);
    ctx.fillStyle = '#f3d68a'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(text, x, y + 1);
    if (lv) { const sx = x + w / 2 + 3, sy = y - 13; ctx.translate(sx, sy); ctx.rotate(0.12); rr(ctx, -1, -8, 20, 16, 2, '#c2362b', '#f0c8b4', 1); ctx.fillStyle = '#fff3e0'; ctx.font = '900 10px sans-serif'; ctx.fillText(lv, 9, 0.5); }
    ctx.restore();
  }
  function house(ctx, x, y, w, h, wall, roofCol) {
    rr(ctx, x - w / 2, y - h, w, h, 3, wall, OUT, 2);
    ctx.fillStyle = 'rgba(0,0,0,.15)'; ctx.fillRect(x - w / 2 + 2, y - 8, w - 4, 6);
  }
  const BDRAW = {
    house(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 70, 12, 'rgba(0,0,0,.3)');
      rr(ctx, x - 64, y - 6, 128, 12, 3, '#4a4458', OUT, 2);
      house(ctx, x, y - 6, 104, 46, '#5c3b3b');
      for (let i = 0; i < 4; i++) rr(ctx, x - 48 + i * 30, y - 50, 6, 44, 2, '#8a2a2a', OUT, 1.2);
      rr(ctx, x - 14, y - 38, 28, 32, 3, '#26161a', OUT, 1.5);
      el(ctx, x - 5, y - 22, 1.8, 1.8, '#d9a84a'); el(ctx, x + 5, y - 22, 1.8, 1.8, '#d9a84a');
      roof(ctx, x, y - 82, 120, 30, '#2e2a40');
      roof(ctx, x, y - 102, 70, 22, '#2e2a40');
      lantern(ctx, x - 36, y - 50, t); lantern(ctx, x + 36, y - 50, t);
      plaque(ctx, x, y - 62, '鬼宅', lv);
    },
    wood(ctx, x, y, lv, t) {
      el(ctx, x, y + 3, 40, 8, 'rgba(0,0,0,.3)');
      for (let i = 0; i < 3; i++) for (let j = 0; j < 3 - i; j++) { el(ctx, x - 22 + j * 11 + i * 5.5, y - 5 - i * 9, 6, 5, '#7a5230', OUT, 1.2); el(ctx, x - 22 + j * 11 + i * 5.5, y - 5 - i * 9, 3, 2.5, '#b8875a'); }
      rr(ctx, x + 8, y - 30, 30, 30, 2, '#5a4030', OUT, 1.5);
      poly(ctx, [x + 2, y - 28, x + 23, y - 46, x + 44, y - 28], '#3a3048', OUT, 1.8);
      // 木樁與斧
      rr(ctx, x - 40, y - 14, 14, 12, 2, '#8a6038', OUT, 1.2);
      plaque(ctx, x, y - 54, '伐木場', lv);
    },
    rice(ctx, x, y, lv, t) {
      rr(ctx, x - 24, y - 26, 48, 26, 2, '#4a3a2a', OUT, 1.5);
      poly(ctx, [x - 30, y - 24, x, y - 44, x + 30, y - 24], '#7a6a3a', OUT, 1.8);
      ctx.strokeStyle = '#a89058'; ctx.lineWidth = 1; for (let i = 0; i < 6; i++) { ctx.beginPath(); ctx.moveTo(x - 24 + i * 9, y - 24 - (i < 3 ? i : 5 - i) * 5); ctx.lineTo(x - 22 + i * 9, y - 28 - (i < 3 ? i : 5 - i) * 5); ctx.stroke(); }
      rr(ctx, x - 8, y - 18, 16, 18, 2, '#2a1a10', OUT, 1);
      plaque(ctx, x, y - 52, '糯米田', lv);
    },
    plank(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 48, 9, 'rgba(0,0,0,.3)');
      house(ctx, x, y, 78, 40, '#4a3a2e');
      rr(ctx, x - 30, y - 30, 22, 26, 2, '#2a1a10', OUT, 1.2);
      // 門口一副棺材
      ctx.save(); ctx.translate(x + 18, y - 6); poly(ctx, [-12, 0, 12, 0, 15, -12, 10, -22, -10, -22, -15, -12], '#5a2a1a', OUT, 1.5); ctx.fillStyle = '#d9a84a'; ctx.font = 'bold 10px serif'; ctx.textAlign = 'center'; ctx.fillText('壽', 0, -8); ctx.restore();
      roof(ctx, x, y - 66, 86, 26, '#3a2a3a');
      lantern(ctx, x - 40, y - 42, t, '#f0f0f0');
      plaque(ctx, x, y - 54, '棺材鋪', lv);
    },
    bun(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 48, 9, 'rgba(0,0,0,.3)');
      house(ctx, x, y, 78, 40, '#6a4232');
      rr(ctx, x - 34, y - 24, 68, 6, 2, '#8a5a3a', OUT, 1.2);
      for (let i = 0; i < 3; i++) { el(ctx, x - 20 + i * 20, y - 14, 9, 6, '#c8a878', OUT, 1.2); el(ctx, x - 20 + i * 20, y - 18, 9, 3, '#d8b888', OUT, 1); for (let k = 0; k < 2; k++) { ctx.strokeStyle = 'rgba(255,255,255,.35)'; ctx.lineWidth = 2; ctx.beginPath(); const sx = x - 22 + i * 20 + k * 4; ctx.moveTo(sx, y - 22); ctx.quadraticCurveTo(sx + 4 + Math.sin(t * 3 + i + k) * 3, y - 30, sx, y - 38 - ((t * 10 + i * 7) % 6)); ctx.stroke(); } }
      roof(ctx, x, y - 66, 86, 26, '#4a2a2a');
      lantern(ctx, x + 40, y - 42, t);
      plaque(ctx, x, y - 54, '包子鋪', lv);
    },
    store(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 52, 9, 'rgba(0,0,0,.3)');
      house(ctx, x, y, 90, 44, '#3e3a4e');
      rr(ctx, x - 22, y - 34, 44, 34, 2, '#2a2236', OUT, 1.5);
      ctx.strokeStyle = OUT; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(x, y - 34); ctx.lineTo(x, y); ctx.stroke();
      for (let i = 0; i < 2; i++) { rr(ctx, x + 28, y - 16 - i * 12, 14, 12, 1, '#7a5a30', OUT, 1); }
      roof(ctx, x, y - 72, 98, 26, '#2a2a3a');
      plaque(ctx, x, y - 58, '倉庫', lv);
    },
    home(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 44, 8, 'rgba(0,0,0,.3)');
      // 甘榜高腳屋
      for (let i = 0; i < 4; i++) rr(ctx, x - 30 + i * 19, y - 16, 4, 16, 1, '#4a3424', OUT, 1);
      rr(ctx, x - 34, y - 42, 68, 26, 2, '#7a5a3a', OUT, 1.5);
      for (let i = 0; i < 7; i++) { ctx.strokeStyle = 'rgba(0,0,0,.25)'; ctx.beginPath(); ctx.moveTo(x - 34 + i * 10, y - 42); ctx.lineTo(x - 34 + i * 10, y - 16); ctx.stroke(); }
      rr(ctx, x - 8, y - 36, 14, 14, 1, '#ffd88a', OUT, 1);
      poly(ctx, [x - 42, y - 40, x, y - 66, x + 42, y - 40], '#5a4a3a', OUT, 1.8);
      plaque(ctx, x, y - 58, '民宅', lv);
    },
    camp(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 48, 9, 'rgba(0,0,0,.3)');
      poly(ctx, [x - 38, y, x, y - 46, x + 38, y], '#3a4a3a', OUT, 2);
      poly(ctx, [x - 10, y, x, y - 30, x + 10, y], '#1a2418', OUT, 1.2);
      rr(ctx, x + 30, y - 58, 2, 58, 1, '#5a3a1a');
      poly(ctx, [x + 32, y - 58, x + 52 + Math.sin(t * 3) * 3, y - 52, x + 32, y - 46], '#7a2a8a', OUT, 1);
      ctx.fillStyle = '#fff'; ctx.font = 'bold 8px sans-serif'; ctx.fillText('陰', x + 36, y - 49);
      plaque(ctx, x - 6, y - 56, '嚇人班', lv);
    },
    altar(ctx, x, y, lv, t) {
      el(ctx, x, y + 4, 40, 9, 'rgba(0,0,0,.3)');
      rr(ctx, x - 34, y - 14, 68, 14, 2, '#4a4458', OUT, 1.5);
      rr(ctx, x - 24, y - 26, 48, 12, 2, '#5a5468', OUT, 1.5);
      for (let i = -1; i <= 1; i += 2) { rr(ctx, x + i * 30 - 1, y - 58, 2, 44, 1, '#3a2a1a'); poly(ctx, [x + i * 30, y - 58, x + i * 30 + i * 4 + Math.sin(t * 2 + i) * 2, y - 52, x + i * 30 + i * 3, y - 30, x + i * 30, y - 34], '#e8e0c8', OUT, 1); }
      const g = ctx.createRadialGradient(x, y - 34, 2, x, y - 34, 22); g.addColorStop(0, 'rgba(120,255,200,.6)'); g.addColorStop(1, 'rgba(120,255,200,0)');
      ctx.fillStyle = g; ctx.fillRect(x - 24, y - 58, 48, 48);
      el(ctx, x, y - 34 + Math.sin(t * 2) * 2, 5, 6, 'rgba(180,255,230,.9)');
      plaque(ctx, x, y - 68, '招魂台', lv);
    },
    furnace(ctx, x, y, lv, t, ready) {
      el(ctx, x, y + 3, 26, 7, 'rgba(0,0,0,.3)');
      rr(ctx, x - 18, y - 36, 36, 36, 6, '#6a3a2a', OUT, 1.8);
      roof(ctx, x, y - 52, 30, 14, '#4a2a2a');
      rr(ctx, x - 8, y - 26, 16, 14, 4, '#1a0a08', OUT, 1);
      const fl = ready ? 1 : 0.35;
      el(ctx, x, y - 18 - Math.sin(t * 8) * 1, 5 * fl + 1, 6 * fl + 1, ready ? '#ffb030' : '#a04020');
      if (ready) { const g = ctx.createRadialGradient(x, y - 20, 2, x, y - 20, 26); g.addColorStop(0, 'rgba(255,170,60,.45)'); g.addColorStop(1, 'rgba(255,170,60,0)'); ctx.fillStyle = g; ctx.fillRect(x - 26, y - 46, 52, 52); }
      plaque(ctx, x, y - 62, '化寶爐', lv);
    },
  };
  function drawBuilding(ctx, id, x, y, lv, t, extra) { BDRAW[id](ctx, x, y, lv, t, extra); }
  function drawSite(ctx, x, y, name) { // 空地：插一塊木牌
    ctx.save(); ctx.font = '700 12px "PingFang TC","Noto Sans TC",sans-serif'; const w = Math.max(64, ctx.measureText(name).width + 22);
    el(ctx, x, y - 2, w * 0.7, 9, 'rgba(60,48,36,.45)');
    ctx.setLineDash([3, 4]); ctx.strokeStyle = 'rgba(236,217,164,.35)'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.ellipse(x, y - 2, w * 0.7, 11, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([]);
    rr(ctx, x - 1.5, y - 30, 3, 28, 1, '#5a4030');
    rr(ctx, x - w / 2, y - 44, w, 20, 2, '#ecd9a4', '#5a4030', 1.5);
    ctx.fillStyle = '#2b1d12'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(name, x, y - 33.5);
    ctx.fillStyle = '#c2362b'; ctx.font = '900 10px sans-serif'; ctx.fillText('待建', x, y - 14);
    ctx.restore();
  }
  // 烏鴉
  function drawCrow(ctx, x, y, s, ph, dir, perched) {
    ctx.save(); ctx.translate(x, y); ctx.scale(dir < 0 ? -s : s, s);
    if (perched) {
      el(ctx, 0, 0, 6, 4.2, '#121014', '#000', 0.8); el(ctx, 4.5, -3.5, 3, 2.8, '#121014');
      poly(ctx, [7, -4, 10.5, -3, 7, -2.4], '#5a524a'); el(ctx, 5.4, -4.2, 0.7, 0.7, '#e03a3a');
      poly(ctx, [-5, -1, -11, 2, -6, 2.5], '#0c0a0e'); ctx.strokeStyle = '#3a3530'; ctx.lineWidth = 0.8; ctx.beginPath(); ctx.moveTo(-1, 4); ctx.lineTo(-1, 6.5); ctx.moveTo(1.5, 4); ctx.lineTo(1.5, 6.5); ctx.stroke();
    } else {
      const w = Math.sin(ph) * 7;
      poly(ctx, [-2, 0, -7, -6 - w, 2, -1], '#0c0a0e', '#6a6078', 0.7); poly(ctx, [-1, 0, -4, 6 + w * 0.4, 3, 0], '#16141a');
      el(ctx, 0, 0, 6, 3.2, '#121014', '#6a6078', 0.7); el(ctx, 5, -1, 2.6, 2.4, '#121014', '#6a6078', 0.6); poly(ctx, [7, -1.6, 10.5, -0.6, 7, 0.2], '#5a524a');
      poly(ctx, [-5, -0.5, -10, -2.5, -10, 2], '#0c0a0e'); el(ctx, 5.8, -1.6, 0.6, 0.6, '#e03a3a');
    }
    ctx.restore();
  }
  // 恐怖的老槐樹：樹瘤長得像人臉，枝上掛著紅繩、黃符和白布
  const PERCH = [[-19, -46, 1], [16, -52, -1], [-4, -64, 1]];
  function drawTree(ctx, x, y, hp, t, shake, perched, idx) {
    const sx = shake ? Math.sin(t * 60) * 2.2 : 0; const v = (idx || 0) % 3;
    el(ctx, x, y + 2, 18, 5, 'rgba(0,0,0,.4)');
    if (hp <= 0) {
      rr(ctx, x - 8, y - 8, 16, 9, 2, '#2a2220', OUT, 1.2); el(ctx, x, y - 8, 8, 2.8, '#6a4a3a', OUT, 1); el(ctx, x, y - 8, 4, 1.4, '#8a2a24');
      ctx.strokeStyle = 'rgba(140,30,30,.7)'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(x + 3, y - 7); ctx.quadraticCurveTo(x + 4, y - 3, x + 3, y + 1); ctx.stroke(); return;
    }
    ctx.save(); ctx.translate(sx, 0);
    // 樹幹（扭曲）
    ctx.beginPath(); ctx.moveTo(x - 9, y + 1); ctx.quadraticCurveTo(x - 4, y - 14, x - 8, y - 26); ctx.quadraticCurveTo(x - 9, y - 34, x - 3, y - 40);
    ctx.lineTo(x + 4, y - 40); ctx.quadraticCurveTo(x + 9, y - 30, x + 5, y - 20); ctx.quadraticCurveTo(x + 3, y - 8, x + 10, y + 1); ctx.closePath();
    ctx.fillStyle = '#2b2321'; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.6; ctx.stroke();
    ctx.strokeStyle = 'rgba(0,0,0,.45)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(x - 4, y - 2); ctx.quadraticCurveTo(x - 1, y - 14, x - 5, y - 30); ctx.moveTo(x + 4, y - 4); ctx.quadraticCurveTo(x + 2, y - 18, x + 3, y - 34); ctx.stroke();
    // 樹瘤人臉
    el(ctx, x - 2.8, y - 21, 2, 2.8, '#0a0708'); el(ctx, x + 2.8, y - 21.5, 2, 2.6, '#0a0708');
    const glow = 0.45 + Math.sin(t * 1.7 + x) * 0.35; el(ctx, x - 2.8, y - 20.5, 0.8, 0.8, `rgba(255,60,50,${glow})`); el(ctx, x + 2.8, y - 21, 0.8, 0.8, `rgba(255,60,50,${glow})`);
    el(ctx, x, y - 14, 1.8, 3, '#0a0708');
    // 枯枝
    const br = (x1, y1, x2, y2, cx, cy, w) => { ctx.strokeStyle = '#2b2321'; ctx.lineCap = 'round'; ctx.lineWidth = w + 1.6; ctx.beginPath(); ctx.moveTo(x1, y1); ctx.quadraticCurveTo(cx, cy, x2, y2); ctx.strokeStyle = OUT; ctx.stroke(); ctx.lineWidth = w; ctx.strokeStyle = '#2b2321'; ctx.stroke(); };
    br(x - 4, y - 38, x - 24, y - 46, x - 12, y - 48, 3); br(x - 20, y - 46, x - 27, y - 56, x - 26, y - 49, 1.4);
    br(x + 2, y - 39, x + 20, y - 52, x + 14, y - 40, 3); br(x + 17, y - 49, x + 27, y - 50, x + 22, y - 47, 1.4);
    br(x, y - 40, x - 4, y - 66, x + 4, y - 54, 2.6); br(x - 3, y - 60, x + 8, y - 70, x + 1, y - 68, 1.3);
    // 稀疏的暗色樹冠
    const c1 = ['#17221c', '#1b241a', '#202018'][v], c2 = ['#1e2b22', '#22291c', '#26261c'][v];
    [[-24, -52, 8, 6, c1], [-14, -60, 9, 6.5, c2], [6, -66, 10, 6.5, c1], [20, -56, 9, 6, c2], [-2, -56, 8, 5, c1]].forEach(([dx, dy, rx, ry, c]) => { ctx.globalAlpha = 0.92; el(ctx, x + dx, y + dy, rx, ry, c, OUT, 1); ctx.globalAlpha = 1; });
    // 紅繩黃符
    const sw = Math.sin(t * 1.8 + x * 0.1) * 0.18;
    ctx.save(); ctx.translate(x + 18, y - 48); ctx.rotate(sw); ctx.strokeStyle = '#b8262a'; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, 9); ctx.stroke();
    rr(ctx, -2.6, 9, 5.2, 11, 0.5, '#e8c44a', '#8a6a1a', 0.7); ctx.strokeStyle = '#b8262a'; ctx.lineWidth = 0.7; ctx.beginPath(); ctx.moveTo(0, 10.5); ctx.quadraticCurveTo(1.6, 12.5, -0.6, 14); ctx.quadraticCurveTo(-1.8, 15.6, 0.8, 17); ctx.lineTo(0, 19); ctx.stroke(); el(ctx, 0, 11.2, 0.9, 0.9, null, '#b8262a', 0.6); ctx.restore();
    // 白布條
    if (v !== 1) { ctx.save(); ctx.translate(x - 22, y - 46); ctx.rotate(-sw * 1.4); ctx.beginPath(); ctx.moveTo(-1.5, 0); ctx.quadraticCurveTo(-3 + Math.sin(t * 2.5) * 2, 9, -1 + Math.sin(t * 2.2) * 3, 17); ctx.lineTo(2 + Math.sin(t * 2.2) * 3, 16); ctx.quadraticCurveTo(0 + Math.sin(t * 2.5) * 2, 8, 1.5, 0); ctx.closePath(); ctx.fillStyle = 'rgba(232,228,216,.85)'; ctx.fill(); ctx.restore(); }
    ctx.restore();
    if (perched) PERCH.forEach(([dx, dy, d], k) => { if (k === 2 && v === 2) return; drawCrow(ctx, x + dx + sx, y + dy - 3, 0.75, 0, d, true); });
  }
  // 蜘蛛網（可以是扇形，用在角落）
  function drawWeb(ctx, cx, cy, r, a0, a1, alpha) {
    ctx.save(); ctx.strokeStyle = `rgba(225,225,235,${alpha || 0.38})`; ctx.lineWidth = 0.6;
    const n = 7; for (let k = 0; k <= n; k++) { const a = a0 + (a1 - a0) * k / n; ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r); ctx.stroke(); }
    for (let ring = 1; ring <= 5; ring++) { const rr2 = r * ring / 5.4; ctx.beginPath(); for (let k = 0; k <= n; k++) { const a = a0 + (a1 - a0) * k / n; const sag = k % 2 ? 0.88 : 1; const px = cx + Math.cos(a) * rr2 * sag, py = cy + Math.sin(a) * rr2 * sag; k ? ctx.lineTo(px, py) : ctx.moveTo(px, py); } ctx.stroke(); }
    ctx.restore();
  }
  function drawSpider(ctx, x, y, top, s) {
    ctx.strokeStyle = 'rgba(220,220,230,.45)'; ctx.lineWidth = 0.6; ctx.beginPath(); ctx.moveTo(x, top); ctx.lineTo(x, y - 2 * s); ctx.stroke();
    ctx.strokeStyle = '#0c0a0e'; ctx.lineWidth = 0.9 * s; for (let k = 0; k < 4; k++) { const dy = -1.5 + k; ctx.beginPath(); ctx.moveTo(x - 1, y + dy * s * 0.6); ctx.quadraticCurveTo(x - 4 * s, y + (dy - 2) * s, x - 5 * s, y + (dy + 1.5) * s); ctx.moveTo(x + 1, y + dy * s * 0.6); ctx.quadraticCurveTo(x + 4 * s, y + (dy - 2) * s, x + 5 * s, y + (dy + 1.5) * s); ctx.stroke(); }
    el(ctx, x, y + 1.5 * s, 2.6 * s, 3 * s, '#100c10'); el(ctx, x, y - 1.2 * s, 1.6 * s, 1.5 * s, '#100c10'); el(ctx, x, y + 1.6 * s, 0.9 * s, 1.2 * s, '#a01818');
  }
  function drawPaddy(ctx, x, y, ripe, t, i) {
    rr(ctx, x - 24, y - 15, 48, 20, 3, '#151b17', '#0c100d', 1.5);
    ctx.fillStyle = 'rgba(80,110,100,.12)'; ctx.fillRect(x - 22, y - 2, 44, 3);
    for (let a = 0; a < 5; a++) for (let b = 0; b < 2; b++) {
      const bx = x - 17 + a * 8.5, by = y - 7 + b * 8, sway = Math.sin(t * 1.4 + a + b) * 0.8;
      if (ripe) { ctx.strokeStyle = '#7a7048'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(bx, by); ctx.quadraticCurveTo(bx + 1, by - 10, bx + 5 + sway, by - 9); ctx.stroke(); el(ctx, bx + 5 + sway, by - 8, 1.6, 2.6, '#c8bc8a'); el(ctx, bx + 3.5 + sway, by - 10, 1.4, 2.2, '#b0a474'); }
      else { ctx.strokeStyle = '#3a4430'; ctx.lineWidth = 1.3; ctx.beginPath(); ctx.moveTo(bx, by); ctx.lineTo(bx + 1.5 + sway, by - 4); ctx.stroke(); }
    }
    drawWeb(ctx, x - 22, y - 13, 12, 0, Math.PI / 2, 0.42);
    if ((i || 0) % 2 === 0) drawSpider(ctx, x + 14, y - 16 + Math.sin(t * 1.3 + (i || 0)) * 3, y - 34, 0.9);
  }
  function drawScarecrow(ctx, x, y, t) {
    const sw = Math.sin(t * 0.9) * 0.05;
    el(ctx, x, y + 2, 12, 3.5, 'rgba(0,0,0,.35)');
    ctx.save(); ctx.translate(x, y); ctx.rotate(sw);
    rr(ctx, -1.6, -46, 3.2, 46, 1, '#4a3424', OUT, 1); rr(ctx, -20, -36, 40, 3, 1, '#4a3424', OUT, 1);
    poly(ctx, [-12, -37, 12, -37, 15, -14, 8, -18, 3, -12, -3, -17, -9, -12, -15, -16], '#4a3a40', OUT, 1.3);
    ctx.strokeStyle = '#a89058'; ctx.lineWidth = 1; [-19, 19].forEach(d => { for (let k = 0; k < 3; k++) { ctx.beginPath(); ctx.moveTo(d, -35); ctx.lineTo(d + Math.sign(d) * (3 + k), -32 + k * 2); ctx.stroke(); } });
    el(ctx, 0, -46, 9, 9.5, '#b8a47a', OUT, 1.4);
    ctx.strokeStyle = '#2a1a10'; ctx.lineWidth = 1.2; ctx.beginPath();
    ctx.moveTo(-5, -49); ctx.lineTo(-2, -46); ctx.moveTo(-2, -49); ctx.lineTo(-5, -46); ctx.moveTo(2, -49); ctx.lineTo(5, -46); ctx.moveTo(5, -49); ctx.lineTo(2, -46); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(-5, -41); ctx.lineTo(5, -41); ctx.stroke(); for (let k = -4; k <= 4; k += 2) { ctx.beginPath(); ctx.moveTo(k, -43); ctx.lineTo(k, -39); ctx.stroke(); }
    poly(ctx, [-11, -52, 11, -52, 6, -62, -5, -61], '#3a2a1a', OUT, 1.2);
    ctx.restore();
    drawCrow(ctx, x + 18, y - 40, 0.7, 0, -1, true);
  }
  function drawWillo(ctx, x, y, t) {
    const fy = y + Math.sin(t * 1.6 + x) * 5, a = 0.5 + Math.sin(t * 3 + x) * 0.25;
    const g = ctx.createRadialGradient(x, fy, 1, x, fy, 14); g.addColorStop(0, `rgba(140,220,255,${a})`); g.addColorStop(1, 'rgba(140,220,255,0)');
    ctx.fillStyle = g; ctx.fillRect(x - 14, fy - 14, 28, 28);
    ctx.beginPath(); ctx.moveTo(x - 3, fy + 2); ctx.quadraticCurveTo(x - 3, fy - 5, x + Math.sin(t * 5) * 1.5, fy - 9); ctx.quadraticCurveTo(x + 3, fy - 5, x + 3, fy + 2); ctx.arc(x, fy + 2, 3, 0, Math.PI); ctx.fillStyle = `rgba(190,240,255,${a + 0.2})`; ctx.fill();
  }
  function drawGate(ctx, x, y, t) {
    el(ctx, x, y + 4, 60, 10, 'rgba(0,0,0,.3)');
    rr(ctx, x - 52, y - 54, 14, 54, 2, '#5a2a2a', OUT, 2); rr(ctx, x + 38, y - 54, 14, 54, 2, '#5a2a2a', OUT, 2);
    rr(ctx, x - 60, y - 66, 120, 12, 3, '#3a2a3a', OUT, 2); rr(ctx, x - 50, y - 50, 100, 8, 2, '#7a3a3a', OUT, 1.5);
    roof(ctx, x, y - 84, 110, 18, '#2a2438');
    plaque(ctx, x, y - 46, '地盤', 0);
    lantern(ctx, x - 45, y - 40, t); lantern(ctx, x + 45, y - 40, t);
  }
  function drawDecor(ctx, kind, x, y, t) {
    if (kind === 'grave') { el(ctx, x, y + 2, 13, 4, 'rgba(0,0,0,.3)'); ctx.beginPath(); ctx.moveTo(x - 10, y); ctx.lineTo(x - 10, y - 18); ctx.arc(x, y - 18, 10, Math.PI, 0); ctx.lineTo(x + 10, y); ctx.closePath(); ctx.fillStyle = '#4a4660'; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.5; ctx.stroke(); ctx.fillStyle = 'rgba(255,255,255,.16)'; for (let k = 0; k < 3; k++) ctx.fillRect(x - 1.2, y - 23 + k * 6, 2.4, 3.6); }
    else if (kind === 'post') { rr(ctx, x - 2, y - 40, 4, 40, 1, '#3a2a20', OUT, 1); lantern(ctx, x, y - 38, t, '#e8e0c8'); }
    else if (kind === 'banana') { rr(ctx, x - 3, y - 34, 6, 34, 2, '#3a5a3a', OUT, 1.2); for (let k = 0; k < 5; k++) { ctx.save(); ctx.translate(x, y - 34); ctx.rotate(-2.4 + k * 0.55 + Math.sin(t + k) * 0.04); el(ctx, 17, 0, 18, 5, k % 2 ? '#2e5a3a' : '#3a6a44', OUT, 1); ctx.restore(); } }
    else if (kind === 'scarecrow') drawScarecrow(ctx, x, y, t);
    else if (kind === 'willo') drawWillo(ctx, x, y, t);
    else if (kind === 'webTL') drawWeb(ctx, x, y, 30, 0, Math.PI / 2, 0.32);
    else if (kind === 'webTR') drawWeb(ctx, x, y, 30, Math.PI / 2, Math.PI, 0.32);
    else if (kind === 'offer') { rr(ctx, x - 9, y - 6, 18, 6, 1, '#7a3a2a', OUT, 1); for (let k = -1; k <= 1; k++) { rr(ctx, x + k * 4 - 0.6, y - 16, 1.2, 10, 0.5, '#c8a050'); el(ctx, x + k * 4, y - 16, 1.2, 1.2, '#ff8040'); } ctx.strokeStyle = 'rgba(220,220,240,.25)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(x, y - 17); ctx.quadraticCurveTo(x + 4 + Math.sin(t * 2) * 3, y - 26, x, y - 34); ctx.stroke(); }
  }
  const hasRig = (type) => typeof MeshAnim !== 'undefined' && !!CHAR_H[type] && MeshAnim.has(type);
  return { CHAR_H, SOLID, hasRig, drawCrow, drawDecor, drawChar, portrait, sysIcon, drawBuilding, drawSite, drawTree, drawPaddy, drawGate, el, rr, poly, lantern, OUT };
})();
