// ============================================================
// 拆不開的角色（Penanggal / Pocong / Toyol）：網格變形動畫
// 整張圖切成小格，每格按位移場各自變形（頭髮、腸子、結、尾巴、錢袋各有各的動）
// 次級動作 = 用「稍早時間」的身體姿勢去帶動（自然的延遲跟隨），再加一條彈簧追蹤橫向移動
// ============================================================
const SPECIAL = (() => {
  const TAU = Math.PI * 2;
  const H0 = { penanggal:52, pocong:54, toyol:46 };
  const ADUR = 0.55, HDUR = 0.45; // 攻擊 / 受擊動畫長度（秒）
  const sm = (a, b, x) => { x = (x - a) / (b - a); x = x < 0 ? 0 : x > 1 ? 1 : x; return x * x * (3 - 2 * x); };
  const lerpKeys = (K, p) => { // 關鍵格之間用 cos 緩動
    for (let i = 1; i < K.length; i++) if (p <= K[i][0]) { const a = K[i - 1], b = K[i], q = (p - a[0]) / (b[0] - a[0]); return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * Math.cos(Math.PI * q)); }
    return K[K.length - 1][1];
  };
  const HOP_SY = [[0, 1], [0.15, 0.84], [0.24, 1.14], [0.45, 1.03], [0.62, 1.08], [0.70, 1.1], [0.78, 0.8], [0.89, 1.05], [1, 1]];

  // ---------- 每個實例的狀態（彈簧、攻擊計時），以位置追蹤 ----------
  const states = new Map(); let uid = 0, lastClean = 0, epoch = 0, lastCall = 0;
  function getState(type, x, o) {
    const now = performance.now();
    if (now - lastCall > 6) epoch++; // 同一幀內的連續繪製算同一輪；一個狀態一輪只能被一個角色認領
    lastCall = now;
    let st = null;
    if (o.key != null) st = states.get(type + '#' + o.key);
    else {
      let best = 1e9;
      for (const s of states.values()) {
        if (s.type !== type || s.keyed || now - s.seen > 400 || s.ep === epoch) continue;
        const d = Math.abs(s.x - x); if (d < 30 && d < best) { best = d; st = s; }
      }
    }
    if (!st) {
      st = { type, keyed:o.key != null, x, seen:now - 16, ep:-1, L:0, V:0, aclk:-1, atkOn:false, hclk:-1, hurtOn:false };
      states.set(o.key != null ? type + '#' + o.key : type + '@' + (uid++), st);
    }
    let dt = (now - st.seen) / 1000; dt = dt < 0 ? 0 : dt > 0.05 ? 0.05 : dt;
    // 橫向彈簧：錨點移動時跟隨點留在原地，再被彈簧拉回（帶過衝）
    let dx = x - st.x; if (Math.abs(dx) > 40) dx = 0;
    st.L -= (o.flip ? -dx : dx);
    for (let i = 0; i < 2; i++) { const h = dt / 2, a = -170 * st.L - 9 * st.V; st.V += a * h; st.L += st.V * h; }
    if (st.L > 9) st.L = 9; else if (st.L < -9) st.L = -9;
    st.x = x; st.seen = now; st.dt = dt; st.ep = epoch;
    if (now - lastClean > 2000) { lastClean = now; for (const [k, s] of states) if (now - s.seen > 2000) states.delete(k); }
    return st;
  }
  const ATKPOSE = { windup:(p) => 0.3 * Math.min(1, p), strike:(p) => 0.3 + 0.4 * Math.min(1, p), recover:(p) => 0.7 + 0.3 * Math.min(1, p), cast:(p) => Math.min(1, p), attack:(p) => Math.min(1, p) };
  function progress(st, o) {
    let pa = -1, ph = -1;
    if (o.pose && ATKPOSE[o.pose] && o.pt != null) pa = ATKPOSE[o.pose](o.pt);
    else {
      if (o.atk && !st.atkOn) st.aclk = 0;
      st.atkOn = !!o.atk;
      if (st.aclk >= 0) { pa = st.aclk / ADUR; st.aclk += st.dt; if (pa > 1.6) st.aclk = -1; }
    }
    if ((o.pose === 'hurt' || o.pose === 'die') && o.pt != null) ph = Math.min(1, o.pt);
    else {
      if (o.hurt && !st.hurtOn) st.hclk = 0;
      st.hurtOn = !!o.hurt;
      if (st.hclk >= 0) { ph = st.hclk / HDUR; st.hclk += st.dt; if (ph > 1.6) st.hclk = -1; }
    }
    return [pa, ph];
  }

  // ---------- 各角色 ----------
  // drive(G, tt, pa, ph, o)：身體整體姿勢（x,y 位移、r 旋轉、sx,sy 縮放，繞 pivot）
  // local(u, v, P, out)：圖內局部位移；lag(u,v)：該點用多少秒前的姿勢；gain：跟隨誇張度
  const C = {};
  C.penanggal = {
    grid:[7, 18], pu:0.46, pv:0.37, cap:4.5,
    drive(G, tt, pa, ph, o, hf) { // hf：高頻抖動的保留比例（延遲取樣時壓低，避免網格混疊撕裂）
      let x = Math.sin(tt * 1.3) * 1.2, y = -4 - Math.sin(tt * 2.6) * 2.2, r = Math.sin(tt * 1.3 + 0.6) * 0.06, sx = 1, sy = 1;
      if (o.walk) { y -= Math.sin(tt * 5.2) * 1.6; r += 0.1 + Math.sin(tt * 5.2 + 0.8) * 0.05; x += Math.sin(tt * 2.6) * 1; }
      if (o.work) { r += Math.sin(tt * 7) * 0.07; y -= Math.abs(Math.sin(tt * 7)) * 1.5; }
      if (pa >= 0) {
        const p = Math.min(1, Math.max(0, pa));
        const a1 = sm(0, 0.25, p) * (1 - sm(0.27, 0.4, p)); // 蓄勢：往後縮、仰頭
        x -= 5 * a1; r -= 0.22 * a1; sy *= 1 + 0.08 * a1; sx *= 1 - 0.06 * a1; y += 1.5 * a1;
        const l = sm(0.25, 0.47, p) * (1 - sm(0.62, 1, p)); // 撲出
        x += 13 * l; r += 0.08 * l; y += 2 * l;
        const str = Math.sin(Math.PI * l); sx *= 1 + 0.22 * str; sy *= 1 - 0.13 * str;
        if (p > 0.44 && p < 0.7) { const q = (p - 0.44) / 0.26, c = Math.abs(Math.sin(q * TAU)) * Math.sin(q * Math.PI) * hf; sy *= 1 - 0.18 * c; sx *= 1 + 0.12 * c; } // 咬兩口
      }
      if (ph >= 0 && ph < 1) { const k = 1 - ph, k2 = k * k * sm(0, 0.16, ph), j = Math.sin(ph * 22) * k * sm(0, 0.06, ph) * hf; x -= 7 * k2; y -= 2 * k2; r -= 0.3 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j; }
      G.x = x; G.y = y; G.r = r; G.sx = sx; G.sy = sy;
    },
    weights(u, v, W) {
      const rr = Math.hypot((u - 0.46) / 0.31, (v - 0.37) / 0.29);
      W.hw = sm(0.8, 1.6, rr); // 頭髮（臉以外）
      W.dw = Math.max(W.hw, sm(0.52, 0.95, v)); // 會晃的部分
      const eu = (u - 0.43) / 0.17; W.ew = sm(0.5, 0.9, v) * Math.exp(-eu * eu); // 腸子
    },
    local(u, v, P, W, out) {
      const t = P.t, dw = W.dw;
      out.x = dw * (Math.sin(t * 3.1 - v * 7 + u * 2) * 1.4 + Math.sin(t * 1.9 - v * 4.3 + u) * 0.7) * (0.35 + 0.9 * v)
            + W.ew * Math.sin(t * 2.1 - v * 3.2) * 2.4 * (v - 0.5) * 2
            + P.L * dw * v * 1.1;
      out.y = W.hw * Math.sin(t * 2.4 - u * 6) * 0.5 + W.ew * Math.sin(t * 4.2 - v * 5) * 0.4;
    },
    lag(u, v, W) { return W.dw * (0.04 + 0.2 * v) + W.ew * 0.06; },
    gain(u, v, W) { return 1 + 0.12 * W.dw; },
  };
  C.pocong = {
    grid:[3, 18], pu:0.5, pv:1, cap:1.6,
    hopping(o) { return !!(o.walk || o.enemy || o.work); },
    hop(tt, o) { // 回傳 [相位, 高度]
      const rate = o.work ? 2.2 : o.walk ? 1.55 : 1.25, h = o.work ? 2.5 : o.walk ? 7 : 4.5;
      const f = tt * rate; return [f - Math.floor(f), h];
    },
    drive(G, tt, pa, ph, o, hf) { // hf：高頻抖動的保留比例（延遲取樣時壓低，避免網格混疊撕裂）
      let x = 0, y = 0, r = 0, sx = 1, sy = 1;
      const atk = pa >= 0 && pa < 1;
      if (atk) {
        const p = Math.max(0, pa);
        if (p < 0.25) { const q = sm(0, 0.25, p); sy = 1 - 0.28 * q; r = -0.08 * q; }
        else if (p < 0.62) { const q = (p - 0.25) / 0.37; y = -22 * 4 * q * (1 - q); x = 11 * sm(0, 1, q); sy = lerpKeys([[0, 0.72], [0.12, 1.22], [0.5, 1.04], [0.85, 1.12], [1, 1.1]], q); r = 0.18 * Math.sin(Math.PI * q); }
        else if (p < 0.72) { const q = sm(0.62, 0.72, p); x = 11; sy = 1.1 - 0.42 * q; }
        else { const k = (p - 0.72) / 0.28; x = 11 * (1 - sm(0, 1, k)); sy = 1 - 0.32 * (1 - k) * (1 - k) * Math.cos(k * 3 * Math.PI); }
        sx = 1 / Math.pow(sy, 0.7);
      } else if (this.hopping(o)) {
        const [f, h] = this.hop(tt, o);
        sy = lerpKeys(HOP_SY, f); sx = 1 / Math.pow(sy, 0.6);
        if (f > 0.2 && f < 0.7) { const q = (f - 0.2) / 0.5; y = -h * 4 * q * (1 - q); r = (o.walk ? 0.08 : 0.04) * Math.sin(Math.PI * q); if (o.walk) x = (q - 0.5) * 2.5; }
        else if (o.walk) x = f > 0.7 ? 1.25 : -1.25;
      } else {
        r = Math.sin(tt * 1.6) * 0.035; sy = 1 + Math.sin(tt * 2.2) * 0.015; sx = 1 - Math.sin(tt * 2.2) * 0.01;
      }
      if (ph >= 0 && ph < 1) { const k = 1 - ph, k2 = k * k * sm(0, 0.16, ph), j = Math.sin(ph * 20) * k * sm(0, 0.06, ph) * hf; x -= 4 * k2; r -= 0.22 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j; }
      G.x = x; G.y = y; G.r = r; G.sx = sx; G.sy = sy;
    },
    weights(u, v, W) { W.kw = 1 - sm(0.03, 0.26, v); W.bw = Math.sin(Math.PI * Math.min(1, Math.max(0, (v - 0.2) / 0.75))); },
    local(u, v, P, W, out) {
      const kw = W.kw, t = P.t;
      out.x = kw * (Math.sin(t * 3.3) * 0.9 + P.flop * 1.8 + P.L * 1.6) * (1.2 - v * 2) + W.bw * P.L * 0.35 + W.bw * P.jel * Math.sin(v * 9 - t * 20) * 0.6;
      out.y = kw * Math.sin(t * 2.6 + u * 3) * 0.3;
    },
    lag(u, v, W) { return W.kw * 0.07 + W.bw * 0.02; },
    gain(u, v, W) { return 1 + 0.4 * W.kw; },
  };
  C.toyol = {
    grid:[5, 18], pu:0.5, pv:0.62, cap:4,
    drive(G, tt, pa, ph, o, hf) { // hf：高頻抖動的保留比例（延遲取樣時壓低，避免網格混疊撕裂）
      let x = Math.sin(tt * 1.4) * 0.8, y = -Math.sin(tt * 2.8) * 1.0, r = Math.sin(tt * 1.7) * 0.05, sy = 1 + Math.sin(tt * 3.0) * 0.02, sx = 1 - Math.sin(tt * 3.0) * 0.012;
      if (o.walk) { r += 0.15 + Math.sin(tt * 6) * 0.03; y += Math.sin(tt * 6) * 0.9; }
      if (o.work) { y -= Math.abs(Math.sin(tt * 6)) * 1.8; r += Math.sin(tt * 6) * 0.06; }
      if (pa >= 0) {
        const p = Math.min(1, Math.max(0, pa));
        const a1 = sm(0, 0.22, p) * (1 - sm(0.22, 0.32, p)); // 縮身蓄勢
        x -= 4 * a1; r -= 0.14 * a1; sx *= 1 + 0.08 * a1; sy *= 1 - 0.1 * a1; y += 1 * a1;
        const l = sm(0.22, 0.4, p) * (1 - sm(0.74, 1, p)); // 衝刺 → 回來
        x += 15 * l; r += 0.2 * Math.sin(Math.PI * sm(0.22, 0.4, p)) + 0.06 * l;
        const str = Math.sin(Math.PI * l); sx *= 1 + 0.26 * str; sy *= 1 - 0.14 * str;
        if (p > 0.4 && p < 0.74) { const q = (p - 0.4) / 0.34, b = Math.sin(q * 3 * Math.PI) * (1 - q) * hf; sy *= 1 - 0.1 * b; sx *= 1 + 0.07 * b; }
      }
      if (ph >= 0 && ph < 1) { const k = 1 - ph, k2 = k * k * sm(0, 0.16, ph), j = Math.sin(ph * 22) * k * sm(0, 0.06, ph) * hf; x -= 6 * k2; r -= 0.28 * k2; sy *= 1 + 0.1 * j; sx *= 1 - 0.08 * j; }
      G.x = x; G.y = y; G.r = r; G.sx = sx; G.sy = sy;
    },
    weights(u, v, W) {
      W.hw = 1 - sm(0.36, 0.5, v); // 頭
      W.bw = sm(0.4, 0.48, v) * (1 - sm(0.68, 0.76, v)); // 身體呼吸
      const su = (u - 0.8) / 0.17, sv = (v - 0.55) / 0.15; W.sw = Math.exp(-(su * su + sv * sv)); // 錢袋
      W.tw = sm(0.68, 1, v); // 尾巴
    },
    local(u, v, P, W, out) {
      const t = P.t, tw = Math.pow(W.tw, 1.3);
      // 頭繞脖子小轉
      const a = W.hw * P.hr, ox = (u - 0.5) * P.Wd, oy = (v - 0.45) * P.H;
      let x = ox * Math.cos(a) - oy * Math.sin(a) - ox, y = ox * Math.sin(a) + oy * Math.cos(a) - oy;
      x += W.bw * (u - 0.55) * P.Wd * 0.05 * Math.sin(t * 3);
      y += W.bw * (0.6 - v) * P.H * 0.03 * Math.sin(t * 3) + W.hw * Math.sin(t * 2.8 - 0.6) * 0.5;
      x += tw * (Math.sin(t * 4.2 - v * 8) * 2.4 + P.L * 1.6);
      y += tw * Math.sin(t * 3.1 - v * 6) * 0.4;
      x += W.sw * P.sj * Math.sin(t * 37) * 1.4;
      y += W.sw * (Math.sin(t * 3 + 1) * 0.8 + P.sj * Math.sin(t * 29 + 1) * 1.8);
      out.x = x; out.y = y;
    },
    lag(u, v, W) { return W.hw * 0.06 + W.tw * 0.16; }, // 錢袋不吃延遲（左右延遲不同會摺），它的晃動在 local 裡
    gain(u, v, W) { return 1 + 0.5 * W.tw; },
  };

  // ---------- 網格繪製 ----------
  const masks = {}; // 每張圖每格是否有內容
  function mask(type, img, cols, rows) {
    if (masks[type]) return masks[type];
    const m = new Uint8Array(cols * rows).fill(1);
    try {
      const cw = cols * 6, ch = rows * 6, c = document.createElement('canvas'); c.width = cw; c.height = ch;
      const g = c.getContext('2d'); g.drawImage(img, 0, 0, cw, ch); const d = g.getImageData(0, 0, cw, ch).data;
      for (let j = 0; j < rows; j++) for (let i = 0; i < cols; i++) {
        let any = 0; for (let yy = j * 6; yy < j * 6 + 6 && !any; yy++) for (let xx = i * 6; xx < i * 6 + 6; xx++) if (d[(yy * cw + xx) * 4 + 3] > 4) { any = 1; break; }
        m[j * cols + i] = any;
      }
    } catch (e) {}
    return (masks[type] = m);
  }
  const VX = new Float32Array(512), VY = new Float32Array(512);
  const GC = []; for (let i = 0; i < 40; i++) GC.push({ x:0, y:0, r:0, sx:1, sy:1, c:1, s:0, ok:-1 });
  const W = {}, D = { x:0, y:0 }, P = { t:0, L:0, flop:0, jel:0, hr:0, sj:0, Wd:0, H:0 };
  let frameId = 0;
  const TMP = { x:0, y:0, r:0, sx:1, sy:1 };
  function poseAt(def, idx, t, pa, ph, o) {
    const G = GC[idx]; if (G.ok === frameId) return G;
    const base = idx / 60;
    if (idx === 0) def.drive(G, t, pa, ph, o, 1);
    else { // 延遲越久越「鈍」：在 [0.5, 1.5]×延遲 的時間窗內取平均（像彈簧的低通），急變不會把網格摺起來
      G.x = G.y = G.r = G.sx = G.sy = 0;
      for (let m = 0; m < 5; m++) {
        const lg = base * (0.3 + 0.35 * m);
        def.drive(TMP, t - lg, pa >= 0 ? pa - lg / ADUR : -1, ph >= 0 ? ph - lg / HDUR : -1, o, Math.exp(-lg * 18));
        G.x += TMP.x * 0.2; G.y += TMP.y * 0.2; G.r += TMP.r * 0.2; G.sx += TMP.sx * 0.2; G.sy += TMP.sy * 0.2;
      }
    }
    G.c = Math.cos(G.r); G.s = Math.sin(G.r); G.ok = frameId; return G;
  }
  // 姿勢 G 作用在單位座標點 (bx,by)
  function apply(G, bx, by, px, py, out) {
    const dx = (bx - px) * G.sx, dy = (by - py) * G.sy;
    out.x = px + dx * G.c - dy * G.s + G.x; out.y = py + dx * G.s + dy * G.c + G.y;
  }
  // 用某姿勢把整張圖畫成一塊（拖影用）
  function drawWhole(ctx, img, M, G, x0, y0, s, Wd, H, px, py) {
    const a = G.sx * G.c, b = G.sx * G.s, c = -G.sy * G.s, d = G.sy * G.c;
    const e = px + G.x - (a * px + c * py), f = py + G.y - (b * px + d * py);
    const la = a * s, lb = b * s, lc = c * s, ld = d * s, le = e * s + x0, lf = f * s + y0;
    ctx.setTransform(M.a * la + M.c * lb, M.b * la + M.d * lb, M.a * lc + M.c * ld, M.b * lc + M.d * ld, M.a * le + M.c * lf + M.e, M.b * le + M.d * lf + M.f);
    ctx.drawImage(img, -Wd / 2, -H, Wd, H);
  }
  function dust(ctx, x0, y0, s, k, big) { // 落地揚塵
    if (k <= 0 || k >= 1) return;
    const n = big ? 5 : 3, a = (1 - k) * (big ? 0.55 : 0.4);
    ctx.save(); ctx.fillStyle = `rgba(214,204,184,${a.toFixed(3)})`;
    for (let i = 0; i < n; i++) for (const sd of [-1, 1]) {
      const d = (big ? 10 : 6) + k * (big ? 18 : 10) + i * 3.2, rr = (big ? 3.4 : 2.4) * (0.6 + k * 0.9) * (1 - i * 0.12);
      ctx.beginPath(); ctx.ellipse(x0 + sd * d * s, y0 - (1 + i * 0.6 + k * 2.5 * (1 + (i & 1))) * s, rr * s, rr * 0.7 * s, 0, 0, TAU); ctx.fill();
    }
    ctx.restore();
  }

  function draw(ctx, type, x0, y0, s, o) {
    const def = C[type], img = SPR[type], iw = img.naturalWidth, ih = img.naturalHeight;
    const t = o.t || 0, H = H0[type], Wd = H * iw / ih, cols = def.grid[0], rows = def.grid[1];
    const st = getState(type, x0, o), [pa, ph] = progress(st, o);
    frameId++;
    const px = (def.pu - 0.5) * Wd, py = -(1 - def.pv) * H;
    // 每幀參數
    P.t = t; P.L = st.L / Math.max(0.3, s); P.Wd = Wd; P.H = H; P.flop = 0; P.jel = 0; P.hr = 0; P.sj = 0;
    let dustK = -1, dustBig = false;
    if (type === 'pocong') {
      if (pa >= 0 && pa < 1) { if (pa > 0.62) { dustK = (pa - 0.62) / 0.38; dustBig = true; P.jel = Math.max(0, 1 - (pa - 0.62) / 0.3); } P.flop = Math.sin(pa * TAU * 1.5) * (1 - pa); }
      else if (def.hopping(o)) { const [f, h] = def.hop(t, o); P.flop = Math.sin(f * TAU - 1.2) * (h / 6); if (f > 0.7 && h > 3) { dustK = (f - 0.7) / 0.3; } if (f > 0.7) P.jel = (1 - (f - 0.7) / 0.3) * 0.6; }
      if (ph >= 0 && ph < 1) P.jel = Math.max(P.jel, 1 - ph);
    } else if (type === 'toyol') {
      P.hr = Math.sin(t * 1.9 + 0.4) * 0.07 + (o.walk ? 0.05 : 0);
      if (pa >= 0 && pa < 1) { P.sj = sm(0.36, 0.45, pa) * (1 - sm(0.7, 0.85, pa)); P.hr += -0.12 * sm(0.22, 0.4, pa) * (1 - sm(0.4, 0.6, pa)); }
      if (ph >= 0 && ph < 1) { P.sj = Math.max(P.sj, (1 - ph) * 0.8); P.hr -= 0.2 * (1 - ph) * (1 - ph); }
    }
    // 頂點
    const nx = cols + 1, out = D;
    for (let j = 0; j <= rows; j++) {
      const v = j / rows;
      for (let i = 0; i <= cols; i++) {
        const u = i / cols;
        def.weights(u, v, W);
        def.local(u, v, P, W, out);
        const bx = (u - 0.5) * Wd + out.x, by = -(1 - v) * H + out.y;
        const G0 = poseAt(def, 0, t, pa, ph, o);
        apply(G0, bx, by, px, py, out);
        let X = out.x, Y = out.y;
        const lf = Math.min(38.999, def.lag(u, v, W) * 60);
        if (lf > 0.001) {
          // 延遲時間連續取值：兩個相鄰快取姿勢之間線性內插，避免一排一排的台階
          const g = def.gain(u, v, W), X0 = X, Y0 = Y, li = Math.floor(lf), fr = lf - li;
          apply(poseAt(def, li, t, pa, ph, o), bx, by, px, py, out); const ax = out.x, ay = out.y;
          apply(poseAt(def, li + 1, t, pa, ph, o), bx, by, px, py, out);
          out.x = ax + (out.x - ax) * fr; out.y = ay + (out.y - ay) * fr;
          let ddx = (out.x - X0) * g, ddy = (out.y - Y0) * g; const m = Math.hypot(ddx, ddy);
          if (m > 1e-4) { const q = def.cap * Math.tanh(m / def.cap) / m; ddx *= q; ddy *= q; } // 軟上限：跟隨再大也不撕裂
          X = X0 + ddx; Y = Y0 + ddy;
        }
        const k = j * nx + i; VX[k] = x0 + X * s; VY[k] = y0 + Y * s;
      }
    }
    // 防摺保險：同一排左→右、同一欄上→下，相鄰頂點至少保留靜止間距的 25%（極端姿勢也不會翻面）
    const mnX = 0.25 * Wd / cols * s, mnY = 0.25 * H / rows * s;
    for (let j = 0; j <= rows; j++) for (let i = 1; i <= cols; i++) { const k = j * nx + i; if (VX[k] < VX[k - 1] + mnX) VX[k] = VX[k - 1] + mnX; }
    for (let i = 0; i <= cols; i++) for (let j = 1; j <= rows; j++) { const k = j * nx + i; if (VY[k] < VY[k - nx] + mnY) VY[k] = VY[k - nx] + mnY; }
    const M = ctx.getTransform(), mk = mask(type, img, cols, rows);
    const cw = iw / cols, ch = ih / rows;
    const Ms = Math.max(0.2, Math.hypot(M.a, M.b)); // 畫布座標 → 螢幕像素
    ctx.save();
    // Toyol 衝刺拖影
    if (type === 'toyol' && pa >= 0 && pa < 1) {
      const G0 = poseAt(def, 0, t, pa, ph, o), G2 = poseAt(def, 2, t, pa, ph, o);
      const spd = Math.abs(G0.x - G2.x) * 30; // 單位/秒
      if (spd > 25) {
        const base = ctx.globalAlpha, amt = Math.min(1, (spd - 25) / 120);
        for (let i = 4; i >= 1; i--) { ctx.globalAlpha = base * amt * 0.22 * (1 - i / 5); drawWhole(ctx, img, M, poseAt(def, i * 2, t, pa, ph, o), x0, y0, s, Wd, H, px, py); }
        ctx.globalAlpha = base;
      }
    }
    for (let j = 0; j < rows; j++) for (let i = 0; i < cols; i++) {
      if (!mk[j * cols + i]) continue;
      const k00 = j * nx + i, k10 = k00 + 1, k01 = k00 + nx, k11 = k01 + 1;
      // 最貼合四角的平行四邊形
      const ex = (VX[k10] - VX[k00] + VX[k11] - VX[k01]) * 0.5, ey = (VY[k10] - VY[k00] + VY[k11] - VY[k01]) * 0.5;
      const fx = (VX[k01] - VX[k00] + VX[k11] - VX[k10]) * 0.5, fy = (VY[k01] - VY[k00] + VY[k11] - VY[k10]) * 0.5;
      const ox = (VX[k00] + VX[k10] + VX[k01] + VX[k11]) * 0.25 - (ex + fx) * 0.5, oy = (VY[k00] + VY[k10] + VY[k01] + VY[k11]) * 0.25 - (ey + fy) * 0.5;
      ctx.setTransform(M.a * ex + M.c * ey, M.b * ex + M.d * ey, M.a * fx + M.c * fy, M.b * fx + M.d * fy, M.a * ox + M.c * oy + M.e, M.b * ox + M.d * oy + M.f);
      // 格子越扭（非平行四邊形），四邊就多蓋一點，免得出現裂縫
      const twS = Math.hypot(VX[k00] + VX[k11] - VX[k10] - VX[k01], VY[k00] + VY[k11] - VY[k10] - VY[k01]) * 0.25 * Ms;
      const lx = Math.max(1, Math.hypot(ex, ey) * Ms), ly = Math.max(1, Math.hypot(fx, fy) * Ms);
      const aL = Math.min(0.25, twS / lx), aR = Math.min(0.3, (1.1 + twS) / lx), aT = Math.min(0.25, twS / ly), aB = Math.min(0.3, (1.1 + twS) / ly);
      const sx0 = Math.max(0, (i - aL) * cw), sx1 = Math.min(iw, (i + 1 + aR) * cw), sy0 = Math.max(0, (j - aT) * ch), sy1 = Math.min(ih, (j + 1 + aB) * ch);
      ctx.drawImage(img, sx0, sy0, sx1 - sx0, sy1 - sy0, sx0 / cw - i, sy0 / ch - j, (sx1 - sx0) / cw, (sy1 - sy0) / ch);
    }
    ctx.setTransform(M);
    if (dustK > 0) dust(ctx, x0, y0, s, dustK, dustBig);
    ctx.restore();
  }

  return {
    has(type) { return !!(C[type] && typeof SPR !== 'undefined' && SPR[type] && SPR[type].naturalWidth); },
    draw,
    _dbg:{ VX, VY, C },
  };
})();
