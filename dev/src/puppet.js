// ===================== 木偶貼片動畫（關節會動的角色）=====================
// 每個角色拆成頭、身體、手臂（上臂＋前臂），工具拿在手上。座標都是分件圖原圖的像素。
// 角度：0 = 手臂自然垂下，正數 = 往前（臉朝的方向）抬。角色原圖臉朝左。
// 木偶分件目前關閉：角色一律用原本的立繪（改成 true 可以重新打開）
let PUPPET_ON = false;
const Puppet = (() => {
  const RIGS = {
    afu: {
      h: 600, // 從尾巴尖到頭頂（原圖像素），用來換算世界高度
      root: [120, 240], tailY: 380, // 腰的位置；尾巴尖在腰下方 140
      torso: ['rg_afu_torso', 261, 384],
      heads: { n:'rg_afu_head', s:'rg_afu_head_s', h:'rg_afu_head_h', p:'rg_afu_head_p' }, head: [440, 362, 0.512, 0.925],
      neck: [135, 28], shF: [212, 78], shB: [45, 78],
      uF: ['rg_afu_uarmF', 155, 291, [95, 34], [88, 262]],
      fF: ['rg_afu_farmF', 138, 287, [62, 30], [62, 222]],
      uB: ['rg_afu_uarmB', 166, 292, [58, 34], [85, 262]],
      fB: ['rg_afu_farmB', 144, 328, [66, 32], [56, 292]],
    },
  };
  const TOOLS = { // 圖、原寬高、握把位置、刀口在圖的哪一邊要不要翻
    axe: ['tool_axe', 205, 374, [205 - 42, 300], false],
    mallet: ['tool_mallet', 241, 371, [241 - 85, 300], false],
    sickle: ['tool_sickle', 0, 0, [0, 0], false],
  };
  const M = new Set();
  function mirror(R) {
    if (M.has(R)) return; M.add(R);
    const tw = R.torso[1], mx = (p) => [tw - p[0], p[1]];
    R.root = mx(R.root); R.neck = mx(R.neck); R.shF = mx(R.shF); R.shB = mx(R.shB); R.head = [R.head[0], R.head[1], 1 - R.head[2], R.head[3]];
    if (R.hipF) { R.hipF = mx(R.hipF); R.hipB = mx(R.hipB); }
    for (const k of ['uF', 'fF', 'uB', 'fB', 'lF', 'lB']) { const P = R[k]; if (!P) continue; P[3] = [P[1] - P[3][0], P[3][1]]; P[4] = [P[1] - P[4][0], P[4][1]]; }
    if (R.tool) { const T = R.tool; TOOLS['_' + R.id] = [T[0], T[1], T[2], [T[1] - T[3][0], T[3][1]], false]; }
  }
  function addRigs(obj) { for (const id in obj) { const R = obj[id]; R.id = id; RIGS[id] = R; } }
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  const has = (id) => { if (!PUPPET_ON) return false; const r = RIGS[id]; if (r) mirror(r); return !!(r && ok(r.torso[0]) && ok(r.heads.n) && ok(r.uF[0]) && ok(r.fF[0]) && ok(r.uB[0]) && ok(r.fB[0])); };
  const img = (k, x, y, w, h, ctx) => { ctx.save(); ctx.scale(-1, 1); ctx.drawImage(SPR[k], -x - w, y, w, h); ctx.restore(); };
  // 工具尺寸：分件圖第二張的圖自己量
  function toolDef(name) {
    const d = TOOLS[name]; if (!d || !ok(d[0])) return null;
    if (!d[1] && d[0].startsWith('tool_s')) { const im = SPR[d[0]], sc = 1 / 0.55; d[1] = im.naturalWidth * sc; d[2] = im.naturalHeight * sc; d[3] = [d[1] - d[1] * 0.13, d[2] * 0.85]; }
    return d;
  }
  // ---------- 姿勢 ----------
  const BASE = { lean:0, dy:0, sx:1, sy:1, head:0, hk:'n', aF:0.15, eF:0.1, aB:-0.12, eB:0.15, tool:null, tr:-1.57, ik:0, tail:0, lF:0, lB:0, jx:0 };
  const ease = { lin:(t) => t, in:(t) => t * t, out:(t) => 1 - (1 - t) * (1 - t), io:(t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t), back:(t) => { const c = 1.9; return 1 + (c + 1) * Math.pow(t - 1, 3) + c * Math.pow(t - 1, 2); } };
  function mix(a, b, k) { const o = {}; for (const key in a) { const va = a[key], vb = b[key]; o[key] = typeof va === 'number' && typeof vb === 'number' ? va + (vb - va) * k : (k < 0.5 ? va : vb); } return o; }
  // 關鍵影格：[[時間, 姿勢, 緩動], ...]，時間 0~1
  function keys(list, p) {
    if (p <= list[0][0]) return Object.assign({}, BASE, list[0][1]);
    for (let i = 1; i < list.length; i++) if (p <= list[i][0]) {
      const [t0, a] = list[i - 1], [t1, b, e] = list[i];
      return mix(Object.assign({}, BASE, a), Object.assign({}, BASE, b), (ease[e || 'io'])((p - t0) / (t1 - t0)));
    }
    return Object.assign({}, BASE, list[list.length - 1][1]);
  }
  const CHOP_STRIKE = { lean:0.22, dy:3, sx:1.04, sy:0.95, head:0.18, hk:'s', aF:1.0, eF:-0.1, aB:0.55, eB:0.5, tool:'axe', tr:-3.0, ik:1 };
  const CHOP_UP = { lean:-0.16, dy:-5, sx:0.96, sy:1.05, head:-0.2, hk:'s', aF:3.35, eF:0.35, aB:2.6, eB:0.4, tool:'axe', tr:-1.5, ik:1 };
  const CLAW_UP = { lean:-0.18, dy:-3, sx:0.96, sy:1.04, head:-0.15, hk:'a', aF:-1.1, eF:-0.9, aB:-0.7, eB:-0.5 };
  const CLAW_HIT = { lean:0.3, dy:2, sx:1.05, sy:0.96, head:0.12, hk:'a', aF:1.65, eF:-0.15, aB:1.2, eB:0.1 };
  const ANIMS = {
    idle(t) { const b = Math.sin(t * 2.2); return Object.assign({}, BASE, { dy:b * 2.5, sy:1 + b * 0.012, sx:1 - b * 0.008, head:Math.sin(t * 1.1) * 0.05, aF:0.35 + Math.sin(t * 1.7) * 0.06, eF:0.55 + Math.sin(t * 1.7 + 0.6) * 0.08, aB:-0.3 + Math.sin(t * 1.7 + 1) * 0.05, eB:0.5, tail:t, tool:null }); },
    move(t) { const s = Math.sin(t * 7); return Object.assign({}, BASE, { lean:0.2, dy:Math.abs(Math.cos(t * 7)) * -3, head:0.05 + s * 0.04, aF:-0.35 + s * 0.55, eF:0.35, aB:0.25 - s * 0.55, eB:0.35, tail:t * 2.6 }); },
    // 砍樹：一下的時間 = 一個循環；循環結束那一刻就是砍中
    chop(p, t) { return Object.assign(keys([[0, CHOP_STRIKE], [0.16, CHOP_STRIKE], [0.5, Object.assign({}, CHOP_UP, { aF:2.6, aB:2.2, lean:-0.1, hk:'n' }), 'io'], [0.8, CHOP_UP, 'out'], [1, CHOP_STRIKE, 'in']], p), { tail:t }); },
    // 錘棺材板：兩下一份
    hammer(p, t) {
      const q = (p * 2) % 1, up = { lean:-0.02, dy:-3, head:-0.12, hk:'s', aF:2.7, eF:0.5, aB:0.6, eB:0.9, tool:'mallet', tr:-1.7 }, dn = { lean:0.25, dy:3, sx:1.03, sy:0.96, head:0.25, hk:'s', aF:0.75, eF:0.35, aB:0.7, eB:0.9, tool:'mallet', tr:-3.2 };
      return Object.assign(keys([[0, dn], [0.12, dn], [0.7, up, 'io'], [1, dn, 'in']], q), { tail:t });
    },
    // 揉壽包：兩隻手輪流往下壓
    knead(p, t) {
      const a = Math.sin(p * Math.PI * 4), b = Math.sin(p * Math.PI * 4 + Math.PI);
      return Object.assign({}, BASE, { lean:0.42 + a * 0.04, dy:2 + Math.abs(a) * 2, head:0.3, hk:p > 0.85 ? 'p' : 's', aF:0.9 + a * 0.35, eF:0.5 - a * 0.25, aB:0.95 + b * 0.35, eB:0.45 - b * 0.25, tail:t, sx:1 + Math.max(0, a) * 0.03, sy:1 - Math.max(0, a) * 0.03 });
    },
    // 割稻：彎腰，鐮刀前後割三下
    reap(p, t) {
      const w = Math.sin(p * Math.PI * 6);
      return Object.assign({}, BASE, { lean:0.55, dy:4, head:0.28 + w * 0.05, hk:p > 0.85 ? 'p' : 's', aF:0.4 + w * 0.75, eF:0.25, aB:0.85 - w * 0.2, eB:0.6, tool:'sickle', tr:-1.3 - w * 0.25, tail:t });
    },
    windup(p, t) { const a = Object.assign({}, BASE, { tool:'_W', tr:-1.4, ik:1 }); return Object.assign(mix(a, CHOP_UP, ease.out(Math.min(1, p))), { tail:t }); },
    strike(p, t) { return Object.assign(mix(CHOP_UP, CHOP_STRIKE, ease.out(Math.min(1, p * 1.6))), { tail:t }); },
    recover(p, t) { return Object.assign(mix(CHOP_STRIKE, Object.assign({}, BASE, { tool:'_W', tr:-1.4 }), ease.io(Math.min(1, p))), { tail:t }); },
    windupC(p, t) { return Object.assign(mix(BASE, CLAW_UP, ease.out(Math.min(1, p))), { tail:t }); },
    strikeC(p, t) { return Object.assign(mix(CLAW_UP, CLAW_HIT, ease.out(Math.min(1, p * 1.6))), { tail:t }); },
    recoverC(p, t) { return Object.assign(mix(CLAW_HIT, BASE, ease.io(Math.min(1, p))), { tail:t }); },
    cast(p, t) { const w = Math.sin(t * 18) * 0.06; return Object.assign({}, BASE, { lean:-0.12, dy:-4 - p * 4, hk:'a', head:-0.2, aF:2.0 + w, eF:-0.4, aB:1.8 - w, eB:-0.3, tail:t, sx:1 + p * 0.04, sy:1 + p * 0.04 }); },
    proud(p, t) { return Object.assign(ANIMS.idle(t), { hk:'p', head:-0.15, aF:-0.25, eF:2.2, aB:-0.3, eB:2.1 }); },
    die(p, t) { return Object.assign(ANIMS.hurt(0, t), { hk:'h', lean:-0.6 * p, dy:-6 * p }); },
    hurt(p, t) { const k = Math.max(0, 1 - p); return Object.assign({}, BASE, { lean:-0.35 * k, dy:-4 * k, hk:'h', head:-0.3 * k, aF:1.2 * k + 0.1, eF:0.9 * k, aB:1.0 * k, eB:1.1 * k, tail:t, sx:1 - 0.06 * k, sy:1 + 0.06 * k }); },
  };
  // ---------- 活人動作 ----------
  const H_ = (o) => Object.assign({}, BASE, o);
  Object.assign(ANIMS, {
    walk(t) { const s = Math.sin(t * 8); return H_({ lean:0.06, dy:-Math.abs(Math.cos(t * 8)) * 1.6, head:Math.sin(t * 8) * 0.03, aF:-s * 0.45, eF:0.25, aB:s * 0.45, eB:0.25, lF:s * 0.42, lB:-s * 0.42 }); },
    run(t) { const s = Math.sin(t * 15); return H_({ lean:0.32, dy:-Math.abs(Math.cos(t * 15)) * 4, head:-0.15 + s * 0.06, hk:'t', aF:2.3 + s * 0.7, eF:-0.3, aB:2.0 - s * 0.7, eB:-0.2, lF:s * 0.85, lB:-s * 0.85, jx:Math.sin(t * 41) * 0.6 }); },
    startle(p, t) {
      const up = p < 0.35 ? ease.out(p / 0.35) : 1 - ease.in((p - 0.35) / 0.65) * 0.75;
      return H_({ lean:-0.32 * up, dy:-9 * Math.sin(Math.min(1, p / 0.7) * Math.PI) - (p < 0.08 ? -3 : 0), sx:1 - 0.06 * up, sy:1 + 0.08 * up, head:-0.25 * up, hk:'s', aF:2.7 * up + 0.2, eF:-0.4 * up, aB:2.5 * up, eB:-0.3 * up, lF:0.45 * up, lB:-0.35 * up, jx:Math.sin(t * 50) * 0.8 * (1 - p) });
    },
    cower(p, t) { const j = Math.sin(t * 45) * 0.04; return H_({ lean:0.35, dy:7, sx:1.04, sy:0.9, head:0.35 + j, hk:'t', aF:2.5 + j, eF:1.7, aB:2.3 - j, eB:1.8, lF:0.55, lB:-0.5, jx:Math.sin(t * 47) * 0.7 }); },
    tremble(p, t) { const j = Math.sin(t * 38); return H_({ lean:-0.05, dy:1.5, head:0.08 + j * 0.03, hk:'f', aF:0.85 + j * 0.05, eF:1.9, aB:0.75 - j * 0.05, eB:2.0, lF:0.12 + j * 0.04, lB:-0.12 - j * 0.04, jx:j * 0.9, sx:0.98, sy:1.0 }); },
    phone(p, t) { const b = Math.sin(t * 1.6); return H_({ lean:0.06, dy:b * 0.6, head:0.28 + b * 0.02, hk:'b', aF:0.75, eF:1.45 + b * 0.03, aB:0.65, eB:1.55, tool:'_P', tr:-1.4, lF:0, lB:0 }); },
    look(t) { const w = Math.sin(t * 1.3); return H_({ lean:-0.02, head:w * 0.18 - 0.05, hk:'q', aF:1.45 + w * 0.15, eF:0.05, aB:-0.15, eB:0.4, tool:'_P', tr:-3.0, dy:Math.sin(t * 2) * 0.5 }); },
    mop(t) { const w = Math.sin(t * 4.5); return H_({ lean:0.18, dy:1, head:0.15, hk:'b', aF:0.55 + w * 0.35, eF:0.35, aB:0.8 + w * 0.3, eB:0.5, tool:'_P', tr:-3.5 + w * 0.15, ik:1, lF:w * 0.08, lB:-w * 0.08 }); },
    faint(p, t) { const k = ease.in(Math.min(1, p)); return H_({ lean:-1.35 * k, dy:4 * k, head:-0.3 * k, hk:'x', aF:2.6 * k, eF:0.4, aB:2.4 * k, eB:0.5, lF:0.6 * k, lB:0.3 * k }); },
    sip(t) { const w = Math.sin(t * 1.4); return H_({ head:-0.08 + w * 0.03, hk:'c', aF:0.55, eF:2.15 + w * 0.05, aB:-0.1, eB:0.3, dy:Math.sin(t * 2) * 0.5 }); },
    stand(t) { const b = Math.sin(t * 2); return H_({ dy:b * 0.5, sy:1 + b * 0.006, head:Math.sin(t * 0.9) * 0.04, aF:0.12 + b * 0.03, eF:0.2, aB:-0.1, eB:0.2 }); },
    hold(t) { const b = Math.sin(t * 2); return H_({ dy:b * 0.5, head:-0.05, hk:'q', aF:0.55, eF:1.25, aB:0.45, eB:1.35, tool:'_P', tr:-1.57 }); },
    shrug(p, t) { const k = Math.sin(Math.min(1, p) * Math.PI); return H_({ head:-0.15 * k, hk:'q', aF:0.6 * k, eF:-1.2 * k, aB:0.5 * k, eB:-1.1 * k, dy:-1.5 * k }); },
  });
  // ---------- 繪製 ----------
  function ik2(sx, sy, tx, ty, L1, L2) { // 回傳 [上臂角, 手肘角]
    const dx = tx - sx, dy = ty - sy; let d = Math.hypot(dx, dy); d = Math.min(d, L1 + L2 - 1);
    const base = Math.atan2(-dx, dy);
    const c = Math.max(-1, Math.min(1, (L1 * L1 + d * d - L2 * L2) / (2 * L1 * d)));
    const a1 = base - Math.acos(c);
    const c2 = Math.max(-1, Math.min(1, (L1 * L1 + L2 * L2 - d * d) / (2 * L1 * L2)));
    return [a1, Math.PI - Math.acos(c2)];
  }
  const rot = (x, y, a) => [x * Math.cos(a) - y * Math.sin(a), x * Math.sin(a) + y * Math.cos(a)];
  function drawTorso(ctx, R, pz) {
    const [k, w, h] = R.torso, im = SPR[k], [rx, ry] = R.root, cut = R.lF ? h : ry - 20;
    const pw = im.naturalWidth / w; // 圖被縮過，換算回原圖像素
    ctx.save(); ctx.scale(-1, 1); const u0 = rx - w; // 鏡像：原圖 x → 畫面 -x
    ctx.drawImage(im, 0, 0, im.naturalWidth, cut * pw, u0, -ry, w, cut);
    const step = 8; // 尾巴一條一條畫，越往下飄得越大
    for (let y = cut; y < h - 0.5; y += step) {
      const f = (y - cut) / (h - cut), off = Math.sin(pz.tail * 3.2 - f * 3) * 16 * f * f + (pz.lean || 0) * -40 * f * f;
      const hh = Math.min(step, h - y);
      ctx.drawImage(im, 0, y * pw, im.naturalWidth, hh * pw, u0 - off, y - ry, w, hh + 0.8);
    }
    ctx.restore();
  }
  function draw(ctx, id, x, y, worldH, pz, flip) {
    const R = RIGS[id], k = worldH / R.h;
    ctx.save(); ctx.translate(x, y + (pz.dy || 0) * worldH / 58); if (flip) ctx.scale(-1, 1); ctx.scale(k * pz.sx, k * pz.sy);
    ctx.translate((pz.jx || 0) / k * (worldH / 58), -(R.tailY - R.root[1]));
    if (R.lF) { // 雙腿：從髖關節轉，不跟著上半身傾斜
      const LS = R.legS || 1, [rx0, ry0] = R.root;
      const leg = (hp, a, L) => { ctx.save(); ctx.translate(hp[0] - rx0, hp[1] - ry0); ctx.rotate(a); ctx.scale(LS, LS); img(L[0], -L[3][0], -L[3][1], L[1], L[2], ctx); ctx.restore(); };
      leg(R.hipB, pz.lB || 0, R.lB); leg(R.hipF, pz.lF || 0, R.lF);
    }
    ctx.rotate(-pz.lean); const AS = R.armS || 0.62;
    const [rx, ry] = R.root;
    if (pz.tool === '_P') pz = Object.assign({}, pz, { tool:R.tool ? '_' + id : null });
    if (pz.tool === '_W' || (pz.tool === 'axe' && id !== 'afu')) pz = Object.assign({}, pz, { tool:R.tool ? '_' + id : id === 'afu' ? 'axe' : null });
    const T = toolDef(pz.tool);
    // 前手的握把位置（身體座標），給後手抓
    const sF = [R.shF[0] - rx, R.shF[1] - ry];
    const uF = R.uF, fF = R.fF, uB = R.uB, fB = R.fB;
    const L1F = (uF[4][1] - uF[3][1]) * AS, L2F = (fF[4][1] - fF[3][1]) * AS;
    const e1 = rot(0, L1F, pz.aF), elb = [sF[0] + e1[0], sF[1] + e1[1]];
    const e2 = rot(0, L2F, pz.aF + pz.eF), grip = [elb[0] + e2[0], elb[1] + e2[1]];
    let aB = pz.aB, eB = pz.eB;
    const sB = [R.shB[0] - rx, R.shB[1] - ry];
    if (T && pz.ik) { // 雙手握：後手抓在握把再下面一點
      const ta = pz.aF + pz.eF + pz.tr; const d = rot(0, 70 * AS, ta); const L1B = (uB[4][1] - uB[3][1]) * AS, L2B = (fB[4][1] - fB[3][1]) * AS;
      [aB, eB] = ik2(sB[0], sB[1], grip[0] + d[0], grip[1] + d[1], L1B, L2B);
    }
    const arm = (sh, a, e, U, Fm, isFront) => {
      ctx.save(); ctx.translate(sh[0], sh[1]); ctx.rotate(a); ctx.scale(AS, AS);
      img(U[0], -U[3][0], -U[3][1], U[1], U[2], ctx);
      ctx.translate(U[4][0] - U[3][0], U[4][1] - U[3][1]); ctx.rotate(e);
      if (isFront && T) { ctx.save(); ctx.translate(Fm[4][0] - Fm[3][0], Fm[4][1] - Fm[3][1]); ctx.rotate(pz.tr); if (T[4]) ctx.scale(-1, 1); if (R.toolS) ctx.scale(R.toolS, R.toolS); img(T[0], -T[3][0], -T[3][1], T[1], T[2], ctx); ctx.restore(); }
      img(Fm[0], -Fm[3][0], -Fm[3][1], Fm[1], Fm[2], ctx);
      ctx.restore();
    };
    arm(sB, aB, eB, uB, fB, false);
    drawTorso(ctx, R, pz);
    // 頭
    const hk = R.heads[pz.hk] && ok(R.heads[pz.hk]) ? R.heads[pz.hk] : R.heads.n, hi = SPR[hk];
    const [hw0, hh0, fx, fy] = R.head, hw = hw0, hh = hw0 * hi.naturalHeight / hi.naturalWidth;
    ctx.save(); ctx.translate(R.neck[0] - rx, R.neck[1] - ry + 10); ctx.rotate(-pz.head); ctx.scale(-1, 1); ctx.drawImage(hi, -hw * (1 - fx), -hh * fy, hw, hh); ctx.restore();
    arm(sF, pz.aF, pz.eF, uF, fF, true);
    ctx.restore();
    // 回傳工具頭的世界座標（給特效用）
    return grip;
  }
  // 工具前端的世界座標：拿來放木屑、火花
  function tipWorld(id, x, y, worldH, pz, flip, along) {
    const R = RIGS[id], k = worldH / R.h, [rx, ry] = R.root, T = toolDef(pz.tool);
    const AS = R.armS || 0.62, uF = R.uF, fF = R.fF; const L1F = (uF[4][1] - uF[3][1]) * AS, L2F = (fF[4][1] - fF[3][1]) * AS;
    let p = [R.shF[0] - rx, R.shF[1] - ry]; let r1 = rot(0, L1F, pz.aF); p = [p[0] + r1[0], p[1] + r1[1]]; r1 = rot(0, L2F, pz.aF + pz.eF); p = [p[0] + r1[0], p[1] + r1[1]];
    if (T) { const d = rot(0, -(along || T[2] * 0.7) * AS, pz.aF + pz.eF + pz.tr); p = [p[0] + d[0], p[1] + d[1]]; }
    let w = rot(p[0], p[1], -pz.lean); w = [w[0], w[1] - (R.tailY - R.root[1])];
    w = [w[0] * k * pz.sx, w[1] * k * pz.sy];
    return [x + (flip ? -w[0] : w[0]), y + (pz.dy || 0) * worldH / 58 + w[1]];
  }
  const armed = (id) => id === 'afu' || !!(RIGS[id] && RIGS[id].tool);
  return { armed, has, draw, ANIMS, tipWorld, RIGS, addRigs };
})();
