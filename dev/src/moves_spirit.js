// ===================== 專屬招式（靈體 + 活人 NPC）：Pontianak、水鬼、天花姐、保安阿伯、清潔安娣、陳總 =====================
// 全部用原圖：整張原圖網格變形（MeshAnim）、原圖拆出來的件（cut/<id>__xxx.png，art/cutspirit.py 切）移動／旋轉、
// Pontianak 的長髮是把她原圖上的一束頭髮沿曲線拉長（貼圖帶狀變形），天花姐倒掛用她自己的倒掛原圖 tianhua_hang。
// 特效（水、聲波、字）是程式畫的蠟筆風。
// 進度 g：預備 0~0.40、出手 0.40~0.60（命中在 0.484）、收招 0.60~1。
// 本地座標：一律換成「原圖面朝左」來想，往前 = -x，往上 = -y，原點 = 自己腳下。
// 會寫回 a.o.vic（受擊方的配合動作：sink 下沉、sq 被勒）和 a.o.hitP（命中點，世界座標）——遊戲不用也沒關係，樣板頁用來做受擊。
(() => {
  const PI = Math.PI, D = PI / 180;
  const cl = (v, a = 0, b = 1) => Math.max(a, Math.min(b, v));
  const lerp = (a, b, k) => a + (b - a) * k;
  const eo = (t) => 1 - (1 - t) * (1 - t), ei = (t) => t * t, eio = (t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t), eo3 = (t) => 1 - Math.pow(1 - t, 3);
  const backOut = (t) => { const c = 1.7; return 1 + (c + 1) * Math.pow(t - 1, 3) + c * Math.pow(t - 1, 2); };
  const seg = (g, a, b) => cl((g - a) / (b - a));
  const bump = (g, a, m, b) => g < a || g > b ? 0 : g < m ? eo((g - a) / (m - a)) : 1 - eio((g - m) / (b - m));
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const HIT = 0.4 + 0.2 * 0.42;
  function prog(o) {
    const p = cl(o.pt || 0);
    switch (o.pose) { case 'windup': return 0.4 * p; case 'strike': return 0.4 + 0.2 * p; case 'follow': return 0.6; case 'recover': return 0.6 + 0.4 * p; }
    return 0;
  }
  // 對手：本地座標（前方 = -x），h = 對手大約身高
  function foe(a, def) {
    const o = a.o; let f = o.tdx != null ? (a.faceRight ? o.tdx : -o.tdx) : def * a.H;
    f = Math.max(f, a.H * 0.3); return { x:-f, y:o.tdy || 0, h:58 * (a.s || a.H / 60) };
  }
  const rot = (x, y, a) => { const c = Math.cos(a), s = Math.sin(a); return [x * c - y * s, x * s + y * c]; };
  const begin = (ctx, a) => { ctx.save(); ctx.translate(a.x, a.y); if (a.faceRight) ctx.scale(-1, 1); };
  const world = (a, x, y) => [a.x + (a.faceRight ? -x : x), a.y + y];
  const floatY = (a) => a.solid ? 0 : -(3 + Math.sin((a.o.t || 0) * 2.4) * 2) * (a.s || a.H / 60);
  const base = (t) => MeshAnim.ANIM.idle(t || 0);
  const pz = (t, add) => Object.assign(base(t), add || {});
  // 沒翻轉的字（面朝右時本地座標是鏡像的，字要轉回來）
  const upright = (ctx, a, x, y, fn) => { ctx.save(); ctx.translate(x, y); if (a.faceRight) ctx.scale(-1, 1); fn(); ctx.restore(); };
  let R = 1; const rnd = (s) => { const x = Math.sin(s * 127.1 + 311.7) * 43758.5453; return x - Math.floor(x); };

  // ---------- 貼圖三角形（原圖某三點 → 畫面三點），帶狀變形用 ----------
  function tri(ctx, img, s0, s1, s2, d0, d1, d2) {
    const [u0, v0] = s0, [u1, v1] = s1, [u2, v2] = s2, [x0, y0] = d0, [x1, y1] = d1, [x2, y2] = d2;
    const den = u0 * (v1 - v2) + u1 * (v2 - v0) + u2 * (v0 - v1); if (Math.abs(den) < 1e-6) return;
    const cx = (x0 + x1 + x2) / 3, cy = (y0 + y1 + y2) / 3, e = 0.7;
    const ex = (px, py) => { const dx = px - cx, dy = py - cy, l = Math.hypot(dx, dy) || 1; return [px + dx / l * e, py + dy / l * e]; };
    const A = ex(x0, y0), B = ex(x1, y1), C = ex(x2, y2);
    ctx.save(); ctx.beginPath(); ctx.moveTo(A[0], A[1]); ctx.lineTo(B[0], B[1]); ctx.lineTo(C[0], C[1]); ctx.closePath(); ctx.clip();
    const m11 = (x0 * (v1 - v2) + x1 * (v2 - v0) + x2 * (v0 - v1)) / den, m12 = (y0 * (v1 - v2) + y1 * (v2 - v0) + y2 * (v0 - v1)) / den;
    const m21 = (x0 * (u2 - u1) + x1 * (u0 - u2) + x2 * (u1 - u0)) / den, m22 = (y0 * (u2 - u1) + y1 * (u0 - u2) + y2 * (u1 - u0)) / den;
    const dx = (x0 * (u1 * v2 - u2 * v1) + x1 * (u2 * v0 - u0 * v2) + x2 * (u0 * v1 - u1 * v0)) / den, dy = (y0 * (u1 * v2 - u2 * v1) + y1 * (u2 * v0 - u0 * v2) + y2 * (u0 * v1 - u1 * v0)) / den;
    ctx.transform(m11, m12, m21, m22, dx, dy); ctx.drawImage(img, 0, 0); ctx.restore();
  }
  // 折線：等距重取樣、算長度
  function resample(pts, n) {
    const L = [0]; for (let i = 1; i < pts.length; i++) L.push(L[i - 1] + Math.hypot(pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1]));
    const tot = L[L.length - 1] || 1, out = []; let j = 0;
    for (let i = 0; i < n; i++) { const s = tot * i / (n - 1); while (j < pts.length - 2 && L[j + 1] < s) j++; const k = (s - L[j]) / ((L[j + 1] - L[j]) || 1); out.push([lerp(pts[j][0], pts[j + 1][0], k), lerp(pts[j][1], pts[j + 1][1], k)]); }
    return { pts:out, len:tot };
  }
  const normals = (P) => P.map((p, i) => { const a = P[Math.max(0, i - 1)], b = P[Math.min(P.length - 1, i + 1)], dx = b[0] - a[0], dy = b[1] - a[1], l = Math.hypot(dx, dy) || 1; return [-dy / l, dx / l]; });
  // 帶狀貼圖：原圖上一條（src 折線，像素座標、半寬 sw）沿畫面上一條（dst 折線、半寬 wf(i)）貼過去；太長就來回鋪（頭髮紋理接得上）
  // depth(i) 回傳 0~1：小於 1 的那段畫淡一點（繞到對手背後）
  function ribbon(ctx, img, src, sw, dst, wf, stretch, depth) {
    const S = resample(src, 40), SN = normals(S.pts), N = dst.length; if (N < 2) return;
    const DN = normals(dst); let acc = 0; const sp = [];
    for (let i = 0; i < N; i++) {
      if (i) acc += Math.hypot(dst[i][0] - dst[i - 1][0], dst[i][1] - dst[i - 1][1]);
      let q = acc / stretch, per = S.len; q = q % (2 * per); if (q > per) q = 2 * per - q; // 來回鋪
      const f = q / per * (S.pts.length - 1), j = Math.min(S.pts.length - 2, Math.floor(f)), k = f - j;
      const c = [lerp(S.pts[j][0], S.pts[j + 1][0], k), lerp(S.pts[j][1], S.pts[j + 1][1], k)], n = SN[j];
      sp.push([[c[0] + n[0] * sw, c[1] + n[1] * sw], [c[0] - n[0] * sw, c[1] - n[1] * sw]]);
    }
    const a0 = ctx.globalAlpha;
    for (let i = 0; i < N - 1; i++) {
      const w0 = wf(i), w1 = wf(i + 1), d = dst[i], e = dst[i + 1], n0 = DN[i], n1 = DN[i + 1];
      const A = [d[0] + n0[0] * w0, d[1] + n0[1] * w0], B = [d[0] - n0[0] * w0, d[1] - n0[1] * w0], C = [e[0] + n1[0] * w1, e[1] + n1[1] * w1], E = [e[0] - n1[0] * w1, e[1] - n1[1] * w1];
      ctx.globalAlpha = a0 * (depth ? depth(i) : 1);
      tri(ctx, img, sp[i][0], sp[i][1], sp[i + 1][0], A, B, C); tri(ctx, img, sp[i][1], sp[i + 1][1], sp[i + 1][0], B, E, C);
    }
    ctx.globalAlpha = a0;
  }

  // ---------- 程式畫的蠟筆特效 ----------
  // 蠟筆字（粗、紅金漸層、深色外框、顆粒），先畫在小畫布上快取
  const GLY = {};
  function glyph(ch, c1, c2) {
    const key = ch + c1 + c2; if (GLY[key]) return GLY[key];
    const S = 168, c = document.createElement('canvas'); c.width = c.height = S; const x = c.getContext('2d');
    const font = '900 120px "Noto Sans CJK TC","Noto Sans TC","PingFang TC","Microsoft JhengHei","Heiti TC",sans-serif';
    x.font = font; x.textAlign = 'center'; x.textBaseline = 'middle'; x.lineJoin = 'round'; x.lineCap = 'round';
    x.strokeStyle = '#2a120c'; x.lineWidth = 24; x.strokeText(ch, S / 2 + 3, S / 2 + 6);
    x.lineWidth = 19; x.strokeText(ch, S / 2 - 1, S / 2 + 2);
    const c2_ = document.createElement('canvas'); c2_.width = c2_.height = S; const y = c2_.getContext('2d');
    y.font = font; y.textAlign = 'center'; y.textBaseline = 'middle';
    const g = y.createLinearGradient(0, S * 0.18, 0, S * 0.85); g.addColorStop(0, c1); g.addColorStop(1, c2); y.fillStyle = g; y.fillText(ch, S / 2, S / 2 + 2);
    y.globalCompositeOperation = 'source-atop';
    for (let i = 0; i < 1400; i++) { const r1 = rnd(i * 3.1 + ch.charCodeAt(0)), r2 = rnd(i * 7.7 + 1), r3 = rnd(i * 1.3 + 9); y.fillStyle = r3 < 0.55 ? 'rgba(255,248,215,.32)' : 'rgba(110,20,0,.22)'; y.save(); y.translate(r1 * S, r2 * S); y.rotate(-0.5); y.fillRect(0, 0, 2 + r3 * 4, 1.4); y.restore(); }
    y.fillStyle = 'rgba(255,255,240,.28)'; y.fillRect(0, S * 0.26, S, S * 0.07);
    x.drawImage(c2_, 0, 0); GLY[key] = c; return c;
  }
  // 小字（哎喲）：白字深框、微抖
  function smallText(ctx, a, x, y, txt, size, alpha, t) {
    if (alpha <= 0) return;
    upright(ctx, a, x, y, () => {
      ctx.globalAlpha *= alpha; ctx.rotate(Math.sin(t * 23) * 0.06 - 0.08);
      ctx.font = `900 ${size}px "Noto Sans CJK TC","Noto Sans TC","PingFang TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.lineJoin = 'round';
      ctx.strokeStyle = '#2a1a22'; ctx.lineWidth = size * 0.28; ctx.strokeText(txt, 0, 0);
      ctx.fillStyle = '#fff3e8'; ctx.fillText(txt, 0, 0);
    });
  }
  // 蠟筆線（抖一點、兩層）
  function crayonLine(ctx, pts, w, col, outline) {
    const path = () => { ctx.beginPath(); pts.forEach((p, i) => i ? ctx.lineTo(p[0], p[1]) : ctx.moveTo(p[0], p[1])); };
    ctx.lineCap = 'round'; ctx.lineJoin = 'round';
    if (outline) { ctx.strokeStyle = outline; ctx.lineWidth = w * 2.1; path(); ctx.stroke(); }
    ctx.strokeStyle = col; ctx.lineWidth = w; path(); ctx.stroke();
  }
  // 水窪（深色、邊緣抖動、漣漪）
  function puddle(ctx, x, y, r, k, t, seed) {
    if (r <= 0.5) return;
    const ry = r * 0.27, path = (rr, ryy) => { ctx.beginPath(); for (let i = 0; i <= 40; i++) { const an = i / 40 * PI * 2, j = 1 + 0.07 * Math.sin(an * 5 + seed) + 0.04 * Math.sin(an * 11 + seed * 2 + t * 3); const px = x + Math.cos(an) * rr * j, py = y + Math.sin(an) * ryy * j; i ? ctx.lineTo(px, py) : ctx.moveTo(px, py); } ctx.closePath(); };
    ctx.save(); ctx.globalAlpha *= k;
    path(r * 1.06, ry * 1.1); ctx.fillStyle = 'rgba(12,22,28,.55)'; ctx.fill();
    path(r, ry); const g = ctx.createRadialGradient(x, y, 0, x, y, r); g.addColorStop(0, 'rgba(6,14,20,.97)'); g.addColorStop(0.7, 'rgba(14,34,44,.94)'); g.addColorStop(1, 'rgba(34,66,80,.88)'); ctx.fillStyle = g; ctx.fill();
    ctx.strokeStyle = 'rgba(130,190,205,.55)'; ctx.lineWidth = Math.max(1, r * 0.035);
    for (let i = 0; i < 2; i++) { const q = ((t * 0.9 + i * 0.5) % 1); ctx.globalAlpha = k * (1 - q) * 0.8; ctx.beginPath(); ctx.ellipse(x, y, r * (0.25 + 0.7 * q), ry * (0.25 + 0.7 * q), 0, 0, PI * 2); ctx.stroke(); }
    ctx.globalAlpha = k * 0.6; ctx.strokeStyle = 'rgba(190,230,240,.5)'; ctx.beginPath(); ctx.ellipse(x - r * 0.25, y - ry * 0.35, r * 0.3, ry * 0.18, 0, PI * 1.1, PI * 1.8); ctx.stroke();
    ctx.restore();
  }
  // 水花：從 (x,y) 噴出的水珠，q = 0~1 經過的進度
  function splash(ctx, x, y, size, q, n, seed, up) {
    if (q <= 0 || q >= 1) return;
    ctx.save();
    for (let i = 0; i < n; i++) {
      const r1 = rnd(seed + i * 1.7), r2 = rnd(seed + i * 3.3), an = -PI / 2 + (r1 - 0.5) * (up ? 2.0 : 2.8), sp = size * (0.6 + r2 * 0.9);
      const px = x + Math.cos(an) * sp * q, py = y + Math.sin(an) * sp * q * (up || 1) + size * 1.6 * q * q, rr = size * (0.018 + r2 * 0.02) * (1 - q * 0.4);
      if (py > y + size * 0.03) continue; // 落回地面（水裡）就不畫
      ctx.globalAlpha = (1 - q) * 0.95;
      ctx.fillStyle = 'rgba(30,60,72,.9)'; ctx.beginPath(); ctx.ellipse(px, py, rr * 1.25, rr * 1.7, an + PI / 2, 0, PI * 2); ctx.fill();
      ctx.fillStyle = 'rgba(160,215,230,.95)'; ctx.beginPath(); ctx.ellipse(px, py, rr, rr * 1.4, an + PI / 2, 0, PI * 2); ctx.fill();
      ctx.fillStyle = 'rgba(255,255,255,.9)'; ctx.beginPath(); ctx.arc(px - rr * 0.3, py - rr * 0.4, rr * 0.35, 0, PI * 2); ctx.fill();
    }
    ctx.restore();
  }
  // 爪痕：一道兩頭尖的白痕，外面一圈暗紅
  function slash(ctx, x0, y0, x1, y1, w) {
    const dx = x1 - x0, dy = y1 - y0, l = Math.hypot(dx, dy) || 1, nx = -dy / l * w, ny = dx / l * w, mx = (x0 + x1) / 2, my = (y0 + y1) / 2;
    ctx.beginPath(); ctx.moveTo(x0, y0); ctx.quadraticCurveTo(mx + nx * 2, my + ny * 2, x1, y1); ctx.quadraticCurveTo(mx - nx * 2, my - ny * 2, x0, y0); ctx.closePath();
    ctx.lineJoin = 'round'; ctx.strokeStyle = 'rgba(120,10,30,.75)'; ctx.lineWidth = w * 0.9; ctx.stroke(); ctx.fillStyle = '#fff4f2'; ctx.fill();
  }
  function drip(ctx, x, y, size, q, seed, rad) { // 一滴往下掉（size：掉多遠 ÷1.4）
    if (q <= 0 || q >= 1) return; const py = y + size * 1.4 * q * q, rr = rad || size * 0.03;
    ctx.save(); ctx.globalAlpha = 1 - q * 0.6; ctx.fillStyle = 'rgba(30,60,72,.9)'; ctx.beginPath(); ctx.ellipse(x, py, rr * 1.2, rr * 1.8, 0, 0, PI * 2); ctx.fill();
    ctx.fillStyle = 'rgba(165,215,232,.95)'; ctx.beginPath(); ctx.ellipse(x, py, rr * 0.9, rr * 1.4, 0, 0, PI * 2); ctx.fill(); ctx.restore();
  }
  // 速度線
  function streaks(ctx, x, y0, y1, w, n, alpha, seed) {
    if (alpha <= 0) return; ctx.save(); ctx.globalAlpha *= alpha; ctx.lineCap = 'round';
    for (let i = 0; i < n; i++) { const xx = x + (rnd(seed + i) - 0.5) * w, a = y0 + (y1 - y0) * rnd(seed + i * 2.3) * 0.3, b = y1 - (y1 - y0) * rnd(seed + i * 5.1) * 0.3;
      ctx.strokeStyle = 'rgba(40,24,40,.5)'; ctx.lineWidth = 4; ctx.beginPath(); ctx.moveTo(xx, a); ctx.lineTo(xx, b); ctx.stroke();
      ctx.strokeStyle = 'rgba(255,246,230,.85)'; ctx.lineWidth = 1.8; ctx.beginPath(); ctx.moveTo(xx, a); ctx.lineTo(xx, b); ctx.stroke(); }
    ctx.restore();
  }
  // 灰塵（天花板掉下來的）
  function dust(ctx, x, y, size, q, n, seed) {
    if (q <= 0 || q >= 1) return; ctx.save();
    for (let i = 0; i < n; i++) { const r1 = rnd(seed + i), r2 = rnd(seed + i * 2.7), px = x + (r1 - 0.5) * size * (0.6 + q), py = y + size * 0.8 * q * q * (0.5 + r2) - size * 0.15 * q;
      ctx.globalAlpha = (1 - q) * 0.8; ctx.fillStyle = i % 3 ? 'rgba(205,190,170,.9)' : 'rgba(120,100,90,.9)'; ctx.beginPath(); ctx.arc(px, py, size * (0.012 + r2 * 0.02), 0, PI * 2); ctx.fill(); }
    ctx.restore();
  }

  // ======================================================================
  // Pontianak：長髮纏——身邊一束長髮甩出去，捲住對手勒緊；她尖叫著往前飄
  // ======================================================================
  const PT_SRC = [[0.30, 0.14], [0.22, 0.27], [0.15, 0.40], [0.11, 0.52], [0.11, 0.64], [0.15, 0.76]]; // 原圖左邊那把長髮的走向
  MOVES.pontianak = function (ctx, a) {
    if (!ok('pontianak') || !MeshAnim.RIG.pontianak) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 0.68), img = SPR.pontianak, W = H * img.naturalWidth / img.naturalHeight;
    const iw = img.naturalWidth, ih = img.naturalHeight, Ht = F.h;
    // 身體：預備往後仰、頭髮炸開、浮高；出手往前飄、前傾；收招飄回來
    const rear = eio(seg(g, 0.0, 0.34)), go = eo3(seg(g, 0.32, HIT)), back = eio(seg(g, 0.66, 1));
    const fwd = Math.min(H * 0.22, Math.max(0, -F.x - H * 0.55));
    const dx = (H * 0.06 * rear * (1 - go) - (fwd + H * 0.04) * go) * (1 - back), dy = floatY(a) - H * (0.05 * rear + 0.04 * go) * (1 - back);
    const shake = g > 0.22 && g < 0.66 ? Math.sin(t * 60) * H * 0.006 : 0;
    const pose = pz(t, { body:(0.10 * rear - 0.16 * go) * (1 - back), head:(-0.14 * rear - 0.06 * go) * (1 - back), hairL:(0.35 * rear - 0.25 * go) * (1 - back), hairR:(-0.3 * rear + 0.2 * go) * (1 - back),
      armF:(0.4 * rear) * (1 - back), armB:(-0.4 * rear) * (1 - back), sy:1 + 0.04 * rear - 0.03 * go, sx:1 - 0.03 * rear + 0.03 * go });
    a.shadow(world(a, dx, 0)[0], 0.8);
    begin(ctx, a);
    const ox = dx + shake, oy = dy;
    const P = (fx, fy) => [ox + (fx - 0.5) * W, oy - H + fy * H]; // 原圖比例 → 本地（約略，不含網格變形）
    // 頭髮：三束，根在頭的左邊，出手時甩出去捲住對手
    const ext = g < HIT ? eo(seg(g, 0.37, HIT)) : g < 0.64 ? 1 : 1 - eio(seg(g, 0.64, 0.92));
    const sq = bump(g, HIT, 0.52, 0.66); // 勒緊
    o.vic = { sq:sq, shake:sq };
    const strands = [];
    if (ext > 0.01) {
      const C = [F.x, F.y]; const rx0 = Ht * 0.2 * (1 - 0.2 * sq);
      const defs = [{ root:[0.27, 0.20], h:0.50, turns:1.25, w:0.075, sh:0.0, ph:0.0 }, { root:[0.24, 0.27], h:0.70, turns:1.1, w:0.068, sh:-0.025, ph:1.7 }, { root:[0.22, 0.34], h:0.33, turns:1.0, w:0.062, sh:0.02, ph:3.1 }];
      defs.forEach((d, k) => {
        const r0 = P(d.root[0], d.root[1]), cy = C[1] - Ht * d.h, rx = rx0 * (1 - k * 0.06), ry = Ht * 0.055;
        // 去程：從頭髮根部往前上方甩出去，越過對手的頭，落到對手另一側
        const s0 = [C[0] - rx, cy], c1 = [r0[0] - H * 0.12, r0[1] - H * (0.32 + 0.07 * k)], c2 = [C[0] - rx * 1.6, C[1] - Ht * (1.15 + 0.05 * k)], app = [];
        for (let i = 0; i <= 26; i++) { const u = i / 26, v = 1 - u; app.push([v * v * v * r0[0] + 3 * u * v * v * c1[0] + 3 * u * u * v * c2[0] + u * u * u * s0[0], v * v * v * r0[1] + 3 * u * v * v * c1[1] + 3 * u * u * v * c2[1] + u * u * u * s0[1]]); }
        // 纏繞：從另一側繞到前面，一圈多（前面那半圈在對手前面，後面那半圈淡一點）
        const wrap = [];
        const NT = Math.round(28 * d.turns);
        for (let i = 1; i <= NT; i++) { const an = PI - i / NT * d.turns * PI * 2; wrap.push([C[0] + rx * Math.cos(an), cy + ry * Math.sin(an) - Ht * 0.06 * (i / NT * d.turns)]); }
        const full = app.concat(wrap), dep = full.map((p, i) => i < app.length ? (p[0] < C[0] + rx * 0.2 && p[1] > C[1] - Ht * 1.0 ? 0.4 : 1) : (Math.sin(PI - (i - app.length + 1) / NT * d.turns * PI * 2) >= 0 ? 1 : 0.4)); // 越過頭、從對手背後落下那段畫淡（在後面）
        // 甩的波：越沒伸到底越彎
        const n = full.length, show = Math.max(2, Math.round(n * ext));
        const pts = full.slice(0, show).map((p, i) => { if (i >= app.length) return p; const u = i / app.length, wv = Math.sin(u * PI * 2.2 - t * 14 + d.ph) * H * 0.07 * (1 - ext * 0.85) * Math.sin(u * PI); return [p[0], p[1] + wv]; });
        strands.push({ pts, dep, w:H * d.w, k, src:PT_SRC.map(([x, y]) => [(x + d.sh) * iw, y * ih]) });
      });
    }
    // 頭髮在身體後面（從頭的後側長出來）先畫一部分？——整束畫在身體前面，根部被她自己的頭髮蓋住才自然：先畫頭髮，再畫身體，再畫纏住對手的那段
    const drawStrand = (s, from, to) => {
      const seg_ = s.pts.slice(from, to + 1); if (seg_.length < 2) return;
      const n = s.pts.length;
      ribbon(ctx, img, s.src, iw * 0.06, seg_, (i) => { const u = (from + i) / Math.max(1, n - 1); return s.w * (0.95 - 0.5 * u) * (u < 0.05 ? 0.75 + u * 5 : 1); }, H / ih * 1.3, (i) => s.dep[from + i] != null ? s.dep[from + i] : 1);
    };
    const split = (s) => Math.min(s.pts.length - 1, 6);
    for (const s of strands) drawStrand(s, 0, split(s));
    ctx.save(); ctx.translate(ox, oy); MeshAnim.drawBody(ctx, 'pontianak', 'pontianak', H, pose); ctx.restore();
    for (const s of strands) drawStrand(s, split(s), s.pts.length - 1);
    // 尖叫：嘴巴前面一圈圈抖動的聲波
    const sk = bump(g, 0.2, 0.36, 0.7);
    if (sk > 0) {
      const m = P(0.43, 0.29);
      for (let i = 0; i < 3; i++) {
        const q = ((g - 0.2) * 4.2 + i / 3) % 1, r = H * (0.1 + 0.5 * q);
        const pts = []; for (let j = 0; j <= 16; j++) { const an = PI + (j / 16 - 0.5) * 1.5, rr = r * (1 + 0.012 * Math.sin(j * 1.3 + t * 40)); pts.push([m[0] + Math.cos(an) * rr, m[1] + Math.sin(an) * rr]); }
        ctx.save(); ctx.globalAlpha *= sk * Math.min(1, (1 - q) * 1.6); crayonLine(ctx, pts, Math.max(2, H * 0.024), '#f4f8ff', 'rgba(40,24,70,.7)'); ctx.restore();
      }
    }
    ctx.restore();
    if (g >= HIT && g < HIT + 0.02) o.hitP = world(a, F.x + Ht * 0.1, F.y - Ht * 0.6);
    return true;
  };

  // ======================================================================
  // 水鬼：自己沉進腳下的水裡；對手腳下冒出一灘黑水，水鬼的手從水裡伸出來抓住、往下拖，水花四濺；然後從自己的水窪浮上來
  // ======================================================================
  MOVES.shuigui = function (ctx, a) {
    if (!ok('shuigui') || !ok('shuigui__arm')) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 0.68), img = SPR.shuigui, W = H * img.naturalWidth / img.naturalHeight, Ht = F.h;
    const sink = g < 0.6 ? eio(seg(g, 0.04, 0.34)) : 1 - eo3(seg(g, 0.74, 0.98));      // 自己沉下去／浮上來
    const myP = bump(g, 0.0, 0.12, 1.0) * (g > 0.9 ? 1 - seg(g, 0.9, 1) : 1);          // 自己腳下的水窪
    const tp = g < 0.7 ? eo(seg(g, 0.16, 0.42)) : 1 - eio(seg(g, 0.72, 0.96));        // 對手腳下的水窪
    const rise = g < HIT ? backOut(seg(g, 0.40, HIT)) : 1, pull = eio(seg(g, 0.53, 0.76));
    o.vic = { sink:pull * (1 - seg(g, 0.8, 0.98)) * 0.32, shake:bump(g, HIT, 0.5, 0.62) };
    if (sink < 0.95) a.shadow(a.x, 0.8 * (1 - sink));
    begin(ctx, a);
    // 自己的水窪 + 身體（地面以下剪掉）
    puddle(ctx, 0, 0, H * 0.27 * eo(cl(myP * 1.6)), 1, t, 1.3);
    if (sink < 0.995) {
      ctx.save(); ctx.beginPath(); ctx.rect(-H * 3, -H * 4, H * 6, H * 4 + H * 0.01); ctx.clip();
      const dy = floatY(a) * (1 - sink) + sink * H * 1.02, lean = (g < 0.6 ? 0.12 * sink : -0.1 * sink);
      ctx.translate(0, dy); ctx.scale(-1, 1); // 水鬼原圖面朝右：鏡像成面朝左
      MeshAnim.drawBody(ctx, 'shuigui', 'shuigui', H, pz(t, { body:lean, head:-0.1 * sink, armB:-0.5 * sink, armF:0.4 * sink, hairL:0.3 * sink, hairR:-0.3 * sink, sy:1 + 0.06 * sink, sx:1 - 0.04 * sink }));
      ctx.restore();
      // 浮上來：身上滴水
      if (g > 0.74) for (let i = 0; i < 6; i++) { const yy = -H * (0.25 + rnd(i * 2.1) * 0.5) * (1 - sink); drip(ctx, (rnd(i + 3) - 0.5) * W * 0.6, yy, -yy / 1.4, ((g - 0.74) * 4 + rnd(i * 5.3)) % 1, i, H * 0.016); }
    }
    // 沉下去的水花
    splash(ctx, 0, 0, H * 0.5, seg(g, 0.2, 0.42), 7, 2.2);
    // 對手腳下：黑水 + 伸出來的手
    const tx = F.x, ty = F.y, rP = Ht * 0.4 * tp;
    puddle(ctx, tx, ty + Ht * 0.01, rP, 1, t, 4.1);
    if (g > 0.36 && g < 0.86) {
      const arm = SPR.shuigui__arm, k = 2.1, PVx = 0.72, PVy = 0.53, len = (0.95 - PVx) * W * k;
      const up = rise * (1 - pull * 0.85);
      const ang = (90 - 14 * cl(rise) + 10 * pull) * D;          // 手朝上、往對手那邊勾
      const reachY = ty - Ht * 0.48;                               // 抓到對手腰
      const px = tx + Ht * 0.14 + Math.cos(ang) * len, py = lerp(ty + len * 1.1, reachY + len * Math.sin(ang), up); // 轉軸（手肘）在水面下
      ctx.save(); ctx.beginPath(); ctx.rect(tx - Ht * 2, ty - Ht * 3, Ht * 4, Ht * 3 + Ht * 0.012); ctx.clip();
      ctx.save(); ctx.translate(px, py); ctx.rotate(ang); ctx.scale(-k, k);
      ctx.drawImage(arm, -PVx * W, -PVy * H, W, H);
      ctx.restore();
      // 黑水沿著手臂往上黏（水鬼的手是從水裡長出來的）
      const ux = -Math.cos(ang), uy = -Math.sin(ang), s0 = (py - ty) / -uy, s1 = Math.max(s0 + len * 0.25 * cl(up * 2), len * 0.3); // 從水面一路接到手肘上面
      if (s1 > s0 + 1) {
        const nx = -uy, ny = ux, pts = [];
        for (let i = 0; i <= 8; i++) { const q = i / 8, sp = lerp(s0, s1, q), w = Ht * (0.085 - 0.06 * q) * (1 + 0.15 * Math.sin(t * 9 + i * 1.7)); pts.push([px + ux * sp + nx * w, py + uy * sp + ny * w]); }
        for (let i = 8; i >= 0; i--) { const q = i / 8, sp = lerp(s0, s1, q), w = Ht * (0.085 - 0.06 * q) * (1 + 0.15 * Math.sin(t * 9 + i * 2.3 + 1)); pts.push([px + ux * sp - nx * w, py + uy * sp - ny * w]); }
        ctx.beginPath(); pts.forEach((p, i) => i ? ctx.lineTo(p[0], p[1]) : ctx.moveTo(p[0], p[1])); ctx.closePath();
        ctx.fillStyle = 'rgba(10,26,34,.88)'; ctx.fill(); ctx.strokeStyle = 'rgba(130,190,205,.55)'; ctx.lineWidth = Math.max(1, Ht * 0.012); ctx.stroke();
      }
      ctx.restore();
      // 手破水而出的水花、拖下去的水花
      splash(ctx, tx + Ht * 0.12, ty, Ht * 0.8, seg(g, 0.40, 0.62), 12, 7.7);
      splash(ctx, tx, ty, Ht * 0.6, seg(g, 0.56, 0.8), 9, 12.9, 0.7);
      // 手上滴水
      for (let i = 0; i < 3; i++) drip(ctx, tx + Ht * (0.06 + 0.06 * i), ty - Ht * 0.45 * up, Ht * 0.45 * up / 1.4, ((g - 0.45) * 3.5 + i / 3) % 1, i + 20, Ht * 0.016);
    }
    ctx.restore();
    if (g >= HIT && g < HIT + 0.02) o.hitP = world(a, F.x + Ht * 0.08, F.y - Ht * 0.22);
    return true;
  };

  // ======================================================================
  // 天花姐：一手扶腰「哎喲」→ 蹬上天花板不見 → 倒掛著從對手頭上垂下來，長髮垂下，一爪由上往下抓 → 縮回天花板 → 掉回原位（又扶腰）
  // ======================================================================
  MOVES.tianhua = function (ctx, a) {
    if (!ok('tianhua') || !ok('tianhua_hang')) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 1.9), Ht = F.h;
    const hang = SPR.tianhua_hang, hh = H * 645 / 577, hw = hh * hang.naturalWidth / hang.naturalHeight; // 倒掛原圖 645px 高、站姿原圖 577px 高：同一個比例
    const OUT = H * 5;
    // ---- 地面上的她：起跳、落地 ----
    let gy = null, ps = null, ouch = 0;
    if (g < 0.32) {
      const crouch = eo(seg(g, 0.0, 0.14)), jump = ei(seg(g, 0.15, 0.32));
      gy = -OUT * jump; ouch = bump(g, 0.0, 0.05, 0.22);
      ps = { body:0.18 * crouch * (1 - jump), head:0.12 * crouch, sy:1 - 0.1 * crouch * (1 - jump) + 0.25 * jump, sx:1 + 0.06 * crouch * (1 - jump) - 0.12 * jump, y:0.02 * crouch * (1 - jump) };
    } else if (g > 0.8) {
      const fall = seg(g, 0.8, 0.9), land = seg(g, 0.9, 1);
      gy = -OUT * 0.5 * (1 - ei(fall)); ouch = g > 0.9 ? bump(g, 0.9, 0.93, 1.0) * 1 + 0.001 : 0;
      const sq = g > 0.9 ? Math.sin(land * PI) * (1 - land * 0.5) : 0;
      ps = { body:0.22 * sq, head:0.15 * sq, sy:1 - 0.16 * sq + (g < 0.9 ? 0.12 : 0), sx:1 + 0.1 * sq - (g < 0.9 ? 0.06 : 0), y:0.02 * sq };
    }
    if (gy != null) a.shadow(a.x, Math.max(0.2, 1 + gy / (H * 1.5)));
    // 倒掛的位置：對手頭上
    const claw = [-(0.82 - 0.72) * hw, 0.86 * hh]; // 錨點（尾巴尖）→ 爪子（倒掛圖鏡像後）
    const ax = F.x + Ht * 0.04 - claw[0], ay = F.y - Ht * 0.86 - claw[1];
    let hy = null, sw = 0;
    if (g >= 0.38 && g <= 0.8) {
      const drop = backOut(seg(g, 0.38, HIT)), up = ei(seg(g, 0.64, 0.8));
      hy = ay - OUT * (1 - drop) - OUT * up;
      // 爪子：預備往後擺 → 由上往下劃過對手的頭 → 擺過頭 → 盪回來
      sw = g < HIT ? -26 * seg(g, 0.38, HIT) : g < 0.6 ? lerp(-26, 30, eo3(seg(g, HIT - 0.03, 0.58))) : lerp(30, 0, eio(seg(g, 0.6, 0.7)));
      if (g < HIT) sw = -26 * eo(seg(g, 0.4, 0.46)) + 26 * ei(seg(g, 0.46, HIT)) * 0.9;
    }
    o.vic = { shake:bump(g, HIT, 0.5, 0.6) };
    if (hy != null) a.shadow(a.x + (a.faceRight ? -1 : 1) * ax, 0.5);
    begin(ctx, a);
    if (gy != null) {
      ctx.save(); ctx.translate(0, gy + floatY(a)); MeshAnim.drawBody(ctx, 'tianhua', 'tianhua', H, pz(t, ps)); ctx.restore();
      if (g > 0.14 && g < 0.34) streaks(ctx, 0, gy - H * 0.2, gy + H * 1.2, H * 0.5, 7, seg(g, 0.14, 0.2) * (1 - seg(g, 0.3, 0.34)), 5);
      if (g > 0.8 && g < 0.92) streaks(ctx, 0, gy - H * 1.6, gy - H * 0.9, H * 0.5, 6, 0.8, 9);
      dust(ctx, 0, 0, H * 0.6, seg(g, 0.15, 0.4), 8, 3.3);
      dust(ctx, 0, 0, H * 0.6, seg(g, 0.9, 1.0), 8, 6.1);
      // 「哎喲」＋扶腰（原圖本來就一手扶著腰）
      if (ouch > 0) smallText(ctx, a, H * 0.2, gy - H * 1.08, '哎喲', H * 0.2, Math.min(1, ouch * 2), t);
    }
    // 她在天花板上爬過去：對手頭上先掉一點灰
    dust(ctx, F.x, F.y - Ht * 2.1, Ht * 1.2, seg(g, 0.27, 0.45), 9, 14.2);
    if (hy != null) {
      // 天花板：她來的地方——掉灰、速度線
      const topY = hy;
      if (g < HIT + 0.04) streaks(ctx, ax, topY - H * 1.6, topY + hh * 0.4, hw * 0.7, 8, seg(g, 0.38, 0.42) * (1 - seg(g, HIT, HIT + 0.04)), 2);
      if (g > 0.64) streaks(ctx, ax, topY - H * 0.3, topY + hh * 0.9, hw * 0.7, 8, (1 - seg(g, 0.74, 0.8)), 4);
      dust(ctx, ax, ay, H * 0.9, seg(g, HIT - 0.02, 0.7), 10, 8.8);
      ctx.save(); ctx.translate(ax, hy); ctx.rotate(sw * D + Math.sin(t * 3) * 0.03);
      ctx.scale(-1, 1); // 倒掛原圖的爪子在右邊：鏡像，爪子朝前
      ctx.drawImage(hang, -0.72 * hw, 0, hw, hh);
      ctx.restore();
      // 爪痕：劃下去那一瞬間
      const ck = bump(g, HIT - 0.01, HIT + 0.02, 0.62);
      if (ck > 0) {
        ctx.save(); ctx.globalAlpha *= ck; const cx = F.x + Ht * 0.02, cy = F.y - Ht * 0.78;
        const grow = eo(seg(g, HIT - 0.01, HIT + 0.03));
        for (let i = -1; i <= 1; i++) slash(ctx, cx + Ht * (0.08 + i * 0.055), cy - Ht * 0.12, cx + Ht * (0.08 + i * 0.055) + (Ht * (-0.1)) * grow, cy - Ht * 0.12 + Ht * 0.3 * grow, Ht * 0.014);
        ctx.restore();
      }
    }
    ctx.restore();
    if (g >= HIT && g < HIT + 0.02) o.hitP = world(a, F.x, F.y - Ht * 0.8);
    return true;
  };

  // 活人 NPC：身體 + 拆出來的手（整張原圖大小、同位置），轉軸 pv（原圖比例）
  function npcBody(ctx, type, key, H, t, add) { MeshAnim.drawBody(ctx, type, key, H, pz(t, Object.assign({ armF:0, armB:0, y:0 }, add))); }
  function piece(ctx, img, W, H, pv, at, ang, sx) { ctx.save(); ctx.translate(at[0], at[1]); ctx.rotate(ang); if (sx) ctx.scale(sx, sx); ctx.drawImage(img, -pv[0] * W, -pv[1] * H, W, H); ctx.restore(); }
  // 身體座標 → 本地：先前傾 lean（繞腰），再位移 (dx,dy)
  const LEANY = 0.3;
  const bodyXf = (H, lean, dx, dy) => (x, y) => { const p = rot(x, y + H * LEANY, lean); return [p[0] + dx, p[1] - H * LEANY + dy]; };
  const pushBody = (ctx, H, lean, dx, dy) => { ctx.translate(dx, dy); ctx.translate(0, -H * LEANY); ctx.rotate(lean); ctx.translate(0, H * LEANY); };

  // ======================================================================
  // 保安阿伯：頭也不回——轉身背對對手（原圖左右翻，中間壓扁一下當轉身），拿保溫瓶那隻手就到了對手那一側，
  // 手繞肩膀往後一甩，反手用瓶底「鏗！」敲在對手臉上，茶濺出來、冒熱氣；再慢吞吞轉回來。
  // 手一直接在肩膀上（只繞肩關節轉）；手電筒那隻手不動。
  // 拆件：cut/npc_guard__club.png（袖子上緣是以肩關節為圓心的圓弧）、cut/npc_guard__bodyC.png（art/cutguard.py 切）
  // ======================================================================
  const GD = { PV:[0.882, 0.4565], TIP:[0.752, 0.725] };
  function teaDrops(ctx, x, y, vx, vy, size, q, n, seed) { // 茶：琥珀色水珠，沿甩出去的方向飛、往下掉
    if (q <= 0 || q >= 1) return; ctx.save();
    for (let i = 0; i < n; i++) {
      const r1 = rnd(seed + i * 1.9), r2 = rnd(seed + i * 4.1), sp = 0.55 + r1 * 0.8, sd = (r2 - 0.5) * 0.9;
      const px = x + (vx * sp - vy * sd) * size * q, py = y + (vy * sp + vx * sd) * size * q + size * 1.3 * q * q, rr = size * (0.022 + r2 * 0.022) * (1 - q * 0.35);
      ctx.globalAlpha = Math.min(1, (1 - q) * 1.6);
      const an = Math.atan2(vy + 2.6 * q, vx);
      ctx.fillStyle = '#4a2a10'; ctx.beginPath(); ctx.ellipse(px, py, rr * 1.7, rr * 1.15, an, 0, PI * 2); ctx.fill();
      ctx.fillStyle = '#c98a2e'; ctx.beginPath(); ctx.ellipse(px, py, rr * 1.35, rr * 0.82, an, 0, PI * 2); ctx.fill();
      ctx.fillStyle = 'rgba(255,240,200,.9)'; ctx.beginPath(); ctx.arc(px - rr * 0.3, py - rr * 0.3, rr * 0.3, 0, PI * 2); ctx.fill();
    }
    ctx.restore();
  }
  function steam(ctx, x, y, size, q, seed) { // 熱茶冒的一縷白煙
    if (q <= 0 || q >= 1) return; ctx.save(); ctx.globalAlpha *= (1 - q) * 0.8;
    for (let k = 0; k < 2; k++) {
      const pts = []; for (let i = 0; i <= 10; i++) { const u = i / 10; pts.push([x + Math.sin(u * 5 + seed + k * 2 + q * 6) * size * 0.12 + (k - 0.5) * size * 0.16, y - u * size * (0.5 + q * 0.6) - q * size * 0.2]); }
      crayonLine(ctx, pts, Math.max(1.5, size * 0.05), 'rgba(250,246,240,.9)', 'rgba(60,50,60,.35)');
    }
    ctx.restore();
  }
  function clank(ctx, a, x, y, size, k, rot) { // 「鏗！」金屬聲：淡黃字、深色粗框、彈出來
    if (k <= 0) return;
    upright(ctx, a, x, y, () => {
      const s = 0.6 + 0.55 * backOut(Math.min(1, k * 1.8)); ctx.scale(s, s); ctx.rotate(rot);
      ctx.globalAlpha *= Math.min(1, (1 - k) * 4);
      ctx.font = `900 ${size}px "Noto Sans CJK TC","Noto Sans TC","PingFang TC","Microsoft JhengHei",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.lineJoin = 'round';
      ctx.strokeStyle = '#2a1608'; ctx.lineWidth = size * 0.2; ctx.strokeText('鏗！', 0, 0);
      const gr = ctx.createLinearGradient(0, -size * 0.5, 0, size * 0.5); gr.addColorStop(0, '#fffbe6'); gr.addColorStop(1, '#ffc93a'); ctx.fillStyle = gr; ctx.fillText('鏗！', 0, 0);
    });
  }
  function burst(ctx, x, y, r, k, seed) { // 命中：一圈蠟筆短線往外炸
    if (k <= 0 || k >= 1) return; ctx.save(); ctx.globalAlpha *= 1 - k; ctx.lineCap = 'round';
    for (let i = 0; i < 8; i++) { const an = i / 8 * PI * 2 + seed, r0 = r * (0.35 + 0.5 * k), r1 = r * (0.75 + 0.6 * k) * (i % 2 ? 0.75 : 1);
      const p = [[x + Math.cos(an) * r0, y + Math.sin(an) * r0], [x + Math.cos(an) * r1, y + Math.sin(an) * r1]];
      crayonLine(ctx, p, Math.max(2, r * 0.09), '#fff3c4', 'rgba(60,30,10,.75)'); }
    ctx.restore();
  }
  MOVES.npc_guard = function (ctx, a) {
    if (!ok('npc_guard__bodyC') || !ok('npc_guard__club')) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 0.68), img = SPR.npc_guard__bodyC, W = H * img.naturalWidth / img.naturalHeight, Ht = F.h;
    const L = (p) => [(p[0] - 0.5) * W, -H + p[1] * H];
    const pv = L(GD.PV), vT = [(GD.TIP[0] - GD.PV[0]) * W, (GD.TIP[1] - GD.PV[1]) * H];
    // 轉過身之後（左右翻）的本地座標：x 取負號。手往「原圖的後面」甩（th 負）＝往對手那邊甩
    const want = [F.x + Ht * 0.12, F.y - Ht * 0.66];               // 對手的下巴（Q 版大頭的下緣）
    const leanHit = 7 * D;                                          // 背對著，上身往對手那邊（＝自己的後方）歪
    const tipAt = (th, lean, dx) => { const r = rot(vT[0], vT[1], th), p = bodyXf(H, lean, 0, 0)(pv[0] + r[0], pv[1] + r[1]); return [-p[0] + dx, p[1]]; };
    let thHit = -105 * D, be = 1e9;
    for (let d = -40; d >= -150; d--) { const e = Math.abs(tipAt(d * D, leanHit, 0)[1] - want[1]); if (e < be) { be = e; thHit = d * D; } if (tipAt(d * D, leanHit, 0)[1] <= want[1]) break; }
    const Lg = cl(tipAt(thHit, leanHit, 0)[0] - want[0], -H * 0.15, H * 0.6);   // 夠不到就往後退著靠過去，太近就退一點
    const TH0 = 38 * D, THF = thHit - 22 * D;
    // ---- 轉身（左右翻，中間壓扁）----
    const turn = g < 0.6 ? eio(seg(g, 0.03, 0.17)) : 1 - eio(seg(g, 0.72, 0.9));
    const cs = Math.cos(turn * PI), fx = (cs >= 0 ? 1 : -1) * (0.32 + 0.68 * Math.abs(cs)); // 1 → -1（背對）→ 1；不壓到零（不會變紙片），過中間直接翻面
    const hopT = Math.sin(turn * PI) * H * 0.025;                   // 轉身時稍微墊一下腳
    // ---- 手 ----
    let th, lean, dx;
    if (g < 0.4) {               // 預備：轉過身，手先往身前收（蓄力）、上身往前縮
      const k = eio(seg(g, 0.14, 0.38));
      th = TH0 * k; lean = -6 * D * k; dx = -Lg * 0.4 * eio(seg(g, 0.05, 0.38));
    } else if (g < HIT) {        // 出手：反手往後一甩，上身跟著往對手那邊歪
      const k = ei(seg(g, 0.4, HIT)), m = eo(seg(g, 0.4, HIT));
      th = lerp(TH0, thHit, k); lean = lerp(-6 * D, leanHit, m); dx = lerp(-Lg * 0.4, -Lg, m);
    } else if (g < 0.6) {        // 揮出：手順勢再甩一點，停住
      const k = eo3(seg(g, HIT, 0.6));
      th = lerp(thHit, THF, k); lean = leanHit + 2 * D * k; dx = -Lg;
    } else {                     // 收招：手垂回身側（晃兩下），轉回來，走回原位
      const k = seg(g, 0.6, 1), q = eio(seg(k, 0, 0.45));
      const sw = k > 0.4 ? Math.sin((k - 0.4) / 0.6 * PI * 2.4) * (1 - (k - 0.4) / 0.6) * 10 * D : 0;
      th = lerp(THF, 0, q) + sw; lean = lerp(leanHit + 2 * D, 0, eio(seg(k, 0, 0.6))); dx = lerp(-Lg, 0, eio(seg(k, 0.15, 1)));
    }
    const walk = Math.abs(dx) / (H * 0.12) * PI, mv = g < 0.6 ? 1 : 0.8;
    o.vic = { shake:bump(g, HIT, 0.5, 0.6) };
    a.shadow(world(a, dx, 0)[0]);
    begin(ctx, a); ctx.translate(dx, -hopT); ctx.scale(fx, 1); pushBody(ctx, H, lean, 0, 0);
    npcBody(ctx, 'npc_guard', 'npc_guard__bodyC', H, t, { legF:Math.sin(walk) * 0.2 * mv, legB:-Math.sin(walk) * 0.2 * mv, head:(g >= 0.4 && g < 0.66 ? -0.06 * bump(g, 0.4, HIT, 0.66) : 0), body:0 });
    // 拖影：瓶底甩過的弧
    const trail = (g > 0.42 && g < 0.56) ? (g < HIT ? seg(g, 0.42, 0.45) : 1 - seg(g, HIT, 0.56)) : 0;
    if (trail > 0) {
      const th2 = g < HIT ? th : thHit, thA = th2 + 70 * D, pts = [];
      for (let i = 0; i <= 14; i++) { const r = rot(vT[0], vT[1], lerp(thA, th2, i / 14)); pts.push([pv[0] + r[0], pv[1] + r[1]]); }
      ctx.save(); ctx.globalAlpha *= 0.6 * trail; crayonLine(ctx, pts, H * 0.045, 'rgba(255,248,226,.85)', 'rgba(70,60,40,.25)'); ctx.restore();
    }
    piece(ctx, SPR.npc_guard__club, W, H, GD.PV, pv, th);
    ctx.restore();
    // 「哼。」：轉過身、懶得看
    const hk0 = bump(g, 0.16, 0.24, 0.4);
    if (hk0 > 0) { begin(ctx, a); smallText(ctx, a, dx + H * 0.2, -H * 1.0, '哼', H * 0.12, hk0, t); ctx.restore(); }
    // ---- 命中 ----
    const hp = want, hk = seg(g, HIT, HIT + 0.12);
    if (g >= HIT && g < HIT + 0.12) { begin(ctx, a); burst(ctx, hp[0], hp[1], Ht * 0.24, hk, 0.4); clank(ctx, a, hp[0] + Ht * 0.05, hp[1] - Ht * 0.4, Ht * 0.2, hk, -0.12); ctx.restore(); }
    const stk = bump(g, HIT, HIT + 0.03, 0.66);
    if (stk > 0) { begin(ctx, a); ctx.globalAlpha *= stk; const c = [F.x + Ht * 0.04, F.y - Ht * 1.02];
      for (let i = 0; i < 3; i++) { const an = (g - HIT) * 9 + i * PI * 2 / 3, r = Ht * 0.17; star(ctx, c[0] + Math.cos(an) * r, c[1] + Math.sin(an) * r * 0.35, Ht * 0.055, an); }
      ctx.restore(); }
    // 茶：敲下去瓶裡的茶晃出來，幾滴往對手那邊濺；冒一縷熱氣
    if (g >= HIT - 0.005 && g < 0.75) {
      const q = seg(g, HIT - 0.005, 0.72), cp = [hp[0] + Ht * 0.06, hp[1] + Ht * 0.02];
      begin(ctx, a); teaDrops(ctx, cp[0], cp[1], -0.8, -0.85, Ht * 0.6, 0.06 + q * 0.94, 6, 7.3); steam(ctx, cp[0] + Ht * 0.04, cp[1] - Ht * 0.04, Ht * 0.35, seg(g, HIT, 0.64), 1.3); ctx.restore();
    }
    if (g >= HIT && g < HIT + 0.02) o.hitP = world(a, hp[0], hp[1]);
    return true;
  };

  function star(ctx, x, y, r, a) {
    ctx.save(); ctx.translate(x, y); ctx.rotate(a); ctx.beginPath();
    for (let i = 0; i < 10; i++) { const an = i / 10 * PI * 2, rr = i % 2 ? r * 0.45 : r; ctx.lineTo(Math.cos(an) * rr, Math.sin(an) * rr); }
    ctx.closePath(); ctx.lineJoin = 'round'; ctx.strokeStyle = '#3a2410'; ctx.lineWidth = r * 0.35; ctx.stroke(); ctx.fillStyle = '#ffd84a'; ctx.fill(); ctx.restore();
  }

  // ======================================================================
  // 清潔安娣：兩手握住拖把（叉腰那隻手拆出來、移到拖把桿上），往前一戳，濺水
  // ======================================================================
  MOVES.npc_auntie = function (ctx, a) {
    if (!ok('npc_auntie__bodyH') || !ok('npc_auntie__arm') || !ok('npc_auntie__hip')) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 0.68), img = SPR.npc_auntie__bodyH, W = H * img.naturalWidth / img.naturalHeight, Ht = F.h;
    const FIST = [0.275, 0.515], TOP = [0.235, 0.34], BOT = [0.37, 0.95], HEAD = [0.10, 0.36];  // 握拳處、桿頂、桿底、拖把頭中心（原圖比例）
    const SH = [0.765, 0.43], HAND = [0.735, 0.595];                                              // 叉腰那隻手：肩膀、手
    const L = (p) => [(p[0] - 0.5) * W, -H + p[1] * H];
    const fist = L(FIST), axisUp = [(TOP[0] - BOT[0]) * W, (TOP[1] - BOT[1]) * H], axAng = Math.atan2(axisUp[1], axisUp[0]);
    const thT = (-PI - axAng) + 6 * D; // 拖把轉成水平朝前（頭稍微抬高）
    // 動作：預備＝把拖把放平、往後拉（雙手握好）；出手＝整個人往前戳；收招＝放回去
    const hold = g < 0.6 ? eio(seg(g, 0.0, 0.26)) : 1 - eio(seg(g, 0.68, 1));
    const pullB = g < 0.4 ? eio(seg(g, 0.14, 0.38)) : g < HIT ? 1 - ei(seg(g, 0.4, HIT)) : 0;
    const poke = g < HIT ? ei(seg(g, 0.4, HIT)) : g < 0.6 ? 1 : 1 - eio(seg(g, 0.6, 0.95));
    const th = thT * hold;
    // 命中：拖把頭碰到對手身體前緣
    const headV = [(HEAD[0] - FIST[0]) * W, (HEAD[1] - FIST[1]) * H];
    const leanHit = -10 * D, rh = rot(headV[0], headV[1], thT), hit0 = bodyXf(H, leanHit, 0, 0)(fist[0] + rh[0] - H * 0.04, fist[1] + rh[1]);
    const want = F.x + Ht * 0.16, Lg = Math.max(0, hit0[0] - want);
    const lean = 10 * D * pullB + leanHit * poke, dx = H * 0.1 * pullB - Lg * poke, jab = -H * 0.06 * poke + H * 0.05 * pullB;
    o.vic = { shake:bump(g, HIT, 0.5, 0.6) };
    a.shadow(world(a, dx, 0)[0]);
    begin(ctx, a); pushBody(ctx, H, lean, dx, 0);
    npcBody(ctx, 'npc_auntie', 'npc_auntie__bodyH', H, t, { legF:-0.2 * poke, legB:0.15 * poke, head:-0.06 * poke + 0.05 * pullB });
    // 拖把（連前手）：繞握拳處轉平，往前戳一下
    const fx = fist[0] + jab, fy = fist[1] + H * 0.01 * hold;
    piece(ctx, SPR.npc_auntie__arm, W, H, FIST, [fx, fy], th);
    // 另一隻手：從腰上移到拖把桿後段握住
    const ub = rot(-axisUp[0], -axisUp[1], th), ul = Math.hypot(ub[0], ub[1]); ub[0] /= ul; ub[1] /= ul;
    const sh = L(SH), hand0 = [L(HAND)[0] - sh[0], L(HAND)[1] - sh[1]], reach = Math.hypot(hand0[0], hand0[1]);
    let bestS = 0, be = 1e9; for (let s = H * 0.06; s < H * 0.45; s += H * 0.01) { const p = [fx + ub[0] * s, fy + ub[1] * s], e = Math.abs(Math.hypot(p[0] - sh[0], p[1] - sh[1]) - reach * 0.95); if (e < be) { be = e; bestS = s; } }
    const grip = [fx + ub[0] * bestS, fy + ub[1] * bestS];
    const ang = Math.atan2(grip[1] - sh[1], grip[0] - sh[0]) - Math.atan2(hand0[1], hand0[0]);
    const r = rot(hand0[0], hand0[1], ang), fixv = [grip[0] - (sh[0] + r[0]), grip[1] - (sh[1] + r[1])];
    piece(ctx, SPR.npc_auntie__hip, W, H, SH, [sh[0] + fixv[0] * hold, sh[1] + fixv[1] * hold], ang * hold);
    // 拖把頭甩水
    const hv = rot(headV[0], headV[1], th), hp = [fx + hv[0], fy + hv[1]];
    if (hold > 0.5) for (let i = 0; i < 3; i++) drip(ctx, hp[0] + H * (i - 1) * 0.04, hp[1] + H * 0.05, Math.max(1, -(hp[1] + H * 0.05)) / 1.4, ((t * 1.4) + i / 3) % 1, i + 40, H * 0.018);
    ctx.restore();
    // 命中濺水（往前噴）
    if (g >= HIT - 0.01 && g < 0.75) {
      const q = seg(g, HIT - 0.01, 0.72), w = world(a, want, F.y - Ht * 0.48);
      ctx.save(); ctx.translate(w[0], w[1]); if (!a.faceRight) ctx.scale(-1, 1); ctx.rotate(PI / 2 + 0.2); splash(ctx, 0, 0, Ht * 0.5, q, 12, 31.3, 0.8); ctx.restore();
    }
    if (g >= HIT && g < HIT + 0.02) o.hitP = world(a, want, F.y - Ht * 0.48);
    return true;
  };

  // ======================================================================
  // 陳總：一手直直指著對手大罵，「扣」「工」「資」三個字從嘴裡飛出去，一個一個砸中對手
  // ======================================================================
  const BOSS_HITS = [HIT, 0.6, 0.72];
  MOVES.npc_boss = function (ctx, a) {
    if (!ok('npc_boss__bodyP') || !ok('npc_boss__point')) return false;
    const o = a.o, H = a.H, t = o.t || 0, g = prog(o), F = foe(a, 1.2), img = SPR.npc_boss__bodyP, W = H * img.naturalWidth / img.naturalHeight, Ht = F.h;
    const SH = [0.775, 0.475], HAND = [0.835, 0.75], MOUTH = [0.39, 0.315];
    const L = (p) => [(p[0] - 0.5) * W, -H + p[1] * H];
    const point = g < 0.6 ? backOut(seg(g, 0.04, 0.26)) : 1 - eio(seg(g, 0.84, 1));
    const yell = bump(g, 0.26, 0.32, 0.86);
    const lean = (-6 * D * point) + (g > 0.26 && g < 0.86 ? -3 * D * Math.abs(Math.sin((g - 0.26) * 26)) : 0);
    const dx = -H * 0.04 * point;
    const tgt = [F.x + Ht * 0.05, F.y - Ht * 0.62]; // 字砸對手的臉
    const aim = [F.x + Ht * 0.05, F.y - Ht * 0.42]; // 手指著對手胸口（手在水晶球下面伸出去，不會被擋住）
    // Q 版手短：指人的時候扭腰，後肩轉到胸前（肩膀往前移），整隻手伸到身體前面
    const SHF = [0.38, 0.45], shP = (k) => { const A = L(SH), B = L(SHF); return [lerp(A[0], B[0], k), lerp(A[1], B[1], k)]; };
    const xf = bodyXf(H, lean, dx, 0), shL = shP(cl(point)), sh = xf(...shL), hd = L(HAND), sh0 = L(SH);
    const ang0 = Math.atan2(hd[1] - sh0[1], hd[0] - sh0[0]);
    const want = Math.atan2(aim[1] - sh[1], aim[0] - sh[0]) - lean;
    let dA = want - ang0; while (dA < 0) dA += PI * 2; while (dA > PI * 2) dA -= PI * 2; // 往前（順時針）抬起
    const jolt = g > 0.26 && g < 0.86 ? Math.sin((g - 0.26) * 40) * 0.08 * yell : 0;
    o.vic = { shake:Math.max(...BOSS_HITS.map(h => bump(g, h, h + 0.015, h + 0.1))) };
    a.shadow(world(a, dx, 0)[0]);
    begin(ctx, a);
    ctx.save(); pushBody(ctx, H, lean, dx, 0);
    npcBody(ctx, 'npc_boss', 'npc_boss__bodyP', H, t, { head:-0.16 * yell - jolt, body:-0.04 * yell, sy:1 + 0.03 * yell, legF:-0.1 * point, legB:0.08 * point });
    piece(ctx, SPR.npc_boss__point, W, H, SH, shL, dA * point + Math.sin(t * 30) * 0.03 * yell, 1 + 0.1 * cl(point));
    ctx.restore();
    // 罵：嘴巴前面的爆炸線
    const m = xf(...L(MOUTH));
    if (yell > 0) {
      ctx.save(); ctx.globalAlpha *= yell;
      for (let i = 0; i < 6; i++) { const an = PI + 0.95 - i * 0.24 + Math.sin(t * 40 + i) * 0.05, r0 = H * 0.2, r1 = H * (0.3 + 0.07 * (i % 2)) * (0.8 + 0.2 * Math.sin(t * 50 + i * 2));
        crayonLine(ctx, [[m[0] + Math.cos(an) * r0, m[1] + Math.sin(an) * r0], [m[0] + Math.cos(an) * r1, m[1] + Math.sin(an) * r1]], Math.max(1.5, H * 0.02), '#fff6d8', 'rgba(60,20,10,.85)'); }
      ctx.restore();
    }
    // 三個字：從嘴飛出 → 抖著飛 → 砸中 → 壓扁、彈開淡出
    const CH = ['扣', '工', '資'], S0 = H * 0.3;
    CH.forEach((ch, i) => {
      const hitG = BOSS_HITS[i], st = hitG - 0.13; if (g < st) return;
      const fly = seg(g, st, hitG), aft = seg(g, hitG, hitG + 0.14); if (aft >= 1) return;
      const end = [tgt[0] + Ht * (0.06 + i * 0.03), tgt[1] + Ht * (-0.08 + i * 0.12)];
      const e = ei(fly) * 0.6 + fly * 0.4;
      let x = lerp(m[0] - H * 0.2, end[0], e), y = lerp(m[1] - H * 0.12, end[1], e) - Math.sin(fly * PI) * H * 0.14;
      let s = S0 * (0.35 + 0.65 * backOut(cl(fly * 2.2))), r = Math.sin(t * 18 + i * 2) * 0.16 - 0.1, sx = 1, sy = 1, al = 1;
      if (aft > 0) { sx = 1 + 0.5 * (1 - aft) * (aft < 0.3 ? aft / 0.3 : 1); sy = 1 - 0.35 * (1 - aft); x += H * 0.25 * eo(aft) * 0.5; y -= H * 0.3 * eo(aft) - H * 0.4 * aft * aft; r += aft * 2; al = 1 - ei(aft); }
      ctx.save(); ctx.translate(x, y); if (a.faceRight) ctx.scale(-1, 1); ctx.rotate(r); ctx.scale(sx, sy); ctx.globalAlpha *= al;
      ctx.drawImage(glyph(ch, '#ff5a3a', '#ffcf3a'), -s / 2, -s / 2, s, s);
      ctx.restore();
      // 砸中的爆點
      const pk = bump(g, hitG, hitG + 0.01, hitG + 0.08);
      if (pk > 0) { ctx.save(); ctx.globalAlpha *= pk; for (let j = 0; j < 8; j++) { const an = j / 8 * PI * 2 + i, r0 = Ht * 0.08, r1 = Ht * (0.14 + 0.1 * (1 - pk)); crayonLine(ctx, [[end[0] + Math.cos(an) * r0, end[1] + Math.sin(an) * r0], [end[0] + Math.cos(an) * r1, end[1] + Math.sin(an) * r1]], Math.max(1.5, Ht * 0.02), '#ffe58a', 'rgba(80,20,0,.8)'); } ctx.restore(); }
    });
    ctx.restore();
    for (const h of BOSS_HITS) if (g >= h && g < h + 0.02) o.hitP = world(a, tgt[0], tgt[1]);
    return true;
  };
  MOVES.npc_boss.hits = BOSS_HITS;
})();
