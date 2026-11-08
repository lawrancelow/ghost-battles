// ===================== 新鬼 40 隻：專屬招式 =====================
// 全部用原圖：整張原圖網格變形（MeshAnim，n30_rigs.js 的骨架）＋原圖剪下來的件（art/n30cut.py：舌頭、頭、鋼叉、老虎…）
// 只做移動、旋轉、縮放、沿曲線拉長（舌頭、脖子、手臂：原圖那一條照原樣沿新路徑貼過去）。特效是程式畫的蠟筆線。
// 戰鬥節奏同 battle.js：蓄力 0~0.22 → 出手 0.22~0.34（0.2704 命中）→ 收招 0.34~0.59（秒）。
// 座標「F」：原點 = 自己腳底，+x = 往敵人，y 往下，單位 = 世界單位。S.tx/S.ty = 敵人腳底，S.th = 敵人身高，S.H = 自己身高。
// 每隻自成一條：MOVES.n30_<id> = …；刪掉那一條就變回通用出手。
const N30K = (() => {
  const K = MoveKit, { E, seg, lerp, cl, rnd, M } = K;
  const TW = K.TW, TC = K.TC, TS = K.TW + K.TS, TE = K.TE;
  const D = Math.PI / 180;
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  function setup(a) {
    const id = a.type, o = a.o; if (!ok(id) || typeof MeshAnim === 'undefined') return null;
    const img = SPR[id], fw = a.faceRight ? 1 : -1, s = a.s, H = a.H, W = H * img.naturalWidth / img.naturalHeight;
    const nr = !!MeshAnim.NATIVE_R[id], tt = K.tau(o), lg = K.lungeOf(o, s), th = 58 * s;
    const tx = Math.max(0.3 * H, (o.tdx != null ? o.tdx * fw : 44 * s) - lg), ty = o.tdy || 0;
    const fl = a.solid ? 0 : (3 + Math.sin((o.t || 0) * 2.4) * 2) * s;
    return { a, id, o, fw, s, H, W, nr, tt, tx, ty, th, fl, t:o.t || 0, solid:a.solid, back:K.tgtBack(tt, th), img };
  }
  // 關鍵格：[[時間, {欄位}], …]（欄位缺的當 0；sx/sy/a 缺的當 1），兩格之間 ease-in-out；第三個元素可指定 'o' 'i' 'back' 'lin'
  const ONE = { sx:1, sy:1, a:1 };
  function kf(t, keys) {
    if (t <= keys[0][0]) return Object.assign({}, keys[0][1]);
    for (let i = 0; i < keys.length - 1; i++) {
      const [t0, A] = keys[i], [t1, B, ez] = keys[i + 1];
      if (t <= t1) {
        const p = (t - t0) / ((t1 - t0) || 1), k = ez === 'lin' ? p : ez === 'o' ? E.o(p) : ez === 'i' ? E.i(p) : ez === 'back' ? E.back(p) : E.io(p), r = {};
        for (const n in A) r[n] = lerp(A[n], B[n] != null ? B[n] : (ONE[n] || 0), k);
        for (const n in B) if (!(n in A)) r[n] = lerp(ONE[n] || 0, B[n], k);
        return r;
      }
    }
    return Object.assign({}, keys[keys.length - 1][1]);
  }
  const TF = { x:1, y:1, r:1, px:1, py:1, sx:1, sy:1, a:1 };
  // 身體矩陣：位移 (x,y)、繞 (px,py) 轉 r 度（正 = 頭往前倒）、以腳底為準縮放
  function bm(S, f) {
    const px = f.px != null ? f.px : 0, py = f.py != null ? f.py : -0.45 * S.H;
    return new M().t(f.x || 0, (f.y || 0) - S.fl).t(px, py).r((f.r || 0) * D).t(-px, -py).s(f.sx != null ? f.sx : 1, f.sy != null ? f.sy : 1);
  }
  // 網格姿勢：待機底子（收小）＋關鍵格裡的骨頭（正 = 往前轉）
  function pose(S, f, idleK) {
    const z = MeshAnim.ANIM.idle(S.t), k = idleK == null ? 0.5 : idleK;
    for (const n in z) if (typeof z[n] === 'number') z[n] = (n === 'sx' || n === 'sy') ? 1 + (z[n] - 1) * k : z[n] * k;
    z.x = 0; z.rot = 0;
    for (const n in f) if (!TF[n]) z[n] = (z[n] || 0) + (S.nr ? f[n] : -f[n]);
    return z;
  }
  function body(ctx, S, m, mp, key, alpha) {
    ctx.save(); m.set(ctx); if (!S.nr) ctx.scale(-1, 1); if (alpha != null) ctx.globalAlpha *= alpha;
    MeshAnim.drawBody(ctx, S.id, key || S.id, S.H, mp); ctx.restore();
  }
  // 一般畫法：關鍵格 f → 畫整個人（key = 拆過件的身體時用 N30.body）
  function whole(ctx, S, f, key, idleK) { body(ctx, S, bm(S, f), pose(S, f, idleK), key, f.a != null ? f.a : null); }
  const ip = (S, u, v) => [(S.nr ? 1 : -1) * (u - 0.5) * S.W, (v - 1) * S.H];
  const at = (S, m, u, v) => { const p = ip(S, u, v); return m.pt(p[0], p[1]); };
  function piece(ctx, S, name, m, pu, pv, alpha) { K.piece(ctx, S, S.id + '__' + name, m, pu, pv, alpha); }
  // 件放在 F 座標 (x,y)、轉 r 度、縮放
  function pieceAt(ctx, S, name, x, y, r, pu, pv, sx, sy, alpha) { piece(ctx, S, name, new M().t(x, y).r((r || 0) * D).s(sx || 1, sy == null ? (sx || 1) : sy), pu, pv, alpha); }
  // ---------- 帶狀貼圖：原圖上一條（舌頭、脖子、手臂）沿新路徑貼過去（均勻拉長）----------
  function tri(ctx, img, s0, s1, s2, d0, d1, d2) {
    const [u0, v0] = s0, [u1, v1] = s1, [u2, v2] = s2, [x0, y0] = d0, [x1, y1] = d1, [x2, y2] = d2;
    const den = u0 * (v1 - v2) + u1 * (v2 - v0) + u2 * (v0 - v1); if (Math.abs(den) < 1e-6) return;
    const cx = (x0 + x1 + x2) / 3, cy = (y0 + y1 + y2) / 3, e = 0.6;
    const ex = (px, py) => { const dx = px - cx, dy = py - cy, l = Math.hypot(dx, dy) || 1; return [px + dx / l * e, py + dy / l * e]; };
    const A = ex(x0, y0), B = ex(x1, y1), C = ex(x2, y2);
    ctx.save(); ctx.beginPath(); ctx.moveTo(A[0], A[1]); ctx.lineTo(B[0], B[1]); ctx.lineTo(C[0], C[1]); ctx.closePath(); ctx.clip();
    const m11 = (x0 * (v1 - v2) + x1 * (v2 - v0) + x2 * (v0 - v1)) / den, m12 = (y0 * (v1 - v2) + y1 * (v2 - v0) + y2 * (v0 - v1)) / den;
    const m21 = (x0 * (u2 - u1) + x1 * (u0 - u2) + x2 * (u1 - u0)) / den, m22 = (y0 * (u2 - u1) + y1 * (u0 - u2) + y2 * (u1 - u0)) / den;
    const dx = (x0 * (u1 * v2 - u2 * v1) + x1 * (u2 * v0 - u0 * v2) + x2 * (u0 * v1 - u1 * v0)) / den, dy = (y0 * (u1 * v2 - u2 * v1) + y1 * (u2 * v0 - u0 * v2) + y2 * (u0 * v1 - u1 * v0)) / den;
    ctx.transform(m11, m12, m21, m22, dx, dy); ctx.drawImage(img, 0, 0); ctx.restore();
  }
  function resample(pts, n) {
    const L = [0]; for (let i = 1; i < pts.length; i++) L.push(L[i - 1] + Math.hypot(pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1]));
    const tot = L[L.length - 1] || 1, out = []; let j = 0;
    for (let i = 0; i < n; i++) { const s = tot * i / (n - 1); while (j < pts.length - 2 && L[j + 1] < s) j++; const k = (s - L[j]) / ((L[j + 1] - L[j]) || 1); out.push([lerp(pts[j][0], pts[j + 1][0], k), lerp(pts[j][1], pts[j + 1][1], k)]); }
    return { pts:out, len:tot };
  }
  const normals = (P) => P.map((p, i) => { const a = P[Math.max(0, i - 1)], b = P[Math.min(P.length - 1, i + 1)], dx = b[0] - a[0], dy = b[1] - a[1], l = Math.hypot(dx, dy) || 1; return [-dy / l, dx / l]; });
  // srcUV：原圖上的中線（原圖比例）；hw：半寬（佔原圖高）；dst：F 座標的中線；wk(i,n)：寬度倍率
  function ribbon(ctx, S, name, srcUV, hw, dst, wk) {
    const key = S.id + '__' + name; if (!ok(key)) return; const img = SPR[key], iw = img.naturalWidth, ih = img.naturalHeight;
    const N = 28, Sp = resample(srcUV.map(p => [p[0] * iw, p[1] * ih]), N).pts, SN = normals(Sp), Dp = resample(dst, N).pts, DN = normals(Dp);
    const sw = hw * ih, dw = hw * S.H, flip = S.nr ? 1 : -1; // 原圖面朝左時畫面是鏡像：法線方向跟著翻，貼上去才不會左右顛倒
    for (let i = 0; i < N - 1; i++) {
      const w0 = dw * (wk ? wk(i, N) : 1), w1 = dw * (wk ? wk(i + 1, N) : 1);
      const sa = [Sp[i][0] + SN[i][0] * sw, Sp[i][1] + SN[i][1] * sw], sb = [Sp[i][0] - SN[i][0] * sw, Sp[i][1] - SN[i][1] * sw];
      const sc = [Sp[i + 1][0] + SN[i + 1][0] * sw, Sp[i + 1][1] + SN[i + 1][1] * sw], sd = [Sp[i + 1][0] - SN[i + 1][0] * sw, Sp[i + 1][1] - SN[i + 1][1] * sw];
      const n0 = DN[i], n1 = DN[i + 1];
      const da = [Dp[i][0] + n0[0] * w0 * flip, Dp[i][1] + n0[1] * w0 * flip], db = [Dp[i][0] - n0[0] * w0 * flip, Dp[i][1] - n0[1] * w0 * flip];
      const dc = [Dp[i + 1][0] + n1[0] * w1 * flip, Dp[i + 1][1] + n1[1] * w1 * flip], dd = [Dp[i + 1][0] - n1[0] * w1 * flip, Dp[i + 1][1] - n1[1] * w1 * flip];
      tri(ctx, img, sa, sb, sc, da, db, dc); tri(ctx, img, sb, sd, sc, db, dd, dc);
    }
  }
  // 原圖中線 → 某個身體矩陣下的 F 座標（休息時的形狀）
  const restLine = (S, m, uv) => uv.map(p => at(S, m, p[0], p[1]));
  const lerpLine = (A, B, k) => A.map((p, i) => [lerp(p[0], B[i][0], k), lerp(p[1], B[i][1], k)]);
  // 二次曲線取樣
  const quad = (a, c, b, n) => { const o = []; for (let i = 0; i < n; i++) { const t = i / (n - 1), u = 1 - t; o.push([u * u * a[0] + 2 * u * t * c[0] + t * t * b[0], u * u * a[1] + 2 * u * t * c[1] + t * t * b[1]]); } return o; };
  // 讓一條折線的點數跟另一條一樣（插值用）
  const same = (pts, n) => resample(pts, n).pts;

  // ---------- 蠟筆特效 ----------
  const crayon = K.crayon, burst = K.burst, speed = K.speed;
  function txt(ctx, S, x, y, str, size, col, al, rot) {
    if (typeof str === 'number' && typeof size === 'string') { const z = str; str = size; size = z; } // 兩種參數順序都收
    if (typeof L === 'function') str = L(str); // 對白語言：中文／粵語（lang.js）
    if (al != null && al <= 0) return;
    ctx.save(); ctx.translate(x, y); ctx.scale(S.fw, 1); if (rot) ctx.rotate(rot); if (al != null) ctx.globalAlpha *= cl(al);
    ctx.font = `900 ${size}px "PingFang TC","Noto Sans TC","Noto Sans CJK TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.lineJoin = 'round'; ctx.lineWidth = Math.max(2, size * 0.22); ctx.strokeStyle = 'rgba(26,20,38,.92)'; ctx.strokeText(str, 0, 0);
    ctx.fillStyle = col || '#fff3d6'; ctx.fillText(str, 0, 0); ctx.restore();
  }
  // 出現→停→淡出的文字（彈出）
  function pop(ctx, S, x, y, str, size, col, t0, dur) {
    const p = (S.tt - t0) / dur; if (p < 0 || p > 1) return;
    const z = p < 0.15 ? 0.4 + p / 0.15 * 0.75 : p < 0.25 ? 1.15 - (p - 0.15) / 0.1 * 0.15 : 1;
    ctx.save(); ctx.translate(x, y - p * 0.08 * S.H); ctx.scale(z, z); txt(ctx, S, 0, 0, str, size, col, p > 0.75 ? (1 - p) / 0.25 : 1, (rnd(str.length) - 0.5) * 0.25); ctx.restore();
  }
  function puff(ctx, x, y, r, k, col, seed, n) {
    if (k <= 0 || k >= 1) return; n = n || 5; ctx.save(); ctx.globalAlpha *= Math.sin(k * Math.PI) * 0.85;
    for (let i = 0; i < n; i++) { const an = rnd(seed + i) * 6.28, d = r * (0.3 + k) * rnd(seed + i + 3), rr = r * (0.35 + 0.4 * rnd(seed + i + 7)) * (0.6 + k);
      ctx.fillStyle = col; ctx.beginPath(); ctx.arc(x + Math.cos(an) * d, y + Math.sin(an) * d * 0.6 - k * r * 0.5, rr, 0, 7); ctx.fill();
      ctx.strokeStyle = 'rgba(60,50,70,.35)'; ctx.lineWidth = Math.max(0.6, r * 0.05); ctx.stroke(); }
    ctx.restore();
  }
  function drops(ctx, x, y, r, k, col, seed, n, up) {
    if (k <= 0 || k >= 1) return; n = n || 7; ctx.save(); ctx.globalAlpha *= 1 - k * 0.7;
    for (let i = 0; i < n; i++) { const an = -Math.PI / 2 + (rnd(seed + i) - 0.5) * (up || 2.6), sp = r * (0.6 + rnd(seed + i + 5)), px = x + Math.cos(an) * sp * k, py = y + Math.sin(an) * sp * k + r * 2.2 * k * k;
      ctx.fillStyle = col; ctx.beginPath(); ctx.ellipse(px, py, r * 0.09, r * 0.13, an + Math.PI / 2, 0, 7); ctx.fill(); ctx.strokeStyle = 'rgba(30,30,50,.5)'; ctx.lineWidth = Math.max(0.5, r * 0.025); ctx.stroke(); }
    ctx.restore();
  }
  function stars(ctx, x, y, r, t, k) {
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= cl(k);
    for (let i = 0; i < 3; i++) { const an = t * 7 + i * 2.09, px = x + Math.cos(an) * r, py = y + Math.sin(an) * r * 0.35;
      ctx.fillStyle = '#ffd84a'; ctx.strokeStyle = '#5a3a10'; ctx.lineWidth = Math.max(0.6, r * 0.06); ctx.beginPath();
      for (let j = 0; j < 10; j++) { const a2 = j * Math.PI / 5 - Math.PI / 2, rr = j % 2 ? r * 0.12 : r * 0.28; ctx.lineTo(px + Math.cos(a2) * rr, py + Math.sin(a2) * rr); } ctx.closePath(); ctx.fill(); ctx.stroke(); }
    ctx.restore();
  }
  // 地面裂痕
  function cracks(ctx, x, y, r, k, seed) {
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= cl(k);
    for (let i = 0; i < 6; i++) { const an = (i / 6) * Math.PI * 2 + rnd(seed + i), pts = [[x, y]]; let px = x, py = y;
      for (let j = 1; j <= 3; j++) { px += Math.cos(an + (rnd(seed + i * 3 + j) - 0.5)) * r * 0.33; py += Math.sin(an + (rnd(seed + i * 3 + j) - 0.5)) * r * 0.12; pts.push([px, py]); }
      crayon(ctx, pts, 'rgba(40,28,22,.85)', Math.max(1, r * 0.05), seed + i); }
    ctx.restore();
  }
  function ring(ctx, x, y, rx, ry, col, w, al) { if (al <= 0) return; ctx.save(); ctx.globalAlpha *= cl(al); ctx.strokeStyle = col; ctx.lineWidth = w; ctx.beginPath(); ctx.ellipse(x, y, Math.max(0.1, rx), Math.max(0.1, ry), 0, 0, 7); ctx.stroke(); ctx.restore(); }
  const hit = (S, x, y) => { if (S.o.hitOut) S.o.hitOut.p = { x:S.a.x + S.fw * x, y:S.a.y + y }; };
  const tgt = (S, f) => [S.tx + S.back, S.ty - f * S.th]; // 敵人身上某高度（0 = 腳、0.85 = 頭）
  return { K, E, seg, lerp, cl, rnd, M, D, TW, TC, TS, TE, setup, kf, bm, pose, body, whole, ip, at, piece, pieceAt, ribbon, restLine, lerpLine, quad, same, resample,
    crayon, burst, speed, txt, pop, puff, drops, stars, cracks, ring, hit, tgt, shadow:K.shadow, ok };
})();

// ======================= 招式本體 =======================
// 小工具：開始／結束（進 F 座標、畫影子）
const N30M = {
  begin(ctx, S, sx, sk) { ctx.save(); N30K.K.enter(ctx, S); N30K.shadow(ctx, S, sx || 0, 0, sk); },
  end(ctx) { ctx.restore(); },
  // 舌頭／脖子類：休息形狀 ↔ 二次曲線（root→ctrl→tip），b = 伸出去的程度
  line(S, m, src, root, ctrl, tip, b) { const N = N30K, rest = N.same(N.restLine(S, m, src), 14), cur = N.quad(root || rest[0], ctrl, tip, 14); return N.lerpLine(rest, cur, N.cl(b)); },
};

// ---------- 吊死鬼：長舌鞭 ----------
// ① 身子往後仰，舌頭往頭後甩成一個圈 → ② 從頭頂甩過去，啪一聲抽在敵人臉上 → ③ 黏著甩兩下、口水噴 → ④ 舌頭捲回嘴裡垂好
MOVES.n30_diaosi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, { E, seg } = N;
  const f = N.kf(t, [[0, {}], [0.16, { r:-9, head:-0.22, body:-0.08, armF:0.35, armB:-0.35, rope:0.35, hairL:0.2, hairR:0.2 }], [0.25, { r:9, head:0.18, body:0.1, x:0.05 * H, rope:-0.45, hairL:-0.25, hairR:-0.25 }, 'o'], [0.36, { r:6, head:0.12, body:0.08, x:0.05 * H, rope:-0.2 }], [0.59, {}]]);
  const m = N.bm(S, f); N30M.begin(ctx, S, f.x);
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  const SRC = [[0.415, 0.36], [0.418, 0.45], [0.415, 0.52], [0.42, 0.59]], root = N.at(S, m, 0.415, 0.36), hd = N.tgt(S, 0.78);
  const T = N.kf(t, [[0, { x:N.at(S, m, 0.42, 0.59)[0], y:N.at(S, m, 0.42, 0.59)[1] }], [0.17, { x:root[0] - 0.30 * H, y:root[1] - 0.42 * H }], [N.TC, { x:hd[0], y:hd[1] }, 'i'], [0.30, { x:hd[0] - 0.04 * H, y:hd[1] + 0.06 * H }], [0.36, { x:hd[0] + 0.02 * H, y:hd[1] + 0.02 * H }], [0.52, { x:root[0] + 0.12 * H, y:root[1] + 0.25 * H }], [0.59, { x:N.at(S, m, 0.42, 0.59)[0], y:N.at(S, m, 0.42, 0.59)[1] }]]);
  const b = N.kf(t, [[0, { v:0 }], [0.06, { v:1 }], [0.53, { v:1 }], [0.59, { v:0 }]]).v;
  const bend = N.kf(t, [[0, { v:0 }], [0.17, { v:-0.55 }], [N.TC, { v:-0.25 }], [0.36, { v:0.1 }], [0.59, { v:0 }]]).v;
  const tip = [T.x, T.y], mid = [(root[0] + tip[0]) / 2, (root[1] + tip[1]) / 2], L = Math.hypot(tip[0] - root[0], tip[1] - root[1]);
  const wob = t > N.TC && t < 0.36 ? Math.sin(t * 90) * 0.06 * H : 0;
  const ctrl = [mid[0] + bend * L * 0.2, mid[1] + bend * L * 0.9 + wob];
  if (t > 0.12 && t < N.TC) N.speed(ctx, tip[0], tip[1], tip[0] - root[0], tip[1] - root[1] + 0.3 * H, 0.18 * H, 0.1 * H, seg(t, 0.12, 0.2), 'rgba(255,220,220,.7)', 3, 3);
  N.ribbon(ctx, S, 'tongue', SRC, 0.05, N30M.line(S, m, SRC, root, ctrl, tip, b), (i, n) => 1 - 0.18 * b * i / n);
  const p = t - N.TC;
  if (p >= 0 && p < 0.14) N.burst(ctx, hd[0], hd[1], 0.35 * th, 1 - p / 0.14, '#ffe4e4', 11, 10);
  N.drops(ctx, hd[0], hd[1], 0.5 * th, N.seg(t, N.TC, 0.5), 'rgba(200,235,255,.9)', 3, 8);
  N.pop(ctx, S, hd[0], hd[1] - 0.32 * th, '啪！', 0.26 * th, '#ffd0d0', N.TC, 0.3);
  N.hit(S, hd[0], hd[1]); N30M.end(ctx);
};

// ---------- 無頭鬼：自己的頭當保齡球 ----------
// ① 捧著頭往後擺（保齡球後擺）→ ② 往前一送，頭落地滾出去 → ③ 撞到敵人腳「全倒！」→ ④ 頭彈回來、滾回腳邊 → ⑤ 一彈跳回手上
MOVES.n30_wutou = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.15, { r:-6, body:-0.12, armB:0.55, armF:-0.25, x:-0.03 * H }], [0.21, { r:12, body:0.18, armB:-0.65, armF:0.2, x:0.05 * H, sy:0.97 }, 'o'], [0.34, { r:10, body:0.15, armB:-0.6, x:0.05 * H }], [0.50, { r:2, body:0.03, armB:-0.2 }], [0.59, {}]]);
  const m = N.bm(S, f); N30M.begin(ctx, S, f.x);
  const HC = [0.775, 0.50], R = 0.165 * H, rest = N.at(S, m, HC[0], HC[1]);
  // 頭的位置：手上 → 後擺 → 落地 → 滾到敵人腳 → 彈回 → 滾回 → 跳上手
  const gy = -R + S.fl, hitX = S.tx - 0.12 * th + S.back;
  const P = N.kf(t, [[0, { x:rest[0], y:rest[1], r:0 }], [0.15, { x:rest[0] - 0.12 * H, y:rest[1] + 0.10 * H, r:-35 }], [0.20, { x:rest[0] + 0.12 * H, y:gy, r:30 }, 'i'], [N.TC, { x:hitX, y:gy, r:30 + (hitX - rest[0]) / R / N.D }, 'lin'], [0.33, { x:hitX - 0.14 * H, y:gy - 0.12 * H, r:-60 }, 'o'], [0.36, { x:hitX - 0.2 * H, y:gy, r:-90 }], [0.50, { x:0.12 * H, y:gy, r:-90 - (hitX - 0.32 * H) / R / N.D }, 'lin'], [0.59, { x:rest[0], y:rest[1], r:0 }, 'back']]);
  // 跟身體連動的頭在手上時用身體矩陣
  const inHand = t < 0.15 || t > 0.585;
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.19 && t < N.TC + 0.02) { for (let i = 0; i < 4; i++) N.puff(ctx, P.x - (i + 1) * 0.09 * H, -0.02 * H, 0.06 * H, N.cl((t - 0.19) * 6 - i * 0.12), 'rgba(200,190,170,.5)', i * 7, 3); N.speed(ctx, P.x - R, P.y, 1, 0, 0.25 * H, 0.18 * H, 1, 'rgba(240,240,255,.7)', 5, 3); }
  N.pieceAt(ctx, S, 'head', P.x, P.y, inHand ? 0 : P.r, HC[0], HC[1]);
  const p = t - N.TC;
  if (p >= 0 && p < 0.15) { N.burst(ctx, hitX + 0.05 * th, gy, 0.4 * th, 1 - p / 0.15, '#fff2c0', 21, 11); }
  N.pop(ctx, S, hitX, S.ty - 0.95 * th, '全倒！', 0.24 * th, '#ffe066', N.TC, 0.32);
  if (t > N.TC && t < 0.5) N.stars(ctx, P.x, P.y - R * 1.1, R * 0.9, t, 1 - N.seg(t, 0.42, 0.5));
  N.hit(S, hitX, S.ty - 0.1 * th); N30M.end(ctx);
};

// ---------- 夜叉：鋼叉突刺 ----------
// ① 鋼叉放平、往後收、身體壓低 → ② 一步踏前直刺 → ③ 刺中、扭一下 → ④ 拔出來、甩回直立
MOVES.n30_yecha = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.31, 0.50];
  const f = N.kf(t, [[0, {}], [0.17, { r:-5, x:-0.06 * H, sy:0.96, sx:1.03, body:-0.06, armF:0.3, legF:-0.15, legB:0.1, hairL:0.15, hairR:0.15 }], [N.TC, { r:8, x:0.10 * H, sy:1.02, body:0.12, armF:-0.5, legF:0.3, legB:-0.2, hairL:-0.3, hairR:-0.35 }, 'i'], [0.36, { r:7, x:0.10 * H, body:0.1, armF:-0.45, legF:0.28, legB:-0.18, hairL:-0.25, hairR:-0.3 }], [0.59, {}]]);
  const m = N.bm(S, f), w0 = N.at(S, m, PV[0], PV[1]), tip = N.tgt(S, 0.55);
  const reach = 0.47 * S.H; // 手腕到叉尖
  const W = N.kf(t, [[0, { x:w0[0], y:w0[1], r:0 }], [0.17, { x:w0[0] - 0.14 * H, y:w0[1] - 0.02 * H, r:84 }], [N.TC, { x:tip[0] - reach + 0.05 * th, y:tip[1], r:90 }, 'i'], [0.33, { x:tip[0] - reach + 0.05 * th, y:tip[1], r:90 + Math.sin(t * 80) * 5 }], [0.40, { x:w0[0] + 0.02 * H, y:w0[1], r:70 }], [0.59, { x:w0[0], y:w0[1], r:0 }]]);
  N30M.begin(ctx, S, f.x);
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.2 && t < 0.3) N.speed(ctx, W.x + reach * 0.7, W.y, 1, 0, 0.5 * H, 0.12 * H, N.seg(t, 0.2, 0.24) * (1 - N.seg(t, 0.28, 0.3)), 'rgba(255,240,200,.75)', 9, 5);
  N.pieceAt(ctx, S, 'trident', W.x, W.y, W.r, PV[0], PV[1]);
  const p = t - N.TC;
  if (p >= 0 && p < 0.14) N.burst(ctx, tip[0], tip[1], 0.36 * th, 1 - p / 0.14, '#fff6c8', 31, 12);
  if (p > 0 && p < 0.3) for (let i = -1; i <= 1; i++) N.crayon(ctx, [[tip[0] - 0.02 * th, tip[1] + i * 0.07 * th], [tip[0] + 0.04 * th, tip[1] + i * 0.07 * th]], 'rgba(150,30,30,.8)', 0.02 * th, 40 + i);
  N.pop(ctx, S, tip[0], tip[1] - 0.5 * th, '叉！', 0.24 * th, '#ffd27a', N.TC, 0.3);
  N.hit(S, tip[0], tip[1]); N30M.end(ctx);
};

// ---------- 旱魃：熱浪 ----------
// ① 雙手高舉、紅眼發光、地面冒煙 → ② 兩手往前推，一波波熱浪（橙色波紋）推過去 → ③ 敵人腳下龜裂、冒蒸氣「好熱！」→ ④ 收手
MOVES.n30_hanba = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.18, { r:-6, y:-0.04 * H, sy:1.05, armF:-0.9, armB:0.9, head:-0.18, hairL:0.3, hairR:0.3 }], [0.25, { r:7, x:0.04 * H, armF:-0.7, armB:-0.5, head:0.12, hairL:-0.3, hairR:-0.3 }, 'o'], [0.40, { r:6, x:0.04 * H, armF:-0.65, armB:-0.45, head:0.1 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); const m = N.bm(S, f);
  N.whole(ctx, S, f, null, 0.3);
  const glow = N.kf(t, [[0, { v:0 }], [0.15, { v:1 }], [0.42, { v:1 }], [0.59, { v:0 }]]).v;
  if (glow > 0) for (const u of [0.41, 0.56]) { const e = N.at(S, m, u, 0.205); const g = ctx.createRadialGradient(e[0], e[1], 0, e[0], e[1], 0.08 * H); g.addColorStop(0, `rgba(255,60,40,${0.7 * glow})`); g.addColorStop(1, 'rgba(255,60,40,0)'); ctx.fillStyle = g; ctx.fillRect(e[0] - 0.08 * H, e[1] - 0.08 * H, 0.16 * H, 0.16 * H); }
  const o = N.at(S, m, 0.5, 0.45), T = N.tgt(S, 0.5);
  for (let i = 0; i < 4; i++) { // 熱浪：從手前方往敵人推
    const q = N.seg(t, 0.2 + i * 0.03, N.TC + 0.06 + i * 0.03); if (q <= 0 || q >= 1) continue;
    const x = N.lerp(o[0] + 0.1 * H, T[0], q), hh = (0.25 + 0.35 * q) * H, pts = [];
    for (let j = 0; j <= 10; j++) { const v = j / 10 - 0.5; pts.push([x + Math.sin(v * 9 + t * 40 + i) * 0.03 * H + Math.abs(v) * -0.12 * H, T[1] + v * hh]); }
    ctx.save(); ctx.globalAlpha *= Math.sin(q * Math.PI); N.crayon(ctx, pts, i % 2 ? 'rgba(255,150,60,.85)' : 'rgba(255,90,40,.8)', 0.03 * H, 50 + i); ctx.restore();
  }
  for (let i = 0; i < 3; i++) N.puff(ctx, (i - 1) * 0.15 * H, -0.02 * H, 0.06 * H, N.seg(t, 0.05 + i * 0.04, 0.5), 'rgba(230,200,170,.45)', 60 + i, 3);
  const p = t - N.TC;
  N.cracks(ctx, S.tx + S.back, S.ty, 0.5 * th, N.seg(t, N.TC, N.TC + 0.05) * (1 - N.seg(t, 0.5, 0.59)), 70);
  for (let i = 0; i < 3; i++) N.puff(ctx, S.tx + S.back + (i - 1) * 0.15 * th, S.ty - (0.5 + i * 0.15) * th, 0.1 * th, N.seg(t, N.TC + i * 0.03, 0.55), 'rgba(255,255,255,.55)', 80 + i, 3);
  if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.35 * th, 1 - p / 0.14, '#ffb070', 81, 10);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '好熱呀！', 0.22 * th, '#ff9a50', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 倀鬼：吹口哨，小老虎撲上去 ----------
// ① 手指放嘴邊吹口哨（♪），小老虎伏低 → ② 老虎一躍撲向敵人 → ③ 一爪抓下「嗷！」→ ④ 老虎跳兩下回到主人腳邊，主人得意
MOVES.n30_changgui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, TP = [0.80, 0.99];
  const f = N.kf(t, [[0, {}], [0.12, { armF:-0.8, head:-0.12, r:-3 }], [0.22, { armF:-0.85, head:-0.15, r:-3 }], [0.30, { armF:0.3, head:0.1, r:4 }], [0.59, {}]]);
  const m = N.bm(S, f), home = N.at(S, N.bm(S, {}), TP[0], TP[1]), land = [S.tx - 0.28 * th + S.back, S.ty];
  // 老虎：伏低 → 起跳（拋物線越過主人前面）→ 撲中 → 往回兩跳
  let x, y, r = 0, sx = 1, sy = 1;
  if (t < 0.14) { const k = N.E.o(N.seg(t, 0.04, 0.14)); x = home[0]; y = home[1]; sy = 1 - 0.18 * k; sx = 1 + 0.1 * k; }
  else if (t < N.TC) { const q = N.seg(t, 0.14, N.TC); x = N.lerp(home[0], land[0], q); y = N.lerp(home[1], land[1], q) - 0.55 * H * 4 * q * (1 - q); r = N.lerp(-25, 30, q); sy = 1 + 0.12 * Math.sin(q * Math.PI); }
  else if (t < 0.36) { x = land[0]; y = land[1]; r = 30 - 30 * N.seg(t, N.TC, 0.31); sy = 1 - 0.12 * Math.sin(N.seg(t, N.TC, 0.31) * Math.PI); }
  else { const q = N.seg(t, 0.36, 0.59), hop = Math.abs(Math.sin(q * Math.PI * 2)); x = N.lerp(land[0], home[0], q); y = home[1] - hop * 0.18 * H; r = -10 * hop; }
  N30M.begin(ctx, S, f.x);
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.pieceAt(ctx, S, 'tiger', x, y, r, TP[0], TP[1], sx, sy);
  const mo = N.at(S, m, 0.25, 0.33);
  for (let i = 0; i < 3; i++) { const q = N.seg(t, 0.04 + i * 0.05, 0.22 + i * 0.05); if (q > 0 && q < 1) N.txt(ctx, S, mo[0] + q * 0.25 * H, mo[1] - q * 0.25 * H - i * 0.03 * H, i % 2 ? '♫' : '♪', 0.1 * H, '#bfe8ff', Math.sin(q * Math.PI)); }
  const T = N.tgt(S, 0.6), p = t - N.TC;
  if (p >= 0 && p < 0.25) for (let i = 0; i < 3; i++) N.crayon(ctx, [[T[0] - 0.12 * th + i * 0.07 * th, T[1] - 0.15 * th], [T[0] - 0.18 * th + i * 0.07 * th, T[1] + 0.12 * th]], 'rgba(255,240,230,.9)', 0.025 * th, 90 + i, 1 - p / 0.25);
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#ffd27a', 95, 9);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '嗷！', 0.24 * th, '#ffb347', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 鬼新娘：拋繡球 ----------
// ① 雙手捧繡球舉過頭 → ② 甩手拋出，繡球拖著紅綢飛過去 → ③ 砸中、花瓣散開「嫁給我！」→ ④ 繡球彈起、飛回她手上
MOVES.n30_guixinniang = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, BC = [0.39, 0.63];
  const f = N.kf(t, [[0, {}], [0.15, { r:-7, armF:-1.0, armB:-0.9, head:-0.12, hairL:0.25, hairR:0.25, y:-0.03 * H }], [0.22, { r:8, armF:-0.6, armB:-0.5, head:0.1, hairL:-0.3, hairR:-0.3 }, 'o'], [0.45, { r:2, armF:-0.2, armB:-0.2 }], [0.59, {}]]);
  const m = N.bm(S, f), rest = N.at(S, m, BC[0], BC[1]), up = N.at(S, m, 0.42, 0.05), T = N.tgt(S, 0.82);
  const P = N.kf(t, [[0, { x:rest[0], y:rest[1], r:0 }], [0.15, { x:up[0] - 0.05 * H, y:up[1], r:-20 }], [0.17, { x:up[0], y:up[1], r:-10 }]]);
  let bx = P.x, by = P.y, br = P.r, bs = 1;
  if (t >= 0.17 && t < N.TC) { const q = N.seg(t, 0.17, N.TC); bx = N.lerp(up[0], T[0], q); by = N.lerp(up[1], T[1], q) - 0.3 * H * 4 * q * (1 - q); br = q * 300; }
  else if (t >= N.TC && t < 0.40) { const q = N.seg(t, N.TC, 0.40); bx = T[0] - q * 0.15 * th; by = T[1] - 0.45 * th * Math.sin(q * Math.PI) ; br = 300 + q * 200; bs = q < 0.12 ? 1 - 0.25 * Math.sin(q / 0.12 * Math.PI) : 1; }
  else if (t >= 0.40) { const q = N.E.io(N.seg(t, 0.40, 0.56)); bx = N.lerp(T[0] - 0.15 * th, rest[0], q); by = N.lerp(T[1], rest[1], q) - 0.35 * H * 4 * q * (1 - q); br = 500 + q * 220; if (t > 0.56) { bx = rest[0]; by = rest[1]; br = 0; } }
  N30M.begin(ctx, S, f.x);
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.17 && t < 0.56) { // 紅綢
    const pts = []; for (let i = 0; i < 8; i++) { const k = i / 7; pts.push([bx - (bx - up[0]) * 0.35 * k + Math.sin(t * 30 + k * 5) * 0.03 * H, by - (by - up[1]) * 0.35 * k + k * 0.08 * H]); }
    ctx.save(); ctx.globalAlpha *= 0.85; N.crayon(ctx, pts, '#d8252e', 0.035 * H, 7); N.crayon(ctx, pts.map(p => [p[0], p[1] + 0.02 * H]), '#ff6a5a', 0.015 * H, 8); ctx.restore();
  }
  N.pieceAt(ctx, S, 'ball', bx, by, br, BC[0], BC[1], bs, 2 - bs);
  const p = t - N.TC;
  if (p >= 0 && p < 0.3) for (let i = 0; i < 9; i++) { const an = N.rnd(i) * 6.28, d = (0.1 + p * 1.3) * th * (0.5 + N.rnd(i + 3)); ctx.save(); ctx.globalAlpha *= 1 - p / 0.3; ctx.fillStyle = i % 2 ? '#e8303a' : '#ff8a80'; ctx.beginPath(); ctx.ellipse(T[0] + Math.cos(an) * d, T[1] + Math.sin(an) * d + p * p * 2 * th, 0.03 * th, 0.018 * th, an + t * 9, 0, 7); ctx.fill(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#ffd0d0', 99, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '嫁畀我！', 0.2 * th, '#ff8a8a', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 山魈：單腳跳過去，長臂一掃 ----------
// ① 單腳蹲低、長臂往後甩 → ② 一跳到敵人面前，長臂由上往下掃 → ③ 三道爪痕 → ④ 單腳跳兩下回去
MOVES.n30_shanxiao = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.45 * th - 0.25 * H);
  const f = N.kf(t, [[0, {}], [0.14, { sy:0.88, sx:1.06, armF:0.9, armB:0.5, body:-0.1, head:-0.1, hairL:0.2, hairR:0.2 }], [0.20, { y:-0.16 * H, x:D2 * 0.6, sy:1.05, armF:0.8, armB:0.4, r:-6 }, 'o'], [N.TC, { x:D2, y:0, sy:0.94, armF:-0.9, armB:-0.3, body:0.15, head:0.1, r:10, hairL:-0.3, hairR:-0.3 }, 'i'], [0.36, { x:D2, sy:0.96, armF:-1.0, armB:-0.4, body:0.15, r:8 }], [0.46, { x:D2 * 0.5, y:-0.12 * H, armF:-0.2 }], [0.52, { x:D2 * 0.3, y:0 }], [0.56, { x:D2 * 0.1, y:-0.06 * H }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H)); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.55), p = t - N.TC;
  if (t > 0.2 && t < 0.3) N.speed(ctx, T[0] - 0.1 * th, T[1] - 0.1 * th, 0.3, 1, 0.4 * H, 0.2 * H, N.seg(t, 0.2, 0.24), 'rgba(220,240,200,.7)', 12, 4);
  if (p >= 0 && p < 0.28) for (let i = 0; i < 3; i++) N.crayon(ctx, [[T[0] - 0.15 * th + i * 0.08 * th, T[1] - 0.25 * th], [T[0] - 0.05 * th + i * 0.08 * th, T[1] + 0.2 * th]], 'rgba(255,245,235,.95)', 0.03 * th, 110 + i, 1 - p / 0.28);
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#e9ffd0', 113, 9);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 白骨精：飛吻變骷髏 ----------
// ① 手指點唇、身子一扭 → ② 送出一個粉紅飛吻（心）飄過去 → ③ 到了敵人面前「啵」一聲變成小骷髏一口咬下 → ④ 骷髏散成白骨碎，她掩嘴笑
MOVES.n30_baigujing = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.15, { r:-5, armF:-0.25, head:-0.15, body:-0.08, orn:0.3 }], [0.22, { r:6, armF:-0.9, head:0.12, body:0.08, orn:-0.3 }, 'o'], [0.40, { r:3, armF:-0.5, head:0.05 }], [0.59, {}]]);
  const m = N.bm(S, f); N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const lip = N.at(S, m, 0.33, 0.235), T = N.tgt(S, 0.8);
  const q = N.seg(t, 0.19, N.TC), x = N.lerp(lip[0], T[0], q), y = N.lerp(lip[1], T[1], q) + Math.sin(q * 9) * 0.03 * H;
  if (t > 0.19 && t < N.TC + 0.01) { // 心
    const r = (0.04 + 0.04 * q) * H; ctx.save(); ctx.translate(x, y); ctx.rotate(Math.sin(t * 20) * 0.2); ctx.fillStyle = '#ff7aa8'; ctx.strokeStyle = '#5a1a30'; ctx.lineWidth = r * 0.15;
    ctx.beginPath(); ctx.moveTo(0, r * 0.9); ctx.bezierCurveTo(-r * 1.4, -r * 0.1, -r * 0.6, -r * 1.1, 0, -r * 0.35); ctx.bezierCurveTo(r * 0.6, -r * 1.1, r * 1.4, -r * 0.1, 0, r * 0.9); ctx.fill(); ctx.stroke(); ctx.restore();
    for (let i = 0; i < 3; i++) N.txt(ctx, S, x - (i + 1) * 0.06 * H, y + Math.sin(i * 2 + t * 10) * 0.03 * H, '♥', 0.05 * H, '#ffb3cc', 0.6 - i * 0.18);
  }
  const p = t - N.TC;
  if (p >= 0 && p < 0.26) { // 小骷髏咬一口
    const k = p / 0.26, r = 0.16 * th * (p < 0.04 ? p / 0.04 : 1), bite = Math.abs(Math.sin(p * 40)) * r * 0.25;
    ctx.save(); ctx.globalAlpha *= k > 0.75 ? (1 - k) / 0.25 : 1; ctx.translate(T[0], T[1]); ctx.lineWidth = r * 0.12; ctx.strokeStyle = '#3a2a2a'; ctx.fillStyle = '#f4efe2';
    ctx.beginPath(); ctx.arc(0, -bite * 0.5, r, Math.PI * 0.95, Math.PI * 2.05); ctx.lineTo(r * 0.6, r * 0.25 - bite * 0.5); ctx.lineTo(-r * 0.6, r * 0.25 - bite * 0.5); ctx.closePath(); ctx.fill(); ctx.stroke();
    ctx.fillStyle = '#2a1a1a'; ctx.beginPath(); ctx.ellipse(-r * 0.38, -r * 0.2 - bite * 0.5, r * 0.22, r * 0.26, 0, 0, 7); ctx.ellipse(r * 0.38, -r * 0.2 - bite * 0.5, r * 0.22, r * 0.26, 0, 0, 7); ctx.fill();
    ctx.fillStyle = '#f4efe2'; ctx.beginPath(); ctx.rect(-r * 0.5, r * 0.3 + bite * 0.5, r, r * 0.35); ctx.fill(); ctx.stroke();
    for (let i = -1; i <= 1; i++) { ctx.beginPath(); ctx.moveTo(i * r * 0.25, r * 0.3 + bite * 0.5); ctx.lineTo(i * r * 0.25, r * 0.65 + bite * 0.5); ctx.stroke(); }
    ctx.restore();
  }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#ffd6e6', 121, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '啵！', 0.22 * th, '#ffb3cc', N.TC - 0.01, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 窮鬼：空口袋飛出一群飛蛾 ----------
// ① 把兩個空口袋翻出來、聳肩 → ② 口袋裡撲出一群飛蛾（原圖那隻蛾帶頭）→ ③ 撲在敵人臉上亂飛「一毛都冇！」→ ④ 蛾散開，帶頭那隻飛回原位
MOVES.n30_qionggui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, MC = [0.84, 0.455];
  const f = N.kf(t, [[0, {}], [0.15, { armF:0.4, armB:-0.4, y:-0.04 * H, sy:1.04, head:-0.1 }], [0.24, { armF:0.55, armB:-0.55, y:-0.02 * H, r:5, head:0.1 }], [0.45, { armF:0.3, armB:-0.3 }], [0.59, {}]]);
  const m = N.bm(S, f), home = N.at(S, m, MC[0], MC[1]), T = N.tgt(S, 0.78);
  const pk = [N.at(S, m, 0.13, 0.62), N.at(S, m, 0.66, 0.62)];
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  pk.forEach((o, i) => N.puff(ctx, o[0], o[1], 0.06 * H, N.seg(t, 0.15, 0.4), 'rgba(190,175,150,.55)', 130 + i, 4));
  // 飛蛾：從口袋飛到敵人頭邊，繞圈，再散開
  const moth = (x, y, s, ph) => { const fl = Math.abs(Math.sin(t * 45 + ph)); ctx.save(); ctx.translate(x, y); ctx.fillStyle = '#c9b08a'; ctx.strokeStyle = '#4a3a28'; ctx.lineWidth = s * 0.12;
    for (const sg of [-1, 1]) { ctx.beginPath(); ctx.ellipse(sg * s * 0.45, -s * 0.1, s * 0.5, s * 0.35 * (0.3 + fl), sg * 0.5, 0, 7); ctx.fill(); ctx.stroke(); }
    ctx.fillStyle = '#5a4630'; ctx.beginPath(); ctx.ellipse(0, 0, s * 0.12, s * 0.3, 0, 0, 7); ctx.fill(); ctx.restore(); };
  for (let i = 0; i < 9; i++) {
    const o = pk[i % 2], st = 0.17 + N.rnd(i) * 0.04, q = N.seg(t, st, N.TC), an = t * 9 + i * 0.7, rad = (0.12 + N.rnd(i + 9) * 0.12) * th;
    if (t < st) continue;
    let x = N.lerp(o[0], T[0] + Math.cos(an) * rad, N.E.o(q)), y = N.lerp(o[1], T[1] + Math.sin(an) * rad * 0.6, N.E.o(q)) - Math.sin(q * Math.PI) * 0.15 * H;
    const sc = N.seg(t, 0.42, 0.59); x += sc * (N.rnd(i + 2) - 0.3) * 0.8 * H; y -= sc * (0.3 + N.rnd(i + 4) * 0.4) * H;
    ctx.save(); ctx.globalAlpha *= 1 - sc; moth(x, y, 0.045 * H, i); ctx.restore();
  }
  const L = N.kf(t, [[0, { x:home[0], y:home[1] }], [0.15, { x:home[0], y:home[1] - 0.06 * H }], [N.TC, { x:T[0], y:T[1] - 0.08 * th }, 'i'], [0.40, { x:T[0] + 0.1 * th, y:T[1] - 0.2 * th }], [0.59, { x:home[0], y:home[1] }]]);
  N.pieceAt(ctx, S, 'moth', L.x + Math.sin(t * 25) * 0.01 * H, L.y, Math.sin(t * 30) * 12, MC[0], MC[1]);
  const p = t - N.TC; if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.28 * th, 1 - p / 0.12, '#e8dcc0', 141, 8);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '一毫都冇！', 0.17 * th, '#e8dcc0', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 賭鬼：擲骰子＋飛牌 ----------
// ① 骰子在手裡搖、撲克牌扇開 → ② 骰子甩出去翻滾、三張牌旋轉飛出 → ③ 骰子砸頭、牌插在身上「梭哈！」→ ④ 骰子彈走，手裡再變出一副
MOVES.n30_dugui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, DC = [0.125, 0.49];
  const shake = t < 0.15 ? Math.sin(t * 90) * 0.12 : 0;
  const f = N.kf(t, [[0, {}], [0.15, { armF:0.5, armB:-0.4, r:-5, head:-0.1 }], [0.22, { armF:-0.9, armB:-0.6, r:7, x:0.03 * H, head:0.1 }, 'o'], [0.40, { armF:-0.5, armB:-0.4, r:4 }], [0.59, {}]]);
  f.armF += shake;
  const m = N.bm(S, f), hand = N.at(S, m, DC[0], DC[1]), T = N.tgt(S, 0.8), C = N.tgt(S, 0.5);
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  let dx = hand[0], dy = hand[1], dr = shake * 60, ds = 1;
  if (t >= 0.18 && t < N.TC) { const q = N.seg(t, 0.18, N.TC); dx = N.lerp(hand[0], T[0], q); dy = N.lerp(hand[1], T[1], q) - 0.2 * H * 4 * q * (1 - q); dr = q * 720; }
  else if (t >= N.TC && t < 0.45) { const q = N.seg(t, N.TC, 0.45); dx = T[0] + q * 0.3 * th; dy = T[1] - 0.4 * th * Math.sin(q * Math.PI) + q * q * 0.8 * th; dr = 720 + q * 500; ds = 1 - q; }
  else if (t >= 0.45) { ds = N.E.back(N.seg(t, 0.47, 0.57)); }
  if (ds > 0.02) N.pieceAt(ctx, S, 'dice', dx, dy, dr, DC[0], DC[1], ds);
  // 撲克牌
  const cardO = N.at(S, m, 0.83, 0.42);
  for (let i = 0; i < 3; i++) {
    const st = 0.2 + i * 0.015, q = N.seg(t, st, N.TC + 0.01); if (q <= 0) continue;
    const stick = t > N.TC + 0.01, tx2 = C[0] - 0.05 * th, ty2 = C[1] + (i - 1) * 0.15 * th;
    const x = stick ? tx2 + S.back * 0 : N.lerp(cardO[0], tx2, q), y = stick ? ty2 : N.lerp(cardO[1], ty2, q) - 0.1 * H * Math.sin(q * Math.PI), al = 1 - N.seg(t, 0.45, 0.55);
    if (al <= 0) continue;
    ctx.save(); ctx.globalAlpha *= al; ctx.translate(x, y); ctx.rotate(stick ? 0.5 + i * 0.3 : q * 20 + i); const w = 0.07 * H, h = 0.1 * H;
    ctx.fillStyle = '#fbf6ea'; ctx.strokeStyle = '#3a2a2a'; ctx.lineWidth = w * 0.1; ctx.beginPath(); ctx.roundRect(-w / 2, -h / 2, w, h, w * 0.15); ctx.fill(); ctx.stroke();
    ctx.fillStyle = i === 1 ? '#222' : '#c8202a'; ctx.font = `900 ${h * 0.55}px sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(i === 1 ? '♠' : '♥', 0, 0); ctx.restore();
  }
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#fff0b0', 151, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '梭哈！', 0.22 * th, '#ffd84a', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 酒鬼：抱著酒埕醉醺醺砸過去 ----------
// ① 往後一晃、酒埕舉高 → ② 整個人撲過去，酒埕砸在敵人頭上 → ③ 酒水四濺「嗝～」→ ④ 東倒西歪晃回去
MOVES.n30_jiugui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.55 * th - 0.25 * H);
  const f = N.kf(t, [[0, {}], [0.16, { r:-16, x:-0.04 * H, y:-0.03 * H, armF:-0.4, armB:-0.4, head:-0.15 }], [N.TC, { r:28, x:D2, y:-0.02 * H, armF:-0.6, armB:-0.6, head:0.15, sy:0.95 }, 'i'], [0.33, { r:22, x:D2, armF:-0.5, armB:-0.5 }], [0.40, { r:-8, x:D2 * 0.7 }], [0.47, { r:10, x:D2 * 0.4 }], [0.53, { r:-6, x:D2 * 0.15 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.82), p = t - N.TC;
  if (p >= 0 && p < 0.35) for (let i = 0; i < 14; i++) { const an = -Math.PI * (0.1 + 0.8 * N.rnd(i)), sp = (0.5 + N.rnd(i + 4)) * 1.4 * th, px = T[0] + Math.cos(an) * sp * p, py = T[1] + Math.sin(an) * sp * p + 3 * th * p * p;
    ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = i % 3 ? 'rgba(170,60,90,.85)' : 'rgba(240,220,160,.9)'; ctx.beginPath(); ctx.ellipse(px, py, 0.025 * th, 0.035 * th, an, 0, 7); ctx.fill(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.34 * th, 1 - p / 0.13, '#ffe0f0', 161, 10);
  N.pop(ctx, S, T[0] - 0.2 * th, T[1] - 0.35 * th, '嗝～', 0.24 * th, '#ffb0c8', N.TC + 0.02, 0.36);
  const m = N.bm(S, f), mo = N.at(S, m, 0.3, 0.3);
  for (let i = 0; i < 3; i++) { const q = N.seg(t, 0.3 + i * 0.06, 0.59); if (q > 0 && q < 1) N.ring(ctx, mo[0] + i * 0.03 * H, mo[1] - q * 0.3 * H, 0.025 * H * (1 + i * 0.3), 0.025 * H * (1 + i * 0.3), 'rgba(200,220,255,.8)', 0.008 * H, 1 - q); }
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 煙鬼：吐煙圈套頭 ----------
// ① 煙斗湊到嘴邊用力吸（胸口鼓起）→ ② 「呼」吐出一個大煙圈飛過去 → ③ 煙圈套住敵人的頭收緊，嗆得咳 → ④ 自己也咳兩聲
MOVES.n30_yangui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.16, { armB:-0.35, armF:-0.2, sy:1.05, sx:1.04, head:-0.12, r:-4 }], [0.22, { armB:0.1, sy:0.97, head:0.15, r:6, x:0.02 * H }, 'o'], [0.40, { r:3 }], [0.46, { r:9, head:0.25, sy:0.95 }], [0.52, { r:2 }], [0.56, { r:8, head:0.2 }], [0.59, {}]]);
  const m = N.bm(S, f), mo = N.at(S, m, 0.56, 0.36), T = N.tgt(S, 0.84);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const q = N.seg(t, 0.2, N.TC);
  if (t > 0.2) {
    const x = t < N.TC ? N.lerp(mo[0], T[0], N.E.o(q)) : T[0] + S.back * 0, y = t < N.TC ? N.lerp(mo[1], T[1], N.E.o(q)) : T[1];
    const shrink = t < N.TC ? 0 : N.seg(t, N.TC, 0.36), rr = (0.06 + 0.12 * q - 0.07 * shrink) * H, al = 1 - N.seg(t, 0.42, 0.59);
    N.ring(ctx, x, y, rr, rr * 0.45, 'rgba(210,210,220,.85)', 0.035 * H, al); N.ring(ctx, x, y, rr * 0.92, rr * 0.4, 'rgba(255,255,255,.5)', 0.012 * H, al);
    if (t < N.TC) N.puff(ctx, x - 0.12 * H, y, 0.05 * H, q, 'rgba(220,220,230,.6)', 171, 3);
  }
  if (t < 0.18) N.puff(ctx, mo[0] + 0.12 * H, mo[1] - 0.05 * H, 0.04 * H, N.seg(t, 0.02, 0.18), 'rgba(210,210,220,.5)', 172, 3);
  N.pop(ctx, S, T[0], T[1] - 0.3 * th, '咳咳！', 0.2 * th, '#e0e0ea', N.TC + 0.02, 0.3);
  N.pop(ctx, S, mo[0], mo[1] - 0.18 * H, '咳…', 0.12 * H, '#cfcfd8', 0.44, 0.15);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 孤寒鬼：算盤摑人 ----------
// ① 算盤高舉過頭（算珠嘩啦一響）→ ② 一記算盤摑在敵人臉上 → ③ 算珠彈飛「計清楚！」→ ④ 收回，摸摸算盤心疼
MOVES.n30_guhangui = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.74, 0.64];
  const f = N.kf(t, [[0, {}], [0.16, { r:-7, x:-0.03 * H, head:-0.12, armF:0.2, orn:0.3 }], [N.TC, { r:10, x:0.08 * H, head:0.12, orn:-0.4 }, 'i'], [0.36, { r:8, x:0.08 * H }], [0.59, {}]]);
  const m = N.bm(S, f), w0 = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.78);
  const A = N.kf(t, [[0, { x:w0[0], y:w0[1], r:0 }], [0.16, { x:w0[0] - 0.02 * H, y:w0[1] - 0.42 * H, r:-150 }], [N.TC, { x:T[0] - 0.28 * H, y:T[1] + 0.1 * H, r:-55 }, 'i'], [0.33, { x:T[0] - 0.26 * H, y:T[1] + 0.16 * H, r:-35 }], [0.45, { x:w0[0] + 0.05 * H, y:w0[1] - 0.05 * H, r:-15 }], [0.59, { x:w0[0], y:w0[1], r:0 }]]);
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.18 && t < 0.29) N.speed(ctx, A.x + 0.1 * H, A.y - 0.15 * H, 1, 0.8, 0.3 * H, 0.15 * H, N.seg(t, 0.18, 0.22), 'rgba(255,240,200,.7)', 181, 4);
  N.pieceAt(ctx, S, 'abacus', A.x, A.y, A.r, PV[0], PV[1]);
  const p = t - N.TC;
  if (p >= 0 && p < 0.35) for (let i = 0; i < 10; i++) { const an = -Math.PI * N.rnd(i + 1), sp = (0.4 + N.rnd(i + 5)) * 1.3 * th, px = T[0] + Math.cos(an) * sp * p, py = T[1] + Math.sin(an) * sp * p + 3 * th * p * p;
    ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = '#e8b84a'; ctx.strokeStyle = '#5a3a10'; ctx.lineWidth = 0.008 * th; ctx.beginPath(); ctx.ellipse(px, py, 0.03 * th, 0.02 * th, 0, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#fff0c0', 191, 10);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '計清楚！', 0.2 * th, '#ffd27a', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 討債鬼：紅油潑門＋「還錢！」 ----------
// ① 油漆桶往後一甩、欠單抖一抖 → ② 往前一潑，一大片紅油飛出去 → ③ 潑中敵人、紅油滴下來，大字「還錢！」→ ④ 收桶，欠單再抖給你看
MOVES.n30_taozhai = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.80, 0.58];
  const f = N.kf(t, [[0, {}], [0.16, { r:-6, x:-0.03 * H, armF:0.3, paper:0.4, head:-0.1 }], [0.24, { r:8, x:0.05 * H, armF:-0.3, paper:-0.5, head:0.12 }, 'o'], [0.40, { r:5, x:0.04 * H, paper:0.3 }], [0.59, {}]]);
  const m = N.bm(S, f), w0 = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.6);
  const B = N.kf(t, [[0, { x:w0[0], y:w0[1], r:0 }], [0.16, { x:w0[0] - 0.12 * H, y:w0[1] + 0.02 * H, r:55 }], [0.24, { x:w0[0] + 0.14 * H, y:w0[1] - 0.12 * H, r:-120 }, 'o'], [0.36, { x:w0[0] + 0.12 * H, y:w0[1] - 0.1 * H, r:-110 }], [0.59, { x:w0[0], y:w0[1], r:0 }]]);
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.pieceAt(ctx, S, 'bucket', B.x, B.y, B.r, PV[0], PV[1]);
  const mouth = [B.x + 0.15 * H, B.y - 0.15 * H], q = N.seg(t, 0.2, N.TC);
  if (t > 0.2 && t < N.TC + 0.02) for (let i = 0; i < 9; i++) { const k = N.cl(q - i * 0.04), x = N.lerp(mouth[0], T[0], k), y = N.lerp(mouth[1], T[1] + (N.rnd(i) - 0.5) * 0.4 * th, k) - 0.15 * H * Math.sin(k * Math.PI);
    ctx.fillStyle = '#c8141e'; ctx.strokeStyle = '#4a0a0a'; ctx.lineWidth = 0.006 * H; ctx.beginPath(); ctx.ellipse(x, y, (0.035 + N.rnd(i + 3) * 0.03) * H, 0.025 * H, 0.3, 0, 7); ctx.fill(); ctx.stroke(); }
  const p = t - N.TC;
  if (p >= 0) { const al = 1 - N.seg(t, 0.5, 0.59); ctx.save(); ctx.globalAlpha *= al; const C = [T[0] + S.back * 0, T[1]];
    for (let i = 0; i < 7; i++) { const an = N.rnd(i + 11) * 6.28, d = N.rnd(i + 13) * 0.22 * th; ctx.fillStyle = '#c8141e'; ctx.beginPath(); ctx.ellipse(C[0] + Math.cos(an) * d, C[1] + Math.sin(an) * d * 1.4, 0.07 * th * (0.6 + N.rnd(i)), 0.05 * th, an, 0, 7); ctx.fill(); }
    for (let i = 0; i < 4; i++) { const x = C[0] + (i - 1.5) * 0.08 * th, l = N.cl(p * 4) * (0.15 + N.rnd(i + 20) * 0.2) * th; N.crayon(ctx, [[x, C[1]], [x, C[1] + l]], '#b0101a', 0.025 * th, 200 + i); }
    ctx.restore(); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#ffb0a0', 201, 9);
  N.pop(ctx, S, T[0], T[1] - 0.6 * th, '還錢！', 0.3 * th, '#ff3a3a', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 膽小鬼：閉眼亂揮 ----------
// ① 縮成一團發抖 → ② 「哇啊啊！」閉著眼往前衝、兩手像風車亂揮 → ③ 誤打誤撞打中 → ④ 自己嚇到彈回去，抱頭
MOVES.n30_danxiao = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.42 * th - 0.25 * H), sh = Math.sin(t * 60) * 0.006 * H;
  const flail = t > 0.15 && t < 0.38 ? t * 55 : 0;
  const f = N.kf(t, [[0, {}], [0.14, { sy:0.88, sx:1.05, head:-0.15, r:-4 }], [N.TC, { x:D2, sy:1.02, r:10, head:0.1 }, 'i'], [0.34, { x:D2, r:8 }], [0.42, { x:D2 * 0.3, y:-0.08 * H, r:-12, sy:0.9 }, 'o'], [0.59, {}]]);
  f.x = (f.x || 0) + sh; if (flail) { f.armF = Math.sin(flail) * 1.3; f.armB = Math.sin(flail + 3.1) * 1.3; } else if (t < 0.15) { f.armF = 0; f.armB = 0; }
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.2);
  const m = N.bm(S, f), hd = N.at(S, m, 0.5, 0.2), T = N.tgt(S, 0.6);
  if (t > 0.1 && t < 0.45) N.drops(ctx, hd[0], hd[1], 0.3 * H, (t * 4) % 1, 'rgba(150,210,255,.9)', Math.floor(t * 4) * 5, 4);
  N.pop(ctx, S, hd[0], hd[1] - 0.3 * H, '哇啊啊！', 0.13 * H, '#bfe0ff', 0.12, 0.3);
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#e0f0ff', 211, 9);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '咦？中咗？', 0.16 * th, '#ffffff', N.TC + 0.03, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 冒失鬼：絆倒、一頭撞過去 ----------
// ① 往前走一步，腳下絆到石頭「哎！」→ ② 整個人往前撲倒，頭先著地滑過去 → ③ 頭槌撞中、冒星星 → ④ 彈起來、拍拍屁股退回
MOVES.n30_maoshi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = S.tx - 0.12 * th - 0.8 * H * Math.sin(70 * N.D);
  const f = N.kf(t, [[0, {}], [0.12, { x:0.03 * H, r:-10, armF:0.4, armB:-0.6, head:-0.15 }], [0.18, { x:0.06 * H, r:25, armF:-1.0, armB:-0.9, head:0.1 }], [N.TC, { x:D2, r:70, px:0, py:0, y:-0.02 * H, armF:-1.2, armB:-1.1, legF:-0.3, legB:0.4, head:0.2 }, 'i'], [0.36, { x:D2 + 0.02 * H, r:74, px:0, py:0, armF:-1.1, armB:-1.0, head:0.2 }], [0.46, { x:D2 * 0.4, y:-0.15 * H, r:20, sy:1.05 }, 'o'], [0.59, {}]]);
  f.px = 0; f.py = 0;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.2);
  const T = N.tgt(S, 0.5), p = t - N.TC;
  N.pop(ctx, S, 0.15 * H, -0.95 * H, '哎！', 0.12 * H, '#ffe066', 0.1, 0.18);
  if (t > 0.18 && t < N.TC) for (let i = 0; i < 3; i++) N.puff(ctx, (f.x || 0) + 0.2 * H - i * 0.12 * H, -0.03 * H, 0.05 * H, N.seg(t, 0.18 + i * 0.02, 0.4), 'rgba(200,190,170,.55)', 220 + i, 3);
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#fff4c0', 221, 10);
  if (t > N.TC && t < 0.5) { N.stars(ctx, T[0] - 0.1 * th, -0.35 * H, 0.15 * H, t, 1 - N.seg(t, 0.44, 0.5)); }
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '咚！', 0.24 * th, '#ffe066', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Hantu Raya：黑影變大、壓下來 ----------
// ① 黑影往上漲高、雙手舉起、腳下黑氣擴散 → ② 整個罩過去，兩手往下一壓 → ③ 地上炸開一圈黑紫色衝擊波 → ④ 縮回原來大小
MOVES.n30_hanturaya = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.4 * th - 0.3 * H);
  const f = N.kf(t, [[0, {}], [0.18, { sy:1.22, sx:1.1, armF:-1.0, armB:-0.7, head:-0.15, hairL:0.3, hairR:0.3, r:-4 }], [N.TC, { sy:1.05, sx:1.12, x:D2, r:22, armF:-0.3, armB:-0.2, head:0.2, hairL:-0.4, hairR:-0.4 }, 'i'], [0.36, { sy:1.0, sx:1.1, x:D2, r:20, armF:-0.25, armB:-0.15 }], [0.59, {}]]);
  const aura = N.kf(t, [[0, { v:0 }], [0.18, { v:1 }], [0.40, { v:0.8 }], [0.59, { v:0 }]]).v;
  N30M.begin(ctx, S, f.x, 1 + aura * 0.6);
  if (aura > 0) { const g = ctx.createRadialGradient(f.x || 0, -0.5 * H, 0, f.x || 0, -0.5 * H, 0.75 * H); g.addColorStop(0, `rgba(40,20,60,${0.45 * aura})`); g.addColorStop(1, 'rgba(40,20,60,0)'); ctx.fillStyle = g; ctx.fillRect((f.x || 0) - 0.8 * H, -1.3 * H, 1.6 * H, 1.4 * H); }
  N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.5), p = t - N.TC;
  if (p >= 0 && p < 0.3) { const k = p / 0.3; N.ring(ctx, T[0], S.ty, (0.2 + k * 0.8) * th, (0.06 + k * 0.2) * th, 'rgba(120,70,170,.9)', 0.05 * th * (1 - k), 1 - k); N.ring(ctx, T[0], S.ty, (0.1 + k * 0.5) * th, (0.03 + k * 0.12) * th, 'rgba(30,10,40,.9)', 0.04 * th * (1 - k), 1 - k); }
  for (let i = 0; i < 5; i++) N.puff(ctx, T[0] + (i - 2) * 0.15 * th, S.ty - 0.1 * th, 0.08 * th, N.seg(t, N.TC + i * 0.01, 0.5), 'rgba(60,30,80,.5)', 230 + i, 3);
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1] - 0.2 * th, 0.4 * th, 1 - p / 0.13, '#c9a0ff', 231, 12);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Polong：從瓶子竄出去咬 ----------
// ① 縮回瓶口、瓶子晃兩下 → ② 「咻」一下竄出去，身後拖一條紅色血絲連著瓶口 → ③ 一口咬住 → ④ 被血絲扯回來、「啵」一聲鑽回瓶裡
MOVES.n30_polong = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.47, 0.565];
  const f = N.kf(t, [[0, {}], [0.06, { r:-6 }], [0.12, { r:6 }], [0.18, { r:-3 }], [0.24, { r:2 }], [0.50, { r:0 }], [0.54, { y:-0.06 * H, sy:1.05 }], [0.59, {}]]);
  const m = N.bm(S, f), mouth = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.8);
  const ho = [(S.nr ? 1 : -1) * (0.33 - PV[0]) * S.W, (0.2 - PV[1]) * S.H]; // 頭相對瓶口
  const goal = [T[0] - ho[0] - 0.03 * th, T[1] - ho[1]];
  const P = N.kf(t, [[0, { x:mouth[0], y:mouth[1], r:0, s:1 }], [0.16, { x:mouth[0], y:mouth[1] + 0.04 * H, r:-8, s:0.82 }], [N.TC, { x:goal[0], y:goal[1], r:25, s:1.0 }, 'i'], [0.36, { x:goal[0] + 0.01 * H, y:goal[1] + 0.02 * H, r:30, s:1.0 }], [0.52, { x:mouth[0], y:mouth[1] + 0.02 * H, r:0, s:0.8 }, 'i'], [0.59, { x:mouth[0], y:mouth[1], r:0, s:1 }]]);
  N30M.begin(ctx, S, f.x);
  if (t > 0.18 && t < 0.52) { const pts = N.quad(mouth, [(mouth[0] + P.x) / 2, Math.min(mouth[1], P.y) - 0.25 * H], [P.x, P.y + 0.02 * H], 10); N.crayon(ctx, pts, '#8a1a24', 0.04 * H, 241); N.crayon(ctx, pts.map(q => [q[0], q[1] - 0.012 * H]), '#d04050', 0.015 * H, 242); }
  N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.pieceAt(ctx, S, 'spirit', P.x, P.y, P.r, PV[0], PV[1], P.s, 2 - P.s * 0.9 - 0.1);
  if (t > 0.18 && t < N.TC) N.speed(ctx, P.x, P.y - 0.25 * H, P.x - mouth[0], P.y - mouth[1], 0.3 * H, 0.15 * H, N.seg(t, 0.18, 0.22), 'rgba(255,200,210,.7)', 243, 4);
  const p = t - N.TC;
  if (p >= 0 && p < 0.25) for (const sg of [-1, 1]) { const g = 0.05 * th * (1 - Math.min(1, p * 8)), pts = []; for (let j = 0; j <= 5; j++) pts.push([T[0] - 0.1 * th + j * 0.04 * th, T[1] + sg * (g + (j % 2 ? 0.02 * th : 0))]); N.crayon(ctx, pts, '#fffaf0', 0.02 * th, 245 + sg, 1 - p / 0.25); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#ffc0c8', 247, 9);
  N.pop(ctx, S, mouth[0], mouth[1] - 0.15 * H, '啵！', 0.12 * H, '#ffd0d8', 0.52, 0.07);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Pelesit：跳起來咬 ----------
// ① 後腿蹲低、觸鬚抖 → ② 彈起一大跳撲到敵人臉上 → ③ 喀一口 → ④ 往回蹦兩下「唧唧」
MOVES.n30_pelesit = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.25 * th - 0.4 * S.W);
  const f = N.kf(t, [[0, {}], [0.14, { sy:0.82, sx:1.08, legB:0.35, legF:0.2, hairL:0.3, hairR:0.3, r:4 }], [0.20, { x:D2 * 0.55, y:-0.75 * H, sy:1.1, r:-25, legB:-0.4, legF:-0.3 }, 'o'], [N.TC, { x:D2, y:-0.45 * th, r:-30, legB:-0.3, legF:-0.4, head:0.2 }], [0.34, { x:D2, y:-0.4 * th, r:-25, head:-0.1 }], [0.42, { x:D2 * 0.6, y:-0.3 * H, r:-5 }, 'o'], [0.48, { x:D2 * 0.35, y:0, sy:0.9 }, 'i'], [0.54, { x:D2 * 0.12, y:-0.2 * H }, 'o'], [0.59, {}, 'i']]);
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H) * 0.6); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.72), p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#f0e0b0', 251, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '喀！', 0.22 * th, '#f0e0b0', N.TC, 0.25);
  N.pop(ctx, S, 0, -1.1 * H, '唧唧', 0.2 * H, '#d8e8a0', 0.46, 0.13);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Jenglot：轉身甩髮 ----------
// ① 縮身、整頭長髮往後甩 → ② 原地一轉，長髮像鞭子掃出去 → ③ 髮梢抽中「嘶！」→ ④ 頭髮落回、甩甩頭
MOVES.n30_jenglot = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.5 * th - 0.35 * H);
  const spin = N.seg(t, 0.17, 0.255), sx = Math.cos(spin * Math.PI * 2);
  const f = N.kf(t, [[0, {}], [0.15, { sy:0.9, r:-8, hairL:0.45, hairR:0.45, head:-0.15 }], [N.TC, { x:D2, r:8, hairL:-0.7, hairR:-0.7, head:0.15 }, 'i'], [0.36, { x:D2, r:6, hairL:-0.5, hairR:-0.5 }], [0.50, { hairL:0.2, hairR:0.2 }], [0.59, {}]]);
  f.sx = (f.sx || 1) * (Math.abs(sx) < 0.15 ? 0.15 * Math.sign(sx || 1) : sx);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.6), hd = [(f.x || 0), -0.75 * H];
  if (t > 0.2 && t < 0.36) for (let i = 0; i < 4; i++) { const k = N.seg(t, 0.2, N.TC), pts = []; for (let j = 0; j <= 8; j++) { const q = j / 8; pts.push([N.lerp(hd[0], T[0] + 0.05 * th, q * k), hd[1] + (i - 1.5) * 0.05 * H + Math.sin(q * 6 + t * 30 + i) * 0.04 * H * q + q * (T[1] - hd[1])]); } N.crayon(ctx, pts, 'rgba(25,18,15,.85)', 0.018 * H, 261 + i, 1 - N.seg(t, 0.32, 0.36)); }
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#e8d8c8', 265, 9);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '嘶！', 0.22 * th, '#d8c8b8', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Hantu Galah：一步跨過去、彎腰彈額頭 ----------
// ① 竹竿身子往後一仰、長腳抬高 → ② 一大步跨到敵人面前，從高處整個彎下來 → ③ 手指「彈！」在額頭上 → ④ 慢慢直起來、退一大步
MOVES.n30_hantugalah = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.35 * th - 0.35 * H);
  const f = N.kf(t, [[0, {}], [0.16, { r:-6, legB:-0.22, legF:0.08, head:-0.1, armB:0.3 }], [N.TC, { x:D2, r:22, py:-0.5 * H, body:0.35, head:0.35, legB:-0.08, legF:0.12, armB:-0.6, armF:0.3 }, 'i'], [0.36, { x:D2, r:20, py:-0.5 * H, body:0.33, head:0.32, armB:-0.4 }], [0.48, { x:D2 * 0.5, legF:-0.12, legB:0.1, r:5, py:-0.5 * H }], [0.59, {}]]);
  f.px = 0; f.py = -0.5 * H;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.88), p = t - N.TC;
  if (p >= 0 && p < 0.13) { N.burst(ctx, T[0], T[1], 0.25 * th, 1 - p / 0.13, '#fff', 271, 8); }
  if (p >= 0 && p < 0.3) N.stars(ctx, T[0], T[1] - 0.1 * th, 0.15 * th, t, 1 - p / 0.3);
  N.pop(ctx, S, T[0], T[1] - 0.3 * th, '彈！', 0.22 * th, '#ffffff', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Jerangkung：拆下前臂當迴旋鏢 ----------
// ① 前臂往後扳到肩上（喀喀響）→ ② 甩出去，骨頭手臂轉著飛 → ③ 敲在頭上「喀啦！」→ ④ 劃一個弧飛回來、「喀」一聲裝回手肘
MOVES.n30_jerangkung = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.63, 0.47], AC = [0.80, 0.44];
  const f = N.kf(t, [[0, {}], [0.15, { r:-7, head:-0.15, body:-0.05 }], [0.20, { r:9, head:0.15, body:0.1, x:0.03 * H }, 'o'], [0.45, { r:2 }], [0.55, { r:-4, head:-0.1 }], [0.59, {}]]);
  const m = N.bm(S, f), el = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.82);
  const off = [(S.nr ? 1 : -1) * (AC[0] - PV[0]) * S.W, (AC[1] - PV[1]) * S.H]; // 旋轉中心＝前臂中段
  let x, y, r;
  if (t < 0.16) { const k = N.E.io(N.seg(t, 0.02, 0.16)); r = -130 * k; x = el[0]; y = el[1]; }
  else if (t < N.TC) { const q = N.seg(t, 0.16, N.TC); x = N.lerp(el[0], T[0] - off[0], q); y = N.lerp(el[1], T[1] - off[1], q) - 0.15 * H * Math.sin(q * Math.PI); r = -130 + q * 900; }
  else if (t < 0.55) { const q = N.seg(t, N.TC, 0.55), bx = T[0] - off[0], by = T[1] - off[1]; x = N.lerp(bx, el[0], q) + Math.sin(q * Math.PI) * 0.1 * H; y = N.lerp(by, el[1], q) - Math.sin(q * Math.PI) * 0.4 * H; r = 770 + q * 1060 - (q > 0.85 ? 0 : 0); }
  else { x = el[0]; y = el[1]; r = 0; }
  if (t >= 0.55) r = 0; else if (t > 0.5) r = r % 360 * (1 - N.seg(t, 0.5, 0.55));
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.16 && t < 0.55) N.speed(ctx, x, y, 1, 0, 0.12 * H, 0.08 * H, 0.6, 'rgba(255,250,230,.5)', 281, 3);
  // 繞手肘轉的時候用支點；飛的時候繞前臂中段轉
  if (t < 0.16 || t >= 0.55) N.pieceAt(ctx, S, 'arm', x, y, r, PV[0], PV[1]);
  else { const c = [x + off[0], y + off[1]]; N.pieceAt(ctx, S, 'arm', c[0], c[1], r, AC[0], AC[1]); }
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#fffbe8', 285, 9);
  N.pop(ctx, S, T[0], T[1] - 0.3 * th, '喀啦！', 0.2 * th, '#f6efd8', N.TC, 0.28);
  N.pop(ctx, S, el[0], el[1] - 0.12 * H, '喀', 0.1 * H, '#f6efd8', 0.55, 0.04);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Genderuwo：跳起來雙拳搥地 ----------
// ① 蹲低一跳、雙拳舉過頭 → ② 重重落地、雙拳搥下去 → ③ 地面裂開一路震到敵人腳下、碎石飛「轟！」→ ④ 站起來拍胸口
MOVES.n30_genderuwo = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.7 * th - 0.3 * H);
  const f = N.kf(t, [[0, {}], [0.06, { sy:0.88, sx:1.06 }], [0.17, { y:-0.25 * H, x:D2 * 0.6, sy:1.06, armF:-0.6, armB:-0.5, head:-0.15 }, 'o'], [N.TC, { y:0, x:D2, sy:0.84, sx:1.1, armF:-0.25, armB:-0.2, r:12, head:0.2 }, 'i'], [0.36, { x:D2, sy:0.9, sx:1.06, r:10, armF:-0.2, armB:-0.15 }], [0.50, { x:D2 * 0.3, armF:-0.5, armB:0.4 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H)); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.4), p = t - N.TC, fx = (f.x || 0) + 0.35 * H;
  if (p >= 0) { const k = N.seg(t, N.TC, N.TC + 0.06), al = 1 - N.seg(t, 0.5, 0.59), pts = []; for (let j = 0; j <= 8; j++) { const q = j / 8 * k; pts.push([N.lerp(fx, S.tx + S.back, q), S.ty * q + Math.sin(j * 2.3) * 0.02 * H]); } ctx.save(); ctx.globalAlpha *= al; N.crayon(ctx, pts, 'rgba(40,28,22,.9)', 0.02 * H, 291); ctx.restore(); N.cracks(ctx, S.tx + S.back, S.ty, 0.4 * th, al * k, 292); }
  if (p >= 0 && p < 0.35) for (let i = 0; i < 9; i++) { const an = -Math.PI * (0.15 + 0.7 * N.rnd(i)), sp = (0.4 + N.rnd(i + 4)) * 1.4 * th, px = fx + Math.cos(an) * sp * p * (i % 2 ? 1 : 0.4) + (i % 2 ? (S.tx - fx) * N.cl(p * 6) : 0), py = Math.sin(an) * sp * p + 3 * th * p * p;
    ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = '#7a6a5a'; ctx.strokeStyle = '#3a2a1a'; ctx.lineWidth = 0.01 * th; ctx.beginPath(); ctx.moveTo(px, py - 0.03 * th); ctx.lineTo(px + 0.03 * th, py); ctx.lineTo(px, py + 0.025 * th); ctx.lineTo(px - 0.03 * th, py + 0.005 * th); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore(); }
  for (let i = 0; i < 4; i++) N.puff(ctx, fx + (i - 1.5) * 0.18 * H, -0.03 * H, 0.08 * H, N.seg(t, N.TC + i * 0.01, 0.5), 'rgba(190,170,150,.6)', 295 + i, 3);
  N.pop(ctx, S, T[0], T[1] - 0.55 * th, '轟！', 0.3 * th, '#ffcf80', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Orang Bunian：隱身、閃到背後 ----------
// ① 化成金色光點消失 → ② 從敵人背後冒出來（轉身面向他）→ ③ 在肩膀上輕輕一拍「噗」金光一閃 → ④ 又消失、回到原位現身
MOVES.n30_bunian = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, BX = S.tx + 0.45 * th + 0.15 * H;
  const behind = t >= 0.2 && t < 0.43;
  const f = behind ? N.kf(t, [[0.2, { x:BX, sx:-1, a:0, r:0 }], [0.24, { x:BX, sx:-1, a:1, r:-4 }], [N.TC, { x:BX - 0.08 * H, sx:-1, a:1, r:10, armB:-0.9, armF:0.3 }, 'i'], [0.36, { x:BX - 0.08 * H, sx:-1, a:1, r:8, armB:-0.7 }], [0.43, { x:BX, sx:-1, a:0 }]])
    : t < 0.2 ? N.kf(t, [[0, {}], [0.05, { r:-3, sy:1.03 }], [0.18, { a:0, sy:1.08, sx:0.9, y:-0.05 * H }]]) : N.kf(t, [[0.43, { a:0, sy:1.08, sx:0.9 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x || 0, f.a != null ? 0.3 + 0.7 * f.a : 1); N.whole(ctx, S, f, null, 0.4);
  const spark = (x, y, k, seed) => { if (k <= 0 || k >= 1) return; for (let i = 0; i < 10; i++) { const an = N.rnd(seed + i) * 6.28, d = (0.1 + k * 0.4) * H * N.rnd(seed + i + 3); ctx.save(); ctx.globalAlpha *= Math.sin(k * Math.PI); ctx.fillStyle = i % 2 ? '#ffe28a' : '#fff6c8'; ctx.beginPath(); ctx.arc(x + Math.cos(an) * d, y + Math.sin(an) * d - k * 0.2 * H, 0.012 * H, 0, 7); ctx.fill(); ctx.restore(); } };
  spark(0, -0.5 * H, N.seg(t, 0.06, 0.26), 301); spark(BX, -0.5 * H, N.seg(t, 0.18, 0.3), 311); spark(BX, -0.5 * H, N.seg(t, 0.38, 0.5), 321); spark(0, -0.5 * H, N.seg(t, 0.44, 0.59), 331);
  const T = [S.tx + S.back + 0.12 * th, S.ty - 0.75 * th], p = t - N.TC;
  if (p >= 0 && p < 0.15) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.15, '#ffe28a', 341, 10);
  N.pop(ctx, S, T[0], T[1] - 0.3 * th, '噗～', 0.2 * th, '#ffe28a', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Mae Nak：手臂伸長抓人 ----------
// ① 手往後收一點、斜眼笑 → ② 手臂「唰」一直伸長到敵人面前 → ③ 一把抓住頭、往回扯一下 → ④ 手臂慢慢縮回來
MOVES.n30_maenak = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, WP = [0.205, 0.45];
  const f = N.kf(t, [[0, {}], [0.16, { r:-4, head:-0.1 }], [N.TC, { r:5, head:0.1, x:0.02 * H }, 'i'], [0.36, { r:-2, head:-0.05 }], [0.59, {}]]);
  const m = N.bm(S, f), SRC = [[0.56, 0.405], [0.45, 0.40], [0.33, 0.40], [0.24, 0.41], [0.19, 0.43]];
  const sh = N.at(S, m, 0.56, 0.405), w0 = N.at(S, m, 0.19, 0.43), T = N.tgt(S, 0.82);
  const handLen = 0.15 * S.W, goal = [T[0] - handLen, T[1] + 0.02 * th];
  const W = N.kf(t, [[0, { x:w0[0], y:w0[1] }], [0.16, { x:w0[0] - 0.08 * H, y:w0[1] - 0.03 * H }], [N.TC, { x:goal[0], y:goal[1] }, 'i'], [0.31, { x:goal[0] - 0.02 * H, y:goal[1] + 0.01 * H }], [0.36, { x:goal[0] - 0.08 * H, y:goal[1] }], [0.59, { x:w0[0], y:w0[1] }, 'io']]);
  const b = N.kf(t, [[0, { v:0 }], [0.05, { v:1 }], [0.55, { v:1 }], [0.59, { v:0 }]]).v;
  const wr = [W.x, W.y], mid = [(sh[0] + wr[0]) / 2, (sh[1] + wr[1]) / 2 + 0.03 * H * (1 - N.seg(t, 0.16, N.TC))];
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.25), key);
  const line = N30M.line(S, m, SRC, sh, mid, wr, b);
  if (t > 0.17 && t < N.TC) N.speed(ctx, wr[0], wr[1], 1, 0, 0.3 * H, 0.08 * H, 0.8, 'rgba(240,230,255,.6)', 351, 3);
  N.ribbon(ctx, S, 'arm', SRC, 0.034, line, (i, n) => 1 - 0.15 * b * N.cl(Math.hypot(wr[0] - w0[0], wr[1] - w0[1]) / H) * Math.sin(i / n * Math.PI));
  const end = line[line.length - 1], prev = line[line.length - 3], restA = Math.atan2(w0[1] - N.at(S, m, 0.24, 0.41)[1], w0[0] - N.at(S, m, 0.24, 0.41)[0]), curA = Math.atan2(end[1] - prev[1], end[0] - prev[0]);
  const grip = t > N.TC && t < 0.4 ? -12 : 0;
  N.pieceAt(ctx, S, 'hand', end[0], end[1], (curA - restA) / N.D + grip, WP[0], WP[1]);
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#efe0ff', 355, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '捉到你～', 0.18 * th, '#e8d0ff', N.TC, 0.32);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Phi Am：鬼壓床，一屁股坐扁 ----------
// ① 蹲到最低、肥肉一抖 → ② 彈起來畫一道弧飛過去 → ③ 一屁股坐在敵人身上壓扁「嘿咻」Zzz → ④ 拍拍屁股跳回去
MOVES.n30_phiam = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = S.tx + S.back * 0.5 - 0.05 * th, SY = S.ty - 0.55 * th;
  const f = N.kf(t, [[0, {}], [0.15, { sy:0.78, sx:1.12, armF:0.3, armB:-0.3 }], [0.21, { x:D2 * 0.5, y:-0.7 * H, sy:1.12, sx:0.92, armF:-0.6, armB:0.6, r:-10 }, 'o'], [N.TC, { x:D2, y:SY, sy:0.8, sx:1.15, armF:-0.3, armB:0.3 }, 'i'], [0.36, { x:D2, y:SY, sy:0.9, sx:1.08, r:4 }], [0.40, { x:D2, y:SY, sy:0.88, sx:1.1, r:-4 }], [0.48, { x:D2 * 0.5, y:-0.45 * H, sy:1.05 }, 'o'], [0.59, {}, 'i']]);
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H) * 0.5); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.55), p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], SY, 0.45 * th, 1 - p / 0.13, '#ffd8f0', 361, 12);
  for (let i = 0; i < 3; i++) { const q = N.seg(t, N.TC + i * 0.04, 0.55); if (q > 0 && q < 1) N.txt(ctx, S, D2 + 0.2 * H + q * 0.15 * H, SY - 0.9 * H - q * 0.3 * H - i * 0.05 * H, 'Z', (0.12 + i * 0.04) * H, '#c8d8ff', Math.sin(q * Math.PI)); }
  N.pop(ctx, S, T[0], SY - 1.05 * H, '坐低！', 0.14 * H, '#ffd8f0', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Churel：轉身倒著跑撞過去（她的腳本來就是反的）----------
// ① 一扭身背對敵人 → ② 倒著小碎步衝過去 → ③ 屁股一頂撞飛「咚！」→ ④ 再轉回來、滑回原位
MOVES.n30_churel = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.3 * th - 0.25 * H);
  const turn = t < 0.12 ? Math.cos(N.seg(t, 0.05, 0.11) * Math.PI) : t > 0.45 ? -Math.cos(N.seg(t, 0.50, 0.56) * Math.PI) : -1;
  const f = N.kf(t, [[0, {}], [0.12, { r:3 }], [N.TC, { x:D2, r:-10 }, 'i'], [0.34, { x:D2, r:-14 }], [0.45, { x:D2 * 0.6 }], [0.59, {}]]);
  f.sx = Math.abs(turn) < 0.15 ? 0.15 * Math.sign(turn || 1) : turn;
  if (t > 0.12 && t < N.TC) { f.legF = Math.sin(t * 60) * 0.45; f.legB = -Math.sin(t * 60) * 0.45; f.armF = Math.sin(t * 60) * 0.3; f.armB = -Math.sin(t * 60) * 0.3; f.y = -Math.abs(Math.sin(t * 60)) * 0.03 * H; f.hairL = 0.3; f.hairR = 0.3; }
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  if (t > 0.12 && t < N.TC) for (let i = 0; i < 3; i++) N.puff(ctx, (f.x || 0) - (i + 1) * 0.1 * H, -0.02 * H, 0.05 * H, N.cl((t - 0.12) * 7 - i * 0.2), 'rgba(200,180,160,.5)', 370 + i, 3);
  const T = N.tgt(S, 0.5), p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#ffd8c8', 375, 10);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '咚！', 0.24 * th, '#ffc0a8', N.TC, 0.28);
  N.pop(ctx, S, 0.1 * H, -1.05 * H, '倒住跑！', 0.11 * H, '#ffd8c8', 0.08, 0.2);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Vetala：倒吊從天而降 ----------
// ① 蹲下一躍跳出畫面 → ② 倒吊在一根樹枝上盪下來，臉貼到敵人面前 → ③ 「嘎！」大叫 → ④ 盪兩下被拉回上面、落回原位
MOVES.n30_vetala = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, HX = S.tx - 0.3 * th, HY = S.ty - 0.62 * th; // 倒吊時頭的位置
  const swing = t > 0.22 && t < 0.45 ? Math.sin((t - 0.22) * 22) * 10 * (1 - N.seg(t, 0.3, 0.45)) : 0;
  const f = N.kf(t, [[0, {}], [0.08, { sy:0.85, sx:1.05 }], [0.16, { y:-1.5 * H, x:HX * 0.5, r:90, sy:1.05 }, 'o'], [0.22, { y:HY + 0.02 * H, x:HX, r:180 }, 'i'], [N.TC, { y:HY + 0.1 * H, x:HX, r:185, head:0.2 }], [0.40, { y:HY + 0.08 * H, x:HX, r:180 }], [0.48, { y:-1.6 * H, x:HX * 0.5, r:250 }, 'i'], [0.54, { y:-0.25 * H, x:0, r:360 }, 'o'], [0.59, { r:360 }]]);
  f.r = (f.r || 0) + swing; f.px = 0; f.py = -0.5 * H;
  // 倒吊：樹枝（從腳往上拉一條藤）
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / (1.5 * H)));
  if (t > 0.19 && t < 0.47) { const m = N.bm(S, f), ft = m.pt(0, 0), top = [ft[0] - Math.sin(swing * N.D) * 0.6 * H, ft[1] - 1.8 * H]; N.crayon(ctx, [ft, [(ft[0] + top[0]) / 2 + 0.03 * H, (ft[1] + top[1]) / 2], top], '#6a4a2a', 0.03 * H, 381); N.crayon(ctx, [[top[0] - 0.4 * H, top[1] + 0.05 * H], [top[0] + 0.4 * H, top[1] - 0.04 * H]], '#5a3a1a', 0.06 * H, 382); }
  N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.75), p = t - N.TC;
  if (p >= 0 && p < 0.3) for (let i = 0; i < 3; i++) { const k = N.cl(p / 0.3 - i * 0.15); if (k > 0 && k < 1) N.ring(ctx, T[0] - 0.2 * th, T[1], (0.1 + k * 0.35) * th, (0.15 + k * 0.5) * th, 'rgba(220,255,220,.8)', 0.02 * th, 1 - k); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#e0ffd8', 385, 9);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '嘎！', 0.26 * th, '#d8ffc8', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 河童：鞠躬潑水 ----------
// ① 很有禮貌地深深一鞠躬（頭頂的碟子對準敵人）→ ② 碟裡的水整盤潑出去 → ③ 嘩啦淋一身 → ④ 直起身，頭上的水只剩一點點，緊張地扶碟子
MOVES.n30_kappa = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.10, { r:-5, head:-0.1 }], [0.24, { r:28, body:0.35, head:0.35, armF:0.4, armB:-0.3, x:0.04 * H }, 'o'], [0.36, { r:26, body:0.3, head:0.3, x:0.04 * H }], [0.50, { r:-3, head:-0.05, armF:-0.9 }], [0.59, {}]]);
  f.px = 0; f.py = 0;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), dish = N.at(S, m, 0.47, 0.05), T = N.tgt(S, 0.75), q = N.seg(t, 0.2, N.TC);
  if (t > 0.2 && t < N.TC + 0.02) for (let i = 0; i < 10; i++) { const k = N.cl(q - i * 0.04), x = N.lerp(dish[0], T[0], k), y = N.lerp(dish[1], T[1] + (N.rnd(i) - 0.5) * 0.3 * th, k) - 0.18 * H * Math.sin(k * Math.PI);
    ctx.fillStyle = 'rgba(120,190,240,.85)'; ctx.strokeStyle = 'rgba(30,70,110,.7)'; ctx.lineWidth = 0.006 * H; ctx.beginPath(); ctx.ellipse(x, y, (0.03 + N.rnd(i + 3) * 0.025) * H, 0.022 * H, 0.4, 0, 7); ctx.fill(); ctx.stroke(); }
  const p = t - N.TC;
  N.drops(ctx, T[0], T[1], 0.6 * th, N.seg(t, N.TC, 0.5), 'rgba(130,200,250,.95)', 391, 12, 3.2);
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.35 * th, 1 - p / 0.13, '#c8ecff', 393, 10);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '嘩啦！', 0.22 * th, '#a8dcff', N.TC, 0.3);
  N.pop(ctx, S, dish[0], dish[1] - 0.12 * H, '我啲水呀！', 0.1 * H, '#a8dcff', 0.47, 0.12);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 轆轤首：伸長脖子頭槌 ----------
// ① 頭往後上方縮、脖子繃成 S 形 → ② 脖子「咻」地伸長，頭直直撞過去 → ③ 額頭撞額頭、冒星星 → ④ 脖子晃兩下縮回來
MOVES.n30_rokurokubi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, AP = [0.43, 0.30], HC = [0.22, 0.27];
  const SRC = [[0.43, 0.30], [0.52, 0.275], [0.61, 0.265], [0.70, 0.285], [0.735, 0.345], [0.715, 0.41], [0.66, 0.46], [0.615, 0.51], [0.60, 0.585]];
  const f = N.kf(t, [[0, {}], [0.16, { r:-4, armF:0.2, armB:-0.2 }], [N.TC, { r:6, x:0.02 * H }, 'i'], [0.59, {}]]);
  const m = N.bm(S, f), A0 = N.at(S, m, AP[0], AP[1]), B = N.at(S, m, 0.60, 0.585), T = N.tgt(S, 0.85);
  const ho = [(S.nr ? 1 : -1) * (HC[0] - AP[0]) * S.W, (HC[1] - AP[1]) * S.H];
  const G = [T[0] - ho[0] - 0.12 * th, T[1] - ho[1]];
  const wob = t > N.TC && t < 0.45 ? Math.sin((t - N.TC) * 40) * 0.05 * H * (1 - N.seg(t, N.TC, 0.45)) : 0;
  const P = N.kf(t, [[0, { x:A0[0], y:A0[1], r:0 }], [0.16, { x:A0[0] - 0.1 * H, y:A0[1] - 0.22 * H, r:-15 }], [N.TC, { x:G[0], y:G[1], r:18 }, 'i'], [0.33, { x:G[0] - 0.03 * H, y:G[1] - 0.02 * H, r:8 }], [0.59, { x:A0[0], y:A0[1], r:0 }]]);
  const b = N.kf(t, [[0, { v:0 }], [0.05, { v:1 }], [0.54, { v:1 }], [0.59, { v:0 }]]).v;
  const Ap = [P.x, P.y + wob], ctrl = [(Ap[0] + B[0]) / 2 + 0.05 * H, Math.min(Ap[1], B[1]) - 0.25 * H * (1 - N.seg(t, 0.16, N.TC) * 0.6)];
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.ribbon(ctx, S, 'neck', SRC, 0.03, N30M.line(S, m, SRC, Ap, ctrl, B, b));
  N.pieceAt(ctx, S, 'head', Ap[0], Ap[1], P.r, AP[0], AP[1]);
  const p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0] - 0.1 * th, T[1], 0.3 * th, 1 - p / 0.13, '#ffe8f0', 401, 10);
  if (p >= 0 && p < 0.3) N.stars(ctx, T[0], T[1] - 0.2 * th, 0.18 * th, t, 1 - p / 0.3);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '咚！', 0.24 * th, '#ffd0e0', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 裂口女：「我漂亮嗎？」剪刀咔嚓 ----------
// ① 剪刀舉到臉旁，頭一歪「我漂亮嗎？」→ ② 一步上前，剪刀直伸過去 → ③ 咔嚓剪一下、剪斷幾根頭髮 → ④ 收剪刀、整理口罩
MOVES.n30_kuchisake = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.21, 0.53];
  const f = N.kf(t, [[0, {}], [0.16, { head:-0.25, r:-4, hairL:0.1, hairR:0.1 }], [N.TC, { head:0.12, r:9, x:0.12 * H, legF:0.25, legB:-0.15, hairL:-0.25, hairR:-0.3 }, 'i'], [0.36, { head:0.1, r:8, x:0.12 * H, legF:0.22, legB:-0.12 }], [0.59, {}]]);
  const m = N.bm(S, f), w0 = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.72), L = 0.32 * H, ang = 40;
  const dir = (-60 + ang) * N.D, G = [T[0] - L * Math.cos(dir), T[1] - L * Math.sin(dir)];
  const W = N.kf(t, [[0, { x:w0[0], y:w0[1], r:0 }], [0.16, { x:w0[0] - 0.05 * H, y:w0[1] - 0.12 * H, r:-25 }], [N.TC, { x:G[0], y:G[1], r:ang }, 'i'], [0.36, { x:G[0] - 0.02 * H, y:G[1], r:ang - 5 }], [0.59, { x:w0[0], y:w0[1], r:0 }]]);
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.pieceAt(ctx, S, 'scissors', W.x, W.y, W.r, PV[0], PV[1]);
  const hd = N.at(S, m, 0.45, 0.12);
  N.pop(ctx, S, hd[0] - 0.05 * H, hd[1] - 0.12 * H, '我靚唔靚？', 0.1 * H, '#ffe0e0', 0.02, 0.24);
  const p = t - N.TC;
  if (p >= 0 && p < 0.2) { const k = Math.min(1, p / 0.05), al = 1 - p / 0.2, r = 0.2 * th; for (const sg of [-1, 1]) N.crayon(ctx, [[T[0] - r, T[1] + sg * r * (1 - k)], [T[0] + r, T[1] - sg * r * (1 - k)]], 'rgba(255,255,255,.95)', 0.03 * th, 411 + sg, al); }
  if (p >= 0 && p < 0.35) for (let i = 0; i < 4; i++) N.crayon(ctx, [[T[0] + (i - 1.5) * 0.04 * th, T[1] + p * 0.6 * th + i * 0.02 * th], [T[0] + (i - 1.5) * 0.04 * th + 0.05 * th, T[1] + p * 0.6 * th + 0.06 * th]], '#2a2020', 0.008 * th, 415 + i, 1 - p / 0.35);
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.28 * th, 1 - p / 0.12, '#ffffff', 419, 8);
  N.pop(ctx, S, T[0], T[1] - 0.38 * th, '咔嚓！', 0.22 * th, '#ffffff', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 雪女：吐冰霜 ----------
// ① 輕輕吸一口氣（胸口抬起、頭往後）→ ② 往前「呼——」一道冰霧捲著雪花吹過去 → ③ 敵人身上結滿冰晶「凍！」→ ④ 冰霧散開
MOVES.n30_yukionna = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.17, { sy:1.05, head:-0.18, r:-4, hairR:0.2 }], [0.24, { sy:0.98, head:0.15, r:6, x:0.02 * H, hairR:-0.15 }, 'o'], [0.42, { head:0.12, r:5 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.35);
  const m = N.bm(S, f), mo = N.at(S, m, 0.42, 0.255), T = N.tgt(S, 0.65);
  const reach = N.seg(t, 0.2, N.TC), fade = 1 - N.seg(t, 0.4, 0.55);
  if (t > 0.2 && fade > 0) {
    const ex = N.lerp(mo[0], T[0], N.E.o(reach)), ey = N.lerp(mo[1], T[1], N.E.o(reach));
    for (let i = 0; i < 4; i++) { const pts = []; for (let j = 0; j <= 10; j++) { const q = j / 10, w = (0.02 + q * 0.12) * H; pts.push([N.lerp(mo[0], ex, q), N.lerp(mo[1], ey, q) + Math.sin(q * 8 + t * 30 + i * 1.6) * w * 0.5 + (i - 1.5) * w * 0.4]); }
      ctx.save(); ctx.globalAlpha *= fade * 0.8; N.crayon(ctx, pts, i % 2 ? 'rgba(220,240,255,.85)' : 'rgba(170,215,255,.8)', 0.025 * H, 421 + i); ctx.restore(); }
    for (let i = 0; i < 6; i++) { const q = N.cl(reach * 1.1 - i * 0.12), x = N.lerp(mo[0], ex, q), y = N.lerp(mo[1], ey, q) + Math.sin(i * 2 + t * 12) * 0.05 * H, r = 0.03 * H;
      ctx.save(); ctx.globalAlpha *= fade; ctx.translate(x, y); ctx.rotate(t * 5 + i); ctx.strokeStyle = '#eaf6ff'; ctx.lineWidth = r * 0.25; ctx.beginPath(); for (let k = 0; k < 3; k++) { const an = k * Math.PI / 3; ctx.moveTo(-Math.cos(an) * r, -Math.sin(an) * r); ctx.lineTo(Math.cos(an) * r, Math.sin(an) * r); } ctx.stroke(); ctx.restore(); }
  }
  const p = t - N.TC;
  if (p >= 0) { const al = 1 - N.seg(t, 0.48, 0.59), k = N.cl(p / 0.06); ctx.save(); ctx.globalAlpha *= al;
    for (let i = 0; i < 7; i++) { const x = T[0] + (N.rnd(i + 430) - 0.5) * 0.4 * th, y = T[1] + (N.rnd(i + 440) - 0.5) * 0.7 * th, h = (0.08 + N.rnd(i + 450) * 0.1) * th * k, an = (N.rnd(i + 460) - 0.5) * 1.2;
      ctx.save(); ctx.translate(x, y); ctx.rotate(an); ctx.fillStyle = 'rgba(200,235,255,.8)'; ctx.strokeStyle = 'rgba(80,140,200,.9)'; ctx.lineWidth = 0.01 * th; ctx.beginPath(); ctx.moveTo(0, -h); ctx.lineTo(h * 0.35, 0); ctx.lineTo(0, h * 0.4); ctx.lineTo(-h * 0.35, 0); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore(); }
    ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.33 * th, 1 - p / 0.13, '#e8f6ff', 471, 10);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '凍！', 0.24 * th, '#c8e8ff', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 唐傘妖：單腳跳過去舔一口 ----------
// ① 單腳蹲低、傘面一收 → ② 一跳跳到敵人面前，長舌從下巴往上一舔 → ③ 口水牽絲「舔～」→ ④ 舌頭捲回、單腳跳回去
MOVES.n30_kasaobake = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.35 * th - 0.35 * S.W);
  const SRC = [[0.52, 0.475], [0.60, 0.49], [0.68, 0.53], [0.73, 0.60], [0.735, 0.67], [0.73, 0.72]];
  const f = N.kf(t, [[0, {}], [0.12, { sy:0.85, sx:1.08, head:-0.06 }], [0.19, { x:D2 * 0.6, y:-0.3 * H, sy:1.08, sx:0.95, r:-8 }, 'o'], [0.24, { x:D2, y:0, sy:0.9, sx:1.06, r:6 }, 'i'], [0.36, { x:D2, sy:1, r:4 }], [0.46, { x:D2 * 0.5, y:-0.22 * H, sy:1.05 }, 'o'], [0.52, { x:D2 * 0.3, y:0, sy:0.92 }, 'i'], [0.56, { x:D2 * 0.1, y:-0.1 * H }, 'o'], [0.59, {}, 'i']]);
  const m = N.bm(S, f), root = N.at(S, m, 0.52, 0.475), T0 = N.tgt(S, 0.6), T1 = N.tgt(S, 0.95);
  const tipR = N.at(S, m, 0.73, 0.72);
  const P = N.kf(t, [[0, { x:tipR[0], y:tipR[1] }], [0.22, { x:tipR[0], y:tipR[1] }], [N.TC, { x:T0[0], y:T0[1] }, 'i'], [0.36, { x:T1[0] + 0.05 * th, y:T1[1] }], [0.44, { x:tipR[0], y:tipR[1] }]]);
  if (t > 0.44) { P.x = tipR[0]; P.y = tipR[1]; }
  const b = N.kf(t, [[0, { v:0 }], [0.22, { v:0 }], [0.25, { v:1 }], [0.40, { v:1 }], [0.44, { v:0 }]]).v;
  const tip = [P.x, P.y], ctrl = [(root[0] + tip[0]) / 2, Math.max(root[1], tip[1]) + 0.12 * H];
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H) * 0.6); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.ribbon(ctx, S, 'tongue', SRC, 0.045, N30M.line(S, m, SRC, root, ctrl, tip, b));
  const p = t - N.TC;
  N.drops(ctx, T0[0], T0[1], 0.4 * th, N.seg(t, N.TC, 0.5), 'rgba(220,240,255,.9)', 481, 7, 1.4);
  if (p > 0 && p < 0.3) { ctx.save(); ctx.globalAlpha *= 1 - p / 0.3; ctx.strokeStyle = 'rgba(230,245,255,.8)'; ctx.lineWidth = 0.012 * th; ctx.beginPath(); ctx.moveTo(T0[0], T0[1]); ctx.quadraticCurveTo(T0[0] + 0.02 * th, T0[1] + 0.25 * th, T0[0] + 0.05 * th, T0[1] + 0.12 * th); ctx.stroke(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T0[0], T0[1], 0.28 * th, 1 - p / 0.13, '#ffd0d0', 485, 8);
  N.pop(ctx, S, T1[0], T1[1] - 0.2 * th, '舔～', 0.24 * th, '#ffb0b8', N.TC + 0.02, 0.3);
  N.hit(S, T0[0], T0[1]); N30M.end(ctx);
};

// ---------- 無臉鬼：公事包一記上勾 ----------
// ① 公事包往後甩（像要趕車）→ ② 由下往上一記公事包上勾 → ③ 打中下巴，文件從包裡飛出來「加班！」→ ④ 公事包垂回去，拉拉領帶
MOVES.n30_nopperabo = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.24, 0.66];
  const f = N.kf(t, [[0, {}], [0.16, { r:-6, x:-0.03 * H, armF:0.35, head:-0.08 }], [N.TC, { r:9, x:0.1 * H, armF:-0.4, head:0.1, legF:0.25, legB:-0.15 }, 'i'], [0.36, { r:8, x:0.1 * H, armF:-0.45, legF:0.22, legB:-0.12 }], [0.59, {}]]);
  const m = N.bm(S, f), w0 = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.72), RT = -120, v = 0.16 * H, s = Math.sin(RT * N.D), c = Math.cos(RT * N.D);
  const G = [T[0] + v * s - 0.04 * th, T[1] - v * c];
  const W = N.kf(t, [[0, { x:w0[0], y:w0[1], r:0 }], [0.16, { x:w0[0] - 0.12 * H, y:w0[1] - 0.04 * H, r:75 }], [N.TC, { x:G[0], y:G[1], r:RT }, 'i'], [0.36, { x:G[0] + 0.02 * H, y:G[1] - 0.03 * H, r:RT - 15 }], [0.59, { x:w0[0], y:w0[1], r:0 }]]);
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  if (t > 0.17 && t < 0.3) N.speed(ctx, W.x, W.y - 0.1 * H, 0.6, -1, 0.3 * H, 0.15 * H, N.seg(t, 0.17, 0.21), 'rgba(230,230,240,.7)', 491, 4);
  N.pieceAt(ctx, S, 'case', W.x, W.y, W.r, PV[0], PV[1]);
  const p = t - N.TC;
  if (p >= 0 && p < 0.4) for (let i = 0; i < 6; i++) { const an = -Math.PI * (0.2 + 0.6 * N.rnd(i + 500)), sp = (0.5 + N.rnd(i + 510)) * 1.0 * th, x = T[0] + Math.cos(an) * sp * p, y = T[1] + Math.sin(an) * sp * p + 1.5 * th * p * p;
    ctx.save(); ctx.globalAlpha *= 1 - p / 0.4; ctx.translate(x, y); ctx.rotate(p * 12 + i); ctx.fillStyle = '#fbfbf6'; ctx.strokeStyle = '#4a4a5a'; ctx.lineWidth = 0.008 * th; ctx.fillRect(-0.05 * th, -0.065 * th, 0.1 * th, 0.13 * th); ctx.strokeRect(-0.05 * th, -0.065 * th, 0.1 * th, 0.13 * th);
    ctx.beginPath(); for (let k = 0; k < 3; k++) { ctx.moveTo(-0.03 * th, -0.03 * th + k * 0.03 * th); ctx.lineTo(0.03 * th, -0.03 * th + k * 0.03 * th); } ctx.stroke(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#f0f0ff', 521, 9);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '返工！', 0.22 * th, '#e8e8ff', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 提燈妖：噴火咬一口 ----------
// ① 燈籠吸氣鼓起來、裡面的火變旺 → ② 往前撲、大嘴一合「啊嗚！」→ ③ 咬中、噴出一團火 → ④ 燈籠縮回、打個嗝冒煙
MOVES.n30_chochin = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.3 * th - 0.4 * S.W);
  const f = N.kf(t, [[0, {}], [0.17, { sx:1.12, sy:1.1, r:-8, x:-0.03 * H, tongue:0.3, flame:0.3 }], [0.24, { sx:1.08, sy:1.15, r:10, x:D2 * 0.8, tongue:-0.3 }, 'o'], [N.TC, { sx:1.15, sy:0.78, r:12, x:D2, tongue:0.1 }, 'i'], [0.36, { sx:1.0, sy:1.05, r:8, x:D2 }], [0.59, {}]]);
  f.px = 0; f.py = -0.5 * H;
  N30M.begin(ctx, S, f.x);
  const glow = N.kf(t, [[0, { v:0 }], [0.17, { v:1 }], [0.36, { v:1 }], [0.59, { v:0 }]]).v;
  if (glow > 0) { const g = ctx.createRadialGradient(f.x || 0, -0.5 * H, 0, f.x || 0, -0.5 * H, 0.6 * H); g.addColorStop(0, `rgba(255,170,60,${0.4 * glow})`); g.addColorStop(1, 'rgba(255,170,60,0)'); ctx.fillStyle = g; ctx.fillRect((f.x || 0) - 0.6 * H, -1.1 * H, 1.2 * H, 1.2 * H); }
  N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.6), p = t - N.TC;
  if (p >= 0 && p < 0.35) for (let i = 0; i < 7; i++) { const k = p / 0.35, x = T[0] + (N.rnd(i + 530) - 0.5) * 0.4 * th, y = T[1] - k * 0.4 * th - N.rnd(i + 540) * 0.2 * th, r = (0.08 + N.rnd(i + 550) * 0.06) * th * (1 - k * 0.6);
    ctx.save(); ctx.globalAlpha *= 1 - k; ctx.translate(x, y); ctx.fillStyle = i % 2 ? '#ffb030' : '#ff6a20'; ctx.strokeStyle = '#7a2a08'; ctx.lineWidth = r * 0.1; ctx.beginPath(); ctx.moveTo(0, -r * 1.4); ctx.quadraticCurveTo(r, -r * 0.2, r * 0.6, r * 0.5); ctx.quadraticCurveTo(0, r, -r * 0.6, r * 0.5); ctx.quadraticCurveTo(-r, -r * 0.2, 0, -r * 1.4); ctx.fill(); ctx.stroke();
    ctx.fillStyle = '#ffe680'; ctx.beginPath(); ctx.ellipse(0, r * 0.2, r * 0.3, r * 0.4, 0, 0, 7); ctx.fill(); ctx.restore(); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.34 * th, 1 - p / 0.13, '#ffd27a', 561, 10);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '啊嗚！', 0.24 * th, '#ffb050', N.TC - 0.02, 0.3);
  N.puff(ctx, 0.2 * H, -0.7 * H, 0.08 * H, N.seg(t, 0.44, 0.59), 'rgba(120,110,110,.5)', 562, 4);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 餓者髑髏：巨手一拍 ----------
// ① 巨大骨手高高舉起、骨頭喀喀響 → ② 整副骨架往前壓，骨手往下一拍 → ③ 拍中、塵土飛揚 → ④ 慢慢撐回去
MOVES.n30_gashadokuro = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.4 * th - 0.45 * S.W);
  const f = N.kf(t, [[0, {}], [0.17, { r:-8, armF:-0.9, armB:-0.2, head:-0.15, x:-0.03 * H }], [N.TC, { r:10, armF:0.15, armB:0.1, head:0.15, x:D2, sy:0.95 }, 'i'], [0.36, { r:9, armF:0.2, head:0.12, x:D2, sy:0.96 }], [0.59, {}]]);
  f.px = 0.2 * H; f.py = 0;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.5), p = t - N.TC;
  if (t > 0.18 && t < 0.29) N.speed(ctx, T[0], T[1] - 0.3 * th, 0.5, 1, 0.5 * H, 0.3 * H, N.seg(t, 0.18, 0.22), 'rgba(245,240,225,.6)', 571, 5);
  for (let i = 0; i < 5; i++) N.puff(ctx, T[0] + (i - 2) * 0.18 * th, S.ty - 0.05 * th, 0.1 * th, N.seg(t, N.TC + i * 0.01, 0.52), 'rgba(200,190,170,.6)', 575 + i, 3);
  if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.45 * th, 1 - p / 0.14, '#fff6e0', 581, 12);
  N.pop(ctx, S, (f.x || 0) - 0.1 * H, -1.0 * H, '喀喀喀', 0.12 * H, '#f6efd8', 0.05, 0.2);
  N.pop(ctx, S, T[0], T[1] - 0.6 * th, '啪！', 0.28 * th, '#fff6e0', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Banshee：報喪尖叫 ----------
// ① 仰頭吸氣、頭髮飄起 → ② 「啊——！」一圈圈聲波轟過去、整個人在抖 → ③ 聲波打中 → ④ 頭髮落回、閉嘴
MOVES.n30_banshee = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const sh = t > 0.2 && t < 0.42 ? Math.sin(t * 120) * 0.008 * H : 0;
  const f = N.kf(t, [[0, {}], [0.17, { head:-0.3, body:-0.1, sy:1.06, hairL:0.35, hairR:0.35, armF:0.3, armB:-0.3, y:-0.03 * H }], [0.23, { head:0.2, body:0.1, r:6, hairL:-0.5, hairR:-0.5, armF:-0.4, armB:0.4 }, 'o'], [0.42, { head:0.15, r:5, hairL:-0.4, hairR:-0.4 }], [0.59, {}]]);
  f.x = (f.x || 0) + sh;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), mo = N.at(S, m, 0.5, 0.26), T = N.tgt(S, 0.7);
  for (let i = 0; i < 5; i++) { const q = N.seg(t, 0.2 + i * 0.03, N.TC + i * 0.03 + 0.02); if (q <= 0 || q >= 1) continue;
    const x = N.lerp(mo[0] + 0.05 * H, T[0] + 0.1 * th, q), r = (0.08 + q * 0.3) * H;
    ctx.save(); ctx.globalAlpha *= Math.sin(q * Math.PI); ctx.strokeStyle = i % 2 ? 'rgba(200,220,255,.95)' : 'rgba(255,255,255,.95)'; ctx.lineWidth = 0.045 * H; ctx.beginPath(); ctx.arc(x - r, N.lerp(mo[1], T[1], q), r, -0.6, 0.6); ctx.stroke(); ctx.restore(); }
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.35 * th, 1 - p / 0.13, '#dfe8ff', 591, 10);
  N.pop(ctx, S, mo[0] + 0.1 * H, mo[1] - 0.3 * H, '啊——！', 0.14 * H, '#dfe8ff', 0.2, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 般若：妒火暴衝 ----------
// ① 氣得發抖、角上冒紅火、頭頂冒煙 → ② 帶著殘影暴衝過去，雙爪往前抓 → ③ 交叉兩道紅爪痕「嫉妒！」→ ④ 飄回去，火慢慢熄
MOVES.n30_hannya = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.35 * th - 0.35 * H);
  const sh = t < 0.2 ? Math.sin(t * 110) * 0.01 * H * N.seg(t, 0, 0.1) : 0;
  const keys = [[0, {}], [0.18, { r:-6, armF:-0.9, armB:-0.7, head:-0.1, sy:1.04 }], [N.TC, { r:14, x:D2, armF:-0.5, armB:-0.4, head:0.15 }, 'i'], [0.36, { r:12, x:D2, armF:-0.3, armB:-0.2, head:0.1 }], [0.59, {}]];
  const f = N.kf(t, keys); f.x = (f.x || 0) + sh;
  N30M.begin(ctx, S, f.x);
  if (t > 0.2 && t < 0.36) for (let i = 2; i >= 1; i--) { const g = N.kf(t - i * 0.025, keys); ctx.save(); ctx.globalAlpha *= 0.22 * (3 - i) / 2; N.whole(ctx, S, g, null, 0.3); ctx.restore(); }
  const fire = N.kf(t, [[0, { v:0 }], [0.12, { v:1 }], [0.40, { v:1 }], [0.59, { v:0 }]]).v;
  const m = N.bm(S, f);
  N.whole(ctx, S, f, null, 0.3);
  if (fire > 0) for (const u of [0.18, 0.62]) { const hn = N.at(S, m, u, 0.04); for (let i = 0; i < 3; i++) { const k = ((t * 4 + i / 3) % 1), r = 0.05 * H * (1 - k) * fire; ctx.save(); ctx.globalAlpha *= (1 - k) * fire; ctx.fillStyle = i % 2 ? '#ff4020' : '#ff9a30'; ctx.beginPath(); ctx.ellipse(hn[0] + Math.sin(t * 20 + i) * 0.02 * H, hn[1] - k * 0.15 * H, r * 0.6, r, 0, 0, 7); ctx.fill(); ctx.restore(); } }
  N.puff(ctx, N.at(S, m, 0.42, 0.02)[0], N.at(S, m, 0.42, 0.02)[1], 0.06 * H, N.seg(t, 0.02, 0.3), 'rgba(240,240,240,.5)', 601, 3);
  const T = N.tgt(S, 0.62), p = t - N.TC;
  if (p >= 0 && p < 0.3) for (const sg of [-1, 1]) for (let i = 0; i < 3; i++) { const k = Math.min(1, p / 0.05), o = (i - 1) * 0.06 * th, A = [T[0] - 0.2 * th * sg + o, T[1] - 0.22 * th], B = [T[0] + 0.2 * th * sg + o, T[1] + 0.22 * th]; N.crayon(ctx, [A, [N.lerp(A[0], B[0], k), N.lerp(A[1], B[1], k)]], 'rgba(230,40,50,.9)', 0.025 * th, 611 + i + sg * 5, 1 - p / 0.3); }
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#ffb0b0', 621, 9);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '妒忌！', 0.22 * th, '#ff6060', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Aswang：長舌吸血 ----------
// ① 翅膀一張、舌頭縮起 → ② 舌頭像吸管一樣直射出去 → ③ 插住、一口一口吸（舌頭上一粒粒鼓起往回送）「啾啾～」→ ④ 舌頭收回、舔舔嘴
MOVES.n30_aswang = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th;
  const SRC = [[0.235, 0.335], [0.20, 0.39], [0.15, 0.45], [0.10, 0.52], [0.095, 0.58], [0.10, 0.62]];
  const flap = Math.sin(t * 30) * 0.25;
  const f = N.kf(t, [[0, {}], [0.16, { r:-5, head:-0.12, cape:-0.5 }], [N.TC, { r:8, head:0.12, cape:0.3, x:0.03 * H }, 'i'], [0.42, { r:6, head:0.1, x:0.03 * H }], [0.59, {}]]);
  f.cape = (f.cape || 0) + (t > 0.1 && t < 0.5 ? flap : 0);
  const m = N.bm(S, f), root = N.at(S, m, 0.235, 0.335), T = N.tgt(S, 0.7), tipR = N.at(S, m, 0.10, 0.62);
  const P = N.kf(t, [[0, { x:tipR[0], y:tipR[1] }], [0.16, { x:root[0] + 0.08 * H, y:root[1] + 0.12 * H }], [N.TC, { x:T[0], y:T[1] }, 'i'], [0.42, { x:T[0], y:T[1] }], [0.55, { x:tipR[0], y:tipR[1] }]]);
  if (t > 0.55) { P.x = tipR[0]; P.y = tipR[1]; }
  const b = N.kf(t, [[0, { v:0 }], [0.08, { v:1 }], [0.5, { v:1 }], [0.56, { v:0 }]]).v;
  const tip = [P.x, P.y], ctrl = [(root[0] + tip[0]) / 2, (root[1] + tip[1]) / 2 - 0.06 * H];
  const suck = t > N.TC + 0.01 && t < 0.44 ? ((t - N.TC) * 6) % 1 : -1;
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.ribbon(ctx, S, 'tongue', SRC, 0.04, N30M.line(S, m, SRC, root, ctrl, tip, b), (i, n) => 1 + (suck >= 0 ? 0.9 * Math.exp(-Math.pow(i / n - (1 - suck), 2) / 0.006) : 0));
  const p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.28 * th, 1 - p / 0.13, '#ffc8c8', 631, 9);
  N.pop(ctx, S, T[0], T[1] - 0.35 * th, '啾啾～', 0.2 * th, '#ff9aa8', N.TC + 0.02, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- Tikbalang：轉身馬後踢 ----------
// ① 叼著雪茄吐一口煙，一扭身背對敵人 → ② 低頭、兩條後腿往後一蹬 → ③ 馬蹄踢中「踢！」→ ④ 轉回來，甩甩鬃毛
MOVES.n30_tikbalang = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.25 * th - 0.4 * H);
  const turn = t < 0.13 ? Math.cos(N.seg(t, 0.06, 0.12) * Math.PI) : t > 0.44 ? -Math.cos(N.seg(t, 0.49, 0.55) * Math.PI) : -1;
  const f = N.kf(t, [[0, {}], [0.13, { x:D2 * 0.5 }], [0.2, { x:D2 * 0.8, r:-6, legF:-0.2, legB:-0.2, head:0.1 }], [N.TC, { x:D2, r:-22, legF:0.9, legB:0.75, head:0.25, body:0.15, cape:0.4 }, 'i'], [0.36, { x:D2, r:-20, legF:0.85, legB:0.7, head:0.2, body:0.12 }], [0.44, { x:D2 * 0.6 }], [0.59, {}]]);
  f.sx = Math.abs(turn) < 0.15 ? 0.15 * Math.sign(turn || 1) : turn; f.px = 0; f.py = -0.5 * H;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m0 = N.bm(S, {}), cg = N.at(S, m0, 0.06, 0.29);
  N.puff(ctx, cg[0], cg[1] - 0.05 * H, 0.06 * H, N.seg(t, 0.0, 0.2), 'rgba(200,200,210,.55)', 641, 4);
  const T = N.tgt(S, 0.45), p = t - N.TC;
  if (t > 0.2 && t < 0.3) N.speed(ctx, T[0], T[1], 1, -0.2, 0.3 * H, 0.2 * H, N.seg(t, 0.2, 0.24), 'rgba(255,240,220,.7)', 643, 4);
  if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.36 * th, 1 - p / 0.14, '#ffe0b0', 645, 11);
  if (p >= 0 && p < 0.3) N.stars(ctx, T[0], T[1] - 0.45 * th, 0.15 * th, t, 1 - p / 0.3);
  N.pop(ctx, S, T[0], T[1] - 0.55 * th, '踢！', 0.26 * th, '#ffd090', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ======================= 第二批：各種死法的意外鬼 =======================
// 小特效：閃電（鋸齒線）
N30M.bolt = function (ctx, a, b, w, seed, col, al) {
  const N = N30K, pts = [a], n = 7; for (let i = 1; i < n; i++) { const k = i / n; pts.push([N.lerp(a[0], b[0], k) + (N.rnd(seed + i) - 0.5) * w * 6, N.lerp(a[1], b[1], k) + (N.rnd(seed + i + 9) - 0.5) * w * 2]); } pts.push(b);
  ctx.save(); ctx.globalAlpha *= al == null ? 1 : al; N.crayon(ctx, pts, 'rgba(255,255,255,.95)', w * 1.6, seed); N.crayon(ctx, pts, col || '#ffe14a', w, seed + 3); ctx.restore();
};
N30M.cloud = function (ctx, x, y, r, al, col) { if (al <= 0) return; ctx.save(); ctx.globalAlpha *= al; const C = [[-0.6, 0.1, 0.45], [-0.2, -0.15, 0.55], [0.3, -0.1, 0.5], [0.7, 0.1, 0.4], [0.1, 0.2, 0.5]]; const path = (k) => { ctx.beginPath(); for (const [dx, dy, rr] of C) { ctx.moveTo(x + dx * r + rr * r + k, y + dy * r); ctx.arc(x + dx * r, y + dy * r, rr * r + k, 0, 7); } }; path(r * 0.05); ctx.fillStyle = 'rgba(20,16,30,.85)'; ctx.fill(); path(0); ctx.fillStyle = col || '#4a4458'; ctx.fill(); ctx.restore(); };

// ---------- 車禍鬼：催油門撞過去 ----------
// ① 伏低像握著車把、引擎抖、屁股冒黑煙「叭叭！」→ ② 「咻」衝出去，地上拖出兩道輪胎印 → ③ 「碰！」撞中、零件飛 → ④ 晃著退回來
MOVES.n30_chehuo = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.35 * th - 0.3 * H), vib = t < 0.2 ? Math.sin(t * 140) * 0.006 * H : 0;
  const f = N.kf(t, [[0, {}], [0.16, { r:8, sy:0.95, armF:-0.5, armB:-0.4, head:0.08, x:-0.03 * H }], [N.TC, { r:14, x:D2, armF:-0.6, armB:-0.5, head:0.1, legF:-0.2, legB:0.2 }, 'i'], [0.33, { r:-6, x:D2 - 0.03 * H, sy:1.03 }], [0.45, { r:5, x:D2 * 0.5 }], [0.59, {}]]);
  f.x = (f.x || 0) + vib; f.px = 0; f.py = 0;
  N30M.begin(ctx, S, f.x);
  if (t > 0.2) { const al = 1 - N.seg(t, 0.45, 0.59), x1 = Math.min(f.x || 0, D2); for (const dy of [-0.012, 0.012]) { ctx.save(); ctx.globalAlpha *= al * 0.8; ctx.strokeStyle = 'rgba(30,24,20,.85)'; ctx.lineWidth = 0.02 * H; ctx.setLineDash([0.03 * H, 0.02 * H]); ctx.beginPath(); ctx.moveTo(-0.1 * H, dy * H); ctx.lineTo(x1 + 0.1 * H, dy * H); ctx.stroke(); ctx.restore(); } }
  N.whole(ctx, S, f, null, 0.3);
  for (let i = 0; i < 3; i++) N.puff(ctx, (f.x || 0) - 0.35 * H - i * 0.05 * H, -0.2 * H, 0.06 * H, N.cl((t * 5 + i / 3) % 1), 'rgba(70,64,70,.55)', 700 + i, 3);
  if (t > 0.18 && t < N.TC) N.speed(ctx, (f.x || 0) - 0.3 * H, -0.5 * H, 1, 0, 0.4 * H, 0.5 * H, 1, 'rgba(240,240,255,.7)', 703, 5);
  N.pop(ctx, S, -0.1 * H, -1.05 * H, '叭叭！', 0.12 * H, '#ffe066', 0.02, 0.2);
  const T = N.tgt(S, 0.55), p = t - N.TC;
  if (p >= 0 && p < 0.35) for (let i = 0; i < 6; i++) { const an = -Math.PI * (0.1 + 0.8 * N.rnd(i + 710)), sp = (0.5 + N.rnd(i + 720)) * 1.2 * th, x = T[0] + Math.cos(an) * sp * p, y = T[1] + Math.sin(an) * sp * p + 3 * th * p * p; ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.translate(x, y); ctx.rotate(p * 15 + i); ctx.fillStyle = i % 2 ? '#9aa0ae' : '#d0d4dc'; ctx.strokeStyle = '#3a3a44'; ctx.lineWidth = 0.008 * th; ctx.beginPath(); ctx.arc(0, 0, 0.025 * th, 0, 7); ctx.fill(); ctx.stroke(); ctx.fillStyle = '#3a3a44'; ctx.fillRect(-0.008 * th, -0.008 * th, 0.016 * th, 0.016 * th); ctx.restore(); }
  if (p >= 0 && p < 0.14) N.burst(ctx, T[0], T[1], 0.4 * th, 1 - p / 0.14, '#fff0b0', 731, 12);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '碰！', 0.28 * th, '#ffe066', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 電死鬼：插頭放電 ----------
// ① 插頭往前一舉，爆炸頭豎得更高、插頭冒火花 → ② 一道閃電從插頭劈到敵人身上 → ③ 敵人全身電到發光「滋滋滋！」→ ④ 自己也被反電一下，頭髮冒煙
MOVES.n30_diansi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, jit = t > 0.22 && t < 0.4 ? Math.sin(t * 160) * 0.01 * H : 0;
  const f = N.kf(t, [[0, {}], [0.16, { armF:-0.55, head:-0.1, hairL:0.25, hairR:0.25, r:-3 }], [N.TC, { armF:-0.75, head:0.08, hairL:0.35, hairR:0.35, r:5, x:0.02 * H }, 'o'], [0.40, { armF:-0.6, hairL:0.3, hairR:0.3 }], [0.5, { head:0.15, sy:0.96 }], [0.59, {}]]);
  f.x = (f.x || 0) + jit;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), plug = N.at(S, m, 0.14, 0.32), T = N.tgt(S, 0.55);
  if (t < 0.22) for (let i = 0; i < 4; i++) { const an = N.rnd(Math.floor(t * 40) + i) * 6.28; N.crayon(ctx, [plug, [plug[0] + Math.cos(an) * 0.08 * H, plug[1] + Math.sin(an) * 0.08 * H]], '#ffe14a', 0.012 * H, 740 + i, N.seg(t, 0.03, 0.15)); }
  if (t > 0.2 && t < 0.42) { const k = N.seg(t, 0.2, N.TC), end = [N.lerp(plug[0], T[0], k), N.lerp(plug[1], T[1], k)], sd = Math.floor(t * 50); N30M.bolt(ctx, plug, end, 0.02 * H, 750 + sd, '#ffe14a', 1 - N.seg(t, 0.36, 0.42)); N30M.bolt(ctx, plug, end, 0.012 * H, 760 + sd, '#9fe8ff', 0.8 * (1 - N.seg(t, 0.36, 0.42))); }
  const p = t - N.TC;
  if (p >= 0 && p < 0.22) { const al = 1 - p / 0.22; for (let i = 0; i < 6; i++) { const an = i / 6 * 6.28 + p * 20, r1 = 0.3 * th, r2 = 0.42 * th; N30M.bolt(ctx, [T[0] + Math.cos(an) * r1 * 0.6, T[1] + Math.sin(an) * r1], [T[0] + Math.cos(an + 0.4) * r2 * 0.6, T[1] + Math.sin(an + 0.4) * r2], 0.012 * th, 770 + i + Math.floor(p * 40), '#ffe14a', al); } }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.36 * th, 1 - p / 0.12, '#fffbd0', 781, 10);
  N.pop(ctx, S, T[0], T[1] - 0.55 * th, '滋滋滋！', 0.2 * th, '#ffe14a', N.TC, 0.32);
  N.puff(ctx, N.at(S, m, 0.55, 0.05)[0], N.at(S, m, 0.55, 0.05)[1], 0.07 * H, N.seg(t, 0.42, 0.59), 'rgba(110,100,100,.55)', 782, 4);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 凍死鬼：一個噴嚏射出冰柱 ----------
// ① 「哈……哈……」頭往後仰吸氣 → ② 「哈啾！」一根冰柱從鼻子射出去 → ③ 敵人被凍成一塊冰 → ④ 冰塊裂開碎掉，自己吸吸鼻涕
MOVES.n30_dongsi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.08, { head:-0.12, r:-2 }], [0.12, { head:-0.06 }], [0.19, { head:-0.25, r:-6, sy:1.04, body:-0.08 }], [0.23, { head:0.25, r:9, sy:0.96, body:0.12, x:0.03 * H }, 'o'], [0.40, { head:0.15, r:6, x:0.03 * H }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), nose = N.at(S, m, 0.40, 0.3), T = N.tgt(S, 0.75);
  N.pop(ctx, S, nose[0], nose[1] - 0.3 * H, '哈……', 0.1 * H, '#cfeaff', 0.02, 0.18);
  N.pop(ctx, S, nose[0] + 0.1 * H, nose[1] - 0.3 * H, '哈啾！', 0.14 * H, '#ffffff', 0.2, 0.2);
  if (t > 0.21 && t < N.TC + 0.01) { const k = N.seg(t, 0.21, N.TC), x = N.lerp(nose[0], T[0], k), y = N.lerp(nose[1], T[1], k), L = 0.16 * H; ctx.save(); ctx.translate(x, y); ctx.rotate(Math.atan2(T[1] - nose[1], T[0] - nose[0])); ctx.fillStyle = 'rgba(210,240,255,.95)'; ctx.strokeStyle = '#4a8ac8'; ctx.lineWidth = 0.008 * H; ctx.beginPath(); ctx.moveTo(L * 0.5, 0); ctx.lineTo(-L * 0.5, -0.03 * H); ctx.lineTo(-L * 0.45, 0.03 * H); ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore(); N.speed(ctx, x, y, 1, 0, 0.25 * H, 0.06 * H, 0.8, 'rgba(220,240,255,.8)', 790, 3); }
  const p = t - N.TC;
  if (p >= 0 && p < 0.3) { const C = [S.tx + S.back, S.ty], w = 0.62 * th, h = 1.05 * th, crack = N.seg(p, 0.15, 0.3), al = 1 - crack; ctx.save(); ctx.globalAlpha *= al * 0.75; ctx.fillStyle = 'rgba(190,230,255,.55)'; ctx.strokeStyle = '#6aaee0'; ctx.lineWidth = 0.02 * th; ctx.beginPath(); ctx.roundRect(C[0] - w / 2, C[1] - h, w, h, 0.05 * th); ctx.fill(); ctx.stroke(); ctx.strokeStyle = 'rgba(255,255,255,.9)'; ctx.beginPath(); ctx.moveTo(C[0] - w * 0.35, C[1] - h * 0.85); ctx.lineTo(C[0] - w * 0.2, C[1] - h * 0.55); ctx.stroke();
    if (crack > 0) N.crayon(ctx, [[C[0], C[1] - h], [C[0] - 0.05 * th, C[1] - h * 0.6], [C[0] + 0.06 * th, C[1] - h * 0.3], [C[0], C[1]]], '#ffffff', 0.015 * th, 795); ctx.restore(); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#e8f6ff', 797, 9);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '凍親！', 0.2 * th, '#c8e8ff', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 椰子砸死鬼：「小心頭上！」掉椰子 ----------
// ① 抬頭指天「小心頭上！」→ ② 一顆椰子（跟他手上那顆同一個樣子）從天上掉下來 → ③ 「咚！」砸中頭、冒星星 → ④ 椰子彈開滾走，他一臉同情「好痛…」
MOVES.n30_yezi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, CC = [0.20, 0.585];
  const f = N.kf(t, [[0, {}], [0.12, { head:-0.25, armB:-0.9, r:-4 }], [0.24, { head:-0.15, armB:-0.8 }], [N.TC, { head:0.1, armB:-0.2, sy:0.95 }, 'o'], [0.40, { head:0.15, sy:0.96 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.95), top = [T[0], T[1] - 1.8 * H];
  if (t > 0.08 && t < 0.5) {
    let x, y, r;
    if (t < N.TC) { const k = N.E.i(N.seg(t, 0.1, N.TC)); x = top[0]; y = N.lerp(top[1], T[1] - 0.1 * th, k); r = k * 90; }
    else { const q = N.seg(t, N.TC, 0.5); x = T[0] + q * 0.6 * th; y = T[1] - 0.1 * th - 0.5 * th * Math.sin(q * Math.PI) + q * q * 0.9 * th; r = 90 + q * 400; }
    N.pieceAt(ctx, S, 'coconut', x, y, r, CC[0], CC[1], 1, 1, 1 - N.seg(t, 0.45, 0.5));
    if (t < N.TC) N.speed(ctx, x, y - 0.1 * H, 0, -1, 0.25 * H, 0.12 * H, N.seg(t, 0.18, 0.24), 'rgba(255,255,255,.7)', 800, 3);
  }
  const m = N.bm(S, f), hd = N.at(S, m, 0.42, 0.1);
  N.pop(ctx, S, hd[0], hd[1] - 0.15 * H, '小心頭頂！', 0.1 * H, '#ffe066', 0.06, 0.2);
  const p = t - N.TC;
  if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.32 * th, 1 - p / 0.13, '#fff0c0', 805, 10);
  if (p >= 0 && p < 0.3) N.stars(ctx, T[0], T[1] - 0.05 * th, 0.2 * th, t, 1 - p / 0.3);
  N.pop(ctx, S, T[0], T[1] - 0.25 * th, '咚！', 0.26 * th, '#ffe066', N.TC, 0.26);
  N.pop(ctx, S, hd[0], hd[1] - 0.15 * H, '好痛呀……', 0.1 * H, '#ffd0d0', 0.42, 0.17);
  N.hit(S, T[0], T[1] + 0.1 * th); N30M.end(ctx);
};

// ---------- 榴槤砸死鬼：從背後再掏一顆榴槤丟過去 ----------
// ① 手伸到背後摸出另一顆榴槤（跟手上那顆同一個）→ ② 推鉛球一樣甩出去 → ③ 刺中「刺！」臭味飄 → ④ 榴槤掉地上滾開
MOVES.n30_liulian = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, DC = [0.16, 0.56];
  const f = N.kf(t, [[0, {}], [0.15, { armB:0.9, r:-8, body:-0.1, head:-0.08 }], [0.21, { armB:-1.0, r:10, body:0.15, x:0.04 * H }, 'o'], [0.38, { armB:-0.6, r:6, x:0.03 * H }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x);
  const m = N.bm(S, f), back = N.at(S, m, 0.82, 0.5), T = N.tgt(S, 0.6);
  let x, y, r, s = 1, al = 1;
  if (t < 0.17) { const k = N.E.back(N.seg(t, 0.04, 0.15)); x = back[0]; y = back[1] - 0.05 * H; r = -20; s = 0.85 * k; }
  else if (t < N.TC) { const q = N.seg(t, 0.17, N.TC), st = N.at(S, m, 0.6, 0.15); x = N.lerp(st[0], T[0], q); y = N.lerp(st[1], T[1], q) - 0.3 * H * 4 * q * (1 - q); r = q * 400; s = 0.85; }
  else { const q = N.seg(t, N.TC, 0.55); x = T[0] + 0.1 * th - q * 0.2 * th; y = N.lerp(T[1], S.ty - 0.15 * th, N.E.i(Math.min(1, q * 2))); r = 400 + q * 200; s = 0.85; al = 1 - N.seg(t, 0.5, 0.56); }
  const behind = t < 0.17;
  if (behind && s > 0.02) N.pieceAt(ctx, S, 'durian', x, y, r, DC[0], DC[1], s, s, al);
  N.whole(ctx, S, f, null, 0.3);
  if (!behind && al > 0) N.pieceAt(ctx, S, 'durian', x, y, r, DC[0], DC[1], s, s, al);
  const p = t - N.TC;
  if (p >= 0 && p < 0.25) for (let i = 0; i < 10; i++) { const an = i / 10 * 6.28, r0 = 0.15 * th, r1 = (0.25 + p) * th; N.crayon(ctx, [[T[0] + Math.cos(an) * r0, T[1] + Math.sin(an) * r0], [T[0] + Math.cos(an) * r1, T[1] + Math.sin(an) * r1]], '#c8d060', 0.02 * th, 810 + i, 1 - p / 0.25); }
  if (p >= 0) for (let i = 0; i < 3; i++) { const q = N.seg(t, N.TC + i * 0.04, 0.59), pts = []; for (let j = 0; j <= 6; j++) pts.push([T[0] + (i - 1) * 0.12 * th + Math.sin(j + t * 12 + i) * 0.03 * th, T[1] - j * 0.06 * th - q * 0.2 * th]); N.crayon(ctx, pts, 'rgba(150,190,80,.75)', 0.015 * th, 820 + i, Math.sin(q * Math.PI)); }
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '拮！', 0.26 * th, '#d8e070', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 噎死鬼：一聲咳，把湯圓咳出去當子彈 ----------
// ① 抓著喉嚨、臉憋紅往後仰 → ② 「咳！」整個人往前一彎，喉嚨那顆湯圓噴出去 → ③ 正中額頭「噗！」→ ④ 湯圓彈開，他鬆一口氣，又夾起一顆
MOVES.n30_yesi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.17, { r:-9, head:-0.25, body:-0.1, armF:-0.6, sy:1.04 }], [0.22, { r:12, head:0.3, body:0.18, armF:0.2, sy:0.95, x:0.03 * H }, 'o'], [0.40, { r:8, head:0.2, body:0.1 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), mo = N.at(S, m, 0.48, 0.24), T = N.tgt(S, 0.86), shake = t < 0.2 ? Math.sin(t * 90) * 0.01 * H : 0;
  const ball = (x, y, r) => { ctx.save(); ctx.translate(x, y); ctx.fillStyle = '#fbf8f0'; ctx.strokeStyle = '#4a3a3a'; ctx.lineWidth = r * 0.15; ctx.beginPath(); ctx.arc(0, 0, r, 0, 7); ctx.fill(); ctx.stroke(); ctx.fillStyle = 'rgba(255,255,255,.9)'; ctx.beginPath(); ctx.arc(-r * 0.35, -r * 0.35, r * 0.25, 0, 7); ctx.fill(); ctx.restore(); };
  const R = 0.045 * H;
  if (t > 0.2 && t < N.TC) { const k = N.seg(t, 0.2, N.TC); ball(N.lerp(mo[0], T[0], k), N.lerp(mo[1], T[1], k), R); N.speed(ctx, N.lerp(mo[0], T[0], k), N.lerp(mo[1], T[1], k), T[0] - mo[0], T[1] - mo[1], 0.2 * H, 0.06 * H, 0.9, 'rgba(255,255,255,.8)', 830, 3); }
  else if (t >= N.TC && t < 0.5) { const q = N.seg(t, N.TC, 0.5); ball(T[0] - q * 0.4 * th, T[1] - 0.4 * th * Math.sin(q * Math.PI) + q * q * 0.9 * th, R); }
  N.pop(ctx, S, mo[0] + shake, mo[1] - 0.25 * H, '咳！', 0.14 * H, '#ffffff', 0.19, 0.18);
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#ffffff', 835, 9);
  N.pop(ctx, S, T[0], T[1] - 0.3 * th, '噗！', 0.24 * th, '#ffffff', N.TC, 0.28);
  N.pop(ctx, S, mo[0], mo[1] - 0.25 * H, '呼～', 0.11 * H, '#d8f0ff', 0.44, 0.15);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 笑死鬼：會傳染的笑 ----------
// ① 憋笑憋到抖 → ② 爆笑彎腰，一串「哈哈哈」飛過去 → ③ 敵人被傳染，笑到眼淚噴、頭暈 → ④ 自己笑到喘不過氣
MOVES.n30_xiaosi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, lb = Math.abs(Math.sin(t * 40));
  const f = N.kf(t, [[0, {}], [0.16, { r:-6, head:-0.15, sy:1.03 }], [0.24, { r:14, head:0.25, body:0.2, x:0.02 * H }, 'o'], [0.45, { r:10, head:0.2, body:0.15 }], [0.59, {}]]);
  f.y = (f.y || 0) - lb * 0.015 * H; f.head = (f.head || 0) + lb * 0.06;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), mo = N.at(S, m, 0.3, 0.3), T = N.tgt(S, 0.8);
  for (let i = 0; i < 6; i++) { const q = N.seg(t, 0.18 + i * 0.012, N.TC + i * 0.012); if (q <= 0 || q >= 1) continue; N.txt(ctx, S, N.lerp(mo[0], T[0], q), N.lerp(mo[1], T[1], q) + Math.sin(q * 12 + i) * 0.06 * H, 0.1 * H * (0.8 + 0.4 * q), '哈', i % 2 ? '#ffe066' : '#ffb347', 1 - q * 0.3, (N.rnd(i) - 0.5) * 0.6); }
  if (t < 0.2) N.pop(ctx, S, mo[0], mo[1] - 0.25 * H, '噗…', 0.1 * H, '#ffe066', 0.03, 0.16);
  const p = t - N.TC;
  if (p >= 0 && p < 0.3) { const k = p / 0.3; N.txt(ctx, S, T[0], T[1] - 0.35 * th, 0.18 * th, '哈…哈哈！', '#ffe066', 1 - k); N.drops(ctx, T[0], T[1], 0.3 * th, (p * 3) % 1, 'rgba(150,210,255,.9)', 840 + Math.floor(p * 3), 4); ctx.save(); ctx.globalAlpha *= 1 - k; ctx.strokeStyle = '#ffe066'; ctx.lineWidth = 0.015 * th; ctx.beginPath(); for (let j = 0; j < 40; j++) { const an = j * 0.4 + t * 10, r = j * 0.004 * th; ctx.lineTo(T[0] + Math.cos(an) * r, T[1] - 0.1 * th + Math.sin(an) * r * 0.5); } ctx.stroke(); ctx.restore(); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.28 * th, 1 - p / 0.12, '#fff3b0', 845, 9);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 嚇死鬼：突然跳出來嚇你 ----------
// ① 縮得小小的、安靜 → ② 「哇！！」突然暴漲撲上前、雙手張開、頭髮炸開 → ③ 敵人嚇到彈起「！」→ ④ 縮回去，自己也被自己嚇到發抖
MOVES.n30_xiasi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.4 * th - 0.3 * H);
  const f = N.kf(t, [[0, {}], [0.18, { sy:0.82, sx:1.04, head:0.12, armF:0.3, armB:-0.3, hairL:0.2, hairR:0.2 }], [0.235, { sy:1.22, sx:1.12, y:-0.06 * H, x:D2, armF:-0.7, armB:0.7, head:-0.1, hairL:-0.45, hairR:-0.45, r:6 }, 'back'], [0.38, { sy:1.15, sx:1.1, y:-0.03 * H, x:D2, armF:-0.6, armB:0.6, r:5 }], [0.59, {}]]);
  N30M.begin(ctx, S, f.x);
  const sc = N.seg(t, 0.2, 0.235) * (1 - N.seg(t, 0.38, 0.5));
  if (sc > 0) { const C = [(f.x || 0), -0.6 * H], r = 0.65 * H * (0.6 + 0.4 * sc); ctx.save(); ctx.globalAlpha *= sc * 0.9; ctx.fillStyle = '#ffe14a'; ctx.strokeStyle = '#5a3a10'; ctx.lineWidth = 0.012 * H; ctx.beginPath(); for (let i = 0; i < 24; i++) { const an = i / 24 * 6.283, rr = i % 2 ? r * 0.72 : r; ctx.lineTo(C[0] + Math.cos(an) * rr, C[1] + Math.sin(an) * rr * 0.85); } ctx.closePath(); ctx.fill(); ctx.stroke(); ctx.restore(); }
  N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.7), p = t - N.TC;
  N.pop(ctx, S, (f.x || 0), -1.35 * H, '哇！！', 0.2 * H, '#ff5050', 0.21, 0.3);
  if (p >= 0 && p < 0.3) { N.txt(ctx, S, T[0] + 0.15 * th, T[1] - 0.45 * th - p * 0.3 * th, 0.3 * th, '！', '#ffffff', 1 - p / 0.3); N.drops(ctx, T[0], T[1] - 0.2 * th, 0.3 * th, p / 0.3, 'rgba(150,210,255,.9)', 850, 5); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#ffffff', 851, 9);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 雷劈鬼：舉傘招雷 ----------
// ① 把破傘高高舉起，敵人頭上聚起一朵烏雲 → ② 「轟隆」一道雷劈下去 → ③ 敵人被劈到冒煙 → ④ 剩下一小道雷順著傘也劈了自己一下「又來！」
MOVES.n30_leipi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.17, { armB:-0.6, umb:-0.2, head:-0.2, r:-4, y:-0.03 * H }], [N.TC, { armB:-0.5, umb:-0.1, head:-0.1 }], [0.44, { armB:-0.5 }], [0.48, { armB:0.1, sy:0.92, head:0.2 }, 'o'], [0.59, {}]]);
  N30M.begin(ctx, S, f.x);
  const T = N.tgt(S, 0.5), cl = [S.tx + S.back, S.ty - 1.45 * th], ca = N.seg(t, 0.05, 0.2) * (1 - N.seg(t, 0.45, 0.59));
  N30M.cloud(ctx, cl[0], cl[1], 0.3 * th * (0.6 + 0.4 * ca), ca);
  N.whole(ctx, S, f, null, 0.3);
  const p = t - N.TC;
  if (p >= -0.02 && p < 0.16) { const al = 1 - N.seg(p, 0.06, 0.16); N30M.bolt(ctx, [cl[0], cl[1] + 0.15 * th], [T[0], S.ty - 0.4 * th], 0.04 * th, 860 + Math.floor(t * 40), '#ffe14a', al); ctx.save(); ctx.globalAlpha *= al * 0.5; const g = ctx.createRadialGradient(T[0], T[1], 0, T[0], T[1], 1.2 * th); g.addColorStop(0, 'rgba(255,251,220,.9)'); g.addColorStop(1, 'rgba(255,251,220,0)'); ctx.fillStyle = g; ctx.fillRect(T[0] - 1.2 * th, T[1] - 1.2 * th, 2.4 * th, 2.4 * th); ctx.restore(); }
  for (let i = 0; i < 3; i++) N.puff(ctx, T[0] + (i - 1) * 0.12 * th, T[1] - 0.4 * th, 0.1 * th, N.seg(t, N.TC + i * 0.03, 0.59), 'rgba(80,70,70,.55)', 865 + i, 3);
  const m = N.bm(S, f), um = N.at(S, m, 0.75, 0.2);
  if (t > 0.43 && t < 0.5) N30M.bolt(ctx, [um[0], um[1] - 0.6 * H], um, 0.02 * H, 870, '#ffe14a', 1 - N.seg(t, 0.47, 0.5));
  N.puff(ctx, N.at(S, m, 0.35, 0.05)[0], N.at(S, m, 0.35, 0.05)[1], 0.07 * H, N.seg(t, 0.46, 0.59), 'rgba(80,70,70,.6)', 872, 4);
  N.pop(ctx, S, T[0], T[1] - 0.6 * th, '轟隆！', 0.24 * th, '#ffe14a', N.TC, 0.28);
  N.pop(ctx, S, -0.1 * H, -1.1 * H, '又嚟！', 0.12 * H, '#ffd0a0', 0.46, 0.13);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 自拍跌死鬼：閃光燈，然後踩到香蕉皮滑過去 ----------
// ① 自拍棒舉高、比 YA「茄子～」→ ② 「咔嚓」閃光燈閃瞎敵人 → ③ 腳下香蕉皮一滑，整個人滑過去一腳踢中 → ④ 爬起來、檢查照片
MOVES.n30_zipai = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.25 * th - 0.25 * H);
  const f = N.kf(t, [[0, {}], [0.14, { armB:-0.25, stick:-0.1, head:-0.08, r:-3 }], [0.19, { armB:-0.25, r:-3 }], [N.TC, { r:-55, px:0, py:0, x:D2, y:-0.05 * H, armB:0.3, armF:-0.6, stick:0.3 }, 'i'], [0.36, { r:-60, px:0, py:0, x:D2, y:-0.03 * H, armB:0.3, armF:-0.6 }], [0.48, { r:-15, px:0, py:0, x:D2 * 0.4 }], [0.59, {}]]);
  f.px = 0; f.py = 0;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m0 = N.bm(S, N.kf(Math.min(t, 0.19), [[0, {}], [0.14, { armB:-0.25, r:-3 }]])), ph = N.at(S, m0, 0.80, 0.14), T = N.tgt(S, 0.5);
  N.pop(ctx, S, -0.05 * H, -1.1 * H, '茄子～', 0.12 * H, '#ffe0f0', 0.02, 0.17);
  const fl = N.seg(t, 0.18, 0.2) * (1 - N.seg(t, 0.2, 0.3));
  if (fl > 0) { const g = ctx.createRadialGradient(ph[0], ph[1], 0, ph[0], ph[1], 0.9 * H); g.addColorStop(0, `rgba(255,255,255,${0.95 * fl})`); g.addColorStop(1, 'rgba(255,255,255,0)'); ctx.fillStyle = g; ctx.fillRect(ph[0] - H, ph[1] - H, 2 * H, 2 * H); N.burst(ctx, ph[0], ph[1], 0.2 * H, fl, '#ffffff', 880, 10); }
  N.pop(ctx, S, ph[0], ph[1] - 0.12 * H, '咔嚓', 0.1 * H, '#ffffff', 0.18, 0.12);
  if (t > 0.2 && t < N.TC) N.speed(ctx, (f.x || 0), -0.1 * H, 1, 0, 0.3 * H, 0.12 * H, 0.8, 'rgba(255,240,180,.7)', 882, 3);
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#fff8d0', 885, 9);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '哎吔！', 0.2 * th, '#ffe066', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 中暑鬼：太陽曬 + 自己融化 ----------
// ① 抹汗，身邊那個太陽越來越亮 → ② 一道烈日光柱照在敵人頭上 → ③ 敵人冒汗冒煙「曬！」→ ④ 自己也熱到融成一灘，慢慢再黏回原形
MOVES.n30_zhongshu = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const f = N.kf(t, [[0, {}], [0.16, { armF:-0.7, head:0.1 }], [N.TC, { armF:-0.2, head:-0.15, r:-3 }], [0.36, { sy:0.72, sx:1.22, head:0.2, armF:0.3, armB:-0.3 }, 'o'], [0.46, { sy:0.75, sx:1.2 }], [0.59, {}, 'back']]);
  N30M.begin(ctx, S, f.x, 1 + (1 - (f.sy || 1)) * 1.5); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.6), sun = [T[0], S.ty - 1.6 * th], k = N.seg(t, 0.12, N.TC) * (1 - N.seg(t, 0.42, 0.59));
  if (k > 0) {
    ctx.save(); ctx.globalAlpha *= k; ctx.fillStyle = '#ffb030'; ctx.strokeStyle = '#a05a10'; ctx.lineWidth = 0.015 * th; ctx.beginPath(); ctx.arc(sun[0], sun[1], 0.14 * th, 0, 7); ctx.fill(); ctx.stroke();
    for (let i = 0; i < 10; i++) { const an = i / 10 * 6.28 + t * 2; N.crayon(ctx, [[sun[0] + Math.cos(an) * 0.19 * th, sun[1] + Math.sin(an) * 0.19 * th], [sun[0] + Math.cos(an) * 0.28 * th, sun[1] + Math.sin(an) * 0.28 * th]], '#ffb030', 0.025 * th, 890 + i); } ctx.restore();
    const b = N.seg(t, 0.2, N.TC) * (1 - N.seg(t, 0.4, 0.5)); if (b > 0) { ctx.save(); ctx.globalAlpha *= b * 0.5; const g = ctx.createLinearGradient(0, sun[1], 0, S.ty); g.addColorStop(0, 'rgba(255,220,100,.9)'); g.addColorStop(1, 'rgba(255,170,60,.2)'); ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(sun[0] - 0.1 * th, sun[1]); ctx.lineTo(sun[0] + 0.1 * th, sun[1]); ctx.lineTo(T[0] + 0.32 * th, S.ty); ctx.lineTo(T[0] - 0.32 * th, S.ty); ctx.closePath(); ctx.fill(); ctx.restore(); }
  }
  const p = t - N.TC;
  if (p >= 0) { N.drops(ctx, T[0], T[1] - 0.3 * th, 0.4 * th, N.seg(p, 0, 0.3), 'rgba(150,210,255,.9)', 900, 6); N.puff(ctx, T[0], T[1] - 0.5 * th, 0.1 * th, N.seg(p, 0, 0.3), 'rgba(255,255,255,.5)', 901, 3); }
  if (t > 0.3 && t < 0.55) { ctx.save(); ctx.globalAlpha *= 0.6 * Math.sin(N.seg(t, 0.3, 0.55) * Math.PI); ctx.fillStyle = 'rgba(230,120,100,.5)'; ctx.beginPath(); ctx.ellipse((f.x || 0), 0, 0.35 * H, 0.04 * H, 0, 0, 7); ctx.fill(); ctx.restore(); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#ffd080', 905, 9);
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, '曬！', 0.24 * th, '#ffb030', N.TC, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 撐死鬼：大肚腩一頂 ----------
// ① 往後一仰，肚子吸氣鼓得更大 → ② 挺著肚子撞過去 → ③ 「嘭！」敵人被彈開，盤子上的食物噴出來 → ④ 打個飽嗝退回
MOVES.n30_chengsi = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = Math.max(0, S.tx - 0.3 * th - 0.45 * S.W);
  const f = N.kf(t, [[0, {}], [0.16, { r:-12, sx:1.1, sy:1.02, x:-0.03 * H, head:-0.15, armF:0.3, armB:-0.2 }], [N.TC, { r:-6, sx:1.16, sy:0.94, x:D2, head:-0.05 }, 'i'], [0.32, { r:-4, sx:0.96, sy:1.04, x:D2 - 0.02 * H }], [0.40, { sx:1.04, sy:0.98, x:D2 * 0.6 }], [0.59, {}]]);
  f.px = 0; f.py = 0;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.5), p = t - N.TC, m = N.bm(S, f), pl = N.at(S, m, 0.82, 0.22);
  if (p >= 0 && p < 0.35) for (let i = 0; i < 7; i++) { const an = -Math.PI * (0.2 + 0.6 * N.rnd(i + 910)), sp = (0.3 + N.rnd(i + 920)) * 1.0 * H, x = pl[0] + Math.cos(an) * sp * p, y = pl[1] + Math.sin(an) * sp * p + 2.5 * H * p * p; ctx.save(); ctx.globalAlpha *= 1 - p / 0.35; ctx.fillStyle = ['#e8a050', '#7ac060', '#f0d080', '#d05040'][i % 4]; ctx.beginPath(); ctx.ellipse(x, y, 0.02 * H, 0.014 * H, i, 0, 7); ctx.fill(); ctx.restore(); }
  if (p >= 0 && p < 0.14) N.burst(ctx, T[0] - 0.15 * th, T[1], 0.4 * th, 1 - p / 0.14, '#fff0d0', 925, 11);
  N.pop(ctx, S, T[0], T[1] - 0.55 * th, '嘭！', 0.28 * th, '#ffd27a', N.TC, 0.28);
  N.pop(ctx, S, -0.1 * H, -1.05 * H, '嗝～', 0.12 * H, '#ffe0b0', 0.44, 0.15);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 蛇咬鬼：屁股上那條蛇撲出去 ----------
// ① 痛到跳腳，蛇鬆口縮起來 → ② 蛇從他身後一彈，越過他撲向敵人 → ③ 一口咬住「嘶！」→ ④ 蛇彈回來又咬回他屁股「哎喲！」
MOVES.n30_shedu = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false; const key = N30.body(S.id); if (!key) return false;
  const t = S.tt, H = S.H, th = S.th, PV = [0.70, 0.575];
  const f = N.kf(t, [[0, {}], [0.10, { y:-0.06 * H, r:-4 }], [0.18, { y:0, sy:0.95 }], [0.44, { r:3 }], [0.50, { y:-0.08 * H, r:-6, armF:-0.3 }, 'o'], [0.59, {}]]);
  const m = N.bm(S, f), home = N.at(S, m, PV[0], PV[1]), T = N.tgt(S, 0.72);
  let x, y, r, sx = 1;
  if (t < 0.15) { const k = N.E.o(N.seg(t, 0, 0.15)); x = home[0] - 0.03 * H * k; y = home[1] + 0.02 * H * k; r = 15 * k; sx = 1 - 0.1 * k; }
  else if (t < N.TC) { const q = N.seg(t, 0.15, N.TC); x = N.lerp(home[0], T[0] - 0.05 * th, q); y = N.lerp(home[1], T[1], q) - 0.55 * H * 4 * q * (1 - q); r = N.lerp(15, -150, q); }
  else if (t < 0.38) { x = T[0] - 0.05 * th + Math.sin(t * 90) * 0.01 * H; y = T[1]; r = -150; }
  else { const q = N.E.io(N.seg(t, 0.38, 0.52)); x = N.lerp(T[0] - 0.05 * th, home[0], q); y = N.lerp(T[1], home[1], q) - 0.4 * H * 4 * q * (1 - q); r = N.lerp(-150, 0, q); if (t > 0.52) { x = home[0]; y = home[1]; r = 0; } }
  N30M.begin(ctx, S, f.x); N.body(ctx, S, m, N.pose(S, f, 0.3), key);
  N.pieceAt(ctx, S, 'snake', x, y, r, PV[0], PV[1], sx, 1);
  const p = t - N.TC; if (p >= 0 && p < 0.13) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.13, '#e8f0a0', 935, 9);
  N.pop(ctx, S, T[0], T[1] - 0.4 * th, '嘶！', 0.24 * th, '#d8e870', N.TC, 0.28);
  N.pop(ctx, S, -0.1 * H, -1.1 * H, '哎喲！', 0.12 * H, '#ffe066', 0.5, 0.09);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 食物中毒鬼：轉身放一個綠色的屁 ----------
// ① 抱著肚子、一扭身屁股對著敵人 → ② 「噗——」一團綠雲噴出去 → ③ 敵人被燻到「臭！」→ ④ 轉回來，鬆一口氣、抱緊廁紙
MOVES.n30_shidu = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th;
  const turn = t < 0.12 ? Math.cos(N.seg(t, 0.05, 0.11) * Math.PI) : t > 0.45 ? -Math.cos(N.seg(t, 0.5, 0.56) * Math.PI) : -1;
  const f = N.kf(t, [[0, {}], [0.12, { body:0.1, head:0.1 }], [0.2, { body:0.25, head:0.15, sy:0.95, r:-6 }], [0.24, { body:0.2, sy:1.03, r:-3 }, 'o'], [0.45, { body:0.1 }], [0.59, {}]]);
  f.sx = Math.abs(turn) < 0.15 ? 0.15 * Math.sign(turn || 1) : turn; f.px = 0; f.py = -0.4 * H;
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.6), src = [0.12 * H, -0.45 * H];
  for (let i = 0; i < 6; i++) { const q = N.seg(t, 0.2 + i * 0.01, N.TC + 0.02 + i * 0.01), x = N.lerp(src[0], T[0] + (i - 2.5) * 0.06 * th, N.E.o(q)), y = N.lerp(src[1], T[1] + (N.rnd(i) - 0.5) * 0.3 * th, N.E.o(q)), al = 1 - N.seg(t, 0.45, 0.59); if (q <= 0) continue;
    ctx.save(); ctx.globalAlpha *= al * 0.85; ctx.fillStyle = i % 2 ? 'rgba(140,190,70,.8)' : 'rgba(110,160,60,.8)'; ctx.strokeStyle = 'rgba(50,80,30,.7)'; ctx.lineWidth = 0.008 * H; ctx.beginPath(); ctx.arc(x, y, (0.05 + 0.07 * q) * H, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore(); }
  if (t > N.TC) for (let i = 0; i < 3; i++) { const q = N.seg(t, N.TC + i * 0.03, 0.59), pts = []; for (let j = 0; j <= 6; j++) pts.push([T[0] + (i - 1) * 0.12 * th + Math.sin(j + t * 14 + i) * 0.03 * th, T[1] - 0.2 * th - j * 0.06 * th - q * 0.2 * th]); N.crayon(ctx, pts, 'rgba(120,170,60,.85)', 0.018 * th, 940 + i, Math.sin(q * Math.PI)); }
  N.pop(ctx, S, src[0] + 0.1 * H, src[1] - 0.1 * H, '噗——', 0.12 * H, '#b8e070', 0.2, 0.2);
  N.pop(ctx, S, T[0], T[1] - 0.55 * th, '臭！', 0.26 * th, '#b8e070', N.TC + 0.02, 0.3);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 打機猝死鬼：手掣狂按連段 ----------
// ① 手指在手掣上狂按，頭上跳出 ↑↑↓↓ → ② 一串 A、B、X、Y 按鍵飛過去 → ③ 像素火花「COMBO ×8」→ ④ 打個呵欠「GG」
MOVES.n30_daji = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, mash = Math.sin(t * 70) * 0.06;
  const f = N.kf(t, [[0, {}], [0.16, { head:0.1, body:0.08, r:2 }], [N.TC, { head:-0.05, body:-0.05, r:-4, x:0.02 * H }], [0.59, {}]]);
  if (t < 0.4) { f.armF = (f.armF || 0) + mash; f.armB = (f.armB || 0) - mash; }
  N30M.begin(ctx, S, f.x); N.whole(ctx, S, f, null, 0.3);
  const m = N.bm(S, f), pad = N.at(S, m, 0.4, 0.6), hd = N.at(S, m, 0.42, 0.02), T = N.tgt(S, 0.6);
  const ar = ['↑', '↑', '↓', '↓', '←', '→'];
  ar.forEach((c, i) => { const q = N.seg(t, 0.02 + i * 0.025, 0.25); if (q > 0 && q < 1) N.txt(ctx, S, hd[0] + (i - 2.5) * 0.08 * H, hd[1] - 0.1 * H - q * 0.06 * H, 0.08 * H, c, '#9fe8ff', Math.sin(q * Math.PI)); });
  const B = [['A', '#4ac060'], ['B', '#e84a4a'], ['X', '#4a8ae8'], ['Y', '#e8c84a']];
  for (let i = 0; i < 8; i++) { const q = N.seg(t, 0.18 + i * 0.008, N.TC + i * 0.008); if (q <= 0 || q >= 1) continue; const x = N.lerp(pad[0], T[0], q), y = N.lerp(pad[1], T[1] + (i % 3 - 1) * 0.1 * th, q) - Math.sin(q * Math.PI) * 0.1 * H, r = 0.035 * H, [c, col] = B[i % 4];
    ctx.save(); ctx.fillStyle = col; ctx.strokeStyle = '#1a1a2a'; ctx.lineWidth = r * 0.2; ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fill(); ctx.stroke(); ctx.restore(); N.txt(ctx, S, x, y, r * 1.3, c, '#ffffff'); }
  const p = t - N.TC;
  if (p >= 0 && p < 0.3) for (let i = 0; i < 12; i++) { const an = N.rnd(i + 950) * 6.28, d = (0.1 + p * 1.2) * th * (0.5 + N.rnd(i + 960)), s = 0.035 * th * (1 - p / 0.3); ctx.fillStyle = ['#ffe14a', '#ff5a8a', '#5ae8ff'][i % 3]; ctx.fillRect(T[0] + Math.cos(an) * d - s / 2, T[1] + Math.sin(an) * d - s / 2, s, s); }
  N.pop(ctx, S, T[0], T[1] - 0.5 * th, 'COMBO ×8', 0.16 * th, '#ffe14a', N.TC, 0.3);
  N.pop(ctx, S, hd[0], hd[1] - 0.1 * H, 'GG', 0.12 * H, '#9fe8ff', 0.45, 0.14);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};

// ---------- 大象踩扁鬼：扁成一張紙，橫著削過去 ----------
// ① 像紙一樣一飄一飄升起來，身子轉成側面（變一條線）→ ② 像紙片刀一樣橫著飛過去 → ③ 「唰！」削過去一道白光 → ④ 飄飄落回地上，攤平
MOVES.n30_xiangcai = function (ctx, a) {
  const N = N30K, S = N.setup(a); if (!S) return false;
  const t = S.tt, H = S.H, th = S.th, D2 = S.tx - 0.1 * th;
  const fl = Math.sin(t * 30) * 0.06;
  const f = N.kf(t, [[0, {}], [0.10, { y:-0.25 * H, r:-8, sy:1.08 }], [0.19, { y:-0.6 * H, sy:0.14, r:0 }], [N.TC, { y:-0.6 * H, sy:0.12, x:D2, r:4 }, 'i'], [0.34, { y:-0.6 * H, sy:0.14, x:D2 + 0.1 * H }], [0.44, { y:-0.35 * H, sy:0.7, x:D2 * 0.5, r:-10 }], [0.52, { y:-0.1 * H, sy:1.05, x:D2 * 0.15, r:6 }], [0.59, {}]]);
  f.px = 0; f.py = -0.5 * H; if (t < 0.5) f.armF = fl * 2; f.armB = -fl * 2;
  N30M.begin(ctx, S, f.x, 1 - N.cl(-(f.y || 0) / H) * 0.6);
  if (t > 0.19 && t < N.TC + 0.02) N.speed(ctx, (f.x || 0) - 0.4 * S.W, f.y - 0.5 * H, 1, 0, 0.5 * H, 0.06 * H, 1, 'rgba(240,240,255,.8)', 970, 3);
  N.whole(ctx, S, f, null, 0.3);
  const T = N.tgt(S, 0.6), p = t - N.TC;
  if (p >= 0 && p < 0.2) { const k = Math.min(1, p / 0.04); N.crayon(ctx, [[T[0] - 0.35 * th, T[1] - 0.05 * th], [T[0] - 0.35 * th + 0.7 * th * k, T[1] + 0.05 * th]], 'rgba(255,255,255,.95)', 0.03 * th, 975, 1 - p / 0.2); }
  if (p >= 0 && p < 0.12) N.burst(ctx, T[0], T[1], 0.3 * th, 1 - p / 0.12, '#ffffff', 977, 9);
  N.pop(ctx, S, T[0], T[1] - 0.45 * th, '唰！', 0.24 * th, '#ffffff', N.TC, 0.28);
  N.hit(S, T[0], T[1]); N30M.end(ctx);
};
