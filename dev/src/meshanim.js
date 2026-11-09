// ===================== 原圖變形動畫（不切圖、不重畫：原本那張立繪自己動）=====================
// 做法：把原圖鋪成網格，每個網格點按「離哪根骨頭近」分配權重；骨頭轉動時，網格跟著彎，原圖貼在網格上。
// 座標一律用原圖的比例（0~1）。骨頭：[名字, 父骨頭, 支點x, 支點y, 末端x, 末端y, 影響半徑]
const MeshAnim = (() => {
  const RIG = {
    afu: { bones: [
      ['body', null, 0.50, 0.72, 0.50, 0.42, 0.30],
      ['tail1', 'body', 0.48, 0.80, 0.48, 0.90, 0.16], ['tail2', 'tail1', 0.48, 0.90, 0.48, 1.00, 0.14],
      ['head', 'body', 0.50, 0.42, 0.48, 0.10, 0.30],
      ['armF', 'body', 0.38, 0.46, 0.27, 0.52, 0.13], ['axe', 'armF', 0.27, 0.52, 0.12, 0.30, 0.20],
      ['armB', 'body', 0.66, 0.50, 0.72, 0.72, 0.11],
      ['tie', 'body', 0.62, 0.42, 0.90, 0.44, 0.12],
    ], hold: 'axe' },
    eguiking: { bones: [
      ['body', null, 0.48, 0.70, 0.50, 0.42, 0.34],
      ['tail1', 'body', 0.50, 0.80, 0.50, 0.90, 0.16], ['tail2', 'tail1', 0.50, 0.90, 0.50, 1.00, 0.14],
      ['head', 'body', 0.55, 0.38, 0.50, 0.12, 0.28],
      ['armF', 'body', 0.38, 0.45, 0.20, 0.30, 0.15],
      ['armB', 'body', 0.62, 0.48, 0.52, 0.55, 0.12],
      ['cape', 'body', 0.78, 0.45, 0.90, 0.65, 0.14],
    ] },
    npc_ken: { bones: [
      ['hips', null, 0.52, 0.72, 0.52, 0.55, 0.22],
      ['legF', 'hips', 0.42, 0.74, 0.40, 0.97, 0.12], ['legB', 'hips', 0.62, 0.74, 0.64, 0.97, 0.12],
      ['body', 'hips', 0.52, 0.66, 0.50, 0.42, 0.26],
      ['head', 'body', 0.50, 0.43, 0.50, 0.12, 0.30],
      ['armF', 'body', 0.32, 0.50, 0.40, 0.52, 0.12], ['armB', 'body', 0.70, 0.52, 0.55, 0.56, 0.12],
    ], legs: true },
    pontianak: { bones: [
      ['body', null, 0.48, 0.66, 0.48, 0.38, 0.30],
      ['tail1', 'body', 0.48, 0.78, 0.48, 0.88, 0.17], ['tail2', 'tail1', 0.48, 0.88, 0.48, 1.00, 0.15],
      ['head', 'body', 0.48, 0.38, 0.48, 0.12, 0.26],
      ['hairL', 'head', 0.25, 0.40, 0.10, 0.70, 0.14], ['hairR', 'head', 0.72, 0.40, 0.90, 0.70, 0.14],
      ['armF', 'body', 0.36, 0.46, 0.28, 0.60, 0.12], ['armB', 'body', 0.62, 0.46, 0.70, 0.58, 0.12],
    ] },
  };
  // 通用骨架：c=身體中線x, n=脖子y, h=頭中心x, L/R=[肩x,肩y,手x,手y]（畫面左手、右手）, legs=[髖y, 左腳x, 右腳x] 或 tail=[尾尖x]
  function mk(o) {
    const B = [], top = o.legs ? o.legs[0] : 0.72;
    if (o.legs) {
      B.push(['hips', null, o.c, o.legs[0], o.c, o.n + 0.15, 0.22]);
      B.push(['legF', 'hips', o.legs[1], o.legs[0] + 0.02, o.legs[1], 0.98, 0.10], ['legB', 'hips', o.legs[2], o.legs[0] + 0.02, o.legs[2], 0.98, 0.10]);
      B.push(['body', 'hips', o.c, o.legs[0] - 0.05, o.c, o.n, 0.26]);
    } else {
      B.push(['body', null, o.c, top, o.c, o.n, 0.30]);
      const tx = o.tail != null ? o.tail : o.c;
      B.push(['tail1', 'body', o.c, 0.80, (o.c + tx) / 2, 0.90, 0.16], ['tail2', 'tail1', (o.c + tx) / 2, 0.90, tx, 1.0, 0.14]);
    }
    B.push(['head', 'body', o.h != null ? o.h : o.c, o.n, o.h != null ? o.h : o.c, o.ht != null ? o.ht : 0.12, o.hr || 0.28]);
    if (o.L) B.push(['armF', 'body', o.L[0], o.L[1], o.L[2], o.L[3], o.ar || 0.12]);
    if (o.R) B.push(['armB', 'body', o.R[0], o.R[1], o.R[2], o.R[3], o.ar || 0.12]);
    if (o.hair) B.push(['hairL', 'head', o.hair[0], o.n - 0.02, o.hair[0] - 0.05, o.n + 0.3, 0.13], ['hairR', 'head', o.hair[1], o.n - 0.02, o.hair[1] + 0.05, o.n + 0.3, 0.13]);
    return { bones: B, legs: !!o.legs, hop: !!o.hop };
  }
  Object.assign(RIG, {
    xiaozhi: mk({ c:0.50, n:0.44, L:[0.30, 0.50, 0.13, 0.68], R:[0.70, 0.50, 0.86, 0.68], legs:[0.86, 0.42, 0.58] }),
    egui: mk({ c:0.55, n:0.40, L:[0.42, 0.50, 0.40, 0.72], R:[0.68, 0.50, 0.84, 0.64], tail:0.40 }),
    xiaogui: mk({ c:0.45, n:0.46, h:0.50, R:[0.62, 0.55, 0.92, 0.55], L:[0.40, 0.56, 0.36, 0.64], tail:0.30 }),
    laojiang: mk({ c:0.47, n:0.50, h:0.47, L:[0.52, 0.54, 0.10, 0.56], R:[0.66, 0.55, 0.62, 0.62], legs:[0.83, 0.42, 0.55], hop:true }),
    zombie: mk({ c:0.45, n:0.52, L:[0.50, 0.55, 0.06, 0.58], R:[0.66, 0.56, 0.62, 0.62], legs:[0.86, 0.38, 0.50], hop:true }),
    shuigui: mk({ c:0.50, n:0.45, L:[0.44, 0.56, 0.40, 0.66], R:[0.62, 0.54, 0.95, 0.50], tail:0.45, hair:[0.18, 0.84] }),
    mengpo: mk({ c:0.47, n:0.43, L:[0.32, 0.50, 0.10, 0.44], R:[0.66, 0.50, 0.62, 0.66], ar:0.14 }),
    youhun: mk({ c:0.45, n:0.46, L:[0.26, 0.56, 0.05, 0.56], R:[0.64, 0.56, 0.86, 0.60], tail:0.45, hr:0.32 }),
    baiwu: mk({ c:0.52, n:0.52, h:0.55, ht:0.10, hr:0.34, L:[0.36, 0.60, 0.24, 0.66], R:[0.68, 0.60, 0.78, 0.66] }),
    heiwu: mk({ c:0.50, n:0.56, ht:0.10, hr:0.36, L:[0.33, 0.64, 0.16, 0.70], R:[0.67, 0.64, 0.84, 0.70] }),
    niutou: mk({ c:0.56, n:0.48, h:0.60, L:[0.36, 0.55, 0.22, 0.60], R:[0.76, 0.56, 0.86, 0.66], ar:0.14 }),
    mamian: mk({ c:0.46, n:0.46, h:0.44, L:[0.26, 0.60, 0.18, 0.66], R:[0.70, 0.55, 0.85, 0.60], ar:0.14 }),
    huang: mk({ c:0.45, n:0.46, L:[0.30, 0.50, 0.08, 0.50], R:[0.64, 0.55, 0.72, 0.66], tail:0.42 }),
    zhiren: mk({ c:0.50, n:0.47, L:[0.30, 0.60, 0.12, 0.72], R:[0.70, 0.60, 0.88, 0.72], legs:[0.88, 0.42, 0.58] }),
    tianhua: mk({ c:0.50, n:0.40, h:0.40, L:[0.35, 0.50, 0.20, 0.62], R:[0.64, 0.42, 0.74, 0.26], hair:[0.18, 0.62] }),
    npc_ken: mk({ c:0.42, n:0.40, h:0.42, ht:0.08, L:[0.22, 0.48, 0.12, 0.50], R:[0.62, 0.48, 0.50, 0.50], legs:[0.66, 0.30, 0.55] }),
    npc_boss: mk({ c:0.56, n:0.45, h:0.58, L:[0.36, 0.50, 0.15, 0.38], R:[0.78, 0.50, 0.86, 0.72], legs:[0.66, 0.48, 0.66] }),
    npc_guard: mk({ c:0.50, n:0.45, L:[0.30, 0.55, 0.08, 0.65], R:[0.70, 0.55, 0.80, 0.62], legs:[0.70, 0.42, 0.60] }),
    npc_auntie: mk({ c:0.55, n:0.42, L:[0.32, 0.48, 0.20, 0.56], R:[0.75, 0.48, 0.82, 0.60], legs:[0.72, 0.45, 0.62] }),
  });
  const GX = 14, GY = 20; // 網格密度
  const cache = {};
  function segDist(px, py, ax, ay, bx, by) {
    const dx = bx - ax, dy = by - ay, l = dx * dx + dy * dy || 1e-6;
    const t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / l));
    return Math.hypot(px - ax - t * dx, py - ay - t * dy);
  }
  function build(id, img) {
    const R = RIG[id], ar = img.naturalHeight / img.naturalWidth, B = R.bones;
    const idx = {}; B.forEach((b, i) => idx[b[0]] = i);
    const verts = [];
    for (let j = 0; j <= GY; j++) for (let i = 0; i <= GX; i++) {
      const u = i / GX, v = j / GY; const w = new Float32Array(B.length);
      let sum = 0;
      B.forEach((b, k) => {
        // 縱橫比校正：用真實距離算
        const d = segDist(u, v * ar, b[2], b[3] * ar, b[4], b[5] * ar) / b[6];
        let ww = Math.exp(-d * d * 2.2);
        if (b[1] === null) ww = Math.max(ww, 0.05); // 根骨頭兜底
        w[k] = ww; sum += ww;
      });
      // 子骨頭權重讓它「搶」：骨頭鏈上越末端的骨頭影響越集中
      for (let k = 0; k < w.length; k++) w[k] /= sum;
      verts.push({ u, v, w });
    }
    // 全透明嘅格（角色圖四周嘅空白）唔使畫：每格先睇原圖有冇實色，冇就跳過（畫面一模一樣，少咗三四成三角形）
    let live = null;
    try {
      const iw = img.naturalWidth, ih = img.naturalHeight, c = document.createElement('canvas'); c.width = iw; c.height = ih;
      const g = c.getContext('2d', { willReadFrequently:true }); g.drawImage(img, 0, 0); const d = g.getImageData(0, 0, iw, ih).data;
      live = new Uint8Array(GX * GY);
      for (let j = 0; j < GY; j++) for (let i = 0; i < GX; i++) {
        const x0 = Math.max(0, Math.floor(i / GX * iw) - 2), x1 = Math.min(iw, Math.ceil((i + 1) / GX * iw) + 2), y0 = Math.max(0, Math.floor(j / GY * ih) - 2), y1 = Math.min(ih, Math.ceil((j + 1) / GY * ih) + 2);
        let hit = 0; for (let y = y0; y < y1 && !hit; y++) for (let x = x0; x < x1; x++) if (d[(y * iw + x) * 4 + 3] > 4) { hit = 1; break; }
        live[j * GX + i] = hit;
      }
    } catch (e) { live = null; }
    return cache[id] = { R, verts, idx, ar, live };
  }
  // 骨頭轉換：每根骨頭繞自己的支點轉，子骨頭疊加父骨頭
  function solve(R, pose) {
    const T = {};
    for (const b of R.bones) {
      const [n, par, px, py] = b, a = (pose[n] || 0);
      const P = par ? T[par] : { a: 0, tx: 0, ty: 0 };
      // 先把支點用父骨頭轉一次
      const ppx = Math.cos(P.a) * px - Math.sin(P.a) * py + P.tx, ppy = Math.sin(P.a) * px + Math.cos(P.a) * py + P.ty;
      const A = P.a + a;
      // 本骨頭：x' = R(A)(x - p) + p'
      T[n] = { a: A, tx: ppx - (Math.cos(A) * px - Math.sin(A) * py), ty: ppy - (Math.sin(A) * px + Math.cos(A) * py) };
    }
    return T;
  }
  // 原圖本來面向哪邊：大部分面朝左，這幾個面朝右
  const NATIVE_R = { egui:1, xiaogui:1, shuigui:1, toyol:1, mamian:1 };
  const KEEP = { y:1, sx:1, sy:1 };
  // faceRight：要面向畫面右邊。動作裡「往前」一律朝 faceRight 的方向
  function draw(ctx, id, x, y, h, pose, faceRight) {
    const nr = !!NATIVE_R[id], flip = faceRight !== nr;
    if (!nr) { const m = {}; for (const k in pose) m[k] = (typeof pose[k] === 'number' && !KEEP[k]) ? -pose[k] : pose[k]; pose = m; }
    return drawRaw(ctx, id, x, y, h, pose, flip);
  }
  // 半透明時：網格三角形互相疊會露出格線，先畫到暫存畫布（不透明）再整張半透明貼上去
  const MBUF = typeof document !== 'undefined' ? document.createElement('canvas') : null;
  // ---------- GPU 畫網格（手機發燙）：以前每個三角形都要 clip＋drawImage 一次（一個角色 ~500 次），而家一個角色一次過交俾 WebGL 畫，
  // 再成塊貼返落 2D 畫布。畫出嚟同原本一樣（仲冇咗三角形之間嘅細縫），半透明都唔使暫存畫布。WebGL 唔得就自動用返舊方法。
  const MGL = (() => {
    if (typeof document === 'undefined') return null;
    let cv = null, gl = null, isGL2 = false, prog = null, buf = null, aP = -1, aU = -1, dead = false; const texs = new Map();
    function init() {
      if (gl || dead) return !!gl;
      try {
        cv = document.createElement('canvas'); cv.width = cv.height = 256;
        const opt = { alpha:true, premultipliedAlpha:true, antialias:false, depth:false, stencil:false, preserveDrawingBuffer:false };
        gl = cv.getContext('webgl2', opt); isGL2 = !!gl; if (!gl) gl = cv.getContext('webgl', opt); if (!gl) { dead = true; return false; }
        const sh = (type, src) => { const o = gl.createShader(type); gl.shaderSource(o, src); gl.compileShader(o); if (!gl.getShaderParameter(o, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(o)); return o; };
        prog = gl.createProgram();
        gl.attachShader(prog, sh(gl.VERTEX_SHADER, 'attribute vec2 p;attribute vec2 u;varying vec2 v;void main(){v=u;gl_Position=vec4(p,0.0,1.0);}'));
        gl.attachShader(prog, sh(gl.FRAGMENT_SHADER, 'precision mediump float;varying vec2 v;uniform sampler2D t;void main(){gl_FragColor=texture2D(t,v);}'));
        gl.linkProgram(prog); if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) throw new Error('link');
        gl.useProgram(prog); aP = gl.getAttribLocation(prog, 'p'); aU = gl.getAttribLocation(prog, 'u'); buf = gl.createBuffer();
        gl.enable(gl.BLEND); gl.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA); gl.clearColor(0, 0, 0, 0);
        cv.addEventListener('webglcontextlost', (e) => { e.preventDefault(); gl = null; dead = true; texs.clear(); });
        return true;
      } catch (e) { gl = null; dead = true; return false; }
    }
    function tex(img) {
      let t = texs.get(img); if (t) return t;
      t = gl.createTexture(); gl.bindTexture(gl.TEXTURE_2D, t); gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true); gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE); gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE); gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR); // 唔用 mipmap：同 2D 畫布一樣利（mipmap 會矇少少）
      texs.set(img, t); return t;
    }
    let arr = new Float32Array(0);
    // dev：每個頂點喺目標畫布嘅裝置像素座標 [x0,y0,x1,y1,…]；uv：原圖 0..1；tris：三角形頂點索引
    function draw(ctx, img, dev, uv, tris, nTri) {
      if (!init()) return false;
      const cw = ctx.canvas.width, ch = ctx.canvas.height; let bx0 = 1e9, by0 = 1e9, bx1 = -1e9, by1 = -1e9;
      for (let i = 0; i < nTri * 3; i++) { const k = tris[i] * 2, X = dev[k], Y = dev[k + 1]; if (X < bx0) bx0 = X; if (X > bx1) bx1 = X; if (Y < by0) by0 = Y; if (Y > by1) by1 = Y; }
      bx0 = Math.max(0, Math.floor(bx0) - 1); by0 = Math.max(0, Math.floor(by0) - 1); bx1 = Math.min(cw, Math.ceil(bx1) + 1); by1 = Math.min(ch, Math.ceil(by1) + 1);
      const bw = bx1 - bx0, bh = by1 - by0; if (bw <= 0 || bh <= 0) return true; // 喺畫面外：唔使畫
      if (bw > 4096 || bh > 4096) return false;
      try {
        if (cv.width < bw || cv.height < bh) { cv.width = Math.max(cv.width, Math.ceil(bw / 64) * 64); cv.height = Math.max(cv.height, Math.ceil(bh / 64) * 64); }
        const need = nTri * 3 * 4; if (arr.length < need) arr = new Float32Array(need);
        for (let i = 0; i < nTri * 3; i++) { const k = tris[i] * 2, o = i * 4; arr[o] = (dev[k] - bx0) / bw * 2 - 1; arr[o + 1] = 1 - (dev[k + 1] - by0) / bh * 2; arr[o + 2] = uv[k]; arr[o + 3] = uv[k + 1]; }
        gl.viewport(0, cv.height - bh, bw, bh); gl.disable(gl.SCISSOR_TEST); gl.clear(gl.COLOR_BUFFER_BIT); // 只用左上角一格：viewport 底 = 畫布高 − bh
        gl.useProgram(prog); gl.activeTexture(gl.TEXTURE0); gl.bindTexture(gl.TEXTURE_2D, tex(img));
        gl.bindBuffer(gl.ARRAY_BUFFER, buf); gl.bufferData(gl.ARRAY_BUFFER, arr.subarray(0, need), gl.STREAM_DRAW);
        gl.enableVertexAttribArray(aP); gl.vertexAttribPointer(aP, 2, gl.FLOAT, false, 16, 0); gl.enableVertexAttribArray(aU); gl.vertexAttribPointer(aU, 2, gl.FLOAT, false, 16, 8);
        gl.drawArrays(gl.TRIANGLES, 0, nTri * 3);
        ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.drawImage(cv, 0, 0, bw, bh, bx0, by0, bw, bh); ctx.restore();
        return true;
      } catch (e) { dead = true; gl = null; return false; }
    }
    return { draw, off:() => { dead = true; gl = null; }, ok:() => init() };
  })();
  function drawRaw(ctx, id, x, y, h, pose, flip) {
    const img = SPR[id]; if (!img || !RIG[id]) return false;
    if (MGL && !NOGL && ctx.canvas && ctx.canvas.width && drawGL(ctx, img, id, x, y, h, pose, flip)) return true;
    if (MBUF && ctx.globalAlpha < 0.995 && ctx.canvas && ctx.canvas !== MBUF && ctx.canvas.width) {
      const cv = ctx.canvas; if (MBUF.width !== cv.width || MBUF.height !== cv.height) { MBUF.width = cv.width; MBUF.height = cv.height; }
      // 只清／貼角色身處嗰一細格（以前每隻半透明鬼都清成張全屏畫布再貼返，手機好食力）
      const M = ctx.getTransform(), ar0 = img.naturalHeight / img.naturalWidth, hw = Math.max(h / ar0, h) * 0.85 + Math.abs(pose.x || 0) * h / ar0;
      const ux0 = x - hw, ux1 = x + hw, uy0 = y - h * 1.45 + Math.min(0, (pose.y || 0) * h), uy1 = y + h * 0.35 + Math.max(0, (pose.y || 0) * h);
      let bx0 = 1e9, by0 = 1e9, bx1 = -1e9, by1 = -1e9;
      for (const [ux, uy] of [[ux0, uy0], [ux1, uy0], [ux0, uy1], [ux1, uy1]]) { const X = M.a * ux + M.c * uy + M.e, Y = M.b * ux + M.d * uy + M.f; bx0 = Math.min(bx0, X); bx1 = Math.max(bx1, X); by0 = Math.min(by0, Y); by1 = Math.max(by1, Y); }
      bx0 = Math.max(0, Math.floor(bx0)); by0 = Math.max(0, Math.floor(by0)); bx1 = Math.min(cv.width, Math.ceil(bx1)); by1 = Math.min(cv.height, Math.ceil(by1));
      if (bx1 <= bx0 || by1 <= by0) return true;
      const b = MBUF.getContext('2d'); b.setTransform(1, 0, 0, 1, 0, 0); b.clearRect(bx0, by0, bx1 - bx0, by1 - by0); b.globalAlpha = 1; b.globalCompositeOperation = 'source-over';
      b.save(); b.beginPath(); b.rect(bx0, by0, bx1 - bx0, by1 - by0); b.clip(); b.setTransform(M); drawRaw(b, id, x, y, h, pose, flip); b.restore();
      ctx.save(); ctx.setTransform(1, 0, 0, 1, 0, 0); ctx.drawImage(MBUF, bx0, by0, bx1 - bx0, by1 - by0, bx0, by0, bx1 - bx0, by1 - by0); ctx.restore(); return true;
    }
    const C = cache[id] || build(id, img), R = C.R, ar = C.ar;
    const W = h / ar, iw = img.naturalWidth, ih = img.naturalHeight;
    const T = solve(R, pose), bones = R.bones;
    // 變形後的網格（單位：原圖比例，y 用 ar 校正後再還原）
    const pts = C.verts.map(V => {
      let X = 0, Y = 0; const vy = V.v * ar;
      for (let k = 0; k < bones.length; k++) { const wk = V.w[k]; if (wk < 0.002) continue; const t = T[bones[k][0]], c = Math.cos(t.a), s = Math.sin(t.a); X += wk * (c * V.u - s * (vy) + t.tx); Y += wk * (s * V.u + c * vy + t.ty); }
      return [X, Y / ar];
    });
    ctx.save(); ctx.translate(x + (pose.x || 0) * W, y + (pose.y || 0) * h); if (flip) ctx.scale(-1, 1);
    if (pose.rot) { ctx.translate(0, -h * 0.35); ctx.rotate(pose.rot); ctx.translate(0, h * 0.35); }
    ctx.scale(pose.sx || 1, pose.sy || 1); ctx.translate(-W / 2, -h);
    const live = C.live;
    for (let j = 0; j < GY; j++) for (let i = 0; i < GX; i++) {
      if (live && !live[j * GX + i]) continue;
      const a = j * (GX + 1) + i, b = a + 1, c = a + GX + 1, d = c + 1;
      tri(ctx, img, iw, ih, W, h, C.verts, pts, a, b, c); tri(ctx, img, iw, ih, W, h, C.verts, pts, b, d, c);
    }
    ctx.restore(); return true;
  }
  let NOGL = typeof location !== 'undefined' && /[?&]nogl\b/.test(location.search);
  function drawGL(ctx, img, id, x, y, h, pose, flip) {
    const C = cache[id] || build(id, img), R = C.R, ar = C.ar, W = h / ar, T = solve(R, pose), bones = R.bones, NV = C.verts.length;
    if (!C.uv) { // 每個 rig 只做一次：uv 同埋有實色嘅三角形清單
      C.uv = new Float32Array(NV * 2); C.verts.forEach((V, i) => { C.uv[i * 2] = V.u; C.uv[i * 2 + 1] = V.v; });
      const t = []; for (let j = 0; j < GY; j++) for (let i = 0; i < GX; i++) { if (C.live && !C.live[j * GX + i]) continue; const a = j * (GX + 1) + i, b = a + 1, c = a + GX + 1, d = c + 1; t.push(a, b, c, b, d, c); }
      C.tris = new Uint16Array(t); C.dev = new Float32Array(NV * 2);
    }
    ctx.save(); ctx.translate(x + (pose.x || 0) * W, y + (pose.y || 0) * h); if (flip) ctx.scale(-1, 1);
    if (pose.rot) { ctx.translate(0, -h * 0.35); ctx.rotate(pose.rot); ctx.translate(0, h * 0.35); }
    ctx.scale(pose.sx || 1, pose.sy || 1); ctx.translate(-W / 2, -h);
    const M = ctx.getTransform(); ctx.restore();
    const cs = bones.map(b => { const t = T[b[0]]; return [Math.cos(t.a), Math.sin(t.a), t.tx, t.ty]; }), dev = C.dev;
    for (let i = 0; i < NV; i++) {
      const V = C.verts[i], vy = V.v * ar; let X = 0, Y = 0;
      for (let k = 0; k < bones.length; k++) { const wk = V.w[k]; if (wk < 0.002) continue; const q = cs[k]; X += wk * (q[0] * V.u - q[1] * vy + q[2]); Y += wk * (q[1] * V.u + q[0] * vy + q[3]); }
      const lx = X * W, ly = Y / ar * h; dev[i * 2] = M.a * lx + M.c * ly + M.e; dev[i * 2 + 1] = M.b * lx + M.d * ly + M.f;
    }
    return MGL.draw(ctx, img, dev, C.uv, C.tris, C.tris.length / 3);
  }
  // 把原圖的一個三角形貼到變形後的三角形（稍微外擴避免縫）
  function tri(ctx, img, iw, ih, W, H, V, P, i0, i1, i2) {
    const s0 = V[i0], s1 = V[i1], s2 = V[i2];
    const x0 = P[i0][0] * W, y0 = P[i0][1] * H, x1 = P[i1][0] * W, y1 = P[i1][1] * H, x2 = P[i2][0] * W, y2 = P[i2][1] * H;
    const u0 = s0.u * iw, v0 = s0.v * ih, u1 = s1.u * iw, v1 = s1.v * ih, u2 = s2.u * iw, v2 = s2.v * ih;
    const cx = (x0 + x1 + x2) / 3, cy = (y0 + y1 + y2) / 3, e = 0.9;
    const ex = (px, py) => { const dx = px - cx, dy = py - cy, l = Math.hypot(dx, dy) || 1; return [px + dx / l * e, py + dy / l * e]; };
    const [a0, b0] = ex(x0, y0), [a1, b1] = ex(x1, y1), [a2, b2] = ex(x2, y2);
    ctx.save(); ctx.beginPath(); ctx.moveTo(a0, b0); ctx.lineTo(a1, b1); ctx.lineTo(a2, b2); ctx.closePath(); ctx.clip();
    const den = u0 * (v1 - v2) + u1 * (v2 - v0) + u2 * (v0 - v1); if (Math.abs(den) < 1e-6) { ctx.restore(); return; }
    const m11 = (x0 * (v1 - v2) + x1 * (v2 - v0) + x2 * (v0 - v1)) / den, m12 = (y0 * (v1 - v2) + y1 * (v2 - v0) + y2 * (v0 - v1)) / den;
    const m21 = (x0 * (u2 - u1) + x1 * (u0 - u2) + x2 * (u1 - u0)) / den, m22 = (y0 * (u2 - u1) + y1 * (u0 - u2) + y2 * (u1 - u0)) / den;
    const dx = (x0 * (u1 * v2 - u2 * v1) + x1 * (u2 * v0 - u0 * v2) + x2 * (u0 * v1 - u1 * v0)) / den, dy = (y0 * (u1 * v2 - u2 * v1) + y1 * (u2 * v0 - u0 * v2) + y2 * (u0 * v1 - u1 * v0)) / den;
    ctx.transform(m11, m12, m21, m22, dx, dy); ctx.drawImage(img, 0, 0); ctx.restore();
  }
  // ---------- 動作 ----------
  const S = Math.sin, ease = (t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t);
  const tail = (t, k) => ({ tail1: S(t * 2.6) * 0.12 * k, tail2: S(t * 2.6 - 1) * 0.22 * k });
  const ANIM = {
    idle: (t) => Object.assign({ body: S(t * 1.8) * 0.025, head: S(t * 1.3) * 0.05, armF: S(t * 1.8 + 0.5) * 0.05, armB: S(t * 1.8 + 1) * 0.06, tie: S(t * 5) * 0.18, cape: S(t * 2) * 0.06, hairL: S(t * 1.6) * 0.07, hairR: S(t * 1.6 + 1) * 0.07, sy: 1 + S(t * 1.8) * 0.015, sx: 1 - S(t * 1.8) * 0.008, y: -0.03 - S(t * 2.2) * 0.02, legF: 0, legB: 0 }, tail(t, 1)),
    walk: (t) => Object.assign({ body: 0.10, head: -0.04 + S(t * 7) * 0.03, armF: S(t * 7) * 0.22, armB: -S(t * 7) * 0.22, tie: -0.3 + S(t * 9) * 0.2, cape: -0.15 + S(t * 7) * 0.08, hairL: -0.12, hairR: -0.18, legF: S(t * 7) * 0.32, legB: -S(t * 7) * 0.32, y: -Math.abs(S(t * 7)) * 0.02 - 0.03 }, tail(t * 2, 1.6)),
    // 攻擊：先往後收（預備），再快速往前（出手），停一下，回來
    attack: (t) => {
      const p = (t % 1.4) / 1.4; let k;
      if (p < 0.4) k = -ease(p / 0.4); else if (p < 0.5) k = -1 + 2.4 * ((p - 0.4) / 0.1); else if (p < 0.62) k = 1.4; else k = 1.4 * (1 - ease((p - 0.62) / 0.38));
      return Object.assign({ body: 0.12 * k, head: 0.06 * k, armF: k > 0 ? -0.9 * k : -1.0 * k, axe: k > 0 ? -0.5 * k : -0.3 * k, armB: 0.25 * k, tie: -0.3 * Math.abs(k), cape: -0.2 * k, hairL: -0.15 * k, hairR: -0.2 * k, x: 0.10 * Math.max(0, k), sx: 1 + 0.05 * Math.max(0, k), sy: 1 - 0.04 * Math.max(0, k), y: -0.03, legF: 0.2 * k, legB: -0.1 * k }, tail(t, 1 + Math.abs(k)));
    },
    hurt: (t) => {
      const p = (t % 1.2) / 1.2, k = p < 0.08 ? p / 0.08 : Math.max(0, 1 - (p - 0.08) / 0.5);
      return Object.assign({ body: -0.18 * k, head: -0.25 * k + S(t * 40) * 0.04 * k, armF: 0.4 * k, armB: -0.4 * k, tie: 0.4 * k, x: -0.08 * k, sx: 1 - 0.05 * k, sy: 1 + 0.05 * k, y: -0.03 - 0.03 * k }, tail(t, 1));
    },
    scared: (t) => { // 被嚇一跳：蹲一下、彈起來、發抖
      const p = (t % 1.6) / 1.6; let jump = 0, sq = 0;
      if (p < 0.1) sq = p / 0.1; else if (p < 0.35) { jump = Math.sin((p - 0.1) / 0.25 * Math.PI); sq = -jump * 0.6; } else sq = 0;
      const sh = p > 0.35 ? S(t * 45) * 0.03 : 0;
      return Object.assign({ body: -0.1 * jump + sh, head: -0.2 * jump + sh * 2, armF: 0.6 * jump + sh, armB: -0.6 * jump - sh, legF: 0.25 * jump, legB: -0.2 * jump, hairL: -0.3 * jump, hairR: -0.3 * jump, x: sh * 0.4, y: -0.16 * jump - 0.02, sx: 1 + 0.08 * sq, sy: 1 - 0.1 * sq }, tail(t, 1.5));
    },
  };
  const base = (t) => ANIM.idle(t);
  const add = (a, b) => { const o = Object.assign({}, a); for (const k in b) o[k] = (typeof b[k] === 'number' && typeof a[k] === 'number' && !['sx', 'sy'].includes(k)) ? a[k] + b[k] : b[k]; return o; };
  // 出手手臂：預設右手（畫面右＝前方）；阿福用拿斧頭的左手
  const BIG = { afu:1, xiaozhi:1, zhiren:1, youhun:1, laojiang:1, zombie:1 };
  const swing = (id, k) => id === 'afu' ? { armF: -0.75 * Math.min(k, 1.0) - 0.15 * Math.max(0, k - 1), axe: -0.45 * Math.min(k, 1.2) } : BIG[id] ? { armB: -0.9 * k, armF: 0.3 * k } : { armB: -0.6 * k, armF: 0.18 * k };
  Object.assign(ANIM, {
    windup: (p, t, id) => { const k = ease(Math.min(1, p)); return add(base(t), Object.assign({ body: -0.14 * k, head: -0.10 * k, x: -0.05 * k, sx: 1 - 0.05 * k, sy: 1 + 0.05 * k, legF: -0.15 * k, legB: 0.12 * k, hairL: 0.1 * k, hairR: 0.1 * k }, swing(id, -0.9 * k))); },
    strike: (p, t, id) => { const k = Math.min(1, p * 1.8); const e = 1 - (1 - k) * (1 - k); return add(base(t), Object.assign({ body: 0.20 * e, head: 0.10 * e, x: 0.18 * e, sx: 1 + 0.08 * e, sy: 1 - 0.06 * e, legF: 0.14 * e, legB: -0.12 * e, hairL: -0.2 * e, hairR: -0.25 * e, tie: -0.4 * e, cape: -0.3 * e }, swing(id, -0.9 + 2.2 * e))); },
    // 挥出：打中之后手和武器繼續揮過頭、身體跟著甩出去，有慣性
    follow: (p, t, id) => { const q = Math.min(1, p), e = 1 - Math.pow(1 - q, 3); return add(base(t), Object.assign({ body: 0.20 + 0.10 * e, head: 0.10 + 0.08 * e, x: 0.18 + 0.04 * e, sx: 1 + 0.08 - 0.05 * e, sy: 1 - 0.06 + 0.04 * e, legF: 0.14 + 0.06 * e, legB: -0.12 - 0.06 * e, hairL: -0.2 - 0.15 * e, hairR: -0.25 - 0.15 * e, tie: -0.4 - 0.3 * e, cape: -0.3 - 0.2 * e }, swing(id, 1.3 + 0.75 * e))); },
    recover: (p, t, id) => { const k = 1 - ease(Math.min(1, p)); return add(base(t), Object.assign({ body: 0.3 * k, head: 0.18 * k, x: 0.22 * k, legF: 0.2 * k, legB: -0.18 * k, hairL: -0.35 * k, hairR: -0.4 * k }, swing(id, 2.05 * k))); },
    hurtP: (p, t) => { const k = p < 0.15 ? p / 0.15 : Math.max(0, 1 - (p - 0.15) / 0.85); return add(base(t), { body: -0.22 * k, head: -0.3 * k + Math.sin(t * 50) * 0.05 * k, armF: 0.5 * k, armB: -0.5 * k, x: -0.10 * k, sx: 1 - 0.07 * k, sy: 1 + 0.06 * k, hairL: 0.3 * k, hairR: 0.3 * k }); },
    cast: (p, t) => { const k = ease(Math.min(1, p * 1.4)), sh = Math.sin(t * 30) * 0.03 * k; return add(base(t), { body: -0.08 * k + sh, head: -0.18 * k, armF: 0.85 * k, armB: -0.85 * k, y: -0.06 * k, sx: 1 + 0.04 * k, sy: 1 + 0.06 * k, hairL: -0.4 * k, hairR: 0.4 * k, legF: 0.15 * k, legB: -0.15 * k }); },
    die: (p, t) => { const k = ease(Math.min(1, p)); return add(base(0), { body: -0.2 * k, head: -0.4 * k, armF: 0.8 * k, armB: -0.8 * k, rot: -1.35 * k, x: -0.25 * k, y: 0.02 * k }); },
    air: (p, t) => { const k = Math.sin(Math.min(1, p) * Math.PI); return add(base(t), { rot: -Math.min(1, p) * 6.283, y: -0.55 * k, armF: 0.9, armB: -0.9, head: -0.3, legF: 0.4, legB: -0.4 }); },
    down: (p, t) => add(base(t * 0.3), { rot: -1.5, x: -0.2, y: 0.03, head: -0.2, armF: 0.4, armB: -0.3 }),
  });
  // 拆掉手的身體：沿用原角色的骨架（去掉手臂骨），畫在原點（腳底中央），原圖方向
  function drawBody(ctx, rigId, imgKey, h, pose) {
    if (!RIG[imgKey] && RIG[rigId]) RIG[imgKey] = { bones: RIG[rigId].bones.filter(b => !['armF', 'axe'].includes(b[0])) };
    return drawRaw(ctx, imgKey, 0, 0, h, pose, false);
  }
  return { drawBody, draw, ANIM, RIG, NATIVE_R, mk, gl:(on) => { NOGL = !on; }, has: (id) => !!RIG[id] && typeof sprOk === 'function' && sprOk(id) };
})();
