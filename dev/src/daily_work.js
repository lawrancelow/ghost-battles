// 平日動作
// ===================== 崗位打工（伐木、割稻、做棺材板、包壽包、管倉庫、工頭、練陰兵、燒金紙）=====================
// 任何鬼怪都做得來：
//   身體 = 原圖網格變形（MeshAnim／MoveKit）；有拆出手的角色（limbs.json）用那隻原圖的手拿工具；
//   拆不開的（Toyol、Pocong、Penanggal）和餓鬼（拆的是頭）用整個身體做：彎腰、跳上去壓、頭頂扛、隔空把東西飄起來。
//   工具和道具全是原圖：tool_axe／tool_mallet／tool_sickle、fx_*；木頭、木箱、米袋、蒸籠、包子、金紙是從建築原圖拆出來的（art/cutprop_work.py）。
//   木屑、米粒、蒸氣、汗、金幣、火苗是程式畫的蠟筆小特效。
// 用法：ART.drawChar(ctx, id, x, y, s, { act:'work_chop', at:秒, wv:{...} })；遊戲裡由 WORK.drawWorker 排班（每隻鬼輪流做 2～3 種，彼此不同步）。
// F 座標：原點 = 腳底，+x = 面向的那邊，y 往下；動作裡的長度都以身高 H 為單位，角度用「度」（正 = 往前）。
const WORK = (() => {
  const D = Math.PI / 180, TAU = Math.PI * 2;
  const cl = (v, a = 0, b = 1) => v < a ? a : v > b ? b : v, lerp = (a, b, k) => a + (b - a) * k;
  const seg = (t, a, b) => cl((t - a) / (b - a));
  const E = {
    lin:(t) => t, o:(t) => 1 - (1 - t) * (1 - t), i:(t) => t * t, io:(t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t),
    o3:(t) => 1 - Math.pow(1 - t, 3), i3:(t) => t * t * t, sin:(t) => 0.5 - 0.5 * Math.cos(Math.PI * t),
    back:(t) => { const c = 1.7; return 1 + (c + 1) * Math.pow(t - 1, 3) + c * Math.pow(t - 1, 2); },
  };
  const rnd = (i) => { const v = Math.sin(i * 127.1 + 311.7) * 43758.5453; return v - Math.floor(v); };
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  // ---------- 關鍵姿勢 ----------
  // lean 整個人前傾（度）｜dx,dy 位移（H）｜sx,sy 擠壓｜bend 上半身彎腰（度）｜head 點頭（度）｜hx,hy 手的位移（H）｜hr 手轉（度）｜ang 工具角度（0 = 朝上，正 = 往前倒）
  const DEF = { lean:0, dx:0, dy:0, sx:1, sy:1, bend:0, head:0, hx:0, hy:0, hr:0, ang:0 };
  // keys = [[時間, {欄位}, 緩動名]]；緩動名套用在「到達這一格」的那一段
  function kf(keys, t) {
    const full = (o) => Object.assign({}, DEF, o);
    if (t <= keys[0][0]) return full(keys[0][1]);
    for (let i = 1; i < keys.length; i++) {
      if (t <= keys[i][0]) {
        const a = full(keys[i - 1][1]), b = full(keys[i][1]), q = (E[keys[i][2] || 'io'])((t - keys[i - 1][0]) / ((keys[i][0] - keys[i - 1][0]) || 1)), o = {};
        for (const k in a) o[k] = lerp(a[k], b[k], q);
        return o;
      }
    }
    return full(keys[keys.length - 1][1]);
  }
  const add = (k, o) => { for (const n in o) k[n] = (n === 'sx' || n === 'sy') ? k[n] * o[n] : k[n] + o[n]; return k; };

  // ---------- 角色資料 ----------
  const HOPS = { laojiang:1, zombie:1, pocong:1 };       // 殭屍類：走路用跳的
  const ARMCARRY = { laojiang:1, zombie:1 };             // 殭屍：兩手平舉，東西放在手上扛
  const PAPER = { zhiren:1, xiaozhi:1 };                 // 紙紮的：怕火
  const GLUTTON = { egui:1, eguiking:1 };                // 餓鬼：偷吃特別多
  const SOLIDS = { laojiang:1, zombie:1, pocong:1, xiaozhi:1, zhiren:1, penanggal:1, npc_ken:1, npc_boss:1, npc_guard:1, npc_auntie:1 };
  const RC = {};
  function rigOf(id) {
    if (RC[id]) return RC[id];
    const special = typeof SPECIAL !== 'undefined' && SPECIAL.has(id);
    const C = typeof LIMBS_DATA !== 'undefined' ? LIMBS_DATA.chars[id] : null;
    const arm = !special && !!C && ok(id + '__body') && ok(id + '__arm') && !(C.still && C.still.indexOf('head') >= 0) && typeof MoveKit !== 'undefined';
    const RG = !special && typeof MeshAnim !== 'undefined' ? MeshAnim.RIG[id] : null;
    const bone = (n) => RG && RG.bones.find(b => b[0] === n);
    const bb = bone('body'), hb = bone('head');
    const img = SPR[arm ? id + '__body' : id]; if (!img || !img.naturalWidth) return null;
    const ar = img.naturalWidth / img.naturalHeight;
    const nr = !!((typeof MeshAnim !== 'undefined' && MeshAnim.NATIVE_R || {})[id] || (C && C.nativeR));
    const pv = arm ? C.pivot : null, gp = arm ? (C.grip || C.tip || C.pivot) : null;
    const long = arm ? Math.hypot((C.tip[0] - C.pivot[0]) * ar, C.tip[1] - C.pivot[1]) > 0.12 : false;
    return RC[id] = { id, special, arm, C, nr, ar, pv, gp, long, mesh:!special && !!RG,
      bp:bb ? [bb[2], bb[3]] : [0.5, 0.66], hd:hb ? [hb[4], hb[5]] : [0.5, 0.2], legs:!!(RG && RG.legs), hop:!!HOPS[id], solid:!!SOLIDS[id] };
  }
  const TOOLS = {
    axe:{ key:'tool_axe', len:0.44, grip:[0.5, 0.86], head:[0.42, 0.2], mir:true },
    mallet:{ key:'tool_mallet', len:0.34, grip:[0.5, 0.86], head:[0.5, 0.18], mir:false },
    sickle:{ key:'tool_sickle', len:0.32, grip:[0.13, 0.86], head:[0.6, 0.2], mir:false },
  };
  const M = () => new MoveKit.M();

  // ---------- 解算：身體矩陣、手、工具、頭頂、嘴 ----------
  function solve(a, fr) {
    const R = rigOf(a.type), H = a.H, k = fr.k, W = H * R.ar, t = a.o.t || 0;
    const ip = (u, v) => [(R.nr ? 1 : -1) * (u - 0.5) * W, (v - 1) * H];
    const fwd = (u, du) => R.nr ? u + du : u - du;
    const fl = R.solid || R.special ? 0 : (3 + Math.sin(t * 2.4) * 2) * a.s;
    let dy = k.dy * H, lean = k.lean, legF = 0, legB = 0, sx = k.sx, sy = k.sy, lift = -k.dy;
    if (fr.walk) { // 走路：殭屍跳、有腳的踏步、鬼用飄的
      const w = fr.walk;
      if (R.hop) { const h = Math.abs(Math.sin(w * 5.5)); dy -= h * 0.1 * H; lift += h * 0.1; const g = 1 - Math.min(1, h * 6); sy *= 1 - 0.07 * g; sx *= 1 + 0.05 * g; }
      else if (R.legs) { legF = Math.sin(w * 8) * 0.34; legB = -legF; dy -= Math.abs(Math.sin(w * 8)) * 0.022 * H; }
      else { lean += 7; dy -= Math.sin(w * 4) * 0.015 * H; }
    }
    const hip = R.special ? 0.35 : 1 - R.bp[1];
    const bm = M().t((fr.ox || 0) * H, fr.oy || 0).s(fr.face || 1, 1).t(k.dx * H, dy - fl).t(0, -hip * H).r(lean * D).t(0, hip * H).s(sx, sy);
    const P = { R, H, W, bm, lift, legF, legB, fl };
    if (R.special) {
      const b2 = k.bend * 0.55;
      P.bm = bm.clone().t(0, -0.3 * H).r(b2 * D).t(0, 0.3 * H);
      P.top = P.bm.pt(0, -0.97 * H); P.mouth = P.bm.pt(0.12 * H, -0.7 * H); P.G = P.bm.pt(0.3 * H, -0.45 * H); P.belly = P.bm.pt(0.15 * H, -0.4 * H);
      return P;
    }
    const mp = R.arm ? MoveKit.pose(P.K = { id:R.id, nr:R.nr, W, H, C:R.C, t, o:a.o }, { body:k.bend * D, head:k.head * D, legF, legB }) : null;
    let yoff;
    if (mp) yoff = (mp.y || 0) * H;
    else { const z = MeshAnim.ANIM.idle(t); yoff = (z.y || 0) * H; }
    P.mp = mp;
    const bend = k.bend * D, c = Math.cos(bend), s = Math.sin(bend), bpp = ip(R.bp[0], R.bp[1] * R.ar); // MeshAnim 的骨頭支點是在 (u, v·高寬比) 空間轉的：實際支點在 v = 支點v × 寬/高
    const bodyPt = (u, v) => { const p = ip(u, v), dx = p[0] - bpp[0], dy2 = p[1] - bpp[1]; return [bpp[0] + c * dx - s * dy2, bpp[1] + s * dx + c * dy2 + yoff]; };
    P.bodyPt = bodyPt;
    const at = (p) => P.bm.pt(p[0], p[1]);
    P.top = at(bodyPt(R.hd[0], 0.02)); P.mouth = at(bodyPt(fwd(R.hd[0], 0.13), R.hd[1] + 0.09)); P.belly = at(bodyPt(fwd(R.bp[0], 0.18), R.bp[1] - 0.1));
    if (R.arm) {
      const hp = bodyPt(R.pv[0], R.pv[1]);
      const hmL = M().t(hp[0] + k.hx * H, hp[1] + k.hy * H).r((k.hr + k.bend) * D);
      P.hm = bm.clone().mul(hmL);
      const gl = hmL.pt((R.nr ? 1 : -1) * (R.gp[0] - R.pv[0]) * W, (R.gp[1] - R.pv[1]) * H);
      P.G = at(gl); P.gl = gl;
      if (fr.tool) {
        const T = TOOLS[fr.tool], img = SPR[T.key];
        if (img && img.naturalWidth) {
          const th = T.len * H, tw = th * img.naturalWidth / img.naturalHeight, mx = T.mir ? -1 : 1;
          const tm = bm.clone().t(gl[0], gl[1]).r(k.ang * D);
          P.tool = { tm, img, th, tw, T, mx }; P.tip = tm.pt(mx * (T.head[0] - T.grip[0]) * tw, (T.head[1] - T.grip[1]) * th);
        }
      }
    } else {
      P.G = at(bodyPt(fwd(R.bp[0], 0.26), 0.5));
    }
    return P;
  }
  // ---------- 畫 ----------
  function prop(ctx, key, x, y, w, rot, o) { // 道具：(x,y) = 錨點（預設底邊中央），w = 寬
    const img = SPR[key]; if (!img || !img.naturalWidth || w <= 0) return;
    o = o || {}; const h = w * img.naturalHeight / img.naturalWidth, an = o.an || [0.5, 1];
    ctx.save(); if (o.alpha != null) ctx.globalAlpha *= cl(o.alpha);
    ctx.translate(x, y); if (rot) ctx.rotate(rot * D); if (o.sx || o.sy) ctx.scale(o.sx || 1, o.sy || 1); if (o.flip) ctx.scale(-1, 1);
    if (o.clip) { ctx.beginPath(); ctx.rect((o.clip[0] - an[0]) * w, -an[1] * h - 2, (o.clip[1] - o.clip[0]) * w, h + 4); ctx.clip(); }
    ctx.drawImage(img, -an[0] * w, -an[1] * h, w, h); ctx.restore();
  }
  const propH = (key, w) => { const img = SPR[key]; return img && img.naturalWidth ? w * img.naturalHeight / img.naturalWidth : w * 0.6; };
  function shadow(ctx, a, P, x) {
    if (a.o.shadow === false) return;
    const k = Math.max(0.45, 1 - P.lift * 1.6), r = 14 * a.s * (P.R.solid ? 1 : 0.8) * k;
    ctx.save(); if (!P.R.solid) ctx.globalAlpha *= 0.55; ctx.fillStyle = 'rgba(0,0,0,.35)';
    ctx.beginPath(); ctx.ellipse(x, 1 * a.s, r, r * 0.29, 0, 0, TAU); ctx.fill(); ctx.restore();
  }
  function drawBody(ctx, a, P, fr) {
    const R = P.R, H = P.H, k = fr.k;
    if (R.special) {
      ctx.save(); P.bm.set(ctx); const ef = (a.faceRight ? 1 : -1) * (fr.face || 1); ctx.scale(ef, 1);
      ART.drawChar(ctx, R.id, 0, 0, a.s, { t:a.o.t, flip:ef < 0, shadow:false, key:a.o.wkey != null ? 'w' + a.o.wkey : undefined, work:false });
      ctx.restore(); return;
    }
    if (R.arm) { MoveKit.body(ctx, P.K, P.bm, P.mp); return; }
    const z = MeshAnim.ANIM.idle(a.o.t || 0); z.body = (z.body || 0) + k.bend * D; z.head = (z.head || 0) + k.head * D; z.legF = P.legF; z.legB = P.legB;
    ctx.save(); P.bm.set(ctx); MeshAnim.draw(ctx, R.id, 0, 0, H, z, true); ctx.restore();
  }
  function drawTool(ctx, P) {
    const T = P.tool; if (!T) return;
    ctx.save(); T.tm.set(ctx); ctx.scale(T.mx, 1); ctx.drawImage(T.img, -T.T.grip[0] * T.tw, -T.T.grip[1] * T.th, T.tw, T.th); ctx.restore();
  }
  function drawHand(ctx, P, key) {
    if (!P.R.arm) return;
    MoveKit.piece(ctx, P.K, key || P.R.id + '__arm', P.hm, P.R.pv[0], P.R.pv[1]);
  }
  // fr = { k:姿勢, tool, face, ox, oy, walk, back(ctx,P), mid(ctx,P)（身體和手之間）, front(ctx,P), hand:手的圖 }
  function render(ctx, a, fr) {
    const P = solve(a, fr);
    ctx.save(); ctx.translate(a.x, a.y); ctx.scale(a.faceRight ? 1 : -1, 1);
    if (fr.back0) fr.back0(ctx, P);
    shadow(ctx, a, P, P.bm.e);
    if (fr.back) fr.back(ctx, P);
    if (fr.toolBehind) drawTool(ctx, P);
    drawBody(ctx, a, P, fr);
    if (fr.mid) fr.mid(ctx, P);
    if (!fr.toolBehind) drawTool(ctx, P);
    if (fr.hand !== false) drawHand(ctx, P, fr.hand || (P.R.id === 'eguiking' && (fr.tool || fr.emptyHand) && ok('eguiking__hand') ? 'eguiking__hand' : null));
    if (fr.front) fr.front(ctx, P);
    ctx.restore();
    return P;
  }
  // 試算某一格的位置（不畫），拿來擺道具（木樁高度、蒸籠高度……）；以身高為單位快取
  const AIM = {};
  function aim(a, name, fn) {
    const key = a.type + '|' + name;
    if (!AIM[key]) {
      const P = solve({ type:a.type, x:0, y:0, s:a.s / a.H, H:1, o:{ t:0 }, faceRight:true }, fn());
      const pick = (p) => p ? [p[0], p[1]] : null;
      AIM[key] = { G:pick(P.G), tip:pick(P.tip), top:pick(P.top), mouth:pick(P.mouth), belly:pick(P.belly) };
    }
    const A = AIM[key], H = a.H, sc = (p) => p ? [p[0] * H, p[1] * H] : null;
    return { G:sc(A.G), tip:sc(A.tip), top:sc(A.top), mouth:sc(A.mouth), belly:sc(A.belly) };
  }

  // ---------- 蠟筆小特效 ----------
  const crayon = (ctx, pts, col, w, seed, alpha) => MoveKit.crayon(ctx, pts, col, w, seed, alpha);
  // 噴出來的小東西：拋物線，n 顆，age 秒
  function spray(ctx, x, y, age, life, n, seed, H, opt, drawOne) {
    if (age < 0 || age > life) return;
    for (let i = 0; i < n; i++) {
      const r1 = rnd(seed + i * 3.1), r2 = rnd(seed + i * 5.7 + 1), r3 = rnd(seed + i * 9.3 + 2);
      const vx = ((opt.dir || 0) + (r1 - 0.5) * (opt.spread || 1.6)) * H * (opt.v || 1.1), vy = -(0.6 + r2 * 0.9) * H * (opt.up || 1.3);
      const g = (opt.g || 5.5) * H, px = x + vx * age, py = Math.min(opt.floor != null ? opt.floor : 1e9, y + vy * age + 0.5 * g * age * age);
      const al = 1 - Math.pow(age / life, 2);
      drawOne(ctx, px, py, i, al, r3, age);
    }
  }
  function chips(ctx, x, y, age, seed, H, floor) {
    spray(ctx, x, y, age, 0.55, 5, seed, H, { up:1.1, floor }, (c, px, py, i, al, r, ag) => {
      const w = H * (0.05 + r * 0.035); c.save(); c.globalAlpha *= al; c.translate(px, py); c.rotate((r * 6 + ag * (8 + r * 10)) * (i % 2 ? 1 : -1));
      const img = SPR.fx_chips; if (img && img.naturalWidth) c.drawImage(img, -w / 2, -w / 2, w, w); c.restore();
    });
  }
  function grains(ctx, x, y, age, seed, H, dir) {
    spray(ctx, x, y, age, 0.6, 7, seed, H, { up:1.0, v:0.8, dir:dir || 0, spread:1.4 }, (c, px, py, i, al, r) => {
      c.save(); c.globalAlpha *= al; crayon(c, [[px, py], [px + H * 0.018 * (r - 0.5), py - H * 0.022]], i % 3 ? '#f2cf5a' : '#c9a23a', Math.max(1, H * 0.022), seed + i); c.restore();
    });
  }
  const TINT = {};
  function tinted(kind) { // fx_dust 染成木屑色（先在小畫布上染好，不能在主畫布上 source-atop）
    const img = SPR.fx_dust; if (!img || !img.naturalWidth) return null;
    if (TINT[kind]) return TINT[kind];
    const c = document.createElement('canvas'); c.width = img.naturalWidth; c.height = img.naturalHeight; const x = c.getContext('2d');
    x.drawImage(img, 0, 0); x.globalCompositeOperation = 'source-atop'; x.fillStyle = 'rgba(165,112,58,.5)'; x.fillRect(0, 0, c.width, c.height);
    return TINT[kind] = c;
  }
  function puff(ctx, x, y, age, life, w, seed, tint) { // fx_dust 一團，往上散開淡掉
    if (age < 0 || age > life) return; const q = age / life, img = tint === 'wood' ? tinted('wood') : SPR.fx_dust; if (!img || !img.width) return;
    ctx.save(); ctx.globalAlpha *= (1 - q) * (tint === 'flour' ? 0.85 : tint === 'wood' ? 0.6 : 0.4);
    const ww = w * (0.6 + 0.7 * E.o(q)), hh = ww * img.height / img.width; ctx.translate(x + (rnd(seed) - 0.5) * w * 0.3 * q, y - w * 0.35 * q);
    if (rnd(seed + 1) < 0.5) ctx.scale(-1, 1);
    ctx.drawImage(img, -ww / 2, -hh, ww, hh);
    ctx.restore();
  }
  function spark(ctx, x, y, age, w) {
    if (age < 0 || age > 0.16) return; const img = SPR.fx_spark; if (!img || !img.naturalWidth) return;
    const q = age / 0.16, ww = w * (0.5 + 0.7 * E.o(q));
    ctx.save(); ctx.globalAlpha *= 1 - q; ctx.translate(x, y); ctx.rotate(q * 0.6); ctx.drawImage(img, -ww / 2, -ww / 2, ww, ww); ctx.restore();
  }
  function steam(ctx, x, y, age, life, H, seed, n) { // 一縷一縷往上捲
    if (age < 0) return;
    for (let i = 0; i < (n || 3); i++) {
      const a0 = age - i * 0.18; if (a0 < 0 || a0 > life) continue;
      const q = a0 / life, ox = (i - 1) * H * 0.07, pts = [];
      for (let j = 0; j <= 6; j++) { const f = j / 6; pts.push([x + ox + Math.sin(f * 5 + a0 * 4 + i) * H * 0.035 * (0.4 + f), y - H * (0.05 + 0.32 * E.o(q)) * f - H * 0.25 * q]); }
      ctx.save(); ctx.globalAlpha *= (1 - q) * 0.8; crayon(ctx, pts, 'rgba(240,240,236,.95)', Math.max(1.2, H * 0.03 * (1 - q * 0.5)), seed + i * 13); ctx.restore();
    }
  }
  function sweat(ctx, x, y, age, H, seed) {
    if (age < 0 || age > 0.7) return;
    for (let i = 0; i < 2; i++) {
      const q = age / 0.7, dir = i ? 1 : -0.6, px = x + dir * H * 0.12 * q, py = y - H * 0.08 * Math.sin(q * Math.PI) + H * 0.12 * q * q;
      ctx.save(); ctx.globalAlpha *= 1 - q * q; ctx.translate(px, py); ctx.rotate(dir * 0.5);
      const r = H * 0.026; ctx.fillStyle = '#bfe6ff'; ctx.strokeStyle = '#3a6e96'; ctx.lineWidth = Math.max(0.8, r * 0.35);
      ctx.beginPath(); ctx.moveTo(0, -r * 1.7); ctx.quadraticCurveTo(r * 1.1, -r * 0.1, 0, r); ctx.quadraticCurveTo(-r * 1.1, -r * 0.1, 0, -r * 1.7); ctx.fill(); ctx.stroke(); ctx.restore();
    }
  }
  function coin(ctx, x, y, H, rot, alpha) { // 冥幣：金色圓、方孔
    const r = H * 0.045; ctx.save(); if (alpha != null) ctx.globalAlpha *= cl(alpha); ctx.translate(x, y); ctx.scale(Math.max(0.15, Math.abs(Math.cos(rot || 0))), 1);
    ctx.fillStyle = '#f0c24a'; ctx.strokeStyle = '#6b4a12'; ctx.lineWidth = Math.max(0.8, r * 0.28);
    ctx.beginPath(); ctx.arc(0, 0, r, 0, TAU); ctx.fill(); ctx.stroke();
    ctx.fillStyle = '#6b4a12'; ctx.fillRect(-r * 0.28, -r * 0.28, r * 0.56, r * 0.56);
    ctx.fillStyle = 'rgba(255,250,210,.8)'; ctx.beginPath(); ctx.arc(-r * 0.45, -r * 0.45, r * 0.22, 0, TAU); ctx.fill(); ctx.restore();
  }
  function coinFlat(ctx, x, y, H, alpha) { // 疊起來的冥幣（側面看：扁的）
    const r = H * 0.045; ctx.save(); if (alpha != null) ctx.globalAlpha *= cl(alpha);
    ctx.fillStyle = '#d9a83a'; ctx.strokeStyle = '#6b4a12'; ctx.lineWidth = Math.max(0.8, r * 0.25);
    ctx.beginPath(); ctx.ellipse(x, y, r, r * 0.38, 0, 0, TAU); ctx.fill(); ctx.stroke();
    ctx.fillStyle = 'rgba(255,240,180,.7)'; ctx.beginPath(); ctx.ellipse(x - r * 0.3, y - r * 0.08, r * 0.35, r * 0.1, 0, 0, TAU); ctx.fill(); ctx.restore();
  }
  function twinkle(ctx, x, y, age, H, seed) {
    if (age < 0 || age > 0.45) return; const q = age / 0.45;
    MoveKit.burst(ctx, x, y, H * 0.12, 1 - q, '#ffe9a0', seed, 6);
  }
  function flame(ctx, x, y, age, life, H, seed) { // 火舌一下竄出來
    if (age < 0 || age > life) return; const q = age / life, k = Math.sin(Math.min(1, q * 2.2) * Math.PI * 0.5) * (1 - E.i(q));
    for (let i = 0; i < 4; i++) {
      const ox = (i - 1.5) * H * 0.05, hh = H * (0.12 + 0.12 * rnd(seed + i)) * k, sw = Math.sin(age * 25 + i * 2) * H * 0.02;
      crayon(ctx, [[x + ox, y], [x + ox * 1.2 + sw, y - hh * 0.6], [x + ox * 0.6 - sw, y - hh]], i % 2 ? '#ffb43a' : '#ff6a2a', Math.max(1.2, H * 0.035 * k), seed + i * 7);
    }
    spark(ctx, x, y - H * 0.08, age, H * 0.22);
  }
  function wisp(ctx, from, to, H, seed, alpha) { // 隔空搬東西：一縷鬼氣
    ctx.save(); ctx.globalAlpha *= 0.45 * cl(alpha == null ? 1 : alpha);
    const mx = (from[0] + to[0]) / 2, my = Math.min(from[1], to[1]) - H * 0.08;
    const pts = []; for (let j = 0; j <= 8; j++) { const f = j / 8, x = (1 - f) * (1 - f) * from[0] + 2 * (1 - f) * f * mx + f * f * to[0], y = (1 - f) * (1 - f) * from[1] + 2 * (1 - f) * f * my + f * f * to[1]; pts.push([x, y + Math.sin(f * 9 + seed) * H * 0.01]); }
    crayon(ctx, pts, 'rgba(160,230,220,.9)', Math.max(1, H * 0.02), seed); ctx.restore();
  }
  function bang(ctx, x, y, H, k, seed) { // 「！」
    if (k <= 0) return; ctx.save(); ctx.globalAlpha *= cl(k);
    crayon(ctx, [[x, y - H * 0.16], [x + H * 0.01, y - H * 0.05]], '#ffe27a', Math.max(1.5, H * 0.04), seed);
    crayon(ctx, [[x + H * 0.012, y - H * 0.012], [x + H * 0.014, y]], '#ffe27a', Math.max(1.5, H * 0.045), seed + 3); ctx.restore();
  }
  const sp = (v) => (v && v.sp) || 1;

  // ===================== 各動作 =====================
  const ACT = {};
  // ---------- 伐木場：劈柴 ----------
  // 有手：斧頭往後舉過頭（預備，停一下）→ 加速劈下 → 砍中（木屑噴、木頭彈一下、斧頭卡住震）→ 拔起來回到架式；劈幾下之後木頭裂成兩半倒開
  // 沒手：縮身蓄力 → 跳起來 → 整個人壓到木頭上（壓扁）→ 彈回原位
  const CHOP_T = 1.25;
  function chopKeys(R, p) {
    if (R.arm) return kf([[0, { ang:45 }], [0.36, { ang:-76, hy:-0.07, hx:-0.03, lean:-8, dx:-0.03, dy:-0.02, sy:1.05, sx:0.96, bend:-6, head:-6 }, 'o'],
      [0.5, { ang:-84, hy:-0.075, hx:-0.035, lean:-9, dx:-0.035, dy:-0.025, sy:1.06, sx:0.955, bend:-7, head:-8 }, 'io'],
      [0.6, { ang:94, hy:0.03, hx:0.05, lean:11, dx:0.05, sx:1.05, sy:0.95, bend:14, head:6 }, 'i3'],
      [0.76, { ang:92, hy:0.03, hx:0.05, lean:10, dx:0.05, sx:1.02, sy:0.98, bend:13, head:5 }, 'o'], [1, { ang:45 }, 'io']], p);
    return kf([[0, {}], [0.3, { sy:0.86, sx:1.1, lean:-4 }, 'o'], [0.5, { dy:-0.36, dx:0.22, sy:1.1, sx:0.93, lean:8 }, 'o'],
      [0.6, { dy:-0.2, dx:0.4, sy:0.8, sx:1.2, lean:4 }, 'i3'], [0.72, { dy:-0.2, dx:0.4, sy:0.9, sx:1.1 }, 'o'],
      [0.86, { dy:-0.3, dx:0.22, sy:1.05, sx:0.96 }, 'o'], [1, {}, 'io']], p);
  }
  function handRot(R, k, ang0) { if (R.arm) k.hr += (k.ang - ang0) * (R.long ? 0.55 : 0.2); return k; }
  ACT.chop = {
    dur:(v) => v.n * CHOP_T / sp(v) + 1.0,
    f(a, R, at, v) {
      const T = CHOP_T / sp(v), H = a.H, n = v.n, i = Math.min(n - 1, Math.floor(at / T)), p = at < n * T ? (at - i * T) / T : 1, tail = at - n * T;
      const k = handRot(R, chopKeys(R, p), 45);
      if (R.arm && p > 0.6 && p < 0.7) k.ang += Math.sin((p - 0.6) * T * 90) * 4 * (1 - (p - 0.6) / 0.1);
      if (tail > 0) add(k, { head:Math.sin(seg(tail, 0.2, 0.7) * Math.PI) * 8, sy:1 + Math.sin(seg(tail, 0.2, 0.7) * Math.PI) * 0.02 });
      // 木樁和木頭：擺在斧頭砍中的地方
      const A = aim(a, 'chop', () => ({ k:handRot(R, chopKeys(R, 0.6), 45), tool:'axe' }));
      const hitX = R.arm ? A.tip[0] : 0.4 * H, logT = 0.12 * H;
      let top = R.arm ? cl(-A.tip[1] - logT * 0.55, 0.16 * H, 0.42 * H) : 0.2 * H;
      const sw = top / 0.84 * 620 / 408, logW = Math.min(0.34 * H, sw * 0.8);
      const hitAge = (j) => at - (j * T + 0.6 * T);
      const back = (ctx) => {
        prop(ctx, 'stump', hitX, 0.5, sw, 0, { an:[0.5, 0.97] });
        const ly = -top + 0.02 * H; let bounce = 0;
        for (let j = 0; j < n; j++) { const g = hitAge(j); if (g > 0 && g < 0.2) bounce = -Math.sin(g / 0.2 * Math.PI) * 0.025 * H * (j === n - 1 ? 0 : 1); }
        const gL = hitAge(n - 1);
        if (gL < 0) { const pop = E.back(seg(at, 0, 0.3)); prop(ctx, 'wood__log', hitX, ly + bounce, logW * pop, 0, { an:[0.5, 1] }); }
        else { // 裂成兩半往兩邊倒，滾到地上淡掉
          const q = seg(gL, 0, 0.5), fall = E.i(q), al = 1 - seg(gL, 0.6, 0.95);
          prop(ctx, 'wood__log', hitX - fall * 0.16 * H, lerp(ly, 0, fall), logW, -fall * 70, { an:[1, 1], clip:[0, 0.5], alpha:al });
          prop(ctx, 'wood__log', hitX + fall * 0.16 * H, lerp(ly, 0, fall), logW, fall * 70, { an:[0, 1], clip:[0.5, 1], alpha:al });
        }
      };
      const front = (ctx) => { for (let j = 0; j < n; j++) { const g = hitAge(j); chips(ctx, hitX, -top, g, 11 + j * 7 + v.seed, H, 0); if (j === n - 1) puff(ctx, hitX, 0, g - 0.25, 0.5, 0.3 * H, 5 + v.seed, 'wood'); } };
      return { k, tool:'axe', back, front, toolBehind:R.arm && k.ang < -12 };
    },
  };
  // ---------- 搬東西（伐木場搬木頭、倉庫搬木箱）----------
  // 彎腰 → 抓住（用力縮一下）→ 抬起來扛到頭頂（殭屍：放在平舉的手上）→ 轉身走到後面那堆 → 往前一拋，東西落到堆上（揚塵）→ 轉回來走回原位
  function carry(key, w, pileKey) {
    return {
      dur:(v) => 5.2 / sp(v),
      f(a, R, at, v) {
        const s = sp(v), t = at * s, H = a.H, armC = !!ARMCARRY[R.id] && R.arm;
        const k = kf([[0, {}], [0.5, { bend:34, lean:8, head:10, sy:0.96, hy:0.05 }, 'io'], [0.62, { bend:30, lean:6, sy:0.88, sx:1.08, hy:0.05 }, 'o'],
          [0.9, { bend:-4, lean:-3, sy:1.06, sx:0.96, hy:armC ? 0 : -0.03 }, 'o'], [1.1, { sy:0.93, sx:1.05, hy:armC ? 0 : -0.03 }, 'io'], [1.3, { sy:0.96, sx:1.02 }],
          [2.75, { sy:0.96, sx:1.02 }], [2.9, { lean:-6, sy:1.02 }, 'o'], [3.05, { lean:12, sy:0.95, sx:1.04 }, 'i'], [3.3, {}, 'io']], t);
        let face = 1, ox = 0, walk = 0;
        if (t > 1.15 && t < 3.35) face = -1;
        const X1 = -0.62; // 走到後面的距離
        if (t > 1.3 && t < 2.7) { ox = lerp(0, X1, E.sin(seg(t, 1.3, 2.7))); walk = t; }
        else if (t >= 2.7 && t < 3.5) ox = X1;
        else if (t >= 3.5 && t < 4.9) { ox = lerp(X1, 0, E.sin(seg(t, 3.5, 4.9))); walk = t; }
        if (t > 1.1 && t < 1.3) add(k, { sy:1 - 0.05 * Math.sin(seg(t, 1.1, 1.3) * Math.PI) }); // 轉身時壓一下
        if (t > 3.3 && t < 3.5) add(k, { sy:1 - 0.04 * Math.sin(seg(t, 3.3, 3.5) * Math.PI) });
        const pw = w * H, ph = propH(key, pw), pileX = (X1 - 0.42) * H, gx = 0.3 * H;
        const fr = { k, face, ox, walk:walk ? walk * 1.0 : 0 };
        // 地上那一個：一開始就在，抬走之後，最後再出現（下一趟）
        const pick = (P) => armC ? [P.G[0], P.G[1] - 0.02 * H] : [P.top[0], P.top[1] + 0.02 * H];
        const pileTop = -ph * 0.72 * (pileKey === 'store__crate' ? 1.25 : 1.0);
        fr.back = (ctx, P) => {
          // 後面那堆
          prop(ctx, pileKey, pileX, 0.5, pw * 1.05, 0, { an:[0.5, 1] });
          prop(ctx, pileKey, pileX - 0.06 * H, -ph * 0.72, pw * 0.95, pileKey === 'wood__log' ? 4 : -3, { an:[0.5, 1] });
          if (t > 3.3) { const al = 1 - seg(t, 4.6, 5.0); prop(ctx, key, pileX + 0.05 * H, pileTop - ph * 0.62, pw * 0.9, pileKey === 'wood__log' ? -5 : 2, { an:[0.5, 1], alpha:al }); }
          if (t < 0.62) prop(ctx, key, gx, 0.5, pw, 0, { an:[0.5, 1] });
          if (t > 4.6) prop(ctx, key, gx, 0.5, pw * E.back(seg(t, 4.6, 5.0)), 0, { an:[0.5, 1] });
        };
        fr.front = (ctx, P) => {
          if (t >= 0.62 && t < 3.05) {
            const q = E.io(seg(t, 0.62, 0.95)), tp = pick(P), from = [gx, 0];
            const x = lerp(from[0], tp[0], q), y = lerp(from[1], tp[1], q) - Math.sin(q * Math.PI) * 0.12 * H;
            prop(ctx, key, x, y, pw, (face < 0 ? 1 : -1) * Math.sin(t * 6) * 1.5, { an:[0.5, 1] });
            if (!R.arm || (R.special && !armC)) { /* 頭頂扛 */ }
          } else if (t >= 3.05 && t < 3.3) { // 拋到堆上
            const q = seg(t, 3.05, 3.3), tp = pick(P), to = [pileX + 0.05 * H, pileTop - ph * 0.62];
            prop(ctx, key, lerp(tp[0], to[0], E.o(q)), lerp(tp[1], to[1], E.i(q)) - Math.sin(q * Math.PI) * 0.15 * H, pw * 0.95, -q * 12, { an:[0.5, 1] });
          }
          puff(ctx, pileX, pileTop * 0.4, t - 3.3, 0.5, 0.35 * H, 3 + v.seed, key === 'wood__log' ? 'wood' : null);
          puff(ctx, gx, 0, t - 0.6, 0.45, 0.25 * H, 9 + v.seed);
        };
        return fr;
      },
    };
  }
  ACT.haul = carry('wood__log', 0.4, 'wood__log');
  ACT.crate = carry('store__crate', 0.3, 'store__crate');
  // ---------- 歇一下：擦汗、伸懶腰 ----------
  ACT.rest = {
    dur:(v) => 3.6 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H;
      const wipe = R.arm ? (R.long ? { hr:-75, hx:0.02, hy:-0.08, head:10 } : { hy:-0.05, hx:-0.01, hr:-20, head:16, bend:10 }) : { head:14, bend:8, sy:0.97 };
      const k = kf([[0, {}], [0.35, { lean:-3, sy:1.02 }], [0.75, wipe, 'io'],
        [1.0, Object.assign({}, wipe, { hx:(wipe.hx || 0) - 0.03, hr:(wipe.hr || 0) - 12 }), 'io'], [1.25, Object.assign({}, wipe, { hx:(wipe.hx || 0) + 0.02 }), 'io'],
        [1.55, {}, 'io'], [2.15, { lean:-10, bend:-14, head:-14, sy:1.07, sx:0.96, hy:-0.03, dy:-0.01 }, 'o'], [2.5, { lean:-11, bend:-15, head:-16, sy:1.08, sx:0.955, hy:-0.035, dy:-0.012 }],
        [2.95, { sy:0.94, sx:1.04, head:6 }, 'io'], [3.6, {}, 'io']], t);
      if (t > 2.95 && t < 3.4) k.sy += Math.sin(seg(t, 2.95, 3.4) * Math.PI * 2) * 0.01;
      const front = (ctx, P) => { sweat(ctx, P.top[0] + 0.08 * H, P.top[1] + 0.14 * H, t - 1.1, H, 7 + v.seed); };
      return { k, front };
    },
  };
  // ---------- 糯米田：割稻 ----------
  // 彎腰、鐮刀伸到前面低處 → 往身邊一拉（米粒噴起）→ 退一小步，再割；割完直起腰
  const REAP_T = 0.95;
  function reapKeys(R, p) {
    if (R.arm) return kf([[0, { bend:28, lean:8, head:8, ang:120, hx:0.05, hy:0.04 }], [0.4, { bend:32, lean:10, head:10, ang:150, hx:0.08, hy:0.06, sy:0.97 }, 'o'],
      [0.58, { bend:26, lean:6, head:6, ang:205, hx:-0.03, hy:0.05, sy:0.95, sx:1.04 }, 'i3'], [0.72, { bend:25, lean:5, head:6, ang:210, hx:-0.035, hy:0.04 }, 'o'],
      [1, { bend:28, lean:8, head:8, ang:120, hx:0.05, hy:0.04 }, 'io']], p);
    return kf([[0, { bend:20, lean:10, head:10 }], [0.4, { bend:34, lean:16, head:16, sy:0.94, dx:0.03 }, 'o'], [0.58, { bend:14, lean:2, head:-6, sy:1.04, dx:-0.02 }, 'i3'],
      [0.75, { bend:16, lean:6, head:4 }, 'o'], [1, { bend:20, lean:10, head:10 }, 'io']], p);
  }
  ACT.reap = {
    dur:(v) => v.n * REAP_T / sp(v) + 1.4,
    f(a, R, at, v) {
      const T = REAP_T / sp(v), H = a.H, n = v.n, in0 = 0.5, body = at - in0;
      let k;
      if (body < 0) k = kf([[0, {}], [in0, R.arm ? { bend:28, lean:8, head:8, ang:120, hx:0.05, hy:0.04 } : { bend:20, lean:10, head:10 }, 'io']], at);
      else if (body < n * T) { const i = Math.floor(body / T), p = (body - i * T) / T; k = reapKeys(R, p); k.dx += -i * 0.06 - E.io(seg(p, 0.75, 1)) * 0.06; }
      else { const q = body - n * T; k = kf([[0, Object.assign(reapKeys(R, 1), {})], [0.5, { lean:-6, bend:-8, head:-8, sy:1.04 }, 'o'], [0.9, {}, 'io']], q); k.dx += -n * 0.06 * (1 - E.io(seg(q, 0.2, 0.9))); }
      if (R.arm) { k.hr += (k.ang - 120) * (R.long ? 0.4 : 0.15); }
      const front = (ctx, P) => {
        for (let j = 0; j < n; j++) { const g = body - (j * T + 0.55 * T); const x = (0.3 - j * 0.06) * H; grains(ctx, x, -0.18 * H, g, 21 + j * 5 + v.seed, H, -0.6); }
        if (!R.arm) for (let j = 0; j < n; j++) grains(ctx, P.mouth[0], P.mouth[1], body - (j * T + 0.5 * T), 33 + j + v.seed, H, 0.2);
      };
      return { k, tool:'sickle', front };
    },
  };
  // ---------- 糯米田：插秧 ----------
  // 彎腰把秧苗插進泥裡（水圈一圈），往後退一步再插；插完扶著腰直起來
  ACT.plant = {
    dur:(v) => v.n * 1.0 / sp(v) + 1.6,
    f(a, R, at, v) {
      const T = 1.0 / sp(v), H = a.H, n = v.n, in0 = 0.5, body = at - in0;
      const dip = R.arm ? (R.long ? { bend:30, lean:10, head:8, hr:35, hy:0.06, hx:0.03 } : { bend:40, lean:14, head:10, hy:0.05, hx:0.03 }) : { bend:36, lean:20, head:16, sy:0.92 };
      const up = R.arm ? { bend:22, lean:6, head:4, hy:0.0 } : { bend:16, lean:6, head:4 };
      let k, step = 0;
      if (body < 0) k = kf([[0, {}], [in0, up, 'io']], at);
      else if (body < n * T) { const i = Math.floor(body / T), p = (body - i * T) / T; k = kf([[0, up], [0.35, dip, 'io'], [0.5, Object.assign({}, dip, { sy:(dip.sy || 1) * 0.97 }), 'o'], [0.75, up, 'o'], [1, up]], p); step = i + E.io(seg(p, 0.75, 1)); }
      else { const q = body - n * T; k = kf([[0, up], [0.6, { lean:-8, bend:-10, head:-10, sy:1.05, hy:-0.02 }, 'o'], [1.1, {}, 'io']], q); step = n * (1 - E.io(seg(q, 0.4, 1.1))); }
      k.dx -= step * 0.07;
      const front = (ctx, P) => {
        for (let j = 0; j < n; j++) {
          const g = body - (j * T + 0.42 * T); if (g < 0) continue;
          const x = (0.3 - j * 0.07) * H + k.dx * 0 , al = 1 - seg(at, this.dur(v) - 0.6, this.dur(v));
          // 水圈
          if (g < 0.6) { ctx.save(); ctx.globalAlpha *= (1 - g / 0.6) * 0.7; ctx.strokeStyle = '#a9d6e6'; ctx.lineWidth = Math.max(1, 0.015 * H); ctx.beginPath(); ctx.ellipse(x, 0, 0.05 * H + g * 0.14 * H, 0.015 * H + g * 0.04 * H, 0, 0, TAU); ctx.stroke(); ctx.restore(); }
          // 秧苗（三根綠線）
          const gr = E.back(seg(g, 0, 0.25)); ctx.save(); ctx.globalAlpha *= al;
          for (let m = 0; m < 3; m++) crayon(ctx, [[x + (m - 1) * 0.012 * H, 0], [x + (m - 1) * 0.03 * H + Math.sin(at * 2 + m + j) * 0.006 * H, -0.09 * H * gr * (m === 1 ? 1.2 : 1)]], m === 1 ? '#7fbf4a' : '#5f9a38', Math.max(1, 0.02 * H), 50 + j * 3 + m);
          ctx.restore();
        }
      };
      return { k, front };
    },
  };
  // ---------- 棺材鋪：釘棺材板 ----------
  // 板子架在兩個木箱上；槌子輕敲兩三下（定位）→ 舉高 → 重重一槌（火花、板子震）
  function hammerKeys(R, p) {
    if (R.arm) return kf([[0, { bend:12, lean:4, ang:60 }], [0.18, { bend:13, lean:5, ang:10, hy:-0.02 }, 'o'], [0.26, { bend:15, lean:6, ang:98, hy:0.01 }, 'i'], [0.36, { bend:13, lean:5, ang:15, hy:-0.02 }, 'o'], [0.44, { bend:15, lean:6, ang:98, hy:0.01 }, 'i'],
      [0.85, { bend:2, lean:-6, ang:-62, hy:-0.07, hx:-0.02, dy:-0.02, sy:1.05, sx:0.97, head:-6 }, 'o'], [0.98, { bend:1, lean:-7, ang:-70, hy:-0.075, hx:-0.025, dy:-0.025, sy:1.06, sx:0.96, head:-8 }],
      [1.08, { bend:18, lean:9, ang:100, hy:0.02, hx:0.03, sy:0.94, sx:1.05, head:8 }, 'i3'], [1.25, { bend:17, lean:8, ang:98, hy:0.02, hx:0.03, sy:0.97, sx:1.02, head:6 }, 'o'], [1.6, { bend:12, lean:4, ang:60 }, 'io']], p);
    return kf([[0, { bend:10 }], [0.18, { bend:4, dy:-0.04 }, 'o'], [0.26, { bend:20, lean:8, sy:0.95 }, 'i'], [0.36, { bend:4, dy:-0.04 }, 'o'], [0.44, { bend:20, lean:8, sy:0.95 }, 'i'],
      [0.85, { bend:-8, lean:-10, dy:-0.08, sy:1.08, sx:0.95 }, 'o'], [0.98, { bend:-9, lean:-11, dy:-0.09, sy:1.09, sx:0.94 }], [1.08, { bend:28, lean:16, sy:0.88, sx:1.1, dx:0.04 }, 'i3'], [1.25, { bend:26, lean:14, sy:0.93, sx:1.05, dx:0.04 }, 'o'], [1.6, { bend:10 }, 'io']], p);
  }
  const hamRot = (R, k) => { if (R.arm) k.hr += (k.ang - 60) * (R.long ? 0.45 : 0.15); return k; };
  function benchOf(a, R) { // 工作台：槌子重重敲下去的那一點 = 板子中間、板面
    const H = a.H;
    const A = aim(a, 'hammer', () => ({ k:hamRot(R, hammerKeys(R, 1.08)), tool:'mallet' }));
    if (R.arm) return { x:cl(A.tip[0] + 0.04 * H, 0.42 * H, 0.75 * H), top:cl(-A.tip[1] - 0.06 * H, 0.14 * H, 0.42 * H) };
    return { x:cl(A.mouth[0] + 0.12 * H, 0.42 * H, 0.75 * H), top:cl(-A.mouth[1] - 0.1 * H, 0.14 * H, 0.4 * H) };
  }
  function drawBench(ctx, B, H, shake, plankLift) {
    const cw = 0.2 * H, chH = propH('store__crate', cw), sc = B.top / (chH * 0.92);
    prop(ctx, 'store__crate', B.x - 0.2 * H, 0.5, cw * Math.min(1.4, sc), 0, { an:[0.5, 1], sy:sc / Math.min(1.4, sc) });
    prop(ctx, 'store__crate', B.x + 0.2 * H, 0.5, cw * Math.min(1.4, sc), 0, { an:[0.5, 1], sy:sc / Math.min(1.4, sc), flip:true });
    if (!plankLift) prop(ctx, 'fx_plank', B.x, -B.top + 0.06 * H + (shake || 0), 0.52 * H, 0, { an:[0.5, 0.8] });
  }
  ACT.hammer = {
    dur:(v) => (v.n * 1.6 + 0.6) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, B = benchOf(a, R), T = 1.6, i = Math.floor(t / T), p = t - i * T;
      let k, hits = [];
      if (i < v.n) k = hamRot(R, hammerKeys(R, p));
      else k = hamRot(R, kf([[0, hammerKeys(R, 1.6)], [0.6, R.arm ? { ang:45 } : {}, 'io']], p));
      for (let j = 0; j < v.n; j++) { const b = j * T; hits.push([(b + 0.26) / s, 0.4], [(b + 0.44) / s, 0.4], [(b + 1.08) / s, 1]); }
      const back = (ctx) => { let sh = 0; for (const [ht, pw] of hits) { const g = at - ht; if (g > 0 && g < 0.12) sh = Math.sin(g / 0.12 * Math.PI * 2) * 0.012 * H * pw; } drawBench(ctx, B, H, sh); };
      const front = (ctx, P) => {
        const hx = P.tip ? P.tip[0] : P.mouth[0];
        for (const [ht, pw] of hits) { const g = at - ht; spark(ctx, hx, -B.top + 0.02 * H, g, (pw > 0.5 ? 0.3 : 0.16) * H); if (pw > 0.5) puff(ctx, hx, -B.top + 0.04 * H, g, 0.45, 0.22 * H, 4 + ht * 10, 'wood'); }
      };
      return { k, tool:'mallet', back, front, toolBehind:R.arm && k.ang < -20 };
    },
  };
  // ---------- 棺材鋪：刨平（手推、木屑一團一團）；沒手的就用肚子推 ----------
  ACT.sand = {
    dur:(v) => (v.n * 0.9 + 0.8) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, B = benchOf(a, R), T = 0.9, n = v.n, in0 = 0.4, b = t - in0;
      const rest = R.arm ? { bend:14, lean:6, hy:0.02 } : { bend:18, lean:10 };
      const push = R.arm ? { bend:20, lean:12, dx:0.06, hx:0.06, hy:0.03, sy:0.96, sx:1.03, head:6 } : { bend:24, lean:16, dx:0.1, sy:0.94, sx:1.05, head:8 };
      const pull = R.arm ? { bend:12, lean:3, dx:-0.02, hx:-0.02, hy:0.02, head:2 } : { bend:14, lean:6, dx:-0.02 };
      let k;
      if (b < 0) k = kf([[0, {}], [in0, rest]], t);
      else if (b < n * T) { const p = (b % T) / T; k = kf([[0, pull], [0.45, push, 'io'], [0.6, push], [1, pull, 'io']], p); }
      else k = kf([[0, pull], [0.4, {}, 'io']], b - n * T);
      const back = (ctx) => drawBench(ctx, B, H, 0);
      const front = (ctx, P) => {
        for (let j = 0; j < n; j++) { const g = (b - (j * T + 0.45 * T)) / s; const x = B.x + 0.18 * H; puff(ctx, x + j % 2 * 0.04 * H, -B.top + 0.03 * H, g, 0.55, 0.2 * H, 30 + j + v.seed, 'wood'); }
      };
      return { k, back, front };
    },
  };
  // ---------- 棺材鋪：把板子舉起來瞄直不直 ----------
  ACT.sight = {
    dur:(v) => 3.4 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H, B = benchOf(a, R);
      const k = kf([[0, {}], [0.5, { bend:14, lean:6, hy:0.03 }, 'io'], [0.75, { bend:10, lean:2, sy:0.95 }, 'o'], [1.2, { bend:-6, lean:-5, head:-12, hy:-0.06, sy:1.03 }, 'o'],
        [1.7, { bend:-7, lean:-6, head:-4, hy:-0.06 }, 'io'], [2.0, { bend:-7, lean:-6, head:-16, hy:-0.06 }, 'io'], [2.2, { bend:-6, lean:-5, head:-8, hy:-0.06 }, 'io'],
        [2.85, { bend:14, lean:6, hy:0.03 }, 'io'], [3.4, {}, 'io']], t);
      const lifted = t > 0.62 && t < 2.85;
      const back = (ctx) => drawBench(ctx, B, H, 0, lifted);
      const front = (ctx, P) => {
        if (!lifted) return;
        const q = E.io(seg(t, 0.62, 1.2)) * (1 - E.io(seg(t, 2.3, 2.85)));
        const hold = [P.G[0] + 0.05 * H, P.G[1] - 0.02 * H], rest = [B.x, -B.top + 0.06 * H];
        const x = lerp(rest[0], hold[0], q), y = lerp(rest[1], hold[1], q);
        prop(ctx, 'fx_plank', x, y, 0.52 * H * (1 - 0.3 * q), -q * 62, { an:[0.5, 0.8] });
        if (!R.arm) wisp(ctx, P.belly, [x, y], H, 3, q);
      };
      return { k, back, front };
    },
  };
  // ---------- 包子鋪：揉麵 ----------
  // 有手：麵糰放在蒸籠上，壓（麵糰扁下去、麵粉飛）→ 放開（彈回來）→ 往前推、往回捲
  // 沒手：一屁股坐上去壓，彈起來，再坐
  function counterOf(a, R) {
    const H = a.H;
    if (!R.arm) return { x:0.4 * H, top:0.26 * H };
    const A = aim(a, 'knead', () => ({ k:Object.assign({}, DEF, { bend:16, lean:8, hy:0.04, sy:0.95 }) }));
    return { x:cl(A.G[0] + 0.02 * H, 0.22 * H, 0.6 * H), top:cl(-A.G[1] - 0.04 * H, 0.16 * H, 0.42 * H) };
  }
  function drawCounter(ctx, C, H, withLid) {
    const sw = 0.36 * H, sh = propH('bun__steamer', sw), sc = C.top / (sh * 0.95);
    prop(ctx, 'bun__steamer', C.x, 0.5, sw, 0, { an:[0.5, 1], sy:sc });
  }
  ACT.knead = {
    dur:(v) => (v.n * 0.85 + 0.9) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, C = counterOf(a, R), T = 0.85, n = v.n, in0 = 0.45, b = t - in0;
      let k, dq = 0, roll = 0;
      if (R.arm) {
        const up = { bend:10, lean:4, hy:0.0 }, press = { bend:18, lean:9, hy:0.05, sy:0.93, sx:1.04, dy:0.01, head:6 };
        if (b < 0) k = kf([[0, {}], [in0, up]], t);
        else if (b < n * T) { const p = (b % T) / T; k = kf([[0, up], [0.32, press, 'i'], [0.45, press], [0.62, up, 'o'], [0.8, Object.assign({}, up, { hx:0.04, hy:0.02 }), 'io'], [1, up, 'io']], p); dq = Math.max(0, Math.sin(seg(p, 0.2, 0.6) * Math.PI)); roll = Math.sin(seg(p, 0.62, 1) * Math.PI); }
        else k = kf([[0, up], [0.45, {}, 'io']], b - n * T);
      } else {
        const sit = { dy:-C.top / H + 0.06, dx:0.4, sy:0.84, sx:1.15 };
        if (b < 0) k = kf([[0, {}], [in0 * 0.6, { sy:0.88, sx:1.08 }, 'o'], [in0, { dy:-C.top / H - 0.12, dx:0.3, sy:1.08 }, 'o']], t);
        else if (b < n * T) { const p = (b % T) / T; k = kf([[0, { dy:-C.top / H - 0.12, dx:0.38, sy:1.06 }], [0.35, sit, 'i3'], [0.5, Object.assign({}, sit, { sy:0.9 }), 'o'], [1, { dy:-C.top / H - 0.12, dx:0.38, sy:1.06 }, 'o']], p); dq = Math.max(0, Math.sin(seg(p, 0.3, 0.7) * Math.PI)); }
        else k = kf([[0, { dy:-C.top / H - 0.12, dx:0.38 }], [0.5, {}, 'io'], [0.7, { sy:0.94 }, 'o'], [0.9, {}, 'io']], b - n * T);
      }
      const back = (ctx) => drawCounter(ctx, C, H);
      const dough = (ctx) => { const dw = 0.26 * H; prop(ctx, 'fx_dough', C.x + roll * 0.04 * H, -C.top + 0.03 * H, dw * (1 + 0.3 * dq), roll * 8, { an:[0.5, 0.9], sy:1 - 0.4 * dq }); };
      const front = (ctx) => { for (let j = 0; j < n; j++) puff(ctx, C.x, -C.top, (b - (j * T + 0.32 * T)) / s, 0.5, 0.22 * H, 40 + j + v.seed, 'flour'); };
      return R.arm ? { k, back:(c) => { back(c); dough(c); }, front } : { k, back:(c) => { back(c); dough(c); }, front };
    },
  };
  // ---------- 包子鋪：掀蒸籠 ----------
  // 抬起上面那層蒸籠 → 蒸氣「噗」一下衝出來 → 被燙到往後縮、搧一搧 → 蓋回去
  ACT.steam = {
    dur:(v) => 3.6 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H, C = counterOf(a, R), cx = R.arm ? C.x : 0.36 * H;
      const k = kf([[0, {}], [0.45, { bend:12, lean:5, hy:0.03 }, 'io'], [0.65, { bend:8, lean:2, sy:0.95 }, 'o'], [0.95, { bend:-2, lean:-2, hy:-0.06, sy:1.03 }, 'o'],
        [1.1, { bend:-12, lean:-14, head:-16, dx:-0.06, hy:-0.06, sy:1.06, sx:0.95 }, 'o'], [1.6, { bend:-8, lean:-8, head:-10, dx:-0.05, hy:-0.04, hr:25 }, 'io'],
        [1.8, { bend:-8, lean:-8, head:-10, dx:-0.05, hy:-0.04, hr:-25 }, 'io'], [2.0, { bend:-8, lean:-8, head:-10, dx:-0.05, hy:-0.04, hr:25 }, 'io'], [2.2, { bend:-6, lean:-6, head:-6, dx:-0.04, hy:-0.04 }, 'io'],
        [2.9, { bend:12, lean:5, hy:0.03 }, 'io'], [3.6, {}, 'io']], t);
      if (!R.arm) { k.hr = 0; }
      const bw = 0.34 * H, bh = propH('bun__basket', bw), baseTop = 0.12 * H;
      const lidW = 0.32 * H, lidH = propH('bun__steamer', lidW);
      const back = (ctx) => { // 底下那籠包子 + 墊高的木箱
        prop(ctx, 'store__crate', cx, 0.5, 0.26 * H, 0, { an:[0.5, 1], sy:baseTop / (propH('store__crate', 0.26 * H) * 0.9) });
        prop(ctx, 'bun__basket', cx, -baseTop + 0.01 * H, bw, 0, { an:[0.5, 0.95] });
      };
      const front = (ctx, P) => {
        const q = E.io(seg(t, 0.62, 0.95)) * (1 - E.io(seg(t, 2.4, 2.9)));
        const rest = [cx, -baseTop - bh * 0.62], hold = R.arm ? [P.G[0] + 0.02 * H, P.G[1] + 0.06 * H] : [cx - 0.02 * H, -baseTop - bh - 0.3 * H];
        const x = lerp(rest[0], hold[0], q), y = lerp(rest[1], hold[1], q);
        steam(ctx, cx, -baseTop - bh * 0.5, t - 0.85, 1.2, H, 60 + v.seed, 4);
        prop(ctx, 'bun__steamer', x, y, lidW, q * (R.arm ? -10 : 6) + (t > 2.9 && t < 3.1 ? Math.sin((t - 2.9) * 60) * 2 : 0), { an:[0.5, 1] });
        if (!R.arm && q > 0.02) wisp(ctx, P.top, [x, y - lidH * 0.3], H, 8, q);
      };
      return { k, back, front };
    },
  };
  // ---------- 包子鋪：偷吃 ----------
  // 東張西望（轉頭兩次）→ 偷拿一顆 → 低頭湊過去咬三口（包子越咬越小、屑屑掉）→ 吞下去（伸一下脖子）→ 滿足
  ACT.sneak = {
    dur:(v) => 5.0 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H, bx = 0.34 * H, baseTop = 0.12 * H;
      let face = 1; if ((t > 0.3 && t < 0.75) || (t > 1.05 && t < 1.3)) face = -1;
      const eat = R.arm ? (R.long ? { hr:-55, hy:-0.06, hx:0.0, bend:8, head:12 } : { hy:-0.04, hx:-0.01, bend:26, lean:10, head:18 }) : { bend:22, lean:12, head:16 };
      const k = kf([[0, {}], [0.25, { head:-6, sy:0.97 }, 'o'], [0.75, { head:-6, sy:0.97 }], [1.0, { head:-4, sy:0.96 }], [1.3, { head:-4, sy:0.96 }], [1.45, { sy:0.95 }],
        [1.75, { bend:14, lean:8, hx:0.05, hy:0.04, head:6 }, 'io'], [1.9, { bend:12, lean:6, hx:0.05, hy:0.03, sy:0.96 }, 'o'], [2.3, eat, 'io'],
        [3.5, eat], [3.75, Object.assign({}, eat, { head:(eat.head || 0) - 18, sy:1.06, sx:0.96, bend:(eat.bend || 0) - 10 }), 'o'],
        [4.3, { head:-8, sy:1.04, lean:-4 }, 'io'], [5.0, {}, 'io']], t);
      if (t > 2.3 && t < 3.5) { const c = Math.abs(Math.sin((t - 2.3) * Math.PI * 2.5)); k.head += c * 7; k.sy *= 1 - c * 0.02; } // 嚼
      const bites = Math.floor(seg(t, 2.4, 3.5) * 3 + (t > 2.4 ? 1 : 0));
      const bunW = 0.16 * H, bs = t < 3.5 ? [1, 0.75, 0.5, 0.3][Math.min(3, bites)] : 0;
      const kingHand = R.id === 'eguiking';
      const back = (ctx) => {
        prop(ctx, 'store__crate', bx, 0.5, 0.26 * H, 0, { an:[0.5, 1], sy:baseTop / (propH('store__crate', 0.26 * H) * 0.9) });
        prop(ctx, 'bun__basket', bx, -baseTop + 0.01 * H, 0.34 * H, 0, { an:[0.5, 0.95] });
      };
      const front = (ctx, P) => {
        if (t > 1.85 && t < 3.6 && bs > 0) {
          const g = seg(t, 1.85, 2.3), from = [bx, -baseTop - 0.08 * H], to = R.arm ? [P.G[0], P.G[1]] : [P.mouth[0] + 0.02 * H, P.mouth[1] + 0.02 * H];
          const p = R.arm ? to : [lerp(from[0], to[0], E.io(g)), lerp(from[1], to[1], E.io(g)) - Math.sin(g * Math.PI) * 0.05 * H];
          prop(ctx, 'bun__bun', p[0], p[1], bunW * bs, 0, { an:[0.5, 0.6] });
          if (!R.arm) wisp(ctx, P.mouth, p, H, 5, 1 - g);
        }
        // 屑屑
        for (let j = 0; j < 3; j++) spray(ctx, P.mouth[0], P.mouth[1] + 0.03 * H, t - (2.5 + j * 0.38), 0.4, 3, 70 + j, H, { up:0.3, v:0.5, g:4 }, (c, px, py, i, al) => { c.save(); c.globalAlpha *= al; c.fillStyle = '#f4ead8'; c.beginPath(); c.arc(px, py, H * 0.012, 0, TAU); c.fill(); c.restore(); });
        if (t > 4.0) twinkle(ctx, P.top[0] + 0.1 * H, P.top[1] + 0.1 * H, t - 4.0, H, 9);
      };
      // 餓鬼王：手上本來就有一顆，直接吃那顆（手 + 包子分開畫，包子越咬越小）；吃完從籠裡再拿一顆
      if (kingHand && ok('eguiking__hand') && ok('eguiking__bun')) {
        const fr = { k, face, back, hand:'eguiking__hand' };
        fr.front = (ctx, P) => {
          const BC = [0.1329, 0.2928], kb = t < 2.4 ? 1 : t < 3.5 ? bs : t < 4.3 ? 0 : E.back(seg(t, 4.3, 4.6));
          if (kb > 0) { const c = MoveKit.ppt(P.K, P.hm, P.R.pv[0], P.R.pv[1], BC[0], BC[1]); ctx.save(); ctx.translate(c[0], c[1]); ctx.scale(kb, kb); ctx.translate(-c[0], -c[1]); MoveKit.piece(ctx, P.K, 'eguiking__bun', P.hm, P.R.pv[0], P.R.pv[1]); ctx.restore(); }
          for (let j = 0; j < 3; j++) spray(ctx, P.mouth[0], P.mouth[1] + 0.03 * H, t - (2.5 + j * 0.38), 0.4, 3, 70 + j, H, { up:0.3, v:0.5, g:4 }, (c, px, py, i, al) => { c.save(); c.globalAlpha *= al; c.fillStyle = '#f4ead8'; c.beginPath(); c.arc(px, py, H * 0.012, 0, TAU); c.fill(); c.restore(); });
          if (t > 4.0) twinkle(ctx, P.top[0] + 0.1 * H, P.top[1] + 0.1 * H, t - 4.0, H, 9);
        };
        return fr;
      }
      return { k, face, back, front };
    },
  };
  // ---------- 倉庫：數冥幣 ----------
  // 從米袋裡摸出一枚 → 拿到眼前看（點頭數一）→ 丟到旁邊那疊；數完把那疊掃進袋子
  // Toyol：數到一半左右張望，偷偷把一枚塞進自己的錢袋，竊笑
  ACT.coins = {
    dur:(v) => (v.n * 0.9 + 1.6) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, n = v.n, T = 0.9, in0 = 0.4, b = t - in0, sx0 = 0.36 * H, stackX = 0.7 * H;
      const thief = R.id === 'toyol', ts = Math.floor(n / 2); // 第幾枚被偷
      const dip = R.arm ? { bend:18, lean:8, hx:0.05, hy:0.05 } : { bend:16, lean:8, head:8 }, look = R.arm ? { bend:2, hy:-0.03, hx:0.0, head:4, hr:-15 } : { bend:0, head:6 };
      let k, face = 1;
      if (b < 0) k = kf([[0, {}], [in0, look]], t);
      else if (b < n * T) { const p = (b % T) / T; k = kf([[0, look], [0.25, dip, 'io'], [0.5, look, 'io'], [0.62, Object.assign({}, look, { head:(look.head || 0) + 10 }), 'o'], [0.75, look, 'io'], [0.9, Object.assign({}, look, { hx:(look.hx || 0) - 0.03 }), 'o'], [1, look, 'io']], p); }
      else { const q = b - n * T; k = kf([[0, look], [0.4, { bend:16, lean:8, hx:0.0, hy:0.05 }, 'io'], [0.8, { bend:14, lean:6, hx:0.07, hy:0.05 }, 'io'], [1.2, {}, 'io']], q); }
      // Toyol：偷之前左右看
      const tt0 = in0 + ts * T;
      if (thief && b > ts * T - 0.6 && b < ts * T) { const q = (b - (ts * T - 0.6)) / 0.6; face = q > 0.25 && q < 0.6 ? -1 : 1; k.sy *= 0.96; }
      if (thief && b > ts * T + 0.6 && b < ts * T + 0.95) { const c = Math.sin(seg(b, ts * T + 0.6, ts * T + 0.95) * Math.PI * 3); k.sy *= 1 + 0.03 * Math.abs(c); }
      const back = (ctx) => { prop(ctx, 'store__sack', sx0, 0.5, 0.36 * H, 0, { an:[0.5, 1] }); };
      const front = (ctx, P) => {
        // 已經數好的那疊
        let stacked = 0; for (let j = 0; j < n; j++) if (b > j * T + 0.95 * T && !(thief && j === ts)) stacked++;
        const sweep = b > n * T ? seg(b - n * T, 0.4, 0.8) : 0;
        for (let j = 0; j < stacked; j++) coinFlat(ctx, lerp(stackX, sx0, E.i(sweep)) + (j % 2 ? 0.006 : -0.004) * H, -0.012 * H - j * 0.024 * H - Math.sin(sweep * Math.PI) * 0.08 * H, H, 1 - seg(sweep, 0.7, 1));
        if (b >= 0 && b < n * T) {
          const j = Math.floor(b / T), p = (b % T) / T;
          if (p > 0.22) {
            let c;
            if (p < 0.82) { c = R.arm ? [P.G[0], P.G[1] - 0.02 * H] : [lerp(sx0, P.mouth[0] + 0.12 * H, E.io(seg(p, 0.22, 0.5))), lerp(-0.2 * H, P.mouth[1] + 0.04 * H, E.io(seg(p, 0.22, 0.5)))]; }
            else { const q = seg(p, 0.82, 1); const from = R.arm ? [P.G[0], P.G[1]] : [P.mouth[0] + 0.12 * H, P.mouth[1] + 0.04 * H];
              const to = thief && j === ts ? [P.belly[0] + 0.02 * H, P.belly[1]] : [stackX, -0.012 * H - stacked * 0.022 * H];
              c = [lerp(from[0], to[0], q), lerp(from[1], to[1], E.i(q)) - Math.sin(q * Math.PI) * 0.1 * H]; }
            coin(ctx, c[0], c[1], H, p * 9 + j, 1);
            if (!R.arm && p < 0.82) wisp(ctx, P.mouth, c, H, 11 + j, 1);
          }
          if (p > 0.55 && p < 0.7) twinkle(ctx, R.arm ? P.G[0] : P.mouth[0] + 0.12 * H, (R.arm ? P.G[1] : P.mouth[1]) - 0.04 * H, (p - 0.55) * T / s, H * 0.7, j);
        }
        if (thief) twinkle(ctx, P.belly[0], P.belly[1], (b - (ts * T + T)) / s, H, 77);
      };
      return { k, face, back, front };
    },
  };
  // ---------- 倉庫：推米袋（排整齊）----------
  ACT.push = {
    dur:(v) => 3.4 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H;
      const k = kf([[0, {}], [0.4, { lean:-4, bend:-4, sy:1.03 }, 'o'], [0.8, { lean:18, bend:16, dx:0.08, sy:0.93, sx:1.05, hx:0.05 }, 'i'], [1.6, { lean:20, bend:18, dx:0.2, sy:0.92, sx:1.06, hx:0.05 }, 'io'],
        [1.9, { lean:12, bend:10, dx:0.2, sy:0.97, hx:0.03 }, 'o'], [2.3, { lean:-6, bend:-6, dx:0.18, sy:1.04, head:-6 }, 'o'], [2.8, { dx:0.08, sy:0.98 }, 'io'], [3.4, {}, 'io']], t);
      if (t > 0.8 && t < 1.6) k.dx += Math.sin((t - 0.8) * 30) * 0.004; // 用力在抖
      const slide = 0.12 * E.io(seg(t, 0.85, 1.6)) * (1 - E.io(seg(t, 2.6, 3.4)));
      const back = (ctx) => { prop(ctx, 'store__sack', (0.42 + slide) * H, 0.5, 0.38 * H, 0, { an:[0.5, 1] }); };
      const front = (ctx) => { puff(ctx, 0.5 * H, 0, t - 1.1, 0.5, 0.25 * H, 81); puff(ctx, 0.56 * H, 0, t - 1.45, 0.5, 0.22 * H, 82); };
      return { k, back, front };
    },
  };
  // ---------- 工頭：巡視（東張西望、點頭、腳打拍子、指著前面喊快點）----------
  ACT.inspect = {
    dur:(v) => 4.6 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H;
      let face = 1; if (t > 0.6 && t < 1.4) face = -1;
      const point = R.arm ? (R.long ? { hr:-70, hx:0.03, hy:-0.02, lean:4, head:-4 } : { hx:0.05, hy:-0.04, hr:-30, lean:6, head:-4 }) : { lean:10, dx:0.03, head:-6 };
      const k = kf([[0, {}], [0.5, { head:-6 }], [0.7, { head:4 }, 'o'], [1.3, { head:4 }], [1.5, { head:-2 }, 'o'], [1.8, { head:8 }, 'io'], [2.0, { head:-2 }, 'io'], [2.2, { head:8 }, 'io'], [2.5, {}, 'io'],
        [2.8, point, 'o'], [3.0, Object.assign({}, point, { dx:(point.dx || 0) + 0.02 }), 'o'], [3.15, point, 'io'], [3.3, Object.assign({}, point, { dx:(point.dx || 0) + 0.02 }), 'o'], [3.7, point], [4.2, {}, 'io']], t);
      // 腳打拍子
      if (t > 1.5 && t < 2.5) { const c = Math.abs(Math.sin((t - 1.5) * Math.PI * 4)); k.dy -= c * 0.012; k.sy *= 1 - (1 - c) * 0.015; }
      const front = (ctx, P) => { bang(ctx, P.top[0] + 0.14 * H, P.top[1] + 0.02 * H, H, seg(t, 2.8, 2.9) * (1 - seg(t, 3.6, 3.9)), 5); };
      return { k, face, front };
    },
  };
  // ---------- 化寶爐：燒金紙（工頭走過去燒）----------
  // o.wtarget = 爐口相對位置（世界單位）。拿一張 → 往後收 → 拋進爐口 → 火舌竄出來 → 往後縮；紙紮的鬼站得遠、縮得更大力
  ACT.burn = {
    dur:(v) => (v.walk ? 4.0 : 0) + (v.n * 1.4 + 0.6) / sp(v),
    f(a, R, at, v) {
      const H = a.H, s = sp(v), wk = v.walk ? 2.0 : 0, paper = !!PAPER[R.id], fw = a.faceRight ? 1 : -1;
      // v.stand = 站定的位置、a.o.wtarget = 爐口（相對站定位置）：都是世界單位，這裡轉成 F 座標
      const st = v.stand ? [v.stand[0] * fw, v.stand[1]] : [0, 0];
      const tw = a.o.wtarget || [0.75 * H * fw, -0.12 * H], tg = [tw[0] * fw, tw[1]];
      const bt = at - wk, total = (v.n * 1.4 + 0.6) / s, dirOut = st[0] >= 0 ? 1 : -1, faceB = tg[0] >= 0 ? 1 : -1;
      let ox = 0, oy = 0, face = faceB, walk = 0;
      if (wk) {
        if (at < wk) { const q = E.sin(seg(at, 0, wk)); ox = st[0] / H * q; oy = st[1] * q; walk = at; face = dirOut; }
        else if (bt > total) { const q = E.sin(seg(bt - total, 0, wk)); ox = st[0] / H * (1 - q); oy = st[1] * (1 - q); walk = at; face = -dirOut; }
        else { ox = st[0] / H; oy = st[1]; }
      }
      const b = bt * s, T = 1.4;
      let k = Object.assign({}, DEF);
      if (bt >= 0 && bt <= total) {
        const i = Math.floor(b / T), p = (b % T) / T;
        if (i < v.n) {
          const flinch = paper ? { lean:-18, bend:-12, head:-18, dx:-0.12, dy:-0.06, sy:1.08, sx:0.94 } : { lean:-10, bend:-6, head:-10, dx:-0.05, sy:0.95, sx:1.04 };
          k = kf([[0, {}], [0.3, { lean:-6, bend:-4, hx:-0.04, hy:-0.02, hr:-25, sy:1.03 }, 'o'], [0.45, { lean:8, bend:8, hx:0.05, hy:-0.03, hr:30, sy:0.97 }, 'i'],
            [0.62, { lean:5, bend:5, hx:0.03, hr:15 }, 'o'], [0.72, flinch, 'o'], [0.9, flinch], [1, {}, 'io']], p);
          if (paper && p > 0.72 && p < 0.92) { k.dx += Math.sin(p * 120) * 0.006; }
        }
      }
      const fr = { k, face, ox, oy, walk };
      fr.front = (ctx, P) => {
        if (bt < 0 || bt > total) return;
        const i = Math.floor(b / T), p = (b % T) / T, mouth = [st[0] + tg[0], st[1] + tg[1]];
        if (i < v.n) {
          const hand = R.arm ? [P.G[0], P.G[1] - 0.02 * H] : [P.belly[0] + 0.08 * H * face, P.belly[1] - 0.08 * H];
          if (p < 0.45) prop(ctx, 'furnace__paper', hand[0], hand[1], 0.13 * H * E.back(seg(p, 0, 0.15)), -20, { an:[0.5, 0.5] });
          else if (p < 0.7) { const q = seg(p, 0.45, 0.7); prop(ctx, 'furnace__paper', lerp(hand[0], mouth[0], q), lerp(hand[1], mouth[1], q) - Math.sin(q * Math.PI) * 0.14 * H, 0.13 * H * (1 - 0.4 * q), -20 + q * 260, { an:[0.5, 0.5] }); }
          if (!R.arm && p < 0.7) wisp(ctx, P.belly, hand, H, 4, 1);
        }
        for (let j = 0; j < v.n; j++) flame(ctx, mouth[0], mouth[1] + 0.05 * H, (b - (j * T + 0.68 * T)) / s, 0.55, H * (paper ? 1.15 : 1), 90 + j);
      };
      return fr;
    },
  };
  // ---------- 陰兵營：原地踏步 ----------
  ACT.march = {
    dur:(v) => (v.n * 0.5 + 0.8) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, n = v.n, b = t - 0.3;
      let k = kf([[0, {}], [0.3, { head:-6, sy:1.03 }]], t);
      if (b > 0 && b < n * 0.5) {
        const ph = b / 0.5 * Math.PI, c = Math.sin(ph);
        k = Object.assign({}, DEF, { head:-6, hx:c * 0.03, hr:c * (R.long ? 30 : 12), lean:2 });
        if (R.hop) { const h = Math.abs(c); k.dy = -h * 0.08; k.sy = 1 - (1 - Math.min(1, h * 5)) * 0.06; }
        else if (!R.legs) { k.dy = -Math.abs(c) * 0.035; k.lean += c * 3; k.sy = 1 + Math.abs(c) * 0.02; }
        else k.dy = -Math.abs(c) * 0.02;
      } else if (b >= n * 0.5) { const q = b - n * 0.5; k = kf([[0, { head:-6 }], [0.12, { dy:-0.03, head:-8, sy:1.05 }, 'o'], [0.25, { sy:0.92, sx:1.05, head:-4 }, 'i'], [0.5, {}, 'io']], q); }
      const fr = { k };
      if (R.legs && b > 0 && b < n * 0.5) fr.walk = b * 0.5 / 0.5 * Math.PI / 8 * 2; // 腿跟著踏
      fr.front = (ctx) => { if (b > n * 0.5) puff(ctx, 0, 0, (b - n * 0.5 - 0.22) / s, 0.45, 0.3 * H, 12); };
      return fr;
    },
  };
  // ---------- 陰兵營：立正、敬禮／抱拳鞠躬 ----------
  ACT.salute = {
    dur:(v) => 3.2 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H;
      const sal = R.arm ? (R.long ? { hr:-115, hx:0.02, hy:-0.05, head:-6 } : { hx:-0.03, hy:-0.06, hr:-20, head:-4 }) : { head:-8 };
      const k = kf([[0, {}], [0.25, { dy:-0.03, sy:1.06, sx:0.95, head:-8 }, 'o'], [0.4, { sy:1.04, sx:0.97, head:-8 }, 'io'], [0.6, Object.assign({ sy:1.04 }, sal), 'o'],
        [1.5, Object.assign({ sy:1.04 }, sal)], [1.75, { sy:1.02, head:-4 }, 'io'], [2.15, { bend:30, lean:10, head:14, sy:0.98 }, 'io'], [2.45, { bend:31, lean:10, head:15 }], [2.85, { head:-4 }, 'io'], [3.2, {}, 'io']], t);
      return { k };
    },
  };
  // ---------- 陰兵營：操練（出拳三下，喝！）----------
  ACT.drill = {
    dur:(v) => (v.n * 0.9 + 0.5) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, n = v.n, T = 0.9, i = Math.floor(t / T), p = (t % T) / T;
      let k = Object.assign({}, DEF);
      if (i < n) k = kf([[0, {}], [0.4, { lean:-8, bend:-6, dx:-0.04, hx:-0.03, hr:-20, sy:1.03, sx:0.97, head:-4 }, 'o'], [0.52, { lean:14, bend:10, dx:0.1, hx:0.05, hr:R.long ? 45 : 15, sy:0.95, sx:1.05, head:4 }, 'i3'],
        [0.7, { lean:12, bend:9, dx:0.1, hx:0.05, hr:R.long ? 42 : 14, sy:0.97, sx:1.03 }, 'o'], [1, {}, 'io']], p);
      const front = (ctx, P) => {
        for (let j = 0; j < n; j++) {
          const g = (t - (j * T + 0.52 * T)) / s; if (g < 0 || g > 0.3) continue;
          const pt = R.arm ? P.G : P.mouth;
          MoveKit.speed(ctx, pt[0] + 0.04 * H, pt[1], 1, 0, 0.18 * H, 0.08 * H, 1 - g / 0.3, 'rgba(255,240,210,.85)', 20 + j, 3);
          MoveKit.burst(ctx, pt[0] + 0.14 * H, pt[1], 0.1 * H, 1 - g / 0.3, '#ffe9a0', 30 + j, 7);
        }
      };
      return { k, front };
    },
  };

  // ---------- 嚇人訓練班：縮埋 → 彈起「嘩！」 ----------
  ACT.boo = {
    dur:(v) => (v.n * 1.7 + 0.3) / sp(v),
    f(a, R, at, v) {
      const s = sp(v), t = at * s, H = a.H, n = v.n, T = 1.7, i = Math.floor(t / T), p = t % T;
      let k = Object.assign({}, DEF);
      if (i < n) k = kf([[0, {}], [0.45, { sy:0.9, sx:1.06, bend:22, lean:6, head:12, hx:-0.02, hy:0.03 }, 'io'], [0.75, { sy:0.9, sx:1.06, bend:24, lean:7, head:14, hx:-0.02, hy:0.03 }],
        [0.86, { dy:-0.07, sy:1.12, sx:0.92, bend:-6, lean:-4, head:-12, hx:0.03, hy:-0.1, hr:R.long ? -70 : -30 }, 'o'], [1.25, { dy:-0.05, sy:1.08, sx:0.95, bend:-5, lean:-3, head:-10, hx:0.03, hy:-0.09, hr:R.long ? -66 : -28 }], [1.7, {}, 'io']], p);
      const front = (ctx, P) => {
        for (let j = 0; j < n; j++) { const g = (t - (j * T + 0.86)) / s; if (g < 0 || g > 0.35) continue;
          MoveKit.burst(ctx, P.mouth[0] + 0.1 * H, P.mouth[1] - 0.02 * H, 0.13 * H, 1 - g / 0.35, '#e8d0ff', 40 + j, 8); }
      };
      return { k, front };
    },
  };
  // ---------- 嚇人訓練班：對住空氣扮鬼臉（頭左右扭、成個人擠扁拉長）----------
  ACT.grimace = {
    dur:(v) => 2.8 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H, w = t > 0.3 && t < 2.4 ? Math.sin((t - 0.3) * 7.5) : 0, e = Math.min(1, Math.max(0, (t - 0.3) * 4)) * Math.min(1, Math.max(0, (2.4 - t) * 4));
      const k = Object.assign({}, DEF, { head:w * 14 * e - 4 * e, lean:w * 4 * e, sx:1 + 0.05 * w * e, sy:1 - 0.05 * w * e, hx:0.02 * e, hy:-0.04 * e, hr:(R.long ? -40 : -14) * e });
      const front = (ctx, P) => { if (e > 0.5 && Math.abs(w) > 0.92) MoveKit.burst(ctx, P.mouth[0] + 0.06 * H * Math.sign(w), P.mouth[1] - 0.05 * H, 0.06 * H, 0.6, '#ffe0f0', 60 + Math.round(t * 3), 5); };
      return { k, front };
    },
  };
  // ---------- 嚇人訓練班：練「背後吹氣」 ----------
  ACT.blow = {
    dur:(v) => 2.6 / sp(v),
    f(a, R, at, v) {
      const t = at * sp(v), H = a.H;
      const k = kf([[0, {}], [0.4, { dy:0.01, sy:1.04, sx:0.97, bend:-6, head:-8 }, 'io'], [0.6, { lean:14, bend:12, head:8, sy:0.96, sx:1.03, dx:0.03 }, 'o'], [1.8, { lean:15, bend:13, head:9, sy:0.97, sx:1.02, dx:0.035 }], [2.6, {}, 'io']], t);
      const front = (ctx, P) => { for (let j = 0; j < 4; j++) { const g = t - 0.6 - j * 0.25; puff(ctx, P.mouth[0] + 0.05 * H + Math.max(0, g) * 0.25 * H, P.mouth[1], g, 0.9, 0.22 * H, 80 + j); } };
      return { k, front };
    },
  };

  // ===================== 對外：DAILY 登記 =====================
  function run(name, ctx, a) {
    const R = rigOf(a.type); if (!R || typeof MoveKit === 'undefined') return false;
    if (!R.special && !R.mesh) return false;
    const v = a.o.wv || defaults(name, a.type, 1);
    const at = Math.max(0, a.o.at || 0);
    const fr = ACT[name].f(a, R, at, v);
    render(ctx, a, fr);
    return true;
  }
  for (const n in ACT) DAILY['work_' + n] = (ctx, a) => run(n, ctx, a);

  // ===================== 排班：每個崗位做哪幾種，輪流、不同步 =====================
  const POST_ACTS = {
    wood:[['chop', 5], ['haul', 3], ['rest', 1.4]],
    rice:[['reap', 5], ['plant', 4], ['rest', 1.4]],
    plank:[['hammer', 5], ['sand', 3], ['sight', 2], ['rest', 0.8]],
    bun:[['knead', 5], ['steam', 3], ['sneak', 1.5]],
    store:[['crate', 4], ['coins', 4], ['push', 2]],
    boss:[['inspect', 5], ['burn', 2.5], ['rest', 1]],
    camp:[['boo', 4], ['grimace', 3], ['blow', 3]],
  };
  function defaults(name, type, r) {
    const R = (x) => rnd(r * 13.7 + x * 7.1);
    const v = { sp:0.88 + R(1) * 0.24, seed:Math.floor(R(2) * 100) };
    if (name === 'chop') v.n = 3 + Math.floor(R(3) * 2);
    if (name === 'reap') v.n = 3 + Math.floor(R(3) * 2);
    if (name === 'plant') v.n = 3;
    if (name === 'hammer') v.n = 2 + Math.floor(R(3) * 2);
    if (name === 'sand') v.n = 4 + Math.floor(R(3) * 2);
    if (name === 'knead') v.n = 4 + Math.floor(R(3) * 3);
    if (name === 'coins') v.n = 4 + Math.floor(R(3) * 2);
    if (name === 'burn') v.n = 2 + Math.floor(R(3) * 2);
    if (name === 'march') v.n = 8 + 2 * Math.floor(R(3) * 3);
    if (name === 'boo') v.n = 2;
    if (name === 'drill') v.n = 3;
    return v;
  }
  const STATE = new Map();
  function pickNext(post, type, prev, ctxInfo) {
    let list = (POST_ACTS[post] || [['rest', 1]]).filter(e => e[0] !== prev);
    if (!ctxInfo || !ctxInfo.furnace) list = list.filter(e => e[0] !== 'burn');
    if (!list.length) list = POST_ACTS[post] || [['rest', 1]];
    const wt = (e) => e[1] * (e[0] === 'sneak' && GLUTTON[type] ? 4 : 1) * (e[0] === 'coins' && type === 'toyol' ? 2 : 1);
    let sum = 0; for (const e of list) sum += wt(e);
    let r = Math.random() * sum; for (const e of list) { r -= wt(e); if (r <= 0) return e[0]; }
    return list[0][0];
  }
  // 遊戲裡畫一個在崗位上的鬼：s = workerSpots() 的一筆 {g, x, y, flip, ph, post}；info.furnace = 爐口世界座標（化寶爐蓋好了才有）
  function plan(s, t, info) {
    const g = s.g, id = g.id || g.k; let st = STATE.get(id);
    if (st && (st.post !== s.post || t < st.t0 - 1 || st.k !== g.k)) st = null;
    const fresh = (prev) => {
      const act = pickNext(s.post, g.k, prev, info), v = defaults(act, g.k, Math.random() * 1000 + 1);
      if (act === 'haul' || act === 'crate') { const fw = s.flip ? -1 : 1, px = s.x - fw * 58; v.mirror = px < 14 || px > 376; } // 後面那堆會跑出畫面：這一趟轉過來做
      if (act === 'burn') { v.walk = 1; const side = info.furnace[0] >= s.x ? -1 : 1; v.stand = [info.furnace[0] + side * 30 - s.x, info.furnace[1] + 16 - s.y]; }
      return { act, v };
    };
    if (!st) { const n = fresh(null); st = { post:s.post, k:g.k, act:n.act, v:n.v, dur:ACT[n.act].dur(n.v) }; st.t0 = t - Math.random() * st.dur * 0.9; STATE.set(id, st); }
    if (t - st.t0 >= st.dur) { const n = fresh(st.act); st.act = n.act; st.v = n.v; st.t0 = t + Math.random() * 0.35; st.dur = ACT[n.act].dur(n.v); }
    return st;
  }
  const SPECIAL_H = { toyol:46, pocong:54, penanggal:52 };
  function drawWorker(ctx, s, t, scale, info) {
    info = info || {};
    const g = s.g, k = g.k, sc = scale || 0.62, st = plan(s, t, info), at = Math.max(0, t - st.t0);
    const o = { t:t + (s.ph || 0), flip:st.v.mirror ? !s.flip : s.flip, tamed:true, untied:true, act:'work_' + st.act, at, wv:st.v, wkey:g.id };
    if (st.act === 'burn' && st.v.stand && info.furnace) o.wtarget = [info.furnace[0] - (s.x + st.v.stand[0]), info.furnace[1] - (s.y + st.v.stand[1])];
    if (typeof SPECIAL !== 'undefined' && SPECIAL.has(k)) {
      if (!DAILY[o.act](ctx, { type:k, x:s.x, y:s.y, s:sc, H:(SPECIAL_H[k] || 50) * sc, o, faceRight:!o.flip, solid:true })) ART.drawChar(ctx, k, s.x, s.y, sc, { t:o.t, work:true, flip:s.flip, tamed:true, untied:true });
      return st;
    }
    ART.drawChar(ctx, k, s.x, s.y, sc, o);
    return st;
  }
  // 直接畫某個動作（樣板頁、其他地方用）：at = 秒；v 省略就用預設
  function drawAct(ctx, type, x, y, sc, act, at, o2) {
    const v = (o2 && o2.wv) || defaults(act, type, 1);
    const o = Object.assign({ t:at, act:'work_' + act, at, wv:v }, o2 || {});
    if (typeof SPECIAL !== 'undefined' && SPECIAL.has(type)) {
      if (!DAILY[o.act](ctx, { type, x, y, s:sc, H:(SPECIAL_H[type] || 50) * sc, o, faceRight:!o.flip, solid:true })) ART.drawChar(ctx, type, x, y, sc, o);
      return;
    }
    ART.drawChar(ctx, type, x, y, sc, o);
  }
  return { drawWorker, drawAct, ACT, POST_ACTS, defaults, rigOf, STATE, render, kf };
})();
