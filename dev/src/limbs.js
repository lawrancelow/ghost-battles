// ===================== 拆手揮武器：從原圖拆出的手 + 可更換的武器 =====================
// 身體用 MeshAnim 做呼吸、頭、尾巴；拿武器的手是原圖拆出的一塊，繞手腕轉；武器另外一張，握在手上（可換）。
// 劈砍五段：① 預備 → ② 劈下 → ③ 命中 → ④ 揮出 → ⑤ 收招
const Limbs = (() => {
  const D = Math.PI / 180;
  const ez = { o:(t) => 1 - (1 - t) * (1 - t), i:(t) => t * t, io:(t) => t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t), o3:(t) => 1 - Math.pow(1 - t, 3) };
  const lerp = (a, b, k) => { const o = {}; for (const n in a) o[n] = a[n] + (b[n] - a[n]) * k; return o; };
  // 沒有特別調過的角色用這組（th 是相對原圖握法的轉角，正 = 往後舉）
  const DEFK = { idle:{ th:0, lean:0, dx:0, dy:0, sx:1, sy:1 }, antic:{ th:60, lean:8, dx:-0.04, dy:-0.02, sx:0.96, sy:1.05 }, contact:{ th:-70, lean:-10, dx:0.11, dy:0, sx:1.06, sy:0.96 }, follow:{ th:-120, lean:-18, dx:0.14, dy:0.02, sx:1.04, sy:0.95 } };
  const C = () => (typeof LIMBS_DATA !== 'undefined' ? LIMBS_DATA.chars : {});
  const ok = (k) => typeof sprOk === 'function' && sprOk(k);
  function has(type) { const c = C()[type]; return !!(c && ok(type + '__body') && ok(type + '__arm')); }
  // 動作名稱 + 進度 → 關鍵姿勢
  // 每格補齊選用欄位：hx/hy＝手額外位移（面朝左的原圖方向，佔寬/高；hx 正＝往後、hy 正＝往上）、bend＝軟武器（鏈）彎曲角度
  const KN = {};
  function keysOf(type) {
    const src = (C()[type] && C()[type].K) || DEFK;
    if (KN[type] && KN[type].src === src) return KN[type].k;
    const o = {}; for (const n in src) o[n] = Object.assign({ th:0, lean:0, dx:0, dy:0, sx:1, sy:1, hx:0, hy:0, bend:0 }, src[n]);
    KN[type] = { src, k:o }; return o;
  }
  function stateOf(type, pose, p) {
    const K = keysOf(type); p = Math.max(0, Math.min(1, p || 0));
    switch (pose) {
      case 'windup': return lerp(K.idle, K.antic, ez.o(p));
      // 戰鬥的「出手」0.12 秒：前 42% 劈到命中，後面是揮出
      case 'strike': return p < 0.42 ? lerp(K.antic, K.contact, ez.i(p / 0.42)) : lerp(K.contact, K.follow, ez.o3((p - 0.42) / 0.58));
      case 'follow': return lerp(K.contact, K.follow, ez.o3(p));
      case 'recover': return lerp(K.follow, K.idle, ez.io(p));
      // 村裡砍樹：一下 = 一個循環，結尾那一刻砍中
      case 'chop': case 'hammer': {
        const q = pose === 'hammer' ? (p * 2) % 1 : p;
        if (q < 0.62) return lerp(K.idle, K.antic, ez.o(q / 0.62));
        if (q < 0.8) return lerp(K.antic, K.contact, ez.i((q - 0.62) / 0.18));
        return lerp(K.contact, K.follow, ez.o3((q - 0.8) / 0.2));
      }
    }
    return K.idle;
  }
  function weaponOf(type, wid) { const W = LIMBS_DATA.weapons, id = wid || C()[type].weapon; return id && W[id] && ok(W[id].img) ? W[id] : null; }
  // 畫武器：原點在握把；軟武器（weapons.json 的 flex>0，例如鐵鏈）沿軸切成幾段，每段多彎 bend/flex 度（甩出去的彎）
  function drawWeapon(ctx, c, wp, H, bend) {
    const im = SPR[wp.img], ww = wp.w * H, wh = wp.h * H;
    const tx = (wp.tip[0] - wp.grip[0]) * ww, ty = (wp.tip[1] - wp.grip[1]) * wh, n = wp.flex || 0;
    if (!n || !bend) { ctx.rotate((c.hold - wp.ang) * D); ctx.drawImage(im, -wp.grip[0] * ww, -wp.grip[1] * wh, ww, wh); ctx.translate(tx, ty); return ctx.getTransform(); }
    const len = Math.hypot(tx, ty), seg = len / n, big = Math.max(ww, wh) * 2, ov = seg * 0.15;
    ctx.rotate(c.hold * D); // 現在武器沿 -y
    const img = () => { ctx.save(); ctx.rotate(-wp.ang * D); ctx.drawImage(im, -wp.grip[0] * ww, -wp.grip[1] * wh, ww, wh); ctx.restore(); };
    for (let i = 0; i < n; i++) { // 第 i 段：軸上 [i*seg, (i+1)*seg]；第 0 段連握把以下那截
      if (i > 0) { ctx.translate(0, -seg * i); ctx.rotate(bend / n * D); ctx.translate(0, seg * i); }
      const y0 = i === 0 ? big : -seg * i + ov, y1 = i === n - 1 ? -big : -seg * (i + 1) - ov;
      ctx.save(); ctx.beginPath(); ctx.rect(-big, y1, big * 2, y0 - y1); ctx.clip(); img(); ctx.restore();
    }
    ctx.translate(0, -len); return ctx.getTransform();
  }
  // 原圖本來面向哪邊：大部分面朝左；這幾個面朝右（跟 meshanim.js 的 NATIVE_R 一致）
  const NATIVE_R = (typeof MeshAnim !== 'undefined' && MeshAnim.NATIVE_R) || { egui:1, xiaogui:1, shuigui:1, toyol:1 };
  // 畫：faceRight = 面向畫面右邊。K 的意思一律以「面朝左」為準（th 正 = 往背後、dx 正 = 往前、lean 正 = 後仰）；
  // 原圖面朝右的角色，先把原圖左右鏡像成「面朝左」再套同一套動作（pivot/tip 仍寫原圖座標）
  function draw(ctx, type, x, y, H, o, faceRight, meshPose) {
    const c = C()[type], s = stateOf(type, o.pose, o.pt), body = SPR[type + '__body'], arm = SPR[type + '__arm'];
    const W = H * body.naturalWidth / body.naturalHeight, wp = weaponOf(type, o.weapon), nr = !!(NATIVE_R[type] || c.nativeR); // nativeR：limbs.json 標記原圖面朝右（例如馬面，馬嘴朝右）
    const pvx = nr ? 1 - c.pivot[0] : c.pivot[0];
    // 殭屍類走路／待機用跳的（原本 MeshAnim 的 hop）
    const R = typeof MeshAnim !== 'undefined' && MeshAnim.RIG[type];
    const atk = o.pose === 'windup' || o.pose === 'strike' || o.pose === 'follow' || o.pose === 'recover';
    if (R && R.hop && !atk && (o.walk || o.enemy || o.pose === 'move' || o.pose === 'walk' || o.pose === 'run')) y -= Math.abs(Math.sin(o.t * 5)) * 0.09 * H;
    // 空手的角色走路時，拆出來的手輕輕擺（拿武器的阿福不變）
    const walking = o.walk || o.pose === 'move' || o.pose === 'walk' || o.pose === 'run';
    const thAdd = (!c.weapon && walking) ? Math.sin(o.t * 7) * (c.swing != null ? c.swing : 7) : 0;
    ctx.save(); ctx.translate(x, y); if (faceRight) ctx.scale(-1, 1);
    ctx.translate(-s.dx * W, s.dy * H); ctx.translate(0, -H * 0.28); ctx.rotate(s.lean * D); ctx.translate(0, H * 0.28); ctx.scale(s.sx, s.sy);
    const mp = Object.assign({}, meshPose); mp.armF = 0; mp.axe = 0; mp.body = 0; mp.x = 0;
    if (c.still) for (const b of c.still) mp[b] = 0; // 拆出來的是頭之類：身體那邊對應的骨頭不動，接縫才對得上
    const px = (pvx - 0.5) * W, py = -H + c.pivot[1] * H + (mp.y || 0) * H;
    const lift = Math.max(0, Math.min(1, (s.th - 25) / 40)), lx = px + (lift * c.lift[0] + s.hx) * W, ly = py - (lift * c.lift[1] + s.hy) * H;
    const hk = c.hk != null ? c.hk : 1, ath = (s.th + thAdd) * hk, wth = (s.th + thAdd) - ath; // 手轉 hk 的份，其餘由武器繞握把轉（手腕）
    let tipM = null;
    // 武器和手分開畫：武器可以在身體後面、手在前面（例如扛在肩上、桿子穿過頭後面）
    const wpn = () => {
      if (!wp) return;
      ctx.save(); ctx.translate(lx, ly); ctx.rotate(ath * D); if (nr) ctx.scale(-1, 1);
      ctx.translate((c.grip[0] - c.pivot[0]) * W, (c.grip[1] - c.pivot[1]) * H); ctx.rotate(wth * D * (nr ? -1 : 1));
      tipM = drawWeapon(ctx, c, wp, H, s.bend); ctx.restore();
    };
    const drawArm = () => {
      ctx.save(); ctx.translate(lx, ly); ctx.rotate(ath * D); if (nr) ctx.scale(-1, 1);
      if (!wp && c.tip) { // 空手：拳頭／爪子的位置（給殘影、命中特效用）
        ctx.save(); ctx.translate((c.tip[0] - c.pivot[0]) * W, (c.tip[1] - c.pivot[1]) * H); tipM = ctx.getTransform(); ctx.restore();
      }
      ctx.drawImage(arm, -c.pivot[0] * W, -c.pivot[1] * H, W, H);
      ctx.restore();
    };
    const behind = s.th > c.behind || (c.behindLo != null && s.th < c.behindLo);
    const wb = c.wbehind, wBehind = wb ? (s.th > wb[0] && s.th < wb[1]) : behind;
    if (wBehind) wpn();
    if (behind) drawArm();
    if (nr) { ctx.save(); ctx.scale(-1, 1); }
    MeshAnim.drawBody(ctx, type, type + '__body', H, mp);
    if (nr) ctx.restore();
    if (!wBehind) wpn();
    if (!behind) drawArm();
    ctx.restore();
    return tipM ? { x:tipM.e, y:tipM.f } : null;
  }
  return { has, draw, stateOf, weaponOf };
})();
