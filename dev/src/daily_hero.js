// ===================== 平日動作：阿福（主公）在村裡 =====================
// 全部用原圖：身體 afu__body（原圖網格變形），拿斧頭的手 afu__arm（原圖拆出，繞手肘轉），
// 斧頭 afu__axe（原圖斧頭，被手擋住的那段握把用同一把斧頭的原圖握把補齊，見 art/cut 說明），
// 手機 afu__phone／震動線 afu__ring（從手機道具原圖拆出）。口水泡、Zzz、汗、灰塵、字是程式畫的蠟筆筆觸。
// 座標：一律以「面朝左」為準（原圖方向）；th 正 = 手往後上方舉，lean 正 = 後仰，dx 正 = 往前，dy 正 = 往下。
const HeroDaily = (() => {
  const D = Math.PI / 180, S = Math.sin, PI = Math.PI;
  const cl = (v, a, b) => Math.max(a == null ? 0 : a, Math.min(b == null ? 1 : b, v));
  const E = {
    l:(t) => t, i:(t) => t * t, o:(t) => 1 - (1 - t) * (1 - t), io:(t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t),
    o3:(t) => 1 - Math.pow(1 - t, 3), i3:(t) => t * t * t,
    back:(t) => { const c1 = 1.70158, c3 = c1 + 1; return 1 + c3 * Math.pow(t - 1, 3) + c1 * Math.pow(t - 1, 2); }, // 衝過頭再回來
    hold:() => 0,
  };
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const LD = () => LIMBS_DATA.chars.afu, WP = () => LIMBS_DATA.weapons.axe;
  const AXE = () => ok('afu__axe') ? SPR.afu__axe : SPR.afu__wpn;
  // ---------- 姿勢 ----------
  // 平面欄位（全部是「在待機姿勢上加多少」）：
  //  身體整體 dx dy lean sx sy；拿斧頭的手 th hx hy；斧頭在手裡 wr（手腕再轉）slide（握把在手裡滑多少，H 單位，正 = 斧頭往斧刃方向滑出）；
  //  網格骨頭 head armB tie tail1 tail2 mb(身體骨，少用)；bob = 上下飄的幅度（-1 = 不飄，站穩）
  const F = ['dx', 'dy', 'lean', 'sx', 'sy', 'th', 'hx', 'hy', 'wr', 'slide', 'head', 'armB', 'tie', 'tail1', 'tail2', 'mb', 'bob', 'msy'];
  const Z = () => { const o = {}; for (const k of F) o[k] = 0; return o; };
  function lerpP(a, b, k) { const o = {}; for (const n of F) o[n] = (a[n] || 0) + ((b[n] || 0) - (a[n] || 0)) * k; return o; }
  function addP(a, b) { const o = Object.assign({}, a); for (const n of F) o[n] = (a[n] || 0) + (b[n] || 0); return o; }
  // 關鍵影格：[[秒, {欄位}, 緩動], ...]；第一格的秒數通常是 0
  function track(at, keys) {
    if (at <= keys[0][0]) return Object.assign(Z(), keys[0][1]);
    for (let i = 1; i < keys.length; i++) {
      const [t1, v1, e] = keys[i], [t0, v0] = keys[i - 1];
      if (at < t1) { const k = (E[e || 'io'])(cl((at - t0) / (t1 - t0))); return lerpP(Object.assign(Z(), v0), Object.assign(Z(), v1), k); }
    }
    return Object.assign(Z(), keys[keys.length - 1][1]);
  }
  const seg = (at, t0, t1) => cl((at - t0) / (t1 - t0));
  const bell = (at, t0, t1) => { const k = seg(at, t0, t1); return k <= 0 || k >= 1 ? 0 : S(k * PI); };
  // 待機（跟 Limbs 的待機完全一樣，動作結束時才接得上）
  function rest(t) { return { head:S(t * 1.3) * 0.05, armB:S(t * 1.8 + 1) * 0.06, tie:S(t * 5) * 0.18, tail1:S(t * 2.6) * 0.12, tail2:S(t * 2.6 - 1) * 0.22 }; }
  // ---------- 骨架計算（不畫，只算矩陣）----------
  const M = () => new DOMMatrix();
  // 地面座標：原點在腳下、面朝左
  function ground(a) { const m = M().translate(a.x, a.y); return a.faceRight ? m.scale(-1, 1) : m; }
  function solveRig(a, P, t) {
    const H = a.H, b = SPR.afu__body, W = H * b.naturalWidth / b.naturalHeight, c = LD();
    const bob = cl(1 + (P.bob || 0), 0, 1);
    const fl = a.solid ? 0 : (3 + S(t * 2.4) * 2 * bob) * a.s;
    const my = -0.03 - S(t * 2.2) * 0.02 * bob;
    const G = ground(a);
    const Mb = G.translate(0, -fl).translate(-(P.dx || 0) * H, (P.dy || 0) * H).translate(0, -H * 0.28).rotate(P.lean || 0).translate(0, H * 0.28).scale(1 + (P.sx || 0), 1 + (P.sy || 0));
    const th = P.th || 0, lift = cl((th - 25) / 40, 0, 1);
    const px = (c.pivot[0] - 0.5) * W, py = -H + c.pivot[1] * H + my * H;
    const lx = px + (lift * c.lift[0] + (P.hx || 0)) * W, ly = py - (lift * c.lift[1] + (P.hy || 0)) * H;
    const Ma = Mb.translate(lx, ly).rotate(th);
    const wp = WP(), ww = wp.w * H, wh = wp.h * H;
    const ax = (wp.tip[0] - wp.grip[0]) * ww, ay = (wp.tip[1] - wp.grip[1]) * wh, al = Math.hypot(ax, ay);
    const Mg = Ma.translate((c.grip[0] - c.pivot[0]) * W, (c.grip[1] - c.pivot[1]) * H).rotate(P.wr || 0).translate(ax / al * (P.slide || 0) * H, ay / al * (P.slide || 0) * H);
    return { H, W, G, Mb, Ma, Mg, my, fl, ww, wh, axU:[ax / al, ay / al], al };
  }
  // 原圖上一點 (u,v) 經過網格變形 + 身體變形，落在世界哪裡（給口水泡、嘴巴、汗用）
  let RB = null;
  function meshPt(R, mp, u, v) {
    const img = SPR.afu__body, ar = img.naturalHeight / img.naturalWidth;
    if (!RB) RB = MeshAnim.RIG.afu.bones.filter(b => !['armF', 'axe'].includes(b[0]));
    const T = {};
    for (const b of RB) { const [n, par, px, py] = b, A0 = mp[n] || 0, Pp = par ? T[par] : { a:0, tx:0, ty:0 };
      const ppx = Math.cos(Pp.a) * px - Math.sin(Pp.a) * py + Pp.tx, ppy = Math.sin(Pp.a) * px + Math.cos(Pp.a) * py + Pp.ty, A = Pp.a + A0;
      T[n] = { a:A, tx:ppx - (Math.cos(A) * px - Math.sin(A) * py), ty:ppy - (Math.sin(A) * px + Math.cos(A) * py) }; }
    let X = 0, Y = 0, sum = 0; const vy = v * ar;
    for (const b of RB) {
      const dx = b[4] - b[2], dy = (b[5] - b[3]) * ar, l = dx * dx + dy * dy || 1e-6, tt = cl(((u - b[2]) * dx + (vy - b[3] * ar) * dy) / l);
      const d = Math.hypot(u - b[2] - tt * dx, vy - b[3] * ar - tt * dy) / b[6]; let w = Math.exp(-d * d * 2.2); if (b[1] === null) w = Math.max(w, 0.05);
      const tr = T[b[0]], c = Math.cos(tr.a), s = Math.sin(tr.a); X += w * (c * u - s * vy + tr.tx); Y += w * (s * u + c * vy + tr.ty); sum += w;
    }
    X /= sum; Y = Y / sum / ar;
    const p = R.Mb.transformPoint(new DOMPoint((X - 0.5) * R.W, (Y - 1 + R.my) * R.H * (1 + (mp.msy || 0))));
    return { x:p.x, y:p.y };
  }
  const wpt = (Mx, x, y) => { const p = Mx.transformPoint(new DOMPoint(x, y)); return { x:p.x, y:p.y }; };
  // ---------- 畫 ----------
  // st: { axe:'hand'|'plant'|'none', plantM（斧頭插在地上的矩陣，地面座標）, phone:0~1（手裡拿手機）, front:true（手畫在身體前面）}
  function render(ctx, a, P, st, t) {
    const base = ctx.getTransform(), R = solveRig(a, P, t), H = R.H, c = LD();
    const body = SPR.afu__body, arm = SPR.afu__arm;
    const mp = { head:P.head, armB:P.armB, tie:P.tie, tail1:P.tail1, tail2:P.tail2, body:P.mb || 0, y:R.my, sy:1 + (P.msy || 0) };
    // 影子：飄得越高越小越淡
    const up = -(P.dy || 0);
    ctx.save(); ctx.globalAlpha *= 0.55 * cl(1 - up * 2.5, 0.35, 1); a.shadow(a.x - (a.faceRight ? -1 : 1) * (P.dx || 0) * H * 0.5, (a.solid ? 1 : 0.8) * cl(1 - up * 1.6, 0.55, 1.1)); ctx.restore();
    const set = (Mx) => ctx.setTransform(base.multiply(Mx));
    const clipGround = () => { set(R.G); ctx.beginPath(); ctx.rect(-H * 3, -H * 3, H * 6, H * 3 + H * 0.015); ctx.clip(); };
    const drawAxe = (Mx) => { const wp = WP(), im = AXE(); ctx.save(); clipGround(); set(Mx); ctx.drawImage(im, -wp.grip[0] * R.ww, -wp.grip[1] * R.wh, R.ww, R.wh); ctx.restore(); };
    const planted = st.axe === 'plant' && st.plantM;
    const drawArm = () => {
      ctx.save(); set(R.Ma); ctx.drawImage(arm, -c.pivot[0] * R.W, -c.pivot[1] * R.H, R.W, R.H); ctx.restore();
      if (st.phone > 0) drawPhoneInHand(ctx, base, R, st, t);
    };
    const behind = st.front ? false : (P.th || 0) > c.behind;
    if (planted && st.plantBehind) drawAxe(R.G.multiply(st.plantM));
    if (behind) { if (st.axe === 'hand') drawAxe(R.Mg); drawArm(); }
    ctx.save(); set(R.Mb); MeshAnim.drawBody(ctx, 'afu', 'afu__body', H, mp); ctx.restore();
    if (planted && !st.plantBehind) drawAxe(R.G.multiply(st.plantM));
    if (!behind) { if (st.axe === 'hand') drawAxe(R.Mg); drawArm(); }
    ctx.setTransform(base);
    R.mp = mp; return R;
  }
  // 手機：拿在握拳的手裡（手機畫在拳頭上，手指那一圈再疊一次蓋住手機下緣，像捏著）
  const FIST = [0.245, 0.505]; // 拳頭中心（原圖比例）
  function drawPhoneInHand(ctx, base, R, st, t) {
    const im = SPR.afu__phone; if (!im || !ok('afu__phone')) return;
    const k = st.phone, H = R.H, c = LD(), ph = H * 0.2 * (0.55 + 0.45 * k), pw = ph * im.naturalWidth / im.naturalHeight;
    const Mf = R.Ma.translate((FIST[0] - c.pivot[0]) * R.W, (FIST[1] - c.pivot[1]) * R.H).rotate(st.phoneRot != null ? st.phoneRot : -20);
    ctx.save(); ctx.setTransform(base.multiply(Mf)); ctx.globalAlpha *= cl(k * 3);
    ctx.drawImage(im, -pw * 0.5, -ph * 0.92, pw, ph);
    // 螢幕亮光
    if (st.glow) { ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha *= st.glow * 0.5; ctx.fillStyle = '#9fe6ff'; ctx.beginPath(); ctx.ellipse(0, -ph * 0.48, pw * 0.36, ph * 0.38, 0, 0, 7); ctx.fill(); }
    ctx.restore();
    // 手指（拳頭上半）疊回去
    ctx.save(); ctx.setTransform(base.multiply(R.Ma)); const W = R.W;
    ctx.beginPath(); ctx.ellipse((0.245 - c.pivot[0]) * W, (0.515 - c.pivot[1]) * H, 0.05 * W, 0.04 * H, -0.3, 0, 7); ctx.clip();
    ctx.drawImage(SPR.afu__arm, -c.pivot[0] * W, -c.pivot[1] * H, W, H); ctx.restore();
  }
  // ---------- 蠟筆特效 ----------
  function jitter(seed) { let s = seed * 9301 + 49297; return () => ((s = (s * 9301 + 49297) % 233280) / 233280); }
  function crayonText(ctx, str, x, y, size, col, alpha, rot) {
    if (alpha <= 0) return; size = Math.max(size, 8); // 村裡阿福很小：字不能小於 8
    ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(x, y); if (rot) ctx.rotate(rot);
    ctx.font = `bold ${size}px "PingFang TC","Noto Sans TC","Noto Sans CJK TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.lineJoin = 'round'; ctx.lineWidth = Math.max(2, size * 0.28); ctx.strokeStyle = 'rgba(28,18,26,.92)'; ctx.strokeText(str, 0, 0);
    ctx.fillStyle = col; ctx.fillText(str, 0, 0);
    ctx.globalAlpha *= 0.35; ctx.fillStyle = '#fff'; ctx.fillText(str, -size * 0.04, -size * 0.05);
    ctx.restore();
  }
  function bubble(ctx, x, y, w, h, alpha, tailX, tailY) { // 對話泡泡（蠟筆描邊）
    if (alpha <= 0) return;
    ctx.save(); ctx.globalAlpha *= alpha; ctx.lineJoin = 'round';
    ctx.beginPath(); ctx.roundRect(x - w / 2, y - h / 2, w, h, h * 0.45);
    if (tailX != null) { ctx.moveTo(x - w * 0.12, y + h / 2 - 1); ctx.lineTo(tailX, tailY); ctx.lineTo(x + w * 0.08, y + h / 2 - 1); }
    ctx.fillStyle = '#fbf3e2'; ctx.fill(); ctx.lineWidth = Math.max(1.4, h * 0.09); ctx.strokeStyle = '#3a2a2e'; ctx.stroke();
    ctx.restore();
  }
  function say(ctx, str, x, y, size, col, alpha, tx, ty) { // 泡泡大小跟著字
    if (alpha <= 0) return; size = Math.max(size, 8);
    ctx.save(); ctx.font = `bold ${size}px "PingFang TC","Noto Sans TC","Noto Sans CJK TC",sans-serif`; const w = ctx.measureText(str).width + size * 1.1; ctx.restore();
    bubble(ctx, x, y, w, size * 1.75, alpha, tx, ty); crayonText(ctx, str, x, y, size, col, alpha);
  }
  function drop(ctx, x, y, r, rot, alpha) { // 汗珠／淚
    if (alpha <= 0) return;
    ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(x, y); ctx.rotate(rot || 0);
    ctx.beginPath(); ctx.moveTo(0, -r * 1.7); ctx.quadraticCurveTo(r * 1.1, -r * 0.1, r * 0.95, r * 0.35); ctx.arc(0, r * 0.35, r * 0.95, 0, PI); ctx.quadraticCurveTo(-r * 1.1, -r * 0.1, 0, -r * 1.7); ctx.closePath();
    ctx.fillStyle = 'rgba(150,215,245,.92)'; ctx.fill(); ctx.lineWidth = Math.max(0.8, r * 0.32); ctx.strokeStyle = '#2f5568'; ctx.stroke();
    ctx.fillStyle = 'rgba(255,255,255,.85)'; ctx.beginPath(); ctx.ellipse(-r * 0.3, r * 0.1, r * 0.22, r * 0.38, 0.3, 0, 7); ctx.fill();
    ctx.restore();
  }
  function snot(ctx, x, y, r, alpha) { // 鼻涕泡
    if (alpha <= 0 || r <= 0.2) return;
    ctx.save(); ctx.globalAlpha *= alpha;
    ctx.beginPath(); ctx.arc(x, y, r, 0, 7); ctx.fillStyle = 'rgba(190,232,250,.45)'; ctx.fill();
    ctx.lineWidth = Math.max(0.7, r * 0.1); ctx.strokeStyle = 'rgba(70,120,150,.85)'; ctx.stroke();
    ctx.fillStyle = 'rgba(255,255,255,.9)'; ctx.beginPath(); ctx.ellipse(x - r * 0.38, y - r * 0.38, r * 0.2, r * 0.13, -0.7, 0, 7); ctx.fill();
    ctx.beginPath(); ctx.arc(x + r * 0.3, y + r * 0.35, r * 0.07, 0, 7); ctx.fill();
    ctx.restore();
  }
  function puff(ctx, x, y, r, alpha, col) { // 一團呼氣／灰塵（蠟筆小圈）
    if (alpha <= 0) return;
    if (col == null && ok('fx_dust')) { const I = SPR.fx_dust, sc = r * 2 / Math.max(I.naturalWidth, I.naturalHeight); ctx.save(); ctx.globalAlpha *= alpha; ctx.drawImage(I, x - I.naturalWidth * sc / 2, y - I.naturalHeight * sc / 2, I.naturalWidth * sc, I.naturalHeight * sc); ctx.restore(); return; }
    ctx.save(); ctx.globalAlpha *= alpha; const C3 = [[0, 0, 0.55], [-0.42, 0.12, 0.4], [0.42, 0.14, 0.42], [0.1, -0.3, 0.38]];
    ctx.beginPath(); for (const [ox, oy, rr] of C3) { ctx.moveTo(x + ox * r + rr * r, y + oy * r); ctx.arc(x + ox * r, y + oy * r, rr * r, 0, 7); }
    ctx.lineWidth = Math.max(1, r * 0.16); ctx.strokeStyle = 'rgba(70,70,85,.55)'; ctx.stroke(); ctx.fillStyle = col || 'rgba(230,225,210,.9)'; ctx.fill();
    ctx.fillStyle = 'rgba(255,255,255,.5)'; ctx.beginPath(); ctx.arc(x - r * 0.15, y - r * 0.22, r * 0.18, 0, 7); ctx.fill();
    ctx.restore();
  }
  function lines(ctx, x, y, r, n, a0, a1, alpha, col, w) { // 放射短線（驚嚇、震動、汗光）
    if (alpha <= 0) return;
    ctx.save(); ctx.globalAlpha *= alpha; ctx.strokeStyle = col || '#fff3c4'; ctx.lineWidth = w || Math.max(1.2, r * 0.12); ctx.lineCap = 'round';
    for (let i = 0; i < n; i++) { const an = a0 + (a1 - a0) * (n === 1 ? 0.5 : i / (n - 1)); ctx.beginPath(); ctx.moveTo(x + Math.cos(an) * r * 0.55, y + Math.sin(an) * r * 0.55); ctx.lineTo(x + Math.cos(an) * r, y + Math.sin(an) * r); ctx.stroke(); }
    ctx.restore();
  }
  function sparkle(ctx, x, y, r, alpha) {
    if (alpha <= 0) return;
    if (ok('fx_spark')) { const I = SPR.fx_spark, sc = r * 2 / Math.max(I.naturalWidth, I.naturalHeight); ctx.save(); ctx.globalAlpha *= alpha; ctx.drawImage(I, x - I.naturalWidth * sc / 2, y - I.naturalHeight * sc / 2, I.naturalWidth * sc, I.naturalHeight * sc); ctx.restore(); return; }
    lines(ctx, x, y, r, 4, 0, PI * 1.5, alpha);
  }
  function mouthO(ctx, p, w, h, rot, alpha) { // 打呵欠張開的嘴（蓋在原圖嘴上）
    if (alpha <= 0 || h <= 0.3) return;
    ctx.save(); ctx.globalAlpha *= alpha; ctx.translate(p.x, p.y); ctx.rotate(rot || 0);
    ctx.beginPath(); ctx.ellipse(0, h * 0.25, w, h, 0, 0, 7); ctx.fillStyle = '#4a2027'; ctx.fill();
    ctx.lineWidth = Math.max(0.9, w * 0.32); ctx.strokeStyle = '#33221f'; ctx.stroke();
    ctx.beginPath(); ctx.ellipse(0, h * 0.25 + h * 0.5, w * 0.6, h * 0.35, 0, PI, 2 * PI); ctx.fillStyle = '#b8565c'; ctx.fill();
    ctx.restore();
  }
  // 臉上幾個點（原圖比例）
  const FACE = { mouth:[0.51, 0.378], nose:[0.49, 0.352], brow:[0.42, 0.235], eyeL:[0.40, 0.305], eyeR:[0.59, 0.29], top:[0.47, 0.06], cheek:[0.36, 0.34], pocket:[0.60, 0.56], chest:[0.50, 0.58] };
  const fp = (R, k) => meshPt(R, R.mp, FACE[k][0], FACE[k][1]);
  // ---------- 狀態（每個阿福一份：動作切換時從上一個姿勢淡入）----------
  const MEM = {};
  function mem(a) { const k = a.o.hid || 'hero'; return MEM[k] || (MEM[k] = { name:null, P:null, st:null, from:null, fromSt:null }); }
  // 種子亂數（同一段走路的跳石頭、四處看都固定，不會每格亂跳）
  const hash = (n) => { const x = S(n * 127.1 + 311.7) * 43758.5453; return x - Math.floor(x); };
  // ---------- 斧頭插地：共用的一段 ----------
  // 插下去那一刻的姿勢（劈到底的收勢，握把滑到手上方，斧刃剛好吃進土裡）
  const PLANT = { th:-122, lean:-17, dx:0.10, dy:0.03, sx:0.03, sy:-0.04, slide:0.07, wr:-6, bob:-1, head:-0.10 };
  const plantCache = {};
  function plantM(a) { // 斧頭插在地上的矩陣（相對地面座標），由 PLANT 姿勢算出 → 手回來握的時候分毫不差
    const R = solveRig(a, addP(Z(), PLANT), 0);
    return R.G.inverse().multiply(R.Mg);
  }
  // ---------- 各動作 ----------
  const ACT = {};
  // 走路：四處張望、領帶尾巴飄、偶爾跳過小石頭
  ACT.walk = (a, at, t) => {
    const w = MeshAnim.ANIM.walk(t), r = rest(t);
    const P = Z();
    // 走路姿勢（相對待機的差）
    P.head = w.head - r.head; P.armB = w.armB - r.armB; P.tie = w.tie - r.tie + S(t * 13) * 0.08; P.tail1 = w.tail1 - r.tail1; P.tail2 = w.tail2 - r.tail2;
    P.th = S(t * 7) * 5; P.wr = S(t * 7 - 0.6) * 4; P.lean = -3; P.dy = -Math.abs(S(t * 7)) * 0.02;
    // 張望：每 2.6 秒換一個方向看（抬頭看天、低頭看路、往前探）
    const gi = Math.floor((at + 0.8) / 2.6), gk = ((at + 0.8) % 2.6) / 2.6, g = hash(gi + 3);
    const look = bell(gk, 0.15, 0.85) ; const ease = E.io(cl(look * 1.6));
    if (g < 0.4) { P.head += -0.16 * ease; P.dx += 0.02 * ease; }       // 往前低頭看路
    else if (g < 0.75) { P.head += 0.15 * ease; P.lean += 3 * ease; }   // 抬頭看看天
    else { P.head += S(gk * PI * 4) * 0.08 * look; }                    // 左右晃頭東張西望
    // 跳過小石頭：每 4~6 秒一次
    // 跳石頭：第一次約走 2.4 秒後，之後每 4.5~6 秒一次
    let hp = -9, stone = null; const base = Math.floor((at - 2.4) / 4.5);
    for (let i = Math.max(0, base - 1); i <= base + 1; i++) { const c = 2.4 + i * 4.5 + hash(i + 17) * 1.5, q = (at - c) / 0.55; if (q > -1.2 && q < 1.6) hp = q; }
    {
      if (hp > -1.2 && hp < 1.6) stone = { k:hp };
      if (hp >= 0 && hp < 1) {
        const q = hp; let up = 0, sq = 0;
        if (q < 0.18) sq = E.o(q / 0.18);                                  // 蹲
        else if (q < 0.75) { const u = (q - 0.18) / 0.57; up = S(u * PI); sq = -0.6 * S(u * PI) + (u < 0.15 ? 1 - u / 0.15 : 0); }
        else sq = S((q - 0.75) / 0.25 * PI) * 0.8;                      // 落地
        P.dy += -0.2 * up; P.sy += -0.07 * sq; P.sx += 0.06 * sq; P.lean += -6 * up;
        P.tie += 0.35 * up; P.tail1 += 0.25 * up; P.tail2 += 0.45 * up; P.th += 14 * up; P.head += -0.06 * sq;
      }
    }
    return { P, st:{ axe:'hand' }, stone };
  };
  // 打呵欠：吸氣、手舉起來伸、頭往後仰張大嘴、抖一下、放鬆、擠出一滴眼淚
  ACT.yawn = (a, at) => {
    const L = 3.6;
    const P = track(at, [
      [0, {}],
      [0.45, { sy:-0.03, sx:0.02, head:-0.08, dy:0.01 }, 'io'],                                    // 預備：縮一下
      [1.25, { sy:0.07, sx:-0.03, dy:-0.03, lean:7, head:0.22, th:94, hx:0.04, hy:0.05, armB:-0.32, tail1:-0.15, tail2:-0.25, tie:0.15 }, 'o3'], // 伸、仰頭
      [2.15, { sy:0.08, sx:-0.035, dy:-0.035, lean:8, head:0.25, th:98, hx:0.04, hy:0.05, armB:-0.36, tail1:-0.18, tail2:-0.3, tie:0.2 }, 'l'],   // 撐住
      [2.75, { sy:-0.04, sx:0.03, dy:0.01, lean:-4, head:-0.1, th:-6, armB:0.08, tail1:0.08, tail2:0.12 }, 'io'],                    // 放下：往前垂
      [3.2, { sy:0.005, head:0.02 }, 'io'],
      [L, {}, 'io'],
    ]);
    const shake = bell(at, 1.35, 2.15); P.head += S(at * 38) * 0.015 * shake; P.th += S(at * 31) * 1.6 * shake;
    const open = E.io(bell(at, 0.6, 2.75) > 0 ? cl(seg(at, 0.6, 1.2)) * (1 - seg(at, 2.2, 2.75)) : 0);
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const m = fp(R, 'mouth'), s = R.H;
      mouthO(ctx, m, s * 0.026 * (0.6 + 0.4 * open), s * 0.034 * open, -(P.head + R.mp.head) * 0.5 * (a.faceRight ? -1 : 1), cl(open * 4));
      // 「哈～」
      const ht = seg(at, 1.0, 2.6); crayonText(ctx, '哈～', m.x + (a.faceRight ? 1 : -1) * s * (0.32 + ht * 0.12), m.y - s * (0.18 + ht * 0.15), s * 0.2, '#fff4d0', bell(at, 1.0, 2.6) * 1.6 > 1 ? 1 : bell(at, 1.0, 2.6) * 1.6);
      // 眼角一滴淚
      const tk = seg(at, 2.55, 3.55), e = meshPt(R, R.mp, 0.345, 0.315);
      if (tk > 0 && tk < 1) drop(ctx, e.x, e.y + tk * s * 0.04, s * 0.014 * (tk < 0.2 ? tk / 0.2 : 1), 0, 1 - E.i(seg(at, 3.2, 3.55)));
    } };
  };
  // 大伸懶腰：雙手往上撐、整個人往後拗、左右扭兩下、喀一聲、洩氣
  ACT.stretch = (a, at) => {
    const L = 3.6;
    const P = track(at, [
      [0, {}],
      [0.4, { sy:-0.05, sx:0.03, dy:0.015, head:-0.06, th:-8 }, 'io'],
      [1.0, { sy:0.1, sx:-0.05, dy:-0.05, lean:12, head:0.18, th:96, hx:0.04, hy:0.06, armB:-0.5, wr:8, tail1:-0.22, tail2:-0.38, tie:0.25 }, 'o3'],
      [1.45, { sy:0.11, sx:-0.055, dy:-0.055, lean:-6, head:0.08, th:100, hx:0.04, hy:0.07, armB:-0.42, wr:10, tail1:0.2, tail2:0.35, tie:-0.15 }, 'io'],
      [1.9, { sy:0.11, sx:-0.055, dy:-0.055, lean:14, head:0.2, th:98, hx:0.04, hy:0.07, armB:-0.55, wr:6, tail1:-0.25, tail2:-0.4, tie:0.3 }, 'io'],
      [2.2, { sy:0.11, sx:-0.05, dy:-0.05, lean:12, head:0.22, th:100, hx:0.04, hy:0.07, armB:-0.55, wr:8, tail1:-0.2, tail2:-0.35, tie:0.25 }, 'l'],
      [2.75, { sy:-0.06, sx:0.04, dy:0.02, lean:-5, head:-0.12, th:-10, armB:0.1, tail1:0.1, tail2:0.15, tie:-0.1 }, 'io'],
      [3.2, { sy:0.01, head:0.02 }, 'io'],
      [L, {}, 'io'],
    ]);
    const shake = bell(at, 1.9, 2.25); P.lean += S(at * 40) * 1.2 * shake;
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const s = R.H, top = fp(R, 'top');
      const k = seg(at, 2.0, 2.55); crayonText(ctx, '喀', top.x + (a.faceRight ? -1 : 1) * s * 0.28, top.y + s * 0.25 - k * s * 0.12, s * 0.17, '#ffe6a8', bell(at, 2.0, 2.6) * 1.8 > 1 ? 1 : bell(at, 2.0, 2.6) * 1.8, 0.2);
      lines(ctx, top.x + (a.faceRight ? -1 : 1) * s * 0.18, top.y + s * 0.35, s * 0.12, 3, -2.4, -1.2, bell(at, 2.0, 2.3), '#fff3c4');
      const m = fp(R, 'mouth'), pk = seg(at, 2.6, 3.4); puff(ctx, m.x + (a.faceRight ? 1 : -1) * s * (0.12 + pk * 0.15), m.y + s * 0.02 - pk * s * 0.05, s * (0.05 + pk * 0.05), bell(at, 2.6, 3.4) * 0.9, 'rgba(235,240,245,.9)');
    } };
  };
  // 抓頭：拿斧頭那隻手舉到頭邊，用手背搔頭（小心斧頭！），頭歪一邊，冒問號
  ACT.scratch = (a, at) => {
    const L = 3.0;
    const P = track(at, [
      [0, {}],
      [0.35, { th:-6, head:-0.03, sy:-0.015 }, 'io'],
      [0.8, { th:80, hx:0.26, hy:-0.08, head:-0.1, lean:-3, wr:20, armB:-0.05 }, 'o3'],
      [2.2, { th:80, hx:0.26, hy:-0.08, head:-0.12, lean:-3, wr:20, armB:-0.05 }, 'l'],
      [2.65, { th:-4, head:-0.02 }, 'io'],
      [L, {}, 'io'],
    ]);
    const sc = bell(at, 0.75, 2.25) > 0 ? cl(seg(at, 0.75, 0.95)) * (1 - seg(at, 2.05, 2.25)) : 0; P.th += S(at * 24) * 6 * sc; P.hy += S(at * 24 + 1.2) * 0.02 * sc; P.wr += S(at * 24) * 5 * sc; P.head += S(at * 12) * 0.025 * sc;
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const s = R.H, top = fp(R, 'top'), al = cl(bell(at, 0.8, 2.6) * 2);
      crayonText(ctx, '？', top.x + (a.faceRight ? 1 : -1) * s * 0.22, top.y - s * 0.08 - seg(at, 0.8, 1.2) * s * 0.06 + S(at * 6) * s * 0.01, s * 0.24, '#ffe9a8', al, (a.faceRight ? 1 : -1) * -0.15);
      // 頭皮屑／搔出來的小線
      if (sc > 0.2) lines(ctx, top.x + (a.faceRight ? -1 : 1) * s * 0.3, top.y + s * 0.18, s * 0.1, 2, -2.6 + S(at * 26) * 0.3, -1.9, sc * 0.8, '#e8dfcf');
    } };
  };
  // 不耐煩：尾巴尖一下一下拍地、斧頭在手裡轉、頭抬著翻白眼、「嘖」
  ACT.tap = (a, at) => {
    const L = 3.4;
    const P = track(at, [
      [0, {}],
      [0.35, { lean:4, head:0.1, th:6, sy:0.01 }, 'io'],
      [3.0, { lean:4, head:0.1, th:6, sy:0.01 }, 'l'],
      [L, {}, 'io'],
    ]);
    const on = bell(at, 0.3, 3.1) > 0 ? cl(seg(at, 0.3, 0.6)) * (1 - seg(at, 2.8, 3.1)) : 0;
    const beat = (at * 3.2) % 1, kick = beat < 0.35 ? E.o(beat / 0.35) : 1 - E.io((beat - 0.35) / 0.65);
    P.tail1 += (-0.35 + 0.45 * kick) * on; P.tail2 += (-0.9 + 1.2 * kick) * on;     // 尾巴尖抬起 → 拍下
    P.dy += -0.006 * (1 - kick) * on; P.sy += 0.012 * (1 - kick) * on;
    P.wr += S(at * 6.4) * 9 * on; P.th += S(at * 6.4 + 0.8) * 4 * on;              // 斧頭在手裡晃
    P.head += S(at * 3.2 * PI) * 0.02 * on;
    const beatN = Math.floor(at * 3.2);
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const s = R.H, g = R.G.transformPoint(new DOMPoint(R.H * 0.02, 0));
      if (on > 0.5 && beat < 0.3) puff(ctx, g.x + (a.faceRight ? -1 : 1) * s * 0.05, g.y - s * 0.02, s * (0.04 + beat * 0.12), (0.3 - beat) / 0.3 * 0.7);
      const m = fp(R, 'mouth'), k = seg(at, 1.2, 2.2);
      crayonText(ctx, '嘖', m.x - (a.faceRight ? 1 : -1) * s * (0.32 + k * 0.05), m.y - s * 0.12 - k * s * 0.08, s * 0.17, '#ffd2b0', cl(bell(at, 1.2, 2.3) * 2));
      const top = fp(R, 'top'); crayonText(ctx, '…', top.x + (a.faceRight ? 1 : -1) * s * 0.2, top.y - s * 0.02, s * 0.2, '#fff', cl(bell(at, 0.4, 1.3) * 2) + cl(bell(at, 2.3, 3.2) * 2));
      void beatN;
    } };
  };
  // 擦汗：額頭冒汗 → 手背由前往後抹過額頭 → 甩掉汗珠 →「呼～」肩膀一沉
  ACT.sweat = (a, at) => {
    const L = 2.8;
    const P = track(at, [
      [0, {}],
      [0.3, { th:-4, head:-0.04, sy:-0.01 }, 'io'],
      [0.75, { th:50, hx:-0.1, hy:0.0, head:0.08, wr:-40, lean:-2 }, 'o3'],              // 手背貼到額頭前
      [1.3, { th:60, hx:0.1, hy:0.02, head:0.16, wr:-32, lean:4 }, 'io'],                // 往後抹
      [1.6, { th:80, hx:0.27, hy:-0.06, head:0.1, wr:16, lean:3 }, 'o'],                 // 甩（手到頭後）
      [2.0, { th:-6, head:-0.08, sy:-0.03, dy:0.01, lean:-3 }, 'io'],                     // 放下、洩氣
      [2.4, { head:0.01 }, 'io'],
      [L, {}, 'io'],
    ]);
    return { P, st:{ axe:'hand', front:at > 0.35 && at < 1.55 }, L, fx:(ctx, R) => {
      const s = R.H, b = fp(R, 'brow'), dir = a.faceRight ? 1 : -1;
      const wiped = seg(at, 0.8, 1.25);
      // 額頭上的汗（被抹掉）
      for (let i = 0; i < 3; i++) { const al = (1 - seg(at, 0.85 + i * 0.12, 1.0 + i * 0.12)) * cl(at / 0.25); drop(ctx, b.x + dir * (0.04 - i * 0.07) * s, b.y + [0, 0.035, -0.01][i] * s, s * [0.016, 0.012, 0.014][i], 0, al); }
      // 甩出去的汗珠
      const fk = seg(at, 1.5, 2.2);
      if (fk > 0 && fk < 1) { const h0 = R.Ma.transformPoint(new DOMPoint((FIST[0] - LD().pivot[0]) * R.W, (FIST[1] - LD().pivot[1]) * R.H)); for (let i = 0; i < 3; i++) { const vx = dir * -(0.25 + i * 0.12), vy = -0.35 + i * 0.12; drop(ctx, h0.x + vx * fk * s, h0.y + (vy * fk + 0.9 * fk * fk) * s, s * 0.016, Math.atan2(vy + 1.8 * fk, vx) + PI / 2, 1 - fk); } }
      
      const m = fp(R, 'mouth'), pk = seg(at, 1.75, 2.6);
      puff(ctx, m.x + dir * s * (0.1 + pk * 0.14), m.y + s * 0.03 + pk * s * 0.02, s * (0.04 + pk * 0.05), bell(at, 1.75, 2.6), 'rgba(235,240,245,.9)');
      crayonText(ctx, '呼～', m.x + dir * s * (0.34 + pk * 0.06), m.y - s * 0.08 - pk * s * 0.06, s * 0.16, '#eaf6ff', cl(bell(at, 1.8, 2.7) * 2));
      void wiped;
    } };
  };
  // 拍灰：空著的手在衣服上拍兩下（拍出灰），再把斧頭舉到嘴前吹一吹斧刃上的木屑
  ACT.dust = (a, at) => {
    const L = 3.0;
    const P = track(at, [
      [0, {}],
      [0.25, { armB:0.25, head:-0.12, lean:-3 }, 'io'],
      [0.42, { armB:-0.18, head:-0.14, lean:-4 }, 'o'],
      [0.6, { armB:0.28, head:-0.14, lean:-4 }, 'io'],
      [0.78, { armB:-0.2, head:-0.14, lean:-4 }, 'o'],
      [0.95, { armB:0.0, head:-0.05 }, 'io'],
      [1.4, { th:30, hx:-0.05, hy:0.02, wr:-18, head:-0.02, lean:-4, dx:0.01 }, 'o3'],         // 斧頭舉到臉前
      [2.2, { th:32, hx:-0.05, hy:0.02, wr:-20, head:-0.06, lean:-7, dx:0.02 }, 'l'],          // 吹
      [2.65, { th:-3, head:0.02 }, 'io'],
      [L, {}, 'io'],
    ]);
    const blow = bell(at, 1.55, 2.2); P.sy += -0.02 * blow; P.sx += 0.015 * blow;
    return { P, st:{ axe:'hand', front:true }, L, fx:(ctx, R) => {
      const s = R.H, c = fp(R, 'chest'), dir = a.faceRight ? 1 : -1;
      for (const [t0, j] of [[0.42, 0], [0.78, 1]]) { const k = seg(at, t0, t0 + 0.5); if (k > 0 && k < 1) for (let i = 0; i < 2; i++) puff(ctx, c.x - dir * s * (0.08 + i * 0.07 + j * 0.03) - dir * k * s * 0.1, c.y + s * (0.08 + i * 0.05) - k * s * 0.06, s * (0.05 + k * 0.07), (1 - k) * 0.85); }
      // 吹斧刃：嘴前一道氣、木屑飛走
      const m = fp(R, 'mouth'), bk = seg(at, 1.55, 2.3);
      if (bk > 0 && bk < 1) {
        ctx.save(); ctx.globalAlpha *= (1 - bk) * 0.9; ctx.strokeStyle = 'rgba(235,245,250,.95)'; ctx.lineWidth = Math.max(1, s * 0.012); ctx.lineCap = 'round';
        for (let i = 0; i < 3; i++) { const y0 = m.y + (i - 1) * s * 0.025, x0 = m.x + dir * s * 0.05; ctx.beginPath(); ctx.moveTo(x0, y0); ctx.quadraticCurveTo(x0 + dir * s * 0.12, y0 - s * 0.02, x0 + dir * s * (0.2 + bk * 0.12), y0 + S(bk * 9 + i) * s * 0.02); ctx.stroke(); }
        ctx.restore();
        const R2 = R.Mg.transformPoint(new DOMPoint(R.axU[0] * R.al * 0.9, R.axU[1] * R.al * 0.9));
        for (let i = 0; i < 5; i++) { const q = cl(bk * 1.3 - i * 0.06); if (q <= 0 || q >= 1) continue; const x = R2.x + dir * (0.05 + q * (0.25 + i * 0.05)) * s, y = R2.y + (-0.04 + i * 0.02 + q * q * 0.25) * s;
          ctx.save(); ctx.globalAlpha *= 1 - q; ctx.fillStyle = ['#c8955a', '#a8743e', '#e0b47a'][i % 3]; ctx.translate(x, y); ctx.rotate(q * 9 + i); ctx.fillRect(-s * 0.012, -s * 0.006, s * 0.024, s * 0.012); ctx.restore(); }
      }
    } };
  };
  // 砍倒樹之後：蹲一下、蹦起來把斧頭高舉、落地、挺胸扛斧、閃光
  ACT.proud = (a, at) => {
    const L = 2.2;
    const P = track(at, [
      [0, {}],
      [0.2, { sy:-0.07, sx:0.05, dy:0.02, head:-0.1, th:-10, lean:-3 }, 'o'],
      [0.48, { sy:0.08, sx:-0.04, dy:-0.2, head:0.18, th:110, hx:0.0, hy:0.1, wr:-20, lean:6, armB:-0.45, tie:0.4, tail1:-0.2, tail2:-0.4 }, 'o3'],
      [0.62, { sy:0.04, sx:-0.02, dy:-0.17, head:0.16, th:112, hx:0.0, hy:0.1, wr:-20, lean:6, armB:-0.45, tie:0.35, tail1:-0.1, tail2:-0.2 }, 'l'],
      [0.78, { sy:-0.08, sx:0.06, dy:0.015, head:0.0, th:60, hx:-0.03, hy:0.1, wr:0, lean:2, armB:-0.2, tie:-0.1, tail1:0.15, tail2:0.3 }, 'i'],
      [1.0, { sy:0.02, sx:-0.01, dy:0, head:0.14, th:10, hx:-0.06, hy:0.12, wr:15, lean:7, armB:-0.12, tie:0.1 }, 'o'],
      [1.75, { sy:0.025, sx:-0.012, head:0.15, th:12, hx:-0.06, hy:0.13, wr:15, lean:7, armB:-0.12 }, 'l'],
      [2.0, { head:0.02, th:-4 }, 'io'],
      [L, {}, 'io'],
    ]);
    const chest = bell(at, 1.0, 1.75); P.sy += S(at * 9) * 0.006 * chest;
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const s = R.H, top = fp(R, 'top'), dir = a.faceRight ? 1 : -1;
      const tip = R.Mg.transformPoint(new DOMPoint(R.axU[0] * R.al, R.axU[1] * R.al));
      const sk = seg(at, 0.42, 1.0); if (sk > 0 && sk < 1) { sparkle(ctx, tip.x, tip.y, s * (0.03 + 0.05 * S(sk * PI)), S(sk * PI)); }
      for (let i = 0; i < 3; i++) { const k = seg(at, 1.0 + i * 0.15, 1.6 + i * 0.15); if (k > 0 && k < 1) sparkle(ctx, top.x + dir * s * (-0.3 + i * 0.3), top.y - s * (0.0 + i % 2 * 0.07) - k * s * 0.05, s * 0.035 * S(k * PI), S(k * PI)); }
      const g = R.G.transformPoint(new DOMPoint(0, 0)), lk = seg(at, 0.76, 1.2);
      if (lk > 0 && lk < 1) for (const sd of [-1, 1]) puff(ctx, g.x + sd * s * (0.12 + lk * 0.12), g.y - s * 0.02 - lk * s * 0.03, s * (0.05 + lk * 0.06), (1 - lk) * 0.8);
    } };
  };
  // 插斧頭的共用時間軸（給看手機、打瞌睡）：舉 → 劈進土裡（停格、塵）→ 放開
  function plantKeys(t0) {
    return [
      [0, {}],
      [t0 + 0.38, { th:62, lean:7, dx:-0.03, dy:-0.02, sx:-0.03, sy:0.04, head:0.05, bob:-0.6 }, 'o'],   // 舉起
      [t0 + 0.52, Object.assign({}, PLANT), 'i'],                                                      // 劈下去
    ];
  }
  // 看手機：插斧 → 從胸前口袋掏手機 → 低頭滑 →「叮」→ 讀到加班通知 → 大嘆一口氣 → 收手機 → 拔斧
  ACT.phone = (a, at) => {
    const L = 7.6, pk = plantKeys(0);
    const HOLD = { th:5, hx:0.18, hy:-0.12, head:-0.15, lean:-3, armB:0.05 };   // 手機拿在胸前
    const P = track(at, pk.concat([
      [0.75, Object.assign({}, PLANT), 'l'],                                                            // 停格
      [1.0, { th:-60, hx:-0.02, hy:0.02, lean:-6, dx:0.04, head:-0.06, bob:-0.3 }, 'io'],               // 放開斧頭，身子直起來
      [1.35, { th:-12, hx:0.3, hy:-0.1, lean:-4, dx:0.02, head:-0.12 }, 'io'],                          // 手伸到胸前口袋
      [1.85, HOLD, 'back'],                                                                              // 掏出來拿到面前
      [2.6, Object.assign({}, HOLD, { head:-0.16 }), 'l'],
      [2.75, Object.assign({}, HOLD, { head:-0.11, dy:-0.012, th:9, sy:0.015 }), 'o'],                           // 叮！嚇一下
      [3.1, Object.assign({}, HOLD, { head:-0.17 }), 'io'],
      [4.2, Object.assign({}, HOLD, { head:-0.2, th:3 }), 'l'],                                        // 讀
      [4.65, Object.assign({}, HOLD, { head:0.06, sy:0.05, dy:-0.025, lean:3, th:2, hy:-0.14 }), 'io'],          // 吸一大口氣
      [5.4, Object.assign({}, HOLD, { head:-0.24, sy:-0.06, sx:0.03, dy:0.025, lean:-7, th:-8, hy:-0.16, armB:0.12, tie:-0.15 }), 'o'], // 唉——整個人垮掉
      [5.7, Object.assign({}, HOLD, { head:-0.22, sy:-0.05, sx:0.025, dy:0.02, lean:-6, th:-8, hy:-0.16, armB:0.12 }), 'l'],
      [6.05, { th:-12, hx:0.3, hy:-0.1, lean:-4, dx:0.02, head:-0.1 }, 'io'],                        // 收回口袋
      [6.45, { th:-60, hx:-0.02, hy:0.02, lean:-6, dx:0.04, head:-0.04, bob:-0.6 }, 'io'],
      [6.8, Object.assign({}, PLANT, { head:-0.06 }), 'io'],                                            // 握回斧頭
      [6.95, Object.assign({}, PLANT, { sy:-0.07, sx:0.05, dy:0.04, head:-0.06 }), 'io'],             // 蹲低使力
      [7.15, { th:20, lean:4, dy:-0.03, sy:0.05, sx:-0.03, head:0.06 }, 'o3'],                          // 拔出來
      [L, {}, 'io'],
    ]));
    const hasAxeInHand = at < 0.75 || at >= 6.8;
    const ph = at < 1.35 ? 0 : at < 1.6 ? E.o((at - 1.35) / 0.25) : at < 5.85 ? 1 : at < 6.05 ? 1 - E.i((at - 5.85) / 0.2) : 0;
    // 滑手機的小動作
    const scroll = bell(at, 1.9, 2.6) + bell(at, 3.1, 4.2);
    P.th += S(at * 9) * 1.5 * scroll;
    return { P, st:{ axe:hasAxeInHand ? 'hand' : 'plant', plantM:plantM(a), phone:ph, glow:ph * (0.6 + 0.4 * bell(at, 2.6, 3.0)), phoneRot:-15 }, L, fx:(ctx, R) => {
      const s = R.H, dir = a.faceRight ? 1 : -1;
      plantFx(ctx, a, R, at, 0.52);
      if (at > 6.95 && at < 7.6) { const k = seg(at, 7.0, 7.5), g = R.G.multiply(plantM(a)).transformPoint(new DOMPoint(R.axU[0] * R.al, R.axU[1] * R.al)); puff(ctx, g.x, g.y - s * 0.02 - k * s * 0.04, s * (0.05 + k * 0.06), (1 - k) * 0.8); }
      // 叮！
      const pp = R.Ma.translate((FIST[0] - LD().pivot[0]) * R.W, (FIST[1] - LD().pivot[1]) * R.H).transformPoint(new DOMPoint(0, -s * 0.15));
      const dk = seg(at, 2.6, 3.6);
      if (dk > 0 && dk < 1 && ok('afu__ring')) { const I = SPR.afu__ring, sc = s * 0.14 / I.naturalHeight * (1 + 0.15 * S(dk * 30)); ctx.save(); ctx.globalAlpha *= cl((1 - dk) * 3); ctx.translate(pp.x + dir * s * 0.02, pp.y - s * 0.02); if (dir < 0) ctx.scale(-1, 1); ctx.drawImage(I, 0, -I.naturalHeight * sc * 0.6, I.naturalWidth * sc, I.naturalHeight * sc); ctx.restore(); }
      const top = fp(R, 'top'), bk = cl(bell(at, 2.6, 3.4) * 3), bx = top.x + dir * s * 0.34, by = top.y - s * 0.02;
      if (bk > 0) { const pop = at < 2.8 ? E.back(seg(at, 2.6, 2.8)) : 1; ctx.save(); ctx.translate(bx, by); ctx.scale(pop, pop); say(ctx, '叮！', 0, 0, s * 0.13, '#d8402e', bk, -dir * s * 0.1, s * 0.2); ctx.restore(); }
      // 讀到的訊息（小卡片從手機上浮起來）
      const mk = cl(bell(at, 3.3, 4.8) * 3);
      if (mk > 0) { const cx = pp.x + dir * Math.max(s * 0.5, 38), y = pp.y - s * (0.12 + seg(at, 3.3, 3.6) * 0.05); say(ctx, '老闆：今晚加班', cx, y, s * 0.1, '#3a2a2e', mk, pp.x + dir * s * 0.08, pp.y - s * 0.02); }
      // 唉——
      const m = fp(R, 'mouth'), sk = seg(at, 4.7, 5.9);
      puff(ctx, m.x + dir * s * (0.12 + sk * 0.2), m.y + s * 0.05 + sk * s * 0.06, s * (0.05 + sk * 0.07), bell(at, 4.7, 5.9), 'rgba(225,235,240,.9)');
      crayonText(ctx, '唉——', m.x + dir * s * (0.5 + sk * 0.08), m.y - s * 0.12 + sk * s * 0.04, s * 0.17, '#cfe0ff', cl(bell(at, 4.75, 6.1) * 2));
    } };
  };
  function plantFx(ctx, a, R, at, tHit) { // 斧頭吃進土：塵土＋裂土
    const s = R.H, g = R.G.multiply(plantM(a)).transformPoint(new DOMPoint(R.axU[0] * R.al, R.axU[1] * R.al));
    const k = seg(at, tHit, tHit + 0.55);
    if (k > 0 && k < 1) { for (const sd of [-1, 1]) puff(ctx, g.x + sd * s * (0.05 + k * 0.1), g.y - s * 0.02 - k * s * 0.05, s * (0.04 + k * 0.06), (1 - k) * 0.9); lines(ctx, g.x, g.y - s * 0.02, s * 0.14, 5, -PI * 0.95, -PI * 0.05, cl((0.25 - k) * 4), '#fff1c8'); }
    if (at >= tHit) { ctx.save(); ctx.globalAlpha *= 0.8; ctx.strokeStyle = 'rgba(30,22,18,.75)'; ctx.lineWidth = Math.max(1, s * 0.012); ctx.lineCap = 'round';
      ctx.beginPath(); ctx.moveTo(g.x - s * 0.07, g.y + s * 0.005); ctx.quadraticCurveTo(g.x, g.y - s * 0.012, g.x + s * 0.07, g.y + s * 0.005); ctx.stroke(); ctx.restore(); }
  }
  // 打瞌睡：插斧 → 撐在斧頭上 → 頭一點一點、鼻涕泡一大一小、Zzz（一直睡到被叫醒）
  ACT.doze = (a, at, t) => {
    const pk = plantKeys(0), LEAN = Object.assign({}, PLANT, { head:-0.22, msy:-0.025, tail1:0.12, tail2:0.2, tie:-0.12 });
    let P = track(at, pk.concat([
      [0.75, Object.assign({}, PLANT), 'l'],
      [1.8, LEAN, 'io'],
    ]));
    const sl = cl((at - 1.6) / 0.8);  // 睡著了
    // 呼吸（慢）＋點頭：慢慢垂下去，猛地一抬，又垂下去
    const br = S(at * 1.6), nodP = ((at - 1.8) % 5.2 + 5.2) % 5.2, nod = nodP < 4.3 ? E.io(nodP / 4.3) : 1 - E.back(cl((nodP - 4.3) / 0.35));
    P.msy += br * 0.012 * sl; P.head += (-0.1 * nod + br * 0.015) * sl; P.tie += S(at * 2) * 0.05 * sl; P.tail2 += S(at * 1.2) * 0.08 * sl;
    return { P, st:{ axe:'hand', plantM:plantM(a) }, fx:(ctx, R) => {
      const s = R.H, dir = a.faceRight ? 1 : -1;
      plantFx(ctx, a, R, at, 0.52);
      if (sl <= 0) return;
      const n = fp(R, 'nose'), r = s * (0.025 + 0.045 * (0.5 + 0.5 * br)) * sl * (nodP > 4.3 && nodP < 4.5 ? 0.6 : 1);
      snot(ctx, n.x + dir * r * 0.55, n.y + r * 0.75, r, sl);
      const top = fp(R, 'top');
      for (let i = 0; i < 3; i++) { const k = ((at * 0.45 + i / 3) % 1); crayonText(ctx, i === 1 ? 'Z' : 'z', top.x - dir * s * (0.3 + k * 0.25) + S(k * 6 + i) * s * 0.03, top.y + s * 0.02 - k * s * 0.4, s * (0.1 + k * 0.08), '#e8e4ff', S(k * PI) * sl, -0.25 * dir); }
    } };
  };
  // 被叫醒：鼻涕泡「啵」破掉 → 驚跳起來（斧頭一把拔出）→ 落地東張西望 → 抹抹嘴
  ACT.wake = (a, at) => {
    const L = 2.4;
    const SLEEP = Object.assign({}, PLANT, { head:-0.28, msy:-0.025, tail1:0.12, tail2:0.2, tie:-0.12 });
    const P = track(at, [
      [0, SLEEP],
      [0.12, Object.assign({}, SLEEP, { head:-0.3, sy:-0.07, sx:0.04 }), 'o'],                              // 縮
      [0.36, { th:70, hx:0.02, hy:0.05, lean:-8, dy:-0.24, sy:0.1, sx:-0.06, head:0.2, armB:-0.6, tie:0.5, tail1:-0.3, tail2:-0.5 }, 'o3'], // 彈起來
      [0.55, { th:60, lean:-4, dy:-0.2, sy:0.05, sx:-0.03, head:0.16, armB:-0.5, tie:0.4, tail1:-0.15, tail2:-0.3 }, 'l'],
      [0.75, { th:10, dy:0.01, sy:-0.08, sx:0.06, head:-0.04, armB:0.1, tie:-0.2, tail1:0.2, tail2:0.35 }, 'i'],                          // 落地
      [0.95, { th:4, head:0.06, sy:0.01 }, 'o'],
      [1.25, { th:4, head:-0.17, dx:0.03, lean:-3, armB:0.1 }, 'io'],                                        // 往前看
      [1.65, { th:4, head:0.18, lean:4, dx:-0.01, armB:-0.1 }, 'io'],                                                             // 右看
      [2.0, { th:0, head:0.0 }, 'io'],
      [L, {}, 'io'],
    ]);
    const sh = bell(at, 0.4, 1.0); P.lean += S(at * 50) * 1.5 * sh;
    return { P, st:{ axe:'hand' }, L, fx:(ctx, R) => {
      const s = R.H, dir = a.faceRight ? 1 : -1, n = fp(R, 'nose');
      // 泡泡破掉
      const pk = seg(at, 0, 0.18); if (pk < 1) { if (at < 0.06) snot(ctx, n.x + dir * s * 0.035, n.y + s * 0.05, s * 0.07 * (1 + at * 3), 1); else lines(ctx, n.x + dir * s * 0.035, n.y + s * 0.05, s * 0.1 * (0.7 + pk), 7, 0, PI * 2, 1 - pk, 'rgba(200,236,252,.95)'); }
      crayonText(ctx, '啵', n.x + dir * s * 0.18, n.y + s * 0.02 - pk * s * 0.05, s * 0.13, '#cdeeff', cl(bell(at, 0.02, 0.5) * 2));
      const top = fp(R, 'top'), ek = seg(at, 0.25, 0.4);
      crayonText(ctx, '！', top.x + dir * s * 0.18, top.y - s * 0.08, s * 0.28 * (at < 0.4 ? E.back(ek) : 1), '#ff6a4a', cl(bell(at, 0.22, 1.4) * 2.5));
      lines(ctx, top.x, top.y + s * 0.12, s * 0.3, 7, -PI * 0.95, -PI * 0.05, cl(bell(at, 0.25, 0.6) * 2), '#fff3c4', Math.max(1, s * 0.012));
      for (let i = 0; i < 2; i++) { const k = seg(at, 0.35 + i * 0.1, 0.9 + i * 0.1); if (k > 0 && k < 1) drop(ctx, top.x - dir * s * (0.25 + i * 0.05) - dir * k * s * 0.12, top.y + s * (0.2 + i * 0.06) + k * k * s * 0.2, s * 0.022, -dir * 0.6, 1 - k); }
      const g = R.G.multiply(plantM(a)).transformPoint(new DOMPoint(R.axU[0] * R.al, R.axU[1] * R.al)), dk = seg(at, 0.12, 0.6);
      if (dk > 0 && dk < 1) for (const sd of [-1, 1]) puff(ctx, g.x + sd * s * (0.05 + dk * 0.1), g.y - s * 0.02 - dk * s * 0.06, s * (0.04 + dk * 0.07), (1 - dk) * 0.85);
      const lk = seg(at, 0.72, 1.2), g0 = R.G.transformPoint(new DOMPoint(0, 0));
      if (lk > 0 && lk < 1) for (const sd of [-1, 1]) puff(ctx, g0.x + sd * s * (0.12 + lk * 0.1), g0.y - s * 0.02, s * (0.04 + lk * 0.05), (1 - lk) * 0.7);
    } };
  };
  // 站著（沒事做時的底）
  ACT.idle = () => ({ P:Z(), st:{ axe:'hand' } });
  // ---------- 註冊到 DAILY ----------
  const BLEND = 0.28;
  function drawAct(name, ctx, a) {
    if (!ok('afu__body') || !ok('afu__arm') || !(ok('afu__axe') || ok('afu__wpn')) || a.type !== 'afu' || typeof LIMBS_DATA === 'undefined') return false;
    const o = a.o, t = o.t || 0, at = o.at || 0, m = mem(a);
    const r = ACT[name](a, at, t);
    let P = addP(rest(t), r.P), st = r.st;
    // 換動作：從上一個動作最後的姿勢淡入（斧頭從插在地上回到手上、手機收掉）
    if (m.name !== name) { if (m.P) { m.from = m.P; m.fromSt = m.st; m.fromT = t; m.fromAt = at; } m.name = name; }
    const bk = m.from ? cl((t - m.fromT) / BLEND) : 1;
    if (m.from && bk < 1) {
      const k = E.io(bk); P = lerpP(m.from, P, k);
      if (m.fromSt && m.fromSt.axe === 'plant' && st.axe === 'hand') st = Object.assign({}, st, { axe:'hand', axeBlend:{ M:m.fromSt.plantM, k } });
      if (m.fromSt && m.fromSt.phone > 0 && !(st.phone > 0)) st = Object.assign({}, st, { phone:m.fromSt.phone * (1 - k) });
    } else m.from = null;
    m.P = P; m.st = st;
    // 速度（給石頭擺在前方路上）
    if (m.lx != null && t > m.lt) { const k = cl((t - m.lt) * 6); m.vx = (m.vx || 0) * (1 - k) + (a.x - m.lx) / (t - m.lt) * k; m.vy = (m.vy || 0) * (1 - k) + (a.y - m.ly) / (t - m.lt) * k; }
    m.lx = a.x; m.ly = a.y; m.lt = t;
    if (r.stone) drawStone(ctx, a, r.stone, m);
    if (st.axeBlend) return renderBlendAxe(ctx, a, P, st, t, r);
    const R = render(ctx, a, P, st, t);
    if (r.fx) { ctx.save(); r.fx(ctx, R); ctx.restore(); }
    return true;
  }
  // 斧頭插著的時候被打斷（去走路）：斧頭從地上飛回手裡（短短 0.28 秒，把矩陣內插）
  function renderBlendAxe(ctx, a, P, st, t, r) {
    const s2 = Object.assign({}, st, { axe:'none' }), R = render(ctx, a, P, s2, t);
    const A = R.G.multiply(st.axeBlend.M), B = R.Mg, k = st.axeBlend.k;
    const ang = (m) => Math.atan2(m.b, m.a), a0 = ang(A), a1 = ang(B); let da = a1 - a0; while (da > PI) da -= 2 * PI; while (da < -PI) da += 2 * PI;
    const sxA = Math.hypot(A.a, A.b) * Math.sign(A.a * A.d - A.b * A.c), an = a0 + da * k, sc = Math.hypot(A.a, A.b) + (Math.hypot(B.a, B.b) - Math.hypot(A.a, A.b)) * k;
    const det = Math.sign(B.a * B.d - B.b * B.c); void sxA;
    const Mx = new DOMMatrix([Math.cos(an) * sc, Math.sin(an) * sc, -Math.sin(an) * sc * det, Math.cos(an) * sc * det, A.e + (B.e - A.e) * k, A.f + (B.f - A.f) * k]);
    const base = ctx.getTransform(), wp = WP(); ctx.save(); ctx.setTransform(base.multiply(Mx)); ctx.drawImage(AXE(), -wp.grip[0] * R.ww, -wp.grip[1] * R.wh, R.ww, R.wh); ctx.restore();
    ctx.save(); ctx.setTransform(base.multiply(R.Ma)); const c = LD(); ctx.drawImage(SPR.afu__arm, -c.pivot[0] * R.W, -c.pivot[1] * R.H, R.W, R.H); ctx.restore();
    if (r.fx) { ctx.save(); r.fx(ctx, R); ctx.restore(); }
    return true;
  }
  // 跳過的小石頭（蠟筆畫的一顆石子）：位置記在世界座標，阿福走過去它不跟著動
  const stones = {};
  function drawStone(ctx, a, st, m) {
    const key = a.o.hid || 'hero', H = a.H;
    let s = stones[key];
    // 第一次出現：擺在前面路上，阿福剛好在跳到最高時經過（速度 × 還要多久）
    if (!s || st.k < s.k - 0.01) { const T = (0.45 - st.k) * 0.55, vx = m.vx || 0, vy = m.vy || 0, sp = Math.hypot(vx, vy);
      const dx = sp > 3 ? vx * T : (a.faceRight ? 1 : -1) * H * 0.3, dy = sp > 3 ? vy * T : 0; s = stones[key] = { x:a.x + dx, y:a.y + dy + H * 0.01, k:st.k }; }
    s.k = st.k;
    const al = cl(1 - Math.abs(st.k - 0.2) / 1.4) * cl((1.6 - st.k) * 3);
    if (al <= 0) return;
    ctx.save(); ctx.globalAlpha *= al; ctx.translate(s.x, s.y); ctx.scale(1.35, 1.35);
    ctx.fillStyle = 'rgba(0,0,0,.28)'; ctx.beginPath(); ctx.ellipse(0, H * 0.012, H * 0.07, H * 0.02, 0, 0, 7); ctx.fill();
    ctx.beginPath(); ctx.moveTo(-H * 0.06, 0); ctx.quadraticCurveTo(-H * 0.055, -H * 0.05, -H * 0.01, -H * 0.055); ctx.quadraticCurveTo(H * 0.05, -H * 0.05, H * 0.06, -H * 0.005); ctx.quadraticCurveTo(0, H * 0.012, -H * 0.06, 0); ctx.closePath();
    ctx.fillStyle = '#86828a'; ctx.fill(); ctx.lineWidth = Math.max(0.8, H * 0.012); ctx.strokeStyle = '#2a2428'; ctx.stroke();
    ctx.fillStyle = 'rgba(255,255,255,.18)'; ctx.beginPath(); ctx.ellipse(-H * 0.015, -H * 0.035, H * 0.025, H * 0.01, -0.2, 0, 7); ctx.fill();
    ctx.restore();
  }
  for (const n in ACT) DAILY['hero_' + n] = (ctx, a) => drawAct(n, ctx, a);
  // ---------- 村裡的小排程：站著沒事 → 隨機挑一個（有權重、有冷卻），走路／幹活就停 ----------
  const LEN = { yawn:3.6, stretch:3.6, scratch:3.0, tap:3.4, sweat:2.8, dust:3.0, proud:2.2, phone:7.6, wake:2.4 };
  const PICK = [['yawn', 3], ['stretch', 2], ['phone', 2.2], ['scratch', 2], ['tap', 2], ['doze', 1.4]];
  const COOL = { yawn:25, stretch:30, phone:35, scratch:22, tap:22, doze:50, sweat:10, dust:10 };
  const Q = { cur:null, at:0, idle:0, next:4, cool:{}, last:null, walkT:0, prevProud:0, hadAct:false, lastKind:null, dozeEnd:0, after:null };
  function start(n) { Q.cur = n; Q.at = 0; if (COOL[n]) Q.cool[n] = COOL[n] * (0.8 + Math.random() * 0.5); Q.last = n; if (n === 'doze') Q.dozeEnd = 14 + Math.random() * 10; }
  function stop() { Q.cur = null; Q.at = 0; Q.idle = 0; Q.next = 3 + Math.random() * 4; }
  function update(V, dt) {
    const H = V.hero;
    for (const k in Q.cool) Q.cool[k] -= dt;
    // 幹完活：砍倒樹／收割（proudT 剛亮起）→ 得意，接著擦汗或拍灰；做完木板／壽包 → 拍灰或擦汗
    const pr = V.proudT || 0, ak = H.act ? H.act.kind : null;
    if (pr > 0 && Q.prevProud <= 0) { start('proud'); Q.after = Q.lastKind === 'tree' ? (Math.random() < 0.65 ? 'sweat' : null) : (Math.random() < 0.6 ? 'dust' : 'sweat'); }
    else if (Q.hadAct && !ak && !H.walking && !H.target && Q.lastKind === 'craft') start(Math.random() < 0.65 ? 'dust' : 'sweat');
    Q.prevProud = pr; Q.hadAct = !!ak; if (ak) Q.lastKind = ak;
    if (H.walking) { if (Q.cur) { Q.cur = null; } Q.walkT += dt; Q.idle = 0; return; }
    Q.walkT = 0;
    if (H.act) { Q.cur = null; Q.idle = 0; return; }
    if (Q.cur) {
      Q.at += dt;
      if (Q.cur === 'doze') { if (Q.at > 1.8 + Q.dozeEnd) start('wake'); return; }
      if (Q.at >= LEN[Q.cur]) { const nx = Q.after; Q.after = null; if (nx && Q.cur === 'proud') start(nx); else stop(); }
      return;
    }
    Q.idle += dt;
    if (Q.idle >= Q.next && !(typeof Story !== 'undefined' && Story.busy && Story.busy())) {
      const c = PICK.filter(([n]) => !(Q.cool[n] > 0) && n !== Q.last && (n !== 'doze' || Q.idle > 8));
      if (!c.length) { Q.next = Q.idle + 2; return; }
      let r = Math.random() * c.reduce((s, x) => s + x[1], 0); for (const [n, w] of c) { if ((r -= w) <= 0) { start(n); break; } }
    }
  }
  // 點畫面：睡著時點到阿福 → 驚醒（不走過去）；點別的地方 → 一樣驚醒，再走過去
  function tap(V, x, y) {
    const H = V.hero;
    if (Q.cur === 'doze' && Q.at > 0.75) { start('wake'); return Math.hypot(x - H.x, y - (H.y - 22)) < 40; }
    return false;
  }
  // 給 drawChar 的參數
  function opts(V) {
    const H = V.hero;
    if (H.walking) return { act:'hero_walk', at:Q.walkT };
    if (H.act) return null;
    if (Q.cur) return { act:'hero_' + Q.cur, at:Q.at };
    return { act:'hero_idle', at:Q.idle };
  }
  return { update, tap, opts, ACT, LEN, Q, rest, track, render };
})();
