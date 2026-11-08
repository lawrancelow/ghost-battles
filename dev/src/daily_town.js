// 平日動作：冥街夜市（店主做生意、閒鬼逛街）＋回陽間（四個活人沒被嚇的時候在幹嘛）
// 全部用原圖：身體 = 原圖拆掉手的那張（MeshAnim 網格變形：頭、腿、尾巴、呼吸），手 = 原圖拆出來的件（繞關節轉），
// 道具 = 現成的原圖件（furnace__paper、afu__phone、bun__basket…）或從背景圖切出來的（street_strainer、street_lanternW/R，art/cuttown.py）。
// 汗、Zzz、熱氣、水滴、亮點、字 = 程式畫的蠟筆小特效。
// DAILY['town_xxx'](ctx, a)：a.o.at = 這個動作做了幾秒、a.o.adur = 這次做多久（頭尾 0.35 秒自己淡入淡出回原圖姿勢）、
// a.o.aw = 外面給的權重（0 = 完全回到原圖姿勢，給「被嚇到時平滑接回去」用）、a.o.walk = 邊走邊做、a.o.prop = 道具／場景資料。
const TOWN = (() => {
  const PI = Math.PI, D = PI / 180;
  const cl = (v, a = 0, b = 1) => v < a ? a : v > b ? b : v, lerp = (a, b, k) => a + (b - a) * k;
  const ss = (t) => { t = cl(t); return t * t * (3 - 2 * t); };
  const seg = (t, a, b) => cl((t - a) / (b - a));
  const eo = (t) => 1 - (1 - cl(t)) * (1 - cl(t)), eo3 = (t) => 1 - Math.pow(1 - cl(t), 3);
  const bump = (t, a, m, b) => t <= a || t >= b ? 0 : t < m ? ss((t - a) / (m - a)) : 1 - ss((t - m) / (b - m));
  // 關鍵格（cos 緩動）：K = [[時間, 值], ...]
  const kf = (K, t) => { if (t <= K[0][0]) return K[0][1]; for (let i = 1; i < K.length; i++) if (t <= K[i][0]) { const a = K[i - 1], b = K[i], q = (t - a[0]) / (b[0] - a[0]); return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * Math.cos(PI * q)); } return K[K.length - 1][1]; };
  const rnd = (s) => { const x = Math.sin(s * 127.1 + 311.7) * 43758.5453; return x - Math.floor(x); };
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const FONT = '"Noto Sans CJK TC","Noto Sans TC","PingFang TC","Microsoft JhengHei",sans-serif';

  // ---------- 畫一個角色：開始（原點 = 腳底中央，原圖方向，不翻；最後依面向整個翻）----------
  // nr = 原圖面朝右。fs = 「往前」在原圖 x 的方向（往前低頭 = rotate(fs*角度)）
  function begin(ctx, a, key, nr, opt) {
    if (!ok(key) || typeof MeshAnim === 'undefined') return null;
    const img = SPR[key], o = a.o, t = o.t || 0, H = a.H, W = H * img.naturalWidth / img.naturalHeight;
    const at = o.at || 0, dur = o.adur || 0;
    let env = ss(at / 0.35); if (dur) env = Math.min(env, ss((dur - at) / 0.35));
    if (o.aw != null) env *= cl(o.aw);
    if (o.shadow !== false && a.shadow) a.shadow(a.x);
    const z = MeshAnim.ANIM.idle(t);
    const flip = a.faceRight !== !!nr;
    ctx.save();
    const fy = a.solid ? 0 : -(3 + Math.sin(t * 2.4) * 2) * (a.s || a.H / 60);
    ctx.translate(a.x, a.y + fy); if (flip) ctx.scale(-1, 1);
    ctx.translate(0, (opt && opt.noLift ? 0 : z.y) * H); ctx.scale(z.sx, z.sy);
    return { ctx, a, o, t, at, dur, env, H, W, z, flip, fs:nr ? 1 : -1, P:(u, v) => [(u - 0.5) * W, (v - 1) * H], walk:!!o.walk };
  }
  const end = (S) => S.ctx.restore();
  // 網格身體的姿勢：沿用待機的頭、尾巴、頭髮晃動；手臂骨、身體骨歸零（拆出來的件才接得上）
  function mpose(S, add) {
    const z = Object.assign({}, S.walk ? MeshAnim.ANIM.walk(S.t) : S.z);
    z.armF = 0; z.armB = 0; z.axe = 0; z.body = 0; z.x = 0; z.y = 0; z.sx = 1; z.sy = 1; z.rot = 0;
    if (!S.walk) { z.legF = 0; z.legB = 0; }
    if (add) for (const k in add) z[k] = (z[k] || 0) + add[k];
    return z;
  }
  function body(S, rig, key, add) { MeshAnim.drawBody(S.ctx, rig, key, S.H, mpose(S, add)); }
  // 繞腰（離地 ly 倍身高）轉 ang、再位移
  function lean(S, ang, ly, dx, dy) { const c = S.ctx; c.translate(dx || 0, dy || 0); c.translate(0, -S.H * (ly || 0.35)); c.rotate(ang); c.translate(0, S.H * (ly || 0.35)); }
  // 整張原圖大小的切塊：支點 pv（原圖比例）放到 at（本地座標），轉 ang，縮放 sc
  function piece(S, key, pv, at, ang, sc, fn) {
    if (!ok(key)) return; const c = S.ctx; c.save(); c.translate(at[0], at[1]); c.rotate(ang || 0); if (sc) c.scale(sc, sc);
    c.drawImage(SPR[key], -pv[0] * S.W, -pv[1] * S.H, S.W, S.H);
    if (fn) fn((u, v) => [(u - pv[0]) * S.W, (v - pv[1]) * S.H]);
    c.restore();
  }
  // 道具（裁好的小圖）：寬 w，錨點 (ax,ay)（0~1），在 (x,y) 轉 ang
  function prop(ctx, key, x, y, w, ang, ax, ay, sx, sy) {
    if (!ok(key)) return; const im = SPR[key], h = w * im.naturalHeight / im.naturalWidth;
    ctx.save(); ctx.translate(x, y); ctx.rotate(ang || 0); ctx.scale(sx || 1, sy || 1); ctx.drawImage(im, -(ax == null ? 0.5 : ax) * w, -(ay == null ? 0.5 : ay) * h, w, h); ctx.restore();
  }
  // 點 (u,v) 繞 (pu,pv) 轉 ang 之後在哪（本地座標）
  const rotP = (S, pu, pv, at, ang, u, v) => { const x = (u - pu) * S.W, y = (v - pv) * S.H, c = Math.cos(ang), s = Math.sin(ang); return [at[0] + x * c - y * s, at[1] + x * s + y * c]; };

  // ---------- 蠟筆小特效 ----------
  function crayon(ctx, pts, w, col, out) {
    const path = () => { ctx.beginPath(); pts.forEach((p, i) => i ? ctx.lineTo(p[0], p[1]) : ctx.moveTo(p[0], p[1])); };
    ctx.lineCap = 'round'; ctx.lineJoin = 'round';
    if (out) { ctx.strokeStyle = out; ctx.lineWidth = w * 2; path(); ctx.stroke(); }
    ctx.strokeStyle = col; ctx.lineWidth = w; path(); ctx.stroke();
  }
  // 字：不跟著角色翻（翻了的話翻回來）
  function text(S, x, y, txt, size, alpha, opt) {
    if (alpha <= 0.01) return; const c = S.ctx; opt = opt || {};
    c.save(); c.translate(x, y); if (S.flip) c.scale(-1, 1); c.rotate(opt.rot || 0); c.globalAlpha *= cl(alpha);
    c.font = `900 ${size}px ${FONT}`; c.textAlign = 'center'; c.textBaseline = 'middle'; c.lineJoin = 'round';
    c.strokeStyle = opt.out || '#2a1a22'; c.lineWidth = size * 0.26; c.strokeText(txt, 0, 0);
    c.fillStyle = opt.col || '#fff3e8'; c.fillText(txt, 0, 0); c.restore();
  }
  function puff(ctx, x, y, r, k, seed, col) { // 一團呼出來的氣（幾圈小雲）
    if (k <= 0 || k >= 1) return; ctx.save(); ctx.globalAlpha *= Math.sin(k * PI) * 0.85;
    for (let i = 0; i < 3; i++) { const a = rnd(seed + i) * 6.28, rr = r * (0.45 + 0.4 * rnd(seed + i * 3)) * (0.6 + k * 0.6);
      const px = x + Math.cos(a) * r * 0.5 * k + i * r * 0.35 * k, py = y + Math.sin(a) * r * 0.3 - k * r * 0.4;
      ctx.fillStyle = col || 'rgba(245,245,250,.85)'; ctx.strokeStyle = 'rgba(60,60,80,.35)'; ctx.lineWidth = Math.max(1, r * 0.08);
      ctx.beginPath(); ctx.arc(px, py, rr, 0, PI * 2); ctx.fill(); ctx.stroke(); }
    ctx.restore();
  }
  function steamCurl(ctx, x, y, h, k, seed, a) { // 一縷熱氣
    if (k <= 0 || k >= 1) return; ctx.save(); ctx.globalAlpha *= Math.sin(k * PI) * (a || 0.75);
    const pts = []; for (let i = 0; i <= 10; i++) { const u = i / 10; pts.push([x + Math.sin(u * 5 + seed + k * 5) * h * 0.12, y - u * h * (0.4 + k * 0.6) - k * h * 0.3]); }
    crayon(ctx, pts, Math.max(1.4, h * 0.06), 'rgba(250,246,240,.9)', 'rgba(60,50,60,.25)'); ctx.restore();
  }
  function drop(ctx, x, y, r, k, fall) { // 一滴水往下掉
    if (k <= 0 || k >= 1) return; const py = y + fall * k * k; ctx.save(); ctx.globalAlpha *= 1 - k * 0.5;
    ctx.fillStyle = 'rgba(30,60,72,.9)'; ctx.beginPath(); ctx.ellipse(x, py, r * 1.2, r * 1.7, 0, 0, PI * 2); ctx.fill();
    ctx.fillStyle = 'rgba(165,215,232,.95)'; ctx.beginPath(); ctx.ellipse(x, py, r * 0.85, r * 1.3, 0, 0, PI * 2); ctx.fill(); ctx.restore();
  }
  function sparkle(ctx, x, y, r, k) { // 四角亮點（擦亮）
    if (k <= 0) return; ctx.save(); ctx.translate(x, y); ctx.scale(k, k); ctx.globalAlpha *= Math.min(1, k * 1.5);
    ctx.beginPath(); for (let i = 0; i < 8; i++) { const an = i / 8 * PI * 2, rr = i % 2 ? r * 0.22 : r; ctx.lineTo(Math.cos(an) * rr, Math.sin(an) * rr); }
    ctx.closePath(); ctx.fillStyle = '#fffbe8'; ctx.strokeStyle = 'rgba(90,70,20,.6)'; ctx.lineWidth = Math.max(1, r * 0.12); ctx.stroke(); ctx.fill(); ctx.restore();
  }
  function zzz(S, x, y, size, t, a) { // Zzz 往上飄
    for (let i = 0; i < 3; i++) { const q = ((t * 0.45 + i / 3) % 1); text(S, x + q * size * 1.2 + Math.sin(q * 6 + i) * size * 0.2, y - q * size * 2.2, i === 1 ? 'Z' : 'z', size * (0.6 + q * 0.6), a * Math.sin(q * PI), { col:'#dfe8ff', out:'#2a2a48' }); }
  }
  function marks(ctx, x, y, r, k, col) { // 驚訝／生氣的三條短線
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= k;
    for (let i = -1; i <= 1; i++) { const an = -PI / 2 + i * 0.55; crayon(ctx, [[x + Math.cos(an) * r * 0.55, y + Math.sin(an) * r * 0.55], [x + Math.cos(an) * r, y + Math.sin(an) * r]], Math.max(1.5, r * 0.12), col || '#fff2c0', 'rgba(40,20,20,.6)'); }
    ctx.restore();
  }
  function anger(ctx, x, y, r, k) { // 生氣青筋（十字）
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= k; ctx.translate(x, y); ctx.scale(0.7 + 0.3 * k, 0.7 + 0.3 * k);
    for (let i = 0; i < 4; i++) { ctx.save(); ctx.rotate(i * PI / 2 + PI / 4); crayon(ctx, [[r * 0.2, -r * 0.35], [r * 0.55, -r * 0.1], [r * 0.55, r * 0.3]], Math.max(1.5, r * 0.2), '#e8333a', 'rgba(60,0,0,.5)'); ctx.restore(); }
    ctx.restore();
  }

  // ======================================================================
  // 回陽間・阿Ken：右手前臂（npc_ken__fore）繞手肘轉；手機在另一隻手（身體上）
  // ======================================================================
  const KEN = { ELB:[0.69, 0.565], HAND:[0.33, 0.50], MOUTH:[0.37, 0.355], EYE:[0.43, 0.305], PHONE:[0.16, 0.43] };
  // k: 0 = 原位；ang = 前臂往上轉（弧度，正 = 手往上抬）；lift = 手肘一起抬多少（佔身高）
  function kenDraw(S, P) {
    const c = S.ctx;
    c.save(); lean(S, P.lean || 0, 0.35);
    body(S, 'npc_ken', 'npc_ken__bodyF', { head:P.head || 0, legF:P.legF || 0, legB:P.legB || 0 });
    const e = S.P(...KEN.ELB);
    piece(S, 'npc_ken__fore', KEN.ELB, [e[0] + (P.fx || 0) * S.H, e[1] - (P.lift || 0) * S.H], P.ang || 0, P.sc || 1);
    c.restore();
  }
  const kenFace = (S, P) => { const l = P.lean || 0, p = S.P(0.40, 0.33); const r = [p[0], p[1] + S.H * 0.35]; const cs = Math.cos(l), sn = Math.sin(l); return [r[0] * cs - r[1] * sn, r[0] * sn + r[1] * cs - S.H * 0.35]; };
  // 滑手機：拇指一下一下往上滑（前臂跟著輕輕抖），頭跟著內容點一點
  DAILY.town_ken_scroll = function (ctx, a) {
    const S = begin(ctx, a, 'npc_ken__bodyF', false); if (!S) return false;
    const k = S.env, q = (S.at % 1.1) / 1.1, fl = bump(q, 0.55, 0.66, 0.85);
    kenDraw(S, { ang:k * (0.035 * fl + 0.01 * Math.sin(S.at * 1.7)), head:k * S.fs * (0.05 + 0.02 * fl), lean:k * S.fs * 0.02 });
    // 拇指滑過螢幕的小弧線
    if (fl > 0.2) { const h = S.P(0.30, 0.445); ctx.save(); ctx.globalAlpha *= k * fl * 0.7; crayon(ctx, [[h[0] - S.W * 0.05, h[1] + S.H * 0.012], [h[0], h[1] - S.H * 0.004], [h[0] + S.W * 0.04, h[1] - S.H * 0.02]], Math.max(1, S.H * 0.008), 'rgba(255,255,255,.9)'); ctx.restore(); }
    end(S); return true;
  };
  // 打呵欠：吸氣伸懶腰、頭往後仰、手摀嘴、眼角擠出一滴淚，「哈～」，放下來甩甩頭
  DAILY.town_ken_yawn = function (ctx, a) {
    const S = begin(ctx, a, 'npc_ken__bodyF', false); if (!S) return false;
    const t = S.at, k = S.env;
    const up = kf([[0, 0], [0.7, 1], [2.2, 1], [2.8, 0]], t), back = kf([[0, 0], [0.5, 0.3], [0.9, 1], [2.0, 1], [2.6, 0], [2.9, -0.25], [3.2, 0]], t);
    const sy = 1 + 0.045 * kf([[0, 0], [0.6, 1], [1.9, 1.15], [2.6, 0], [2.9, -0.3], [3.3, 0]], t) * k;
    ctx.save(); ctx.scale(1 / Math.sqrt(sy), sy);
    kenDraw(S, { ang:k * up * 0.62, lift:k * up * 0.035, fx:k * up * 0.02, sc:1 + 0.05 * up * k, head:-S.fs * k * back * 0.16 + S.fs * k * 0.05 * Math.sin(Math.max(0, t - 2.6) * 18) * seg(t, 2.6, 2.75) * (1 - seg(t, 2.95, 3.2)), lean:-S.fs * k * back * 0.03 });
    ctx.restore();
    const f = kenFace(S, {}), hk = bump(t, 0.6, 1.0, 2.3) * k;
    text(S, f[0] - S.fs * S.H * 0.32, f[1] - S.H * 0.25 - hk * S.H * 0.04, '哈～', S.H * 0.11, hk, { rot:-0.1 });
    // 眼淚
    const tk = bump(t, 1.2, 1.6, 2.8) * k; if (tk > 0) { const e = S.P(0.25, 0.33); ctx.save(); ctx.globalAlpha *= tk; ctx.fillStyle = 'rgba(170,220,255,.95)'; ctx.strokeStyle = 'rgba(40,70,110,.6)'; ctx.lineWidth = 1; ctx.beginPath(); ctx.ellipse(e[0], e[1] + tk * S.H * 0.01, S.H * 0.008, S.H * 0.012, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); ctx.restore(); }
    end(S); return true;
  };
  // 揉眼睛：手背頂著眼鏡下面揉幾圈，頭低一點湊過去
  DAILY.town_ken_rub = function (ctx, a) {
    const S = begin(ctx, a, 'npc_ken__bodyF', false); if (!S) return false;
    const t = S.at, k = S.env, up = kf([[0, 0], [0.6, 1], [2.2, 1], [2.8, 0]], t), rb = seg(t, 0.6, 2.2) * (1 - seg(t, 2.1, 2.3));
    const wig = Math.sin(t * 15) * rb;
    kenDraw(S, { ang:k * (up * 0.8 + wig * 0.035), lift:k * (up * 0.10 + Math.cos(t * 15) * rb * 0.006), fx:k * up * 0.03, sc:1 + 0.06 * up * k, head:S.fs * k * up * 0.09, lean:S.fs * k * up * 0.025 });
    end(S); return true;
  };
  // 對著螢幕嘆氣：吸一口氣（肩膀上去），呼出來（垂肩、低頭、手機手往下掉一點），「唉……」
  DAILY.town_ken_sigh = function (ctx, a) {
    const S = begin(ctx, a, 'npc_ken__bodyF', false); if (!S) return false;
    const t = S.at, k = S.env, inh = kf([[0, 0], [0.7, 1], [1.0, 1], [1.5, -0.6], [2.6, -0.5], [3.0, 0]], t);
    ctx.save(); ctx.scale(1, 1 + 0.03 * inh * k);
    kenDraw(S, { ang:k * (0.05 * inh), head:S.fs * k * (-0.05 * Math.max(0, inh) + 0.14 * Math.max(0, -inh)), lean:S.fs * k * 0.03 * Math.max(0, -inh) });
    ctx.restore();
    const f = kenFace(S, {});
    puff(ctx, f[0] + S.fs * S.H * 0.04, f[1] + S.H * 0.06, S.H * 0.05, seg(t, 1.0, 2.2), 3.1);
    text(S, f[0] - S.fs * S.H * 0.30, f[1] - S.H * 0.22, '唉……', S.H * 0.1, bump(t, 1.0, 1.4, 2.6) * k, { col:'#cfd8ff', out:'#1e2238' });
    end(S); return true;
  };

  // ======================================================================
  // 陳總：水晶球手（npc_boss__arm，繞手肘）＋手套手（npc_boss__point，繞肩膀），身體 npc_boss__bodyN
  // ======================================================================
  const BOSS = { EL:[0.23, 0.56], BALL:[0.12, 0.27], SH:[0.775, 0.475], HAND:[0.835, 0.75], WATCH:[0.80, 0.63], MOUTH:[0.39, 0.315] };
  function bossDraw(S, P, after) {
    const c = S.ctx; c.save(); lean(S, P.lean || 0, 0.35, P.dx || 0, 0);
    body(S, 'npc_boss', 'npc_boss__bodyN', { head:P.head || 0, legF:P.legF || 0, legB:P.legB || 0 });
    const sh = S.P(...BOSS.SH), el = S.P(...BOSS.EL);
    const gl = () => piece(S, 'npc_boss__point', BOSS.SH, [sh[0], sh[1] - (P.shUp || 0) * S.H], P.glove || 0, 1, P.gfn);
    if (P.gloveBack) gl();
    piece(S, 'npc_boss__arm', BOSS.EL, [el[0], el[1] - (P.elUp || 0) * S.H], P.ball || 0, 1, P.bfn);
    if (!P.gloveBack) gl();
    if (after) after();
    c.restore();
  }
  // 擦水晶球：舉近一點、對著它哈一口氣（球起霧），手指在球上轉圈擦，擦亮了「叮」一下，滿意點頭
  DAILY.town_boss_polish = function (ctx, a) {
    const S = begin(ctx, a, 'npc_boss__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env, near = kf([[0, 0], [0.6, 1], [3.1, 1], [3.6, 0]], t), rub = seg(t, 1.3, 2.7) * (1 - seg(t, 2.6, 2.8));
    let ballPos = null;
    bossDraw(S, { ball:k * (near * 0.13 + Math.sin(t * 13) * 0.03 * rub), elUp:k * near * 0.015, head:S.fs * k * (near * 0.1 - 0.06 * bump(t, 2.9, 3.1, 3.4)), lean:S.fs * k * near * 0.025,
      bfn:(L) => { const p = L(...BOSS.BALL); ballPos = [p[0], p[1]]; const fog = bump(t, 0.9, 1.25, 2.4) * k; if (fog > 0) { ctx.save(); ctx.globalAlpha *= fog * 0.55; ctx.fillStyle = 'rgba(235,240,250,.9)'; ctx.beginPath(); ctx.arc(p[0], p[1], S.W * 0.1, 0, PI * 2); ctx.fill(); ctx.restore(); }
        if (rub > 0) { ctx.save(); ctx.globalAlpha *= rub * k * 0.8; const r = S.W * 0.07, an = t * 13; crayon(ctx, [[p[0] + Math.cos(an) * r, p[1] + Math.sin(an) * r * 0.7], [p[0] + Math.cos(an + 0.9) * r, p[1] + Math.sin(an + 0.9) * r * 0.7]], Math.max(1, S.H * 0.008), 'rgba(255,255,255,.9)'); ctx.restore(); }
        sparkle(ctx, p[0] + S.W * 0.04, p[1] - S.W * 0.05, S.H * 0.05, bump(t, 2.75, 2.9, 3.4) * k); } });
    // 哈氣
    const m = S.P(...BOSS.MOUTH); puff(ctx, lerp(m[0], m[0] + S.fs * S.W * 0.12, seg(t, 0.75, 1.2)), m[1], S.H * 0.035, seg(t, 0.7, 1.3), 7.7);
    text(S, m[0] + S.fs * S.W * 0.42, m[1] - S.H * 0.06, '哈——', S.H * 0.085, bump(t, 0.7, 0.85, 1.3) * k);
    end(S); return true;
  };
  // 看錶：手套手抬到胸前，低頭看錶，不耐煩地點腳，「嘖」
  DAILY.town_boss_watch = function (ctx, a) {
    const S = begin(ctx, a, 'npc_boss__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env, up = kf([[0, 0], [0.5, 1], [2.2, 1], [2.7, 0]], t), flick = Math.sin(Math.max(0, t - 0.5) * 30) * bump(t, 0.5, 0.55, 0.75);
    const tap = Math.max(0, Math.sin(t * 9)) * seg(t, 1.2, 1.4) * (1 - seg(t, 2.3, 2.5));
    bossDraw(S, { glove:k * (up * 1.45 + flick * 0.05), shUp:k * up * 0.01, head:S.fs * k * up * 0.16, lean:S.fs * k * up * 0.02, legF:k * tap * 0.12 * -S.fs });
    const m = S.P(0.5, 0.0); text(S, m[0] - S.fs * S.W * 0.42, m[1] + S.H * 0.04, '嘖', S.H * 0.11, bump(t, 1.4, 1.6, 2.3) * k);
    end(S); return true;
  };
  // 罵電話：手機（afu__phone 原圖件）開擴音拿在嘴前大罵，青筋、震動、身體一下一下往前頂
  DAILY.town_boss_call = function (ctx, a) {
    const S = begin(ctx, a, 'npc_boss__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env, up = kf([[0, 0], [0.5, 1], [3.4, 1], [3.9, 0]], t), yell = seg(t, 0.8, 1.0) * (1 - seg(t, 3.2, 3.5));
    const jab = Math.max(0, Math.sin(t * 7.5)) * yell, sh = Math.sin(t * 40) * 0.008 * yell;
    bossDraw(S, { glove:k * (up * 1.75 + jab * 0.06), shUp:k * up * 0.03, head:S.fs * k * (up * 0.06 + jab * 0.08) + sh, lean:S.fs * k * (jab * 0.04), dx:S.fs * k * jab * S.H * 0.01,
      gfn:(L) => { const p = L(...BOSS.HAND); prop(ctx, 'afu__phone', p[0] + S.fs * S.W * 0.02, p[1] - S.H * 0.04, S.H * 0.14 * up * k + 0.0001, -S.fs * 0.3 - (up * 1.75) * k, 0.5, 0.6, -S.fs, 1); } });
    const m = S.P(...BOSS.MOUTH);
    const words = ['喂？！', '我不管！', '明天交！'], wi = Math.min(2, Math.floor(Math.max(0, t - 0.9) / 0.85));
    text(S, m[0] + S.fs * S.W * 0.55, m[1] - S.H * 0.30 - jab * S.H * 0.02, words[wi], S.H * 0.1, yell * k, { col:'#ffe0d8', rot:-0.08 });
    anger(ctx, S.P(0.66, 0.08)[0], S.P(0.66, 0.08)[1], S.H * 0.07, yell * k * (0.8 + 0.2 * Math.sin(t * 12)));
    end(S); return true;
  };
  // 站著：水晶球手輕輕轉一下球，看著它
  DAILY.town_boss_admire = function (ctx, a) {
    const S = begin(ctx, a, 'npc_boss__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env; bossDraw(S, { ball:k * Math.sin(t * 1.6) * 0.06, head:S.fs * k * (0.05 + Math.sin(t * 1.6 + 0.4) * 0.025) });
    end(S); return true;
  };

  // ======================================================================
  // 保安阿伯：手電筒手（npc_guard__arm，繞肩）＋保溫瓶：袖子（npc_guard__sleeve，繞肩）＋手和瓶（npc_guard__tea，繞手腕）
  // ======================================================================
  const GU = { FL:[0.33, 0.53], FTIP:[0.06, 0.66], SH:[0.882, 0.4565], WR:[0.885, 0.578], CAP:[0.745, 0.465], MOUTH:[0.5, 0.335] };
  function guardDraw(S, P, after) {
    const c = S.ctx; c.save(); lean(S, P.lean || 0, 0.4, 0, P.dy || 0);
    body(S, 'npc_guard', 'npc_guard__bodyN', { head:P.head || 0 });
    const sh = S.P(...GU.SH), fl = S.P(...GU.FL);
    const wr = rotP(S, GU.SH[0], GU.SH[1], sh, P.arm || 0, GU.WR[0], GU.WR[1]);
    piece(S, 'npc_guard__tea', GU.WR, wr, (P.arm || 0) + (P.wrist || 0), 1, P.tfn);
    piece(S, 'npc_guard__sleeve', GU.SH, sh, P.arm || 0);
    piece(S, 'npc_guard__arm', GU.FL, fl, P.fl || 0, 1, P.ffn);
    if (after) after();
    c.restore();
  }
  // 地上的手電筒光斑（跟著手電筒掃）
  function beamSpot(S, L) {
    const p = L(...GU.FTIP), ctx = S.ctx, g = ctx.createRadialGradient(0, 0, 0, 0, 0, 1);
    const dx = -S.H * 1.0, sx = p[0] + dx * 1 + (p[1] + 0) * 0, sy = 0;
    ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha *= 0.5 * S.env;
    const gx = p[0] - S.H * 0.95, gy = -S.H * 0.01; const gr = ctx.createRadialGradient(gx, gy, 0, gx, gy, S.H * 0.25); gr.addColorStop(0, 'rgba(255,240,170,.5)'); gr.addColorStop(1, 'rgba(255,240,170,0)');
    ctx.fillStyle = gr; ctx.translate(gx, gy); ctx.scale(1, 0.28); ctx.translate(-gx, -gy); ctx.beginPath(); ctx.arc(gx, gy, S.H * 0.25, 0, PI * 2); ctx.fill(); ctx.restore();
  }
  // 巡邏：手電筒左右慢慢掃，頭跟著看（可以邊走邊做）
  DAILY.town_guard_patrol = function (ctx, a) {
    const S = begin(ctx, a, 'npc_guard__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env, sw = Math.sin(t * 1.9) * 0.16 + Math.sin(t * 0.7) * 0.05;
    guardDraw(S, { fl:k * (sw + 0.04), head:S.fs * k * (-sw * 0.35 + 0.02), arm:k * Math.sin(S.t * 7) * 0.05 * (S.walk ? 1 : 0) });
    end(S); return true;
  };
  // 喝保溫瓶的茶：手抬起來、手腕一扭把瓶口湊到嘴邊、頭往後仰喝、放下「哈～」冒熱氣
  function guardSip(S) {
    const t = S.at, k = S.env, up = kf([[0, 0], [0.7, 1], [2.3, 1], [2.9, 0]], S.dur ? Math.min(t, 3.3) : t), drink = bump(t, 0.9, 1.2, 2.2);
    // 用 IK 算：瓶口到嘴邊（嘴稍微往前、往下一點，頭往後仰時剛好對上）
    const sh = S.P(...GU.SH), m = S.P(...GU.MOUTH), tgt = [m[0] + S.fs * S.W * 0.02, m[1] + S.H * 0.03];
    let best = [0, 0], be = 1e9;
    for (let a1 = 0; a1 <= 2.2; a1 += 0.05) for (let a2 = -2.4; a2 <= 0.4; a2 += 0.05) {
      const w = rotP(S, GU.SH[0], GU.SH[1], sh, a1, GU.WR[0], GU.WR[1]), c = rotP(S, GU.WR[0], GU.WR[1], w, a1 + a2, GU.CAP[0], GU.CAP[1]);
      const e = Math.hypot(c[0] - tgt[0], c[1] - tgt[1]) + Math.abs(a1 + a2 - S.fs * 0.55) * S.H * 0.03; if (e < be) { be = e; best = [a1, a2]; }
    }
    const A = k * up;
    guardDraw(S, { arm:best[0] * A, wrist:(best[1] - drink * 0.25) * A, head:-S.fs * k * (up * 0.06 + drink * 0.1), lean:-S.fs * k * drink * 0.03, fl:k * up * 0.05,
      tfn:(L) => { const p = L(...GU.CAP); steamCurl(S.ctx, p[0], p[1] - S.H * 0.02, S.H * 0.18, ((t * 0.9) % 1), 2.1, 0.6 * k); } });
    const f = S.P(0.45, 0.30);
    puff(S.ctx, f[0] - S.fs * S.W * 0.05, f[1] + S.H * 0.04, S.H * 0.04, seg(t, 2.3, 3.2), 5.5);
    text(S, f[0] - S.fs * S.W * 0.35, f[1] - S.H * 0.18, '哈～', S.H * 0.095, bump(t, 2.3, 2.5, 3.1) * k);
  }
  DAILY.town_guard_sip = function (ctx, a) { const S = begin(ctx, a, 'npc_guard__bodyN', false); if (!S) return false; guardSip(S); end(S); return true; };
  // 打瞌睡：頭慢慢垂下去、身體一沉、Zzz，手電筒也跟著垂；突然驚醒抬頭「！」，裝沒事
  DAILY.town_guard_doze = function (ctx, a) {
    const S = begin(ctx, a, 'npc_guard__bodyN', false); if (!S) return false;
    const t = S.at, k = S.env, nod = kf([[0, 0], [1.2, 0.6], [1.5, 0.5], [2.6, 1], [3.2, 1], [3.35, -0.25], [3.7, 0.05], [4.2, 0]], t);
    const jerk = bump(t, 3.2, 3.35, 3.7);
    ctx.save(); ctx.scale(1, 1 - 0.03 * Math.max(0, nod) * k);
    guardDraw(S, { head:S.fs * k * nod * 0.5, lean:S.fs * k * nod * 0.06, dy:k * (Math.max(0, nod) * S.H * 0.015 - jerk * S.H * 0.03), fl:-k * Math.max(0, nod) * 0.45, arm:-k * Math.max(0, nod) * 0.06 });
    ctx.restore();
    const h = S.P(0.3, 0.12); zzz(S, h[0] - S.fs * S.W * 0.15, h[1], S.H * 0.09, t, seg(t, 1.0, 1.5) * (1 - seg(t, 3.1, 3.25)) * k);
    marks(ctx, S.P(0.5, 0.05)[0], S.P(0.5, 0.05)[1] - S.H * 0.03, S.H * 0.09, jerk * k);
    end(S); return true;
  };

  // ======================================================================
  // 清潔安娣：拖把（npc_auntie__mop，拳頭握的那段用原圖接回來）＋拳頭（npc_auntie__fist）＋叉腰的手（npc_auntie__hip）
  // 拖把倒過來（拖把頭著地）：桿子還是穿過同一個拳頭（同一條線），拳頭握在桿子的另一段
  // ======================================================================
  const AU = { FIST:[0.275, 0.512], TOP:[0.235, 0.34], BOT:[0.37, 0.95], HEAD:[0.10, 0.40], SH:[0.765, 0.43], HAND:[0.735, 0.595] };
  // 拖把：整支繞拳頭轉 th，再沿桿子滑 s（0 = 原本握的地方，1 = 握到桿尾）。拳頭只轉「桿子方向的差」（同一條線），所以桿子一定穿過拳頭
  function auAxis(S) { const ax = (AU.BOT[0] - AU.TOP[0]) * S.W, ay = (AU.BOT[1] - AU.TOP[1]) * S.H, L = Math.hypot(ax, ay); return { ux:ax / L, uy:ay / L, L }; }
  function auHead(S, fx, fy, th, s) { const A = auAxis(S), hx = (AU.HEAD[0] - AU.FIST[0]) * S.W - A.ux * s * A.L, hy = (AU.HEAD[1] - AU.FIST[1]) * S.H - A.uy * s * A.L, c = Math.cos(th), sn = Math.sin(th); return [fx + hx * c - hy * sn, fy + hx * sn + hy * c]; }
  // 讓拖把頭剛好碰地（y = floor）要滑多少
  function auReach(S, fx, fy, th, floor) { const h0 = auHead(S, fx, fy, th, 0), h1 = auHead(S, fx, fy, th, 1); return cl((floor - h0[1]) / ((h1[1] - h0[1]) || 1e-6), 0, 1.05); }
  // 拖把頭朝哪個方向（從拳頭看出去的角度）→ 整支要轉多少
  const HEAD0 = Math.atan2((AU.TOP[1] - AU.FIST[1]), (AU.TOP[0] - AU.FIST[0]));
  function auMop(S, fx, fy, th, s, wfn) {
    const ctx = S.ctx, A = auAxis(S);
    ctx.save(); ctx.translate(fx, fy); ctx.rotate(th); ctx.translate(-A.ux * s * A.L, -A.uy * s * A.L);
    ctx.drawImage(SPR.npc_auntie__mop, -AU.FIST[0] * S.W, -AU.FIST[1] * S.H, S.W, S.H);
    if (wfn) wfn((u, v) => [(u - AU.FIST[0]) * S.W, (v - AU.FIST[1]) * S.H]);
    ctx.restore();
  }
  const resid = (th) => th - Math.round(th / PI) * PI;
  // 握拖把的手 = 拳頭＋手腕一整塊（npc_auntie__hand，cutauntie_hand.py），繞袖口的手腕 WR 轉：拳頭永遠接在手腕上，不會飄
  const WR = [0.386, 0.526];
  function auntieDraw(S, P) {
    const c = S.ctx; c.save(); lean(S, P.lean || 0, 0.35, P.dx || 0, 0);
    const handOK = ok('npc_auntie__hand') && ok('npc_auntie__bodyM');
    body(S, 'npc_auntie', handOK ? 'npc_auntie__bodyM' : 'npc_auntie__bodyH', { head:P.head || 0, legF:P.legF || 0, legB:P.legB || 0 });
    const f = S.P(...AU.FIST), w = S.P(...WR), th = P.th || 0;
    // 想要的拳頭位置 → 換成手腕轉幾度（手長不變）
    const want = [f[0] + (P.fx || 0) * S.H, f[1] + (P.fy || 0) * S.H];
    let ha = Math.atan2(want[1] - w[1], want[0] - w[0]) - Math.atan2(f[1] - w[1], f[0] - w[0]);
    while (ha > PI) ha -= 2 * PI; while (ha < -PI) ha += 2 * PI; ha = cl(ha, -0.55, 0.55) + (P.fa || 0);
    const cs = Math.cos(ha), sn = Math.sin(ha), rx = f[0] - w[0], ry = f[1] - w[1];
    const fx = handOK ? w[0] + rx * cs - ry * sn : want[0], fy = handOK ? w[1] + rx * sn + ry * cs : want[1];
    let s = P.s || 0; if (P.floor != null) s = lerp(0, auReach(S, fx, fy, th, P.floor), P.reach == null ? 1 : P.reach);
    auMop(S, fx, fy, th, s, P.mfn);
    if (handOK) piece(S, 'npc_auntie__hand', WR, w, ha);
    else piece(S, 'npc_auntie__fist', AU.FIST, [fx, fy], resid(th) + (P.fa || 0));
    if (P.hip) P.hip(fx, fy, th, s); else piece(S, 'npc_auntie__hip', AU.SH, S.P(...AU.SH), P.hipA || 0);
    c.restore();
    return { fx, fy, th, s };
  }
  // 拖把頭要朝的方向（往前下方 down 弧度）→ th
  const auTh = (S, down) => { const want = S.fs > 0 ? down : PI - down; let th = want - HEAD0; while (th > PI) th -= 2 * PI; while (th < -PI) th += 2 * PI; return th; };
  // 拖地：握住桿尾，拖把頭伸到前面地上來回推，身體跟著擺；地上一片濕；拖把頭滴水（可以邊走邊拖）
  DAILY.town_auntie_mop = function (ctx, a) {
    const S = begin(ctx, a, 'npc_auntie__bodyH', false); if (!S) return false;
    const t = S.at, k = S.env, push = Math.sin(t * 3.4), q = ss(k);
    const th = auTh(S, 0.62 + push * 0.06) * q;
    const fx = q * S.fs * (0.03 + push * 0.05), fy = q * (0.05 - push * 0.01);
    // 濕的一片（前面地上）
    if (k > 0.3) { const g = S.P(...AU.FIST)[0] + S.fs * S.H * 0.42; ctx.save(); ctx.globalAlpha *= (k - 0.3) * 0.8; ctx.fillStyle = 'rgba(160,210,230,.2)'; ctx.beginPath(); ctx.ellipse(g, -S.H * 0.004, S.H * 0.28, S.H * 0.035, 0, 0, PI * 2); ctx.fill(); ctx.restore(); }
    auntieDraw(S, { th, fx, fy, floor:-S.H * 0.045, reach:q, lean:S.fs * k * (0.05 + push * 0.025), head:S.fs * k * (0.08 + push * 0.02), legF:S.walk ? 0 : 0,
      mfn:(L) => { if (k < 0.5) return; const h = L(...AU.HEAD); for (let i = 0; i < 2; i++) drop(ctx, h[0] + (i - 0.5) * S.H * 0.05, h[1], S.H * 0.009, ((t * 0.7 + i * 0.5) % 1), S.H * 0.04); } });
    end(S); return true;
  };
  // 擰乾：桿子立直、拖把頭頂在地上，叉腰那隻手也來握桿子，兩手一扭一扭，水擠出來
  DAILY.town_auntie_wring = function (ctx, a) {
    const S = begin(ctx, a, 'npc_auntie__bodyH', false); if (!S) return false;
    const t = S.at, k = S.env, q = ss(k), tw = Math.sin(t * 8) * seg(t, 0.45, 0.65) * (1 - seg(t, 1.8, 2.0));
    const th = auTh(S, PI / 2 + S.fs * 0.12) * q + tw * 0.04;
    const fx = q * S.fs * 0.05, fy = q * 0.04;
    let hipF = null;
    const hip = (FX, FY, TH, s) => { // 叉腰的手移到桿子上（拳頭上面一點）
      const sh = S.P(...AU.SH), H0 = S.P(...AU.HAND), h0 = [H0[0] - sh[0], H0[1] - sh[1]], A = auAxis(S);
      const c = Math.cos(TH), sn = Math.sin(TH), up = [-(A.ux * c - A.uy * sn), -(A.ux * sn + A.uy * c)]; // 往桿尾（現在在上面）
      const g = [FX - up[0] * S.H * 0.12, FY - up[1] * S.H * 0.12];
      const a0 = Math.atan2(h0[1], h0[0]), ang = Math.atan2(g[1] - sh[1], g[0] - sh[0]) - a0, r = Math.hypot(h0[0], h0[1]);
      const fix = [g[0] - (sh[0] + Math.cos(ang + a0) * r), g[1] - (sh[1] + Math.sin(ang + a0) * r)];
      piece(S, 'npc_auntie__hip', AU.SH, [sh[0] + fix[0] * q, sh[1] + fix[1] * q], ang * q - tw * 0.06 * q);
    };
    auntieDraw(S, { th, fx, fy, floor:-S.H * 0.06, reach:q, fa:tw * 0.08, lean:S.fs * k * 0.06, head:S.fs * k * 0.12, hip,
      mfn:(L) => { if (k < 0.5) return; const h = L(...AU.HEAD), sq = Math.abs(tw); for (let i = 0; i < 4; i++) drop(ctx, h[0] + (rnd(i) - 0.5) * S.H * 0.1, h[1] + S.H * 0.01, S.H * 0.01, ((t * 1.7 + i / 4) % 1), S.H * 0.05 * (0.4 + sq)); } });
    end(S); return true;
  };
  // 叉腰碎碎唸：拖把桿往地上篤兩下，頭左右搖，「哼！」「嘖嘖……」
  DAILY.town_auntie_grumble = function (ctx, a) {
    const S = begin(ctx, a, 'npc_auntie__bodyH', false); if (!S) return false;
    const t = S.at, k = S.env, tap = Math.max(0, Math.sin(t * 7)) * seg(t, 0.2, 0.4) * (1 - seg(t, 1.0, 1.2)), shake = Math.sin(t * 9) * seg(t, 1.1, 1.3) * (1 - seg(t, 2.0, 2.2));
    auntieDraw(S, { fy:-k * tap * 0.025, head:k * (shake * 0.1 + S.fs * 0.03), lean:-S.fs * k * 0.02 });
    const h = S.P(0.45, 0.12);
    text(S, h[0] - S.fs * S.W * 0.42, h[1] - S.H * 0.05, t < 1.1 ? '哼！' : '嘖嘖……', S.H * 0.1, (bump(t, 0.15, 0.3, 1.0) + bump(t, 1.1, 1.3, 2.2)) * k);
    anger(ctx, S.P(0.70, 0.10)[0], S.P(0.70, 0.10)[1], S.H * 0.075, bump(t, 0.2, 0.4, 2.1) * k);
    end(S); return true;
  };

  // ======================================================================
  // 冥街夜市・店主
  // ======================================================================
  // 小紙（紙紮鋪）：手拿一張紙（furnace__paper），摺一下（紙翻過來、變窄），拍平，再摺
  DAILY.town_paper_fold = function (ctx, a) {
    const S = begin(ctx, a, 'xiaozhi__body', false); if (!S) return false;
    const t = S.at % 2.4, k = S.env, up = k * kf([[0, 0.6], [0.4, 1], [1.6, 1], [2.0, 0.75], [2.4, 0.6]], t), fold = seg(t, 0.5, 0.9), pat = bump(t, 1.2, 1.3, 1.45) + bump(t, 1.5, 1.6, 1.75);
    const pv = [0.315, 0.535], at = S.P(...pv);
    body(S, 'xiaozhi', 'xiaozhi__body', { head:S.fs * k * (0.08 + 0.03 * pat) });
    piece(S, 'xiaozhi__arm', pv, [at[0], at[1] - pat * S.H * 0.01], -S.fs * (up * 0.55 + pat * 0.05) * 1, 1, (L) => {
      const h = L(0.16, 0.71); const w = S.H * 0.26 * k;
      const sx = Math.cos(fold * PI) * (S.at % 4.8 < 2.4 ? 1 : -1), sy = 1 - 0.35 * fold;
      prop(ctx, 'furnace__paper', h[0], h[1] - S.H * 0.02, w, S.fs * 0.5, 0.5, 0.6, Math.abs(sx) < 0.08 ? 0.08 : sx, sy);
    });
    end(S); return true;
  };
  // 小紙：抱著一疊紙紮（furnace__stack），往下篤兩下對齊，點頭
  DAILY.town_paper_arrange = function (ctx, a) {
    const S = begin(ctx, a, 'xiaozhi__body', false); if (!S) return false;
    const t = S.at % 2.2, k = S.env, tap = bump(t, 0.3, 0.42, 0.55) + bump(t, 0.7, 0.82, 0.95), nod = bump(t, 1.3, 1.5, 1.8);
    const pv = [0.315, 0.535], at = S.P(...pv);
    body(S, 'xiaozhi', 'xiaozhi__body', { head:S.fs * k * (0.06 + 0.1 * nod) });
    const st = S.P(0.18, 0.75); prop(ctx, 'furnace__stack', st[0], st[1] + tap * S.H * 0.03 * k - S.H * 0.04 * k, S.H * 0.36 * k + 0.001, 0, 0.5, 0.5);
    piece(S, 'xiaozhi__arm', pv, [at[0], at[1] + tap * S.H * 0.03 * k], -S.fs * k * 0.1);
    end(S); return true;
  };
  // 小鬼（講價攤）：爪子在攤上畫圈擦檯面（吱吱的亮點）
  DAILY.town_haggle_polish = function (ctx, a) {
    const S = begin(ctx, a, 'xiaogui__body', true); if (!S) return false;
    const t = S.at, k = S.env, an = t * 7, pv = [0.61, 0.585], at = S.P(...pv);
    body(S, 'xiaogui', 'xiaogui__body', { head:S.fs * k * (0.1 + Math.sin(an) * 0.02), tail1:Math.sin(an) * 0.05 * k });
    piece(S, 'xiaogui__arm', pv, [at[0] + Math.cos(an) * S.H * 0.03 * k, at[1] + (0.04 + Math.sin(an) * 0.015) * S.H * k], S.fs * k * (0.25 + Math.sin(an) * 0.06), 1, (L) => {
      const p = L(0.93, 0.58); if (Math.sin(an) > 0.6) sparkle(ctx, p[0] + S.H * 0.05, p[1] + S.H * 0.01, S.H * 0.035, (Math.sin(an) - 0.6) * 2.5 * k);
    });
    end(S); return true;
  };
  // 小鬼：拿一張冥鈔舉到眼前瞇眼看（頭往前湊、停住、上下打量），「嗯……」
  DAILY.town_haggle_squint = function (ctx, a) {
    const S = begin(ctx, a, 'xiaogui__body', true); if (!S) return false;
    const t = S.at, k = S.env, up = k * kf([[0, 0], [0.5, 1], [2.6, 1], [3.0, 0]], t), look = Math.sin(t * 2.2) * seg(t, 0.8, 1.0) * (1 - seg(t, 2.3, 2.6));
    const pv = [0.61, 0.585], at = S.P(...pv);
    body(S, 'xiaogui', 'xiaogui__body', { head:S.fs * (up * 0.14 + look * 0.05) });
    piece(S, 'xiaogui__arm', pv, [at[0] + S.fs * up * S.W * 0.06, at[1] - up * S.H * 0.05], -S.fs * up * 0.45, 1, (L) => {
      const p = L(0.95, 0.55); prop(ctx, 'furnace__paper', p[0] + S.fs * S.W * 0.06, p[1] - S.H * 0.03, S.H * 0.22 * up + 0.001, S.fs * (0.3 + look * 0.1), 0.5, 0.7);
    });
    const h = S.P(0.6, 0.15); text(S, h[0] + S.fs * S.W * 0.2, h[1] - S.H * 0.08, '嗯……', S.H * 0.11, bump(t, 1.0, 1.3, 2.6) * k);
    end(S); return true;
  };
  // 白無常（冥幣兌換）：哭喪棒靠在旁邊，手裡一疊冥鈔扇開來數，一張一張翻；舔一下手指；最後蓋章「冥」
  DAILY.town_exch_count = function (ctx, a) {
    const S = begin(ctx, a, 'baiwu__body', false); if (!S) return false;
    const t = S.at, k = S.env, pv = [0.32, 0.655], at = S.P(...pv);
    const lick = bump(t % 3.6, 2.4, 2.65, 3.0), flipN = Math.floor(t * 2.6), fq = (t * 2.6) % 1;
    // 哭喪棒靠在身邊
    if (ok('baiwu__wpn')) { const g = S.P(0.12, 1.0); prop(ctx, 'baiwu__wpn', g[0] + S.fs * S.W * 0.05, g[1], S.H * 0.42, -S.fs * 0.12 * k, 0.5, 1); }
    body(S, 'baiwu', 'baiwu__body', { head:S.fs * k * (0.1 - lick * 0.12 + 0.02 * Math.sin(t * 5.2)) });
    piece(S, 'baiwu__arm', pv, [at[0] + S.fs * (0.03 + lick * 0.03) * S.W * k, at[1] - (0.01 + lick * 0.13) * S.H * k], -S.fs * k * (0.12 + lick * 0.55 + 0.04 * Math.sin(fq * PI)), 1, (L) => {
      const h = L(0.27, 0.62);
      if (lick < 0.5) for (let i = 0; i < 5; i++) { // 扇開的冥鈔，最上面那張翻過去
        const top = i === 4, an = (i - 2) * 0.16 + (top ? -0.32 * ss(fq) : 0);
        prop(ctx, 'furnace__paper', h[0], h[1], S.H * 0.22 * k * (1 - lick) + 0.001, S.fs * 0.15 + an, 0.5, 0.9);
      }
    });
    if (k > 0.5) text(S, S.P(0.5, 0.1)[0] + S.fs * S.W * 0.4, S.P(0.5, 0.1)[1], ['一', '二', '三', '四', '五', '六'][flipN % 6], S.H * 0.07, (1 - fq) * (1 - lick) * (k - 0.5) * 2, { col:'#ffe08a' });
    end(S); return true;
  };
  DAILY.town_exch_stamp = function (ctx, a) {
    const S = begin(ctx, a, 'baiwu__body', false); if (!S) return false;
    const t = S.at, k = S.env, pv = [0.32, 0.655], at = S.P(...pv);
    const lift = kf([[0, 0], [0.5, 1], [0.7, 1.1], [0.8, -0.2], [1.0, 0], [1.3, 0.8], [1.45, -0.2], [1.6, 0], [2.0, 0]], t);
    if (ok('baiwu__wpn')) { const g = S.P(0.12, 1.0); prop(ctx, 'baiwu__wpn', g[0] + S.fs * S.W * 0.05, g[1], S.H * 0.42, -S.fs * 0.12 * k, 0.5, 1); }
    body(S, 'baiwu', 'baiwu__body', { head:S.fs * k * (0.14 - lift * 0.04) });
    // 桌面上（店前）一張冥鈔，被蓋章
    const n = S.P(0.18, 0.80); prop(ctx, 'furnace__paper', n[0], n[1], S.H * 0.24 * k + 0.001, 0.1, 0.5, 0.5);
    const hit = t > 0.8 ? 1 : 0, hit2 = t > 1.45 ? 1 : 0;
    if (hit) { ctx.save(); ctx.globalAlpha *= k * 0.85; ctx.translate(n[0], n[1]); ctx.rotate(-0.2); ctx.strokeStyle = '#c8202a'; ctx.lineWidth = S.H * 0.008; ctx.strokeRect(-S.H * 0.035, -S.H * 0.035, S.H * 0.07, S.H * 0.07); ctx.font = `900 ${S.H * 0.05}px ${FONT}`; ctx.fillStyle = '#c8202a'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; if (S.flip) ctx.scale(-1, 1); ctx.fillText('冥', 0, S.H * 0.002); ctx.restore(); }
    piece(S, 'baiwu__arm', pv, [at[0] - S.fs * S.W * 0.02 * k, at[1] - lift * S.H * 0.06 * k + S.H * 0.03 * k], -S.fs * k * (0.15 + lift * 0.25));
    marks(ctx, n[0], n[1] - S.H * 0.05, S.H * 0.06, (bump(t, 0.78, 0.82, 1.0) + bump(t, 1.43, 1.47, 1.65)) * k);
    end(S); return true;
  };
  // 餓鬼王（宵夜檔）：手拿漏勺在鍋裡攪（漏勺下半截沒進鍋裡），撈起一勺麵（冒熱氣、滴湯），偷吃一口、左右張望
  // o.prop = { potDX, potDY }：鍋口中心相對腳底的位置（世界座標，ghoststreet 算好；沒給就假設在前方）
  function eguiPot(S) {
    const p = S.o.prop || {};
    if (p.potDX == null) return [S.fs * S.H * 0.42, -S.H * 0.47];
    return [(S.flip ? -1 : 1) * p.potDX / S.z.sx, (p.potDY - S.z.y * S.H) / S.z.sy];
  }
  function noodles(ctx, x, y, s, k, t) { // 掛在漏勺上的麵（幾條黃色蠟筆線，晃）
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= cl(k);
    for (let i = 0; i < 6; i++) { const ox = (i - 2.5) * s * 0.07, len = s * (0.22 + 0.16 * rnd(i + 3)), sw = Math.sin(t * 6 + i) * s * 0.04;
      crayon(ctx, [[x + ox, y], [x + ox + sw * 0.5, y + len * 0.5], [x + ox + sw, y + len]], Math.max(1.2, s * 0.03), '#f4d77a', 'rgba(110,70,20,.55)'); }
    ctx.restore();
  }
  // 漏勺（從背景切的原圖）：柄的上端握在手裡，網子朝下。回傳網子中心
  function strainer(S, hx, hy, ang, nood, t, clipY) {
    const ctx = S.ctx; if (!ok('street_strainer')) return null;
    const im = SPR.street_strainer, h = S.H * 0.34, w = h * im.naturalWidth / im.naturalHeight;
    ctx.save();
    if (clipY != null) { ctx.beginPath(); ctx.rect(-S.H * 5, -S.H * 5, S.H * 10, clipY + S.H * 5); ctx.clip(); }
    ctx.translate(hx, hy); ctx.rotate(ang);
    ctx.drawImage(im, -w / 2, -h * 0.1, w, h);
    const net = [0, h * 0.68];
    if (nood > 0) noodles(ctx, net[0], net[1] + h * 0.12, h, nood, t);
    const c = Math.cos(ang), s = Math.sin(ang); ctx.restore();
    return { x:hx + net[0] * c - net[1] * s, y:hy + net[0] * s + net[1] * c };
  }
  function eguiCook(S, mode) {
    const ctx = S.ctx, t = S.at, k = S.env, pot = eguiPot(S), pv = [0.12, 0.5], at = S.P(...pv), G0 = [0.10, 0.30], g0 = S.P(...G0);
    // 手（握漏勺的點）要去的位置：鍋口上方
    let tx = pot[0], ty = pot[1] - S.H * 0.31, sAng = 0, nood = 0, headA = S.fs * 0.12, txt = '', ta = 0, clip = true, rot = 0;
    if (mode === 'stir') { const an = t * 4.2; tx += Math.cos(an) * S.H * 0.035; ty += S.H * 0.05 + Math.sin(an) * S.H * 0.012; sAng = Math.cos(an) * 0.15; headA = S.fs * (0.14 + Math.sin(an) * 0.02); rot = Math.sin(an) * 0.04; }
    if (mode === 'ladle') {
      const q = t % 3.0, lift = kf([[0, 0], [0.5, 0.15], [0.9, -0.1], [1.4, 1], [2.4, 1], [3.0, 0]], q);
      ty += S.H * (0.06 - lift * 0.16); sAng = -S.fs * lift * 0.12; nood = seg(q, 1.0, 1.4) * (1 - seg(q, 2.5, 2.9)); headA = S.fs * (0.12 - lift * 0.06); rot = -S.fs * lift * 0.1;
    }
    if (mode === 'taste') {
      const up = kf([[0, 0], [0.5, 0.45], [1.0, 1], [2.2, 1], [2.6, 0.3], [3.3, 0]], t), m = S.P(0.47, 0.34), chew = Math.sin(t * 14) * seg(t, 1.0, 1.1) * (1 - seg(t, 1.8, 1.9)), look = Math.sin((t - 1.9) * 8) * bump(t, 1.9, 2.1, 2.7);
      tx = lerp(tx, m[0] + S.fs * S.W * 0.1, up); ty = lerp(ty + S.H * 0.05, m[1] - S.H * 0.22, up); sAng = -S.fs * up * 0.6; nood = (1 - seg(t, 1.0, 1.15)) * Math.min(1, t / 0.3 + 0.0001);
      headA = S.fs * (0.1 - up * 0.1) + chew * 0.04 + look * 0.18; txt = t < 1.9 ? '嗯～' : '……'; ta = bump(t, 1.1, 1.3, 2.0) + bump(t, 2.0, 2.2, 2.7) * 0.8; clip = up < 0.2; rot = -S.fs * up * 0.25;
    }
    const dx = (tx - g0[0]) * k, dy = (ty - g0[1]) * k, ang = rot * k;
    body(S, 'eguiking', 'eguiking__body', { head:headA * k });
    // 漏勺先畫（被手握住），鍋口以下不畫
    const hp = rotP(S, pv[0], pv[1], [at[0] + dx, at[1] + dy], ang, G0[0], G0[1]);
    if (k > 0.02) {
      ctx.save(); ctx.globalAlpha *= ss(k * 1.5);
      const net = strainer(S, hp[0], hp[1], sAng * k + ang, nood * k, t, clip ? pot[1] : null);
      if (net && nood > 0) { steamCurl(ctx, net.x, net.y - S.H * 0.02, S.H * 0.22, (t * 0.8) % 1, 1.7, nood * k); drop(ctx, net.x, net.y + S.H * 0.06, S.H * 0.008, (t * 1.5) % 1, S.H * 0.1); }
      if (mode === 'stir' && k > 0.5) steamCurl(ctx, pot[0] + Math.sin(t) * S.H * 0.04, pot[1] - S.H * 0.03, S.H * 0.3, (t * 0.5) % 1, 4.4, 0.6);
      ctx.restore();
    }
    piece(S, 'eguiking__hand', pv, [at[0] + dx, at[1] + dy], ang);
    if (ta > 0) { const h = S.P(0.5, 0.05); text(S, h[0] - S.fs * S.W * 0.35, h[1], txt, S.H * 0.1, ta * k); }
  }
  DAILY.town_food_stir = function (ctx, a) { const S = begin(ctx, a, 'eguiking__body', false); if (!S) return false; eguiCook(S, 'stir'); end(S); return true; };
  DAILY.town_food_ladle = function (ctx, a) { const S = begin(ctx, a, 'eguiking__body', false); if (!S) return false; eguiCook(S, 'ladle'); end(S); return true; };
  DAILY.town_food_taste = function (ctx, a) { const S = begin(ctx, a, 'eguiking__body', false); if (!S) return false; eguiCook(S, 'taste'); end(S); return true; };

  // 店主打招呼：有空的手揮一揮／鞠躬
  const GREET = {
    xiaozhi:{ key:'xiaozhi__body', arm:'xiaozhi__arm', pv:[0.315, 0.535], nr:false, wave:1 },
    xiaogui:{ key:'xiaogui__body', arm:'xiaogui__arm', pv:[0.61, 0.585], nr:true, wave:0 },
    baiwu:{ key:'baiwu__body', arm:'baiwu__arm', pv:[0.32, 0.655], nr:false, wave:0, staff:1 },
    eguiking:{ key:'eguiking__body', arm:'eguiking__arm', pv:[0.12, 0.5], nr:false, wave:1 },
  };
  DAILY.town_greet = function (ctx, a) {
    const G = GREET[a.type]; if (!G) return false;
    const S = begin(ctx, a, G.key, G.nr); if (!S) return false;
    const t = S.at, k = S.env, c = S.ctx;
    if (G.wave) {
      const up = k * kf([[0, 0], [0.35, 1], [1.4, 1], [1.7, 0.2]], t), w = Math.sin(t * 11) * seg(t, 0.3, 0.4) * (1 - seg(t, 1.3, 1.5));
      body(S, a.type, G.key, { head:S.fs * k * (-0.06 + 0.03 * w) });
      const at = S.P(...G.pv); piece(S, G.arm, G.pv, [at[0], at[1] - up * S.H * 0.04], (a.type === 'eguiking' ? S.fs * up * 0.4 : -S.fs * up * 1.9) + w * 0.22 * up);
    } else { // 鞠躬（白無常：哭喪棒跟著手；小鬼：不情不願點個頭）
      const deep = a.type === 'baiwu' ? 0.38 : 0.16, b = k * kf([[0, 0], [0.4, 1], [0.9, 1], [1.4, 0]], t);
      c.save(); lean(S, S.fs * b * deep, 0.25);
      body(S, a.type, G.key, { head:S.fs * b * 0.1 });
      const at = S.P(...G.pv);
      if (G.staff && typeof Limbs !== 'undefined' && Limbs.has('baiwu')) { c.restore(); c.save(); lean(S, S.fs * b * deep, 0.25); }
      piece(S, G.arm, G.pv, at, 0, 1, G.staff ? (L) => { const h = L(0.275, 0.625); const W = LIMBS_DATA.weapons[LIMBS_DATA.chars.baiwu.weapon]; if (W && ok(W.img)) { const im = SPR[W.img], ww = W.w * S.H, wh = W.h * S.H; c.save(); c.translate(h[0], h[1]); c.drawImage(im, -W.grip[0] * ww, -W.grip[1] * wh, ww, wh); c.restore(); } } : null);
      c.restore();
    }
    end(S); return true;
  };

  // ======================================================================
  // 冥街夜市・閒鬼：拿著道具走（燈籠吊在手上晃、外賣袋、講電話）、撞到人互相道歉、停在攤前看
  // ======================================================================
  const WALK = {
    youhun:{ key:'youhun__body', arm:'youhun__arm', pv:[0.245, 0.47], tip:[0.04, 0.55], nr:false },
    egui:{ key:'egui__body', arm:'egui__arm', pv:[0.56, 0.44], tip:[0.74, 0.27], nr:true },
    zombie:{ key:'zombie__body', arm:'zombie__arm', pv:[0.27, 0.56], tip:[0.06, 0.57], nr:false },
    shuigui:{ key:'shuigui__body', arm:'shuigui__arm', pv:[0.72, 0.53], tip:[0.92, 0.53], nr:true },
  };
  // 吊著的東西：繩子從手吊下來，跟著走路擺（彈簧感：比手慢半拍）
  function hang(S, key, x, y, w, len, t, walk) {
    const ctx = S.ctx, sw = (walk ? Math.sin(t * 7 - 0.9) * 0.22 : Math.sin(t * 1.7) * 0.06) + (walk ? -S.fs * 0.12 : 0);
    ctx.save(); ctx.translate(x, y); ctx.rotate(sw);
    ctx.strokeStyle = 'rgba(40,28,24,.9)'; ctx.lineWidth = Math.max(1, S.H * 0.008); ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, len); ctx.stroke();
    prop(ctx, key, 0, len, w, -sw * 0.4, 0.5, 0.04); ctx.restore();
  }
  function walker(S, G, P) {
    const ctx = S.ctx, t = S.t, pr = S.o.prop || {}, k = S.env;
    ctx.save(); lean(S, P.lean || 0, 0.3, P.dx || 0, 0);
    const ad = { head:P.head || 0 };
    if (G.still) ad.head = 0;
    body(S, S.a.type, G.key, ad);
    const at = S.P(...G.pv), kind = pr.kind;
    let ang = P.arm || 0;
    if (kind === 'phone') ang += -S.fs * 0.15 * k;
    if (kind === 'lanternW' || kind === 'lanternR') ang += (S.walk ? Math.sin(t * 7) * 0.08 : 0) - S.fs * 0.1 * k;
    piece(S, G.arm, G.pv, at, ang, 1, (L) => {
      const h = L(...G.tip);
      if (kind === 'lanternW' || kind === 'lanternR') hang(S, kind === 'lanternW' ? 'street_lanternW' : 'street_lanternR', h[0], h[1], S.H * 0.24 * (pr.big || 1), S.H * 0.06, t, S.walk);
      if (kind === 'bag') hang(S, 'bun__basket', h[0], h[1], S.H * 0.3, S.H * 0.03, t, S.walk);
      if (kind === 'phone') { prop(ctx, 'afu__phone', h[0], h[1] - S.H * 0.03, S.H * 0.13, S.fs * 0.2, 0.5, 0.6, -S.fs, 1); }
    });
    ctx.restore();
    if (kind === 'phone') { // 講電話：一句一句冒出來
      const q = (t * 0.5 + (pr.seed || 0)) % 1, lines = pr.lines || ['喂？', '收到收到', '在路上了'];
      const h = S.P(0.5, 0.0); text(S, h[0] - S.fs * S.W * 0.1, h[1] - S.H * 0.05, lines[Math.floor((t * 0.5 + (pr.seed || 0))) % lines.length], S.H * 0.13, bump(q, 0.05, 0.2, 0.7) * k * 0.95, { col:'#e8fff0', out:'#14281e' });
    }
  }
  DAILY.town_walk = function (ctx, a) {
    const G = WALK[a.type]; if (!G) return false;
    const S = begin(ctx, a, G.key, G.nr); if (!S) return false;
    S.env = Math.max(S.env, 0.999); // 拿著道具：一直拿著（不淡出）
    walker(S, G, { head:0 }); end(S); return true;
  };
  // 撞到：往後彈一下、「！」，然後互相鞠躬兩下
  DAILY.town_bump = function (ctx, a) {
    const G = WALK[a.type]; if (!G) return false;
    const S = begin(ctx, a, G.key, G.nr); if (!S) return false;
    const t = S.at, rec = kf([[0, 0], [0.12, 1], [0.45, 0.6], [0.6, 0]], t), bow = bump(t, 0.6, 0.8, 1.05) + bump(t, 1.05, 1.25, 1.5);
    S.env = 1;
    walker(S, G, { lean:-S.fs * rec * 0.2 + S.fs * bow * 0.3, dx:-S.fs * rec * S.H * 0.06, head:S.fs * bow * 0.15 });
    marks(ctx, S.P(0.5, 0.02)[0], S.P(0.5, 0.02)[1] - S.H * 0.04, S.H * 0.12, bump(t, 0.08, 0.15, 0.55));
    const tt = (a.o.prop && a.o.prop.sorry) || '不好意思';
    text(S, S.P(0.5, 0)[0], S.P(0.5, 0)[1] - S.H * 0.2, tt, S.H * 0.13, bump(t, 0.65, 0.8, 1.7), { col:'#fff6dc' });
    end(S); return true;
  };
  // 停在攤前：轉向攤子、身體往前湊、頭上下打量、手抬起來摸下巴，看到喜歡的「哦？」
  DAILY.town_look = function (ctx, a) {
    const G = WALK[a.type]; if (!G) return false;
    const S = begin(ctx, a, G.key, G.nr); if (!S) return false;
    const t = S.at, k = S.env, scan = Math.sin(t * 1.6), inq = bump(t, 1.6, 1.9, 2.8);
    walker(S, G, { lean:S.fs * k * (0.06 + inq * 0.05), head:S.fs * k * (0.08 + scan * 0.06) - k * inq * 0.08, arm:-S.fs * k * (0.3 + 0.05 * Math.sin(t * 3)) });
    text(S, S.P(0.5, 0)[0] + S.fs * S.W * 0.2, S.P(0.5, 0)[1] - S.H * 0.08, '哦？', S.H * 0.13, inq * k);
    end(S); return true;
  };

  // ======================================================================
  // 排程：每個人一張動作清單（權重、做多久、冷卻），隨機挑，不連續做同一個
  // ======================================================================
  // [動作, 權重, [最短, 最長]秒, 冷卻秒, 'walk' = 走路時也能做]
  const LIST = {
    npc_ken:[['town_ken_scroll', 5, [4, 7], 0], ['town_ken_yawn', 1.3, [3.3, 3.3], 9], ['town_ken_rub', 1.1, [2.9, 2.9], 8], ['town_ken_sigh', 1.1, [3.1, 3.1], 8]],
    npc_boss:[['town_boss_admire', 2.5, [2.5, 4.5], 0], ['town_boss_polish', 2, [3.7, 3.7], 6], ['town_boss_watch', 1.5, [2.9, 2.9], 8], ['town_boss_call', 1.2, [4.0, 4.0], 12]],
    npc_guard:[['town_guard_patrol', 3, [3, 5], 0, 'walk'], ['town_guard_sip', 1.5, [3.3, 3.3], 8], ['town_guard_doze', 1.0, [4.3, 4.3], 14]],
    npc_auntie:[['town_auntie_mop', 2, [2.2, 3.5], 0, 'walk'], ['town_auntie_wring', 1.5, [2.3, 2.3], 6], ['town_auntie_grumble', 1.4, [2.3, 2.3], 7]],
    xiaozhi:[['town_paper_fold', 3, [4.8, 7.2], 0], ['town_paper_arrange', 2, [4.4, 6.6], 4]],
    xiaogui:[['town_haggle_polish', 3, [3, 5], 0], ['town_haggle_squint', 2, [3.1, 3.1], 6]],
    baiwu:[['town_exch_count', 3, [3.6, 7.2], 0], ['town_exch_stamp', 1.5, [2.1, 2.1], 5]],
    eguiking:[['town_food_stir', 3, [3, 5], 0], ['town_food_ladle', 2, [3.0, 6.0], 3], ['town_food_taste', 1.3, [3.3, 3.3], 10]],
  };
  // st：角色身上的排程狀態 { act, at, dur, w, cd:{} }；eligible：現在能不能做（false = 慢慢放回原圖姿勢）；walk：正在走路
  function tick(st, id, dt, eligible, walk, force) {
    const L = LIST[id]; if (!L) return st;
    st = st || { act:null, at:0, dur:0, w:0, cd:{} };
    for (const k in st.cd) st.cd[k] -= dt;
    const can = (e) => !walk || e[4] === 'walk';
    if (force && (st.act !== force[0] || st.at > st.dur)) { st.act = force[0]; st.at = 0; st.dur = force[1]; }
    st.at += dt;
    const cur = L.find(e => e[0] === st.act);
    const want = eligible && (st.act && cur ? can(cur) : true);
    st.w = cl(st.w + (want ? 1 : -1) * dt / 0.25);
    if (eligible && (!st.act || st.at >= st.dur || (cur && !can(cur) && st.w <= 0))) {
      const opts = L.filter(e => can(e) && (st.cd[e[0]] || 0) <= 0 && (e[0] !== st.act || L.filter(can).length === 1));
      if (opts.length) {
        let r = Math.random() * opts.reduce((s, e) => s + e[1], 0), e = opts[0];
        for (const o of opts) { r -= o[1]; if (r <= 0) { e = o; break; } }
        st.act = e[0]; st.at = 0; st.dur = e[2][0] + Math.random() * (e[2][1] - e[2][0]); st.cd[e[0]] = e[3] + st.dur;
      }
    }
    if (!eligible && st.w <= 0) st.act = null;
    return st;
  }
  // 畫的時候要加的參數（沒在做就回傳空的）
  const opts = (st) => (st && st.act && st.w > 0) ? { act:st.act, at:st.at, adur:st.dur, aw:ss(st.w) } : {};

  // ---------- 回陽間：scare.js 用 ----------
  // 冷靜（沒被嚇）＋沒在反應（或是木訥／保安喝茶）＝ 可以做平日動作
  function npcTick(n, dt, scare) {
    const d = n.d, rx = n.rx && n.rx.t >= 0 ? n.rx : null;
    const calm = !n.fleeing && !n.gone && n.fear < 25 && (!rx || rx.k === 'numb' || rx.k === 'sip');
    const walk = n.act === 'walk';
    const force = rx && rx.k === 'sip' && d.spr === 'npc_guard' ? ['town_guard_sip', Math.max(3.3, rx.dur + 0.4)] : null;
    n.daily = tick(n.daily, d.spr, dt, calm, walk, force);
  }
  const npcOpts = (n) => opts(n.daily);

  return { tick, opts, npcTick, npcOpts, LIST };
})();
