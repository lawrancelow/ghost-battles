// ===================== 陰間日常：隨機搞笑短劇（skits.js）=====================
// 1) Theater：共用小劇場。角色一律用現有原圖動畫（PlazaLife.drawAgent → DAILY 平日動作 / ART.drawChar 招式姿勢），
//    特效（飄字、冥紙、燈光、咪高峰）全部程式畫。大字對白泡泡跟住講嘢嗰隻鬼。棟篤笑（standup.js）都用呢個劇場。
// 2) SKITS：陰間日常短劇（下面資料）。form 唔寫 = 小劇場；chat / news / radio / sys / mail = 借用 Story 現成嘅對話形式。
// 3) Skits：觸發。喺村子玩一陣（有操作先計時）就嚟一段；打完仗、完成任務會早啲嚟。唔會打斷戰鬥、彈窗、劇情；全部可以跳過；
//    未睇晒所有已解鎖嘅段落之前唔會重複。存檔：S.skit = { seen:{}, cyc:{}, act, next, n }（舊存檔自動補）。
const Theater = (() => {
  const PI = Math.PI;
  const ONE = { wave:1.4, bow:1.2, startle:1.3, eek:0.8, laugh:1.7, boo:0.95, reach:0.6, stretch:2, spin:2.2, shake:1.8, look:2, dizzy:2.2, backrub:2.6, bump:0.8 };
  let el = null, cv = null, ctx = null, W = 390, H = 700, dpr = 1, raf = 0, last = 0, T = 0;
  let sc = null; // 現在這一場
  // ---------- 外觀（自己帶 CSS，不改 style.css）----------
  function css() {
    if (document.getElementById('th-css')) return;
    const s = document.createElement('style'); s.id = 'th-css';
    s.textContent = `
#gtheater{position:absolute;inset:0;z-index:55;display:none;background:#0c0a12;overflow:hidden;touch-action:manipulation}
#gtheater.on{display:block;animation:thIn .35s ease-out}
@keyframes thIn{from{opacity:0}to{opacity:1}}
#gtheater canvas{position:absolute;inset:0;width:100%;height:100%}
#gtheater .th-top{position:absolute;left:0;right:0;top:0;display:flex;align-items:center;gap:8px;padding:calc(env(safe-area-inset-top) + 10px) 12px 10px;background:linear-gradient(rgba(12,10,18,.92),rgba(12,10,18,0));z-index:3}
#gtheater .th-tag{flex:none;font-family:var(--serif);font-size:13px;font-weight:900;color:#fbe6d6;background:var(--cinnabar);padding:3px 7px;border-radius:2px;letter-spacing:1px}
#gtheater .th-title{flex:1;font-family:var(--serif);font-size:19px;font-weight:900;color:#f3d68a;letter-spacing:1px;text-shadow:0 2px 0 #000;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
#gtheater .th-skip{flex:none;background:rgba(0,0,0,.5);box-shadow:inset 0 0 0 1px rgba(255,255,255,.35);border-radius:3px;padding:7px 13px;font-size:14px;color:#eee}
#gtheater .th-bub{position:absolute;z-index:4;max-width:min(88vw,380px);padding:10px 14px 12px;background:#f6ecd2;color:#2a1a10;border-radius:14px;box-shadow:0 0 0 2px #3a2a1a,0 6px 16px rgba(0,0,0,.55);font-size:19px;line-height:1.5;font-weight:700;display:none}
#gtheater .th-bub.on{display:block;animation:thPop .18s ease-out}
@keyframes thPop{from{transform:scale(.9);opacity:.3}to{transform:none;opacity:1}}
#gtheater .th-bub::after{content:"";position:absolute;left:var(--tx,50%);bottom:-11px;margin-left:-9px;border:9px solid transparent;border-top:12px solid #f6ecd2;border-bottom:0;filter:drop-shadow(0 2px 0 #3a2a1a)}
#gtheater .th-bub.up::after{bottom:auto;top:-11px;border-top:0;border-bottom:12px solid #f6ecd2;filter:drop-shadow(0 -2px 0 #3a2a1a)}
#gtheater .th-bub.sys{background:#0e2a2a;color:#c8fff0;box-shadow:0 0 0 2px #5fbfaa,0 0 18px rgba(95,191,170,.45)}
#gtheater .th-bub.sys::after{display:none}
#gtheater .th-bub.aud{font-size:17px;background:#e6dcff;box-shadow:0 0 0 2px #3a2a5a,0 6px 16px rgba(0,0,0,.55)}
#gtheater .th-bub.aud::after{border-top-color:#e6dcff}
#gtheater .th-nm{display:block;font-family:var(--serif);font-size:14px;font-weight:900;color:var(--cinnabar);margin-bottom:2px;letter-spacing:1px}
#gtheater .th-bub.sys .th-nm{color:#7fffd4}
#gtheater .th-cap{position:absolute;left:16px;right:16px;top:calc(env(safe-area-inset-top) + 58px);z-index:4;text-align:center;font-family:var(--serif);font-size:18px;line-height:1.55;color:#efe6ff;background:rgba(12,8,20,.78);border-radius:6px;padding:10px 14px;box-shadow:inset 0 0 0 1px rgba(200,180,255,.25);display:none}
#gtheater .th-cap.on{display:block}
#gtheater .th-choice{position:absolute;left:16px;right:16px;bottom:calc(env(safe-area-inset-bottom) + 18px);z-index:5;display:none;flex-direction:column;gap:10px}
#gtheater .th-choice.on{display:flex}
#gtheater .th-choice .btn{font-size:17px;padding:13px}
#gtheater .th-tap{position:absolute;left:0;right:0;bottom:calc(env(safe-area-inset-bottom) + 10px);z-index:3;text-align:center;font-size:13px;color:rgba(255,255,255,.5);pointer-events:none}
#su-pick{position:absolute;inset:0;z-index:56;display:none;flex-direction:column;background:rgba(10,8,14,.94)}
#su-pick.on{display:flex}
#su-pick .sp-h{display:flex;align-items:center;gap:10px;padding:calc(env(safe-area-inset-top) + 12px) 14px 10px;border-bottom:1px solid #3a2f2a}
#su-pick .sp-h b{flex:1;font-family:var(--serif);font-size:22px;color:#f3d68a;letter-spacing:2px}
#su-pick .sp-sub{padding:8px 16px 0;font-size:14.5px;color:#cbbfd8;line-height:1.5}
#su-pick .sp-list{flex:1;overflow:auto;padding:8px 12px calc(env(safe-area-inset-bottom) + 16px)}
#su-pick .sp-it{display:flex;align-items:center;gap:12px;width:100%;text-align:left;margin:8px 0;padding:10px 12px;border-radius:8px;background:#221d28;box-shadow:inset 0 0 0 1px #4a3a5a}
#su-pick .sp-it canvas{flex:none;width:56px;height:56px;border-radius:50%;background:rgba(255,240,210,.12)}
#su-pick .sp-it span{flex:1;min-width:0}
#su-pick .sp-it b{display:block;font-family:var(--serif);font-size:18px;color:#f6e2b0}
#su-pick .sp-it small{display:block;font-size:13.5px;color:#a99fb4;margin-top:2px}
#su-pick .sp-it em{flex:none;font-style:normal;font-size:12px;font-weight:900;color:#fff3e0;background:var(--cinnabar);padding:2px 7px;border-radius:2px}
#su-pick .sp-it.off{opacity:.45}
#gs-panel .su-wide{margin:10px 0 2px;padding:10px;font-size:16px}
`;
    document.head.appendChild(s);
  }
  function ensure() {
    css();
    el = document.getElementById('gtheater');
    if (!el) { el = document.createElement('section'); el.id = 'gtheater'; (document.getElementById('app') || document.body).appendChild(el); }
    el.innerHTML = `<canvas></canvas><div class="th-top"><span class="th-tag"></span><b class="th-title"></b><button class="th-skip">跳過 ▸▸</button></div>
      <div class="th-cap"></div><div class="th-bub"><b class="th-nm"></b><span class="th-tx"></span></div><div class="th-choice"></div><div class="th-tap"></div>`;
    cv = el.querySelector('canvas'); ctx = cv.getContext('2d');
    el.onclick = (e) => { if (e.target.closest('.th-skip')) { e.stopPropagation(); close(true); return; } if (e.target.closest('.th-choice')) return; tap(); };
  }
  function resize() {
    const r = el.getBoundingClientRect(); dpr = Math.min(2, window.devicePixelRatio || 1);
    W = r.width || 390; H = r.height || 700; cv.width = W * dpr; cv.height = H * dpr;
  }
  // ---------- 角色 ----------
  const SC = () => (typeof PlazaLife !== 'undefined' ? PlazaLife.SC : 0.58);
  const charH = (k) => ((typeof ART !== 'undefined' && ART.CHAR_H && ART.CHAR_H[k]) || 56) * SC();
  function canDraw(k) { return typeof sprOk === 'function' ? sprOk(k) : true; }
  function mkActor(name, k, i, x) {
    return { name, k, id:'th' + i + '_' + k, px:x, tx:x, home:x, face:true, want:true, turnT:9, w:0, wph:Math.random() * 9, hp:-1, seed:Math.random() * 50,
      act:null, at:0, pl:{}, style:{}, eatT:0, icon:null, iconT:9, one:0, base:null, spk:false, pose:null, pt:0, sc:1, alpha:1, aud:false };
  }
  function actKey(a, k) {
    if (!a) return null;
    if (a.indexOf('n30:') === 0) { const key = 'n30_' + k.slice(4) + '_' + a.slice(4); return (typeof DAILY !== 'undefined' && DAILY[key]) ? key : 'plaza_talk'; }
    if (a.indexOf('pose:') === 0) return a;
    if (a.indexOf('ag:') === 0) { const key = 'ag_' + a.slice(3); return (typeof DAILY !== 'undefined' && DAILY[key]) ? key : 'plaza_talk'; } // 三個死對頭（npc_antag.js）
    return 'plaza_' + a;
  }
  function agDur(k, st) { try { return Antag.dur(k, st) || 2; } catch (e) { return 2; } }
  function n30Dur(key) { try { for (const id in N30D.ACTS) for (const r of N30D.ACTS[id]) if (r[0] === key) return r[2]; } catch (e) {} return 2.4; }
  // 做一個動作：talk/argue 等會一直做；揮手、鞠躬、嚇一跳等一次性動作做完回到原本的樣子
  function doAct(a, act, hold) {
    const key = actKey(act, a.k); if (!key) { a.act = a.spk ? 'plaza_talk' : null; a.pose = null; return; }
    a.at = 0; a.pose = null;
    if (key.indexOf('pose:') === 0) { a.pose = key.slice(5); a.act = null; a.one = 1.2; a.pt = 0; return; }
    const nm = key.replace('plaza_', '');
    a.act = key; a.pl = { d:hold || ONE[nm] || 6, spk:a.spk, deep:0.7 };
    a.one = ONE[nm] ? ONE[nm] : key.indexOf('n30_') === 0 ? n30Dur(key) * (hold ? 99 : 1.5) : key.indexOf('ag_') === 0 ? agDur(a.k, key.slice(3)) * (hold ? 99 : 1.2) : 0;
  }
  function settle(a) { a.pose = null; a.act = a.spk ? (a.talk ? actKey(a.talk, a.k) : 'plaza_talk') : (a.base ? actKey(a.base, a.k) : null); a.pl = { d:99, spk:a.spk }; a.at = 0; a.one = 0; }
  function stepActor(a, dt) {
    a.at += dt; a.iconT += dt;
    if (a.act === 'plaza_eat' || a.style.eat) a.eatT += dt;
    const dx = a.tx - a.px, sp = W * 0.42;
    if (Math.abs(dx) > 1.5) { a.px += Math.sign(dx) * Math.min(Math.abs(dx), sp * dt); a.w = Math.min(1, a.w + dt * 6); a.wph += dt * 1.7; a.want = dx > 0; if (a.k === 'laojiang' || a.k === 'zombie') { a.hp = a.hp < 0 ? 0 : (a.hp + dt / 0.5) % 1; } }
    else { a.w = Math.max(0, a.w - dt * 5); if (a.hp >= 0 && (a.k === 'laojiang' || a.k === 'zombie')) { a.hp += dt / 0.5; if (a.hp >= 1) a.hp = -1; } }
    if (a.pose) { a.pt = Math.min(1, a.pt + dt * 1.4); }
    if (a.one > 0) { a.one -= dt; if (a.one <= 0) settle(a); }
    if (a.want !== a.face && a.turnT >= 0.22) a.turnT = 0;
    if (a.turnT < 0.22) { a.turnT += dt; if (a.turnT >= 0.11 && !a._fl) { a.face = a.want; a._fl = 1; } if (a.turnT >= 0.22) a._fl = 0; }
    if (a.act === 'plaza_talk' || a.act === 'plaza_argue') a.pl.spk = a.spk;
  }
  function drawActor(a, K, gy, t) {
    if (!canDraw(a.k)) { // 原圖仲未到：只畫一個影（程式畫），唔畫假角色
      const h = charH(a.k) * K * (a.sc || 1); ctx.save(); ctx.setTransform(dpr, 0, 0, dpr, 0, 0); ctx.globalAlpha = 0.55 * a.alpha;
      ctx.fillStyle = 'rgba(0,0,0,.45)'; ctx.beginPath(); ctx.ellipse(a.px, gy, h * 0.22, h * 0.05, 0, 0, PI * 2); ctx.fill();
      ctx.fillStyle = 'rgba(20,14,28,.85)'; ctx.beginPath(); ctx.ellipse(a.px, gy - h * 0.82, h * 0.15, h * 0.17, 0, 0, PI * 2); ctx.fill();
      ctx.beginPath(); ctx.moveTo(a.px - h * 0.2, gy); ctx.quadraticCurveTo(a.px - h * 0.22, gy - h * 0.62, a.px, gy - h * 0.66); ctx.quadraticCurveTo(a.px + h * 0.22, gy - h * 0.62, a.px + h * 0.2, gy); ctx.fill();
      ctx.restore(); return;
    }
    const k = K * (a.sc || 1);
    ctx.save(); ctx.setTransform(dpr * k, 0, 0, dpr * k, 0, 0); ctx.globalAlpha = a.alpha;
    a.x = a.px / k; a.y = gy / k;
    const glide = a.w > 0.3 && typeof Antag !== 'undefined' && Antag.STATES && Antag.STATES[a.k] && typeof DAILY !== 'undefined' && DAILY.ag_walk; // 三個死對頭：冇腳，飄過嚟
    if (glide) ART.drawChar(ctx, a.k, a.x, a.y, SC(), { t:t + a.seed, act:'ag_walk', at:t, flip:!a.face, tamed:true, untied:true });
    else if (a.pose) ART.drawChar(ctx, a.k, a.x, a.y, SC(), { t:t + a.seed, pose:a.pose, pt:a.pt, flip:!a.face, tamed:true, untied:true, tdx:(a.face ? 40 : -40), tdy:0 });
    else if (typeof PlazaLife !== 'undefined') { a.style.eat = a.act === 'plaza_eat'; PlazaLife.drawAgent(ctx, a, t, { noIcon:true }); if (a.k === 'shuigui') PlazaLife.drawDrips(ctx, a, t + a.seed); }
    else ART.drawChar(ctx, a.k, a.x, a.y, SC(), { t:t + a.seed, walk:a.w > 0.3, flip:!a.face, tamed:true, untied:true });
    ctx.restore();
  }
  // ---------- 程式畫的小東西 ----------
  function floatTxt(x, y, s, col, size, life) { sc.floats.push({ x, y, s:L(s), col:col || '#ffe9a8', size:size || 22, t:0, life:life || 1.3, vx:(Math.random() - 0.5) * 20 }); }
  function joss(n) { for (let i = 0; i < n; i++) sc.parts.push({ x:Math.random() * W, y:-20 - Math.random() * H * 0.4, vy:40 + Math.random() * 50, rot:Math.random() * 6, vr:(Math.random() - 0.5) * 3, flip:Math.random() * 6, vf:2 + Math.random() * 3, ph:Math.random() * 6 }); }
  function drawParts(dt) {
    sc.parts = sc.parts.filter(p => { p.y += p.vy * dt; p.rot += p.vr * dt; p.flip += p.vf * dt; return p.y < H + 20; });
    for (const p of sc.parts) {
      const sz = 7; ctx.save(); ctx.translate(p.x + Math.sin(T * 1.3 + p.ph) * 10, p.y); ctx.rotate(p.rot); ctx.scale(1, Math.cos(p.flip));
      ctx.fillStyle = '#e8c35a'; ctx.strokeStyle = '#6a4a14'; ctx.lineWidth = 1; ctx.fillRect(-sz, -sz * 0.7, sz * 2, sz * 1.4); ctx.strokeRect(-sz, -sz * 0.7, sz * 2, sz * 1.4);
      ctx.fillStyle = '#b8322a'; ctx.fillRect(-sz * 0.35, -sz * 0.35, sz * 0.7, sz * 0.7); ctx.restore();
    }
    sc.floats = sc.floats.filter(f => (f.t += dt) < f.life);
    for (const f of sc.floats) {
      const k = f.t / f.life, a = Math.min(1, (1 - k) * 3, f.t * 8), s = f.size * (0.7 + 0.3 * Math.min(1, f.t * 6));
      ctx.save(); ctx.globalAlpha = a; ctx.font = `900 ${s}px ${getComputedStyle(document.body).fontFamily}`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.lineJoin = 'round';
      ctx.lineWidth = s * 0.25; ctx.strokeStyle = 'rgba(20,12,24,.92)'; const x = f.x + f.vx * f.t, y = f.y - k * 36;
      ctx.strokeText(f.s, x, y); ctx.fillStyle = f.col; ctx.fillText(f.s, x, y); ctx.restore();
    }
  }
  function crayon(pts, w, col) {
    ctx.save(); ctx.lineCap = 'round'; ctx.lineJoin = 'round'; ctx.strokeStyle = col;
    for (let p = 0; p < 2; p++) { ctx.globalAlpha = p ? 0.5 : 1; ctx.lineWidth = w * (p ? 0.5 : 1); ctx.beginPath(); pts.forEach(([x, y], i) => { const j = p ? w * 0.35 : 0; i ? ctx.lineTo(x + j, y - j * 0.5) : ctx.moveTo(x + j, y); }); ctx.stroke(); }
    ctx.restore();
  }
  function drawMic(x, gy, h, dir) { // 咪高峰架：底座、支架、咪頭（蠟筆線）
    const top = gy - h * 0.66;
    ctx.save(); ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.beginPath(); ctx.ellipse(x, gy + 2, h * 0.12, h * 0.025, 0, 0, PI * 2); ctx.fill(); ctx.restore();
    crayon([[x - h * 0.09, gy], [x, gy - h * 0.03], [x + h * 0.09, gy]], h * 0.018, '#1c1820');
    crayon([[x, gy - h * 0.02], [x, top]], h * 0.02, '#2a2630');
    crayon([[x, top], [x + dir * h * 0.13, top - h * 0.06]], h * 0.016, '#2a2630');
    ctx.save(); ctx.translate(x + dir * h * 0.15, top - h * 0.07); ctx.rotate(-dir * 0.45);
    ART.rr(ctx, -h * 0.022, -h * 0.05, h * 0.044, h * 0.09, h * 0.02, '#3a3640', '#111', 1.5);
    ctx.fillStyle = '#9a9aa8'; ctx.beginPath(); ctx.ellipse(0, -h * 0.05, h * 0.03, h * 0.034, 0, 0, PI * 2); ctx.fill(); ctx.strokeStyle = '#111'; ctx.lineWidth = 1.4; ctx.stroke();
    ctx.strokeStyle = 'rgba(40,40,50,.6)'; ctx.lineWidth = 0.8; for (let i = -2; i <= 2; i++) { ctx.beginPath(); ctx.moveTo(-h * 0.026, -h * 0.05 + i * h * 0.01); ctx.lineTo(h * 0.026, -h * 0.05 + i * h * 0.01); ctx.stroke(); }
    ctx.restore();
  }
  function drawStageFloor(gy) { // 小木台
    const top = gy - 6, x0 = W * 0.08, x1 = W * 0.92;
    ctx.save(); ctx.fillStyle = '#3a2418'; ctx.beginPath(); ctx.moveTo(x0, top); ctx.lineTo(x1, top); ctx.lineTo(x1 + 14, gy + 26); ctx.lineTo(x0 - 14, gy + 26); ctx.closePath(); ctx.fill();
    ctx.strokeStyle = 'rgba(255,210,150,.18)'; ctx.lineWidth = 1.2; for (let i = 1; i < 4; i++) { const y = top + i * 7; ctx.beginPath(); ctx.moveTo(x0 - i * 3, y); ctx.lineTo(x1 + i * 3, y); ctx.stroke(); }
    ctx.fillStyle = '#1e120c'; ctx.fillRect(x0 - 14, gy + 26, x1 - x0 + 28, 40); ctx.restore();
    crayon([[x0, top], [x1, top]], 2.4, '#7a5634');
  }
  function drawBanner(text) { // 台後面掛一塊布：棟篤笑・今晚開咪
    const w = Math.min(W * 0.62, 260), x = W / 2 - w / 2, y = H * 0.17;
    ctx.save(); ctx.fillStyle = 'rgba(130,24,20,.92)'; ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x + w, y); ctx.lineTo(x + w - 6, y + 44); ctx.lineTo(x + w / 2, y + 52); ctx.lineTo(x + 6, y + 44); ctx.closePath(); ctx.fill();
    ctx.strokeStyle = '#f3d68a'; ctx.lineWidth = 1.5; ctx.stroke();
    ctx.font = `900 21px ${getComputedStyle(document.documentElement).getPropertyValue('--serif') || 'serif'}`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillStyle = '#ffe9b8'; ctx.fillText(text, W / 2, y + 23);
    crayon([[x - 8, y - 10], [x + 2, y + 2]], 2, '#2a1a10'); crayon([[x + w + 8, y - 10], [x + w - 2, y + 2]], 2, '#2a1a10');
    ctx.restore();
  }
  // ---------- 每一幀 ----------
  function frame(now) {
    if (!sc) return;
    const dt = Math.min(0.05, (now - last) / 1000); last = now; T += dt;
    const r = el.getBoundingClientRect(); if (Math.abs(r.width - W) > 1 || Math.abs(r.height - H) > 1) resize();
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0); ctx.clearRect(0, 0, W, H);
    const shk = sc.shake > 0 ? (sc.shake -= dt, Math.sin(T * 70) * 4 * sc.shake) : 0;
    ctx.save(); ctx.translate(shk, 0);
    if (typeof paintBg === 'function') paintBg(ctx, W, H, sc.bg || 'village', T); else { ctx.fillStyle = '#16131b'; ctx.fillRect(0, 0, W, H); }
    const L = layout();
    if (sc.mode === 'standup') {
      ctx.fillStyle = 'rgba(8,6,14,.55)'; ctx.fillRect(0, 0, W, H);
      const g = ctx.createRadialGradient(W / 2, L.gy - L.ch * 0.6, 10, W / 2, L.gy - L.ch * 0.4, Math.max(W, H) * 0.55);
      g.addColorStop(0, 'rgba(255,236,190,.34)'); g.addColorStop(0.45, 'rgba(255,220,160,.08)'); g.addColorStop(1, 'rgba(0,0,0,.55)'); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H);
      drawBanner(sc.banner || '棟篤笑・今晚開咪');
      drawStageFloor(L.gy);
    } else {
      const g = ctx.createLinearGradient(0, L.gy - 40, 0, H); g.addColorStop(0, 'rgba(10,8,16,0)'); g.addColorStop(1, 'rgba(10,8,16,.6)'); ctx.fillStyle = g; ctx.fillRect(0, L.gy - 40, W, H - L.gy + 40);
    }
    for (const a of sc.cast) stepActor(a, dt);
    for (const a of sc.aud) stepActor(a, dt);
    const order = sc.cast.slice().sort((p, q) => (p.z || 0) - (q.z || 0));
    for (const a of order) drawActor(a, L.K, L.gy + (a.dy || 0), T);
    if (sc.mode === 'standup' && sc.cast[0]) { const p = sc.cast[0]; drawMic(p.px + (p.face ? 1 : -1) * L.ch * 0.36, L.gy + 2, L.ch, p.face ? -1 : 1); }
    if (sc.aud.length) {
      for (const a of sc.aud) drawActor(a, L.K * 0.78, H - 8 + (a.dy || 0), T);
      const g = ctx.createLinearGradient(0, H - L.ch * 0.9, 0, H); g.addColorStop(0, 'rgba(6,4,10,0)'); g.addColorStop(0.5, 'rgba(6,4,10,.38)'); g.addColorStop(1, 'rgba(6,4,10,.7)'); ctx.fillStyle = g; ctx.fillRect(0, H - L.ch * 0.9, W, L.ch * 0.9);
    }
    drawParts(dt);
    ctx.restore();
    if (sc.flash > 0) { sc.flash -= dt; ctx.fillStyle = `rgba(255,250,235,${Math.max(0, sc.flash) * 1.4})`; ctx.fillRect(0, 0, W, H); }
    tickFlow(dt);
    placeBubble();
    raf = requestAnimationFrame(frame);
  }
  function layout() {
    const stand = sc.mode === 'standup';
    const gy = stand ? H * 0.70 : H * 0.77;
    const ch = stand ? Math.min(H * 0.34, W * 0.52) : Math.min(H * 0.3, W * (sc.cast.length > 3 ? 0.31 : 0.4));
    return { gy, ch, K:ch / (60 * SC()) };
  }
  // ---------- 劇本流程 ----------
  function actorOf(name) { return sc.cast.find(a => a.name === name) || sc.aud.find(a => a.name === name) || null; }
  function setSpeaker(name) {
    for (const a of sc.cast) { const on = a.name === name; if (a.spk !== on) { a.spk = on; if (!a.one && !a.pose) settle(a); } }
    const sp = actorOf(name);
    if (sp && !sp.aud) for (const a of sc.cast) if (a !== sp && !a.lockFace) a.want = sp.px > a.px; // 大家望住講嘢嗰個
    if (sp && !sp.aud && sc.cast.length > 1 && !sp.lockFace) { const o = sc.cast.filter(x => x !== sp); const c = o.reduce((s, x) => s + x.px, 0) / o.length; sp.want = c > sp.px; }
  }
  function show(b) {
    const cap = el.querySelector('.th-cap'), bub = el.querySelector('.th-bub'), tx = bub.querySelector('.th-tx'), nm = bub.querySelector('.th-nm');
    sc.beat = b; sc.typing = true; sc.shown = 0; sc.full = L(b.text); sc.ty = 0;
    if (b.fx) runFx(b.fx);
    if (b.who === '旁白') { setSpeaker(null); bub.className = 'th-bub'; cap.className = 'th-cap on'; cap.textContent = ''; sc.target = cap; }
    else {
      cap.className = 'th-cap'; setSpeaker(b.who);
      const sp = actorOf(b.who);
      bub.className = 'th-bub on' + (b.who === '系統' ? ' sys' : sp && sp.aud ? ' aud' : '');
      nm.textContent = b.who; tx.textContent = ''; sc.target = tx; sc.bubFor = sp;
      if (sp && b.act) doAct(sp, b.act, b.hold);
      else if (sp && !sp.aud) settle(sp);
      if (sp && sp.aud && !b.act) doAct(sp, 'laugh');
    }
    if (b.re) for (const n in b.re) { const a = actorOf(n); if (a) doAct(a, b.re[n], b.hold); }
    el.querySelector('.th-tap').textContent = '';
  }
  function placeBubble() {
    const bub = el.querySelector('.th-bub'); if (!bub || !bub.classList.contains('on')) return;
    bub.style.left = '0px'; // 先放返左邊量闊度，唔係近右邊會被壓窄
    const L = layout(), sp = sc.bubFor, w = bub.offsetWidth, h = bub.offsetHeight;
    let x = W / 2, y;
    if (!sp || sc.beat.who === '系統') { y = Math.max(64, H * 0.16); bub.style.left = Math.max(10, (W - w) / 2) + 'px'; bub.style.top = y + 'px'; return; }
    if (sp.aud) { const k = L.K * 0.78; x = sp.px; const top = H - 8 - charH(sp.k) * k; y = top - h - 14; }
    else { x = sp.px; const head = L.gy - charH(sp.k) * L.K * (sp.sc || 1) - 10; y = head - h - 12; }
    y = Math.max(sc.mode === 'standup' ? H * 0.17 + 58 : 60, y);
    const left = Math.max(10, Math.min(W - w - 10, x - w / 2));
    bub.style.left = left + 'px'; bub.style.top = y + 'px'; bub.style.setProperty('--tx', Math.max(16, Math.min(w - 16, x - left)) + 'px');
  }
  function tickFlow(dt) {
    if (sc.phase === 'enter') { if (sc.cast.every(a => Math.abs(a.tx - a.px) < 2)) { sc.phase = 'run'; next(); } return; }
    if (sc.phase === 'exit') { sc.exitT -= dt; if (sc.exitT <= 0 || sc.cast.every(a => Math.abs(a.tx - a.px) < 2)) close(false); return; }
    if (sc.phase !== 'run' || !sc.typing) { if (sc.autoT > 0) { sc.autoT -= dt; if (sc.autoT <= 0) next(); } return; }
    sc.ty += dt; const n = Math.min(sc.full.length, Math.floor(sc.ty / 0.026));
    if (n !== sc.shown) { sc.shown = n; sc.target.textContent = sc.full.slice(0, n); }
    if (n >= sc.full.length) done();
  }
  function done() {
    sc.typing = false; sc.target.textContent = sc.full;
    const b = sc.beat; if (b && b.react && sc.react) sc.react(b.react, b);
    if (b && b.auto) sc.autoT = b.auto;
    el.querySelector('.th-tap').textContent = '點擊繼續';
  }
  function next() {
    sc.autoT = 0;
    if (sc.i >= sc.beats.length) { if (sc.choice) { askChoice(); return; } exit(); return; }
    show(sc.beats[sc.i++]);
  }
  function tap() {
    if (!sc) return; Sound.play && Sound.play('click');
    if (sc.phase === 'enter') { for (const a of sc.cast) { a.px = a.tx; } return; }
    if (sc.phase === 'exit') { close(false); return; }
    if (sc.phase === 'choice') return;
    if (sc.typing) { done(); return; }
    next();
  }
  function askChoice() { // 選項 a / b / c；disabled = 做唔到（標籤寫明原因）；next = 再問一條（例如三局籃球）；on() = 揀咗即刻做嘅事
    sc.phase = 'choice'; const c = sc.choice, box = el.querySelector('.th-choice'), cap = el.querySelector('.th-cap');
    el.querySelector('.th-bub').className = 'th-bub'; cap.className = 'th-cap on'; cap.textContent = L(c.q); setSpeaker(null);
    el.querySelector('.th-tap').textContent = '';
    box.innerHTML = ['a', 'b', 'c'].filter(k => c[k]).map(k => `<button class="btn ${k === 'a' && !c.plain ? 'gold' : ''} wide" data-k="${k}" ${c[k].disabled ? 'disabled' : ''}>${L(c[k].label)}</button>`).join('');
    box.className = 'th-choice on';
    box.querySelectorAll('button').forEach(b => b.onclick = (e) => {
      e.stopPropagation(); if (b.disabled) return; const o = c[b.dataset.k]; sc.chosen = b.dataset.k; sc.picks.push(b.dataset.k); box.className = 'th-choice'; box.innerHTML = '';
      Sound.play && Sound.play('paper');
      let more = o.lines || []; if (o.on) { const r = o.on(sc.picks.slice()); if (Array.isArray(r)) more = more.concat(r); }
      sc.beats = sc.beats.concat(parse(more));
      if (o.next) { sc.choice = typeof o.next === 'function' ? o.next(sc.picks.slice()) : o.next; sc.chosen = null; } else sc.choice = null;
      sc.phase = 'run'; next();
    });
  }
  function exit() {
    sc.phase = 'exit'; sc.exitT = 1.3; el.querySelector('.th-bub').className = 'th-bub'; el.querySelector('.th-cap').className = 'th-cap';
    el.querySelector('.th-tap').textContent = '';
    if (sc.mode === 'standup') { sc.exitT = 0.9; return; }
    sc.cast.forEach((a, i) => { a.spk = false; settle(a); a.tx = a.home < W / 2 ? -W * 0.25 : W * 1.25; });
  }
  function runFx(fx) {
    for (const f of String(fx).split(',')) {
      if (f === 'joss') joss(26);
      else if (f === 'shake') sc.shake = 0.5;
      else if (f === 'flash') sc.flash = 0.35;
      else if (f.indexOf('txt:') === 0) floatTxt(W / 2, H * 0.42, f.slice(4), '#ffe9a8', 28, 1.6);
    }
  }
  // 劇本格式：[說話者, 台詞, 動作?, { 其他角色: 反應動作 }?, 特效?]
  function parse(lines) {
    return lines.map(l => Array.isArray(l) ? { who:l[0], text:l[1], act:l[2] || null, re:l[3] || null, fx:l[4] || null } : l);
  }
  function play(scene, cb) {
    if (sc) close(true);
    ensure(); el.className = 'on'; resize();
    const cast = scene.cast || [], n = cast.length;
    const xs = scene.xs || (n === 1 ? [0.5] : n === 2 ? [0.3, 0.7] : n === 3 ? [0.2, 0.5, 0.8] : [0.15, 0.38, 0.62, 0.85]);
    sc = { mode:scene.mode || 'skit', bg:scene.bg, banner:scene.banner, cb, cast:[], aud:[], parts:[], floats:[], beats:parse(scene.lines || []), i:0, phase:'enter', choice:scene.choice || null, chosen:null, picks:[], react:scene.react || null, shake:0, flash:0, autoT:0 };
    cast.forEach(([name, k, opt], i) => {
      const a = mkActor(name, k, i, W * xs[i]); Object.assign(a, opt || {});
      a.home = W * xs[i]; a.tx = a.home; a.base = (opt && opt.base) || null; a.talk = (opt && opt.talk) || null;
      if (scene.mode === 'standup' || (opt && opt.onstage)) { a.px = a.tx; a.want = a.face = (opt && opt.face != null) ? opt.face : a.home < W / 2; }
      else { const fromL = a.home < W / 2; a.px = fromL ? -W * 0.18 - i * 40 : W * 1.18 + (n - i) * 40; a.face = a.want = fromL; }
      if (a.base) settle(a);
      sc.cast.push(a);
    });
    (scene.aud || []).forEach(([name, k], i, arr) => { const x = W * (0.1 + 0.8 * (arr.length === 1 ? 0.5 : i / (arr.length - 1))); const a = mkActor(name, k, 50 + i, x); a.aud = true; a.face = a.want = x < W / 2; a.dy = (i % 2) * 6; sc.aud.push(a); });
    el.querySelector('.th-tag').textContent = scene.tag || '陰間日常';
    el.querySelector('.th-title').textContent = L(scene.title || '');
    if (Sound.setMode) Sound.setMode('story');
    if (scene.fx) runFx(scene.fx);
    last = performance.now(); cancelAnimationFrame(raf); raf = requestAnimationFrame(frame);
    if (sc.mode === 'standup') { sc.phase = 'run'; setTimeout(() => { if (sc && sc.i === 0) next(); }, 450); }
  }
  function close(skipped) {
    if (!sc) return; const s = sc; sc = null; cancelAnimationFrame(raf);
    if (el) { el.className = ''; el.innerHTML = ''; }
    if (Sound.setMode) Sound.setMode(typeof GhostStreet !== 'undefined' && GhostStreet.active ? 'story' : 'village');
    if (s.cb) s.cb({ skipped:!!skipped, choice:s.chosen || s.picks[s.picks.length - 1] || null, picks:s.picks });
  }
  // 棟篤笑用：觀眾反應
  try { css(); } catch (e) {}
  const API = {
    play, close, get on() { return !!sc; },
    aud() { return sc ? sc.aud : []; }, cast() { return sc ? sc.cast : []; },
    act(a, act, hold) { doAct(a, act, hold); }, float:floatTxt, joss, fx:runFx,
    size() { return { W, H }; }, layout() { return sc ? layout() : null; },
    insert(beats) { if (sc) sc.beats.splice(sc.i, 0, ...parse(beats)); },
    charH,
  };
  return API;
})();

// ===================== 陰間日常：劇本 =====================
// need = 要看過的劇情（id 全部看過才會出）；pre = 只在「陰司 KPI 系統」時期（第一季完之前）；cast = [名, 原圖, 選項]
// 台詞：[說話者, 台詞, 自己的動作?, { 其他角色: 反應動作 }?, 特效?]；動作 = 平日動作名（talk、laugh、startle…）或 'n30:動作'、'pose:strike'
// choice = 結尾的小選擇：{ q, a:{ label, lines, give() }, b:{…} }；give() 回傳獎勵（壽包／冥幣／好評），只在第一次睇、冇跳過時發。
const rwd = (n) => Math.round(n * (1 + (typeof S !== 'undefined' && S ? S.lv : 1) * 0.18));
const SKITS = [
{ id:'kpi', title:'地府 KPI 會', bg:'hq', need:['prologue_sys'], src:'su05 打工人變打工鬼',
  cast:[['白無常','baiwu'],['阿福','afu'],['黑無常','heiwu']], lines:[
  ['白無常','各位，第三季勾魂 KPI 出咗嚟喇。上頭話，今年要增長兩成。'],
  ['黑無常','人唔肯死。','look'],
  ['白無常','所以要搵合作夥伴。今季表現最好嘅，係陽間啲寫字樓——淨係吉隆坡，就幫我哋完成咗三千二百八十四個。'],
  ['阿福','……等陣。我就係嗰三千二百八十四個其中一個。','startle'],
  ['白無常','係呀！你係我哋嘅成功案例，張相仲印咗喺季度報告封面。','wave'],
  ['阿福','你哋同我老細，係咪有分成㗎？'],
  ['黑無常','佢哋出 OT 紙，我哋出死亡證。'],
  ['白無常','下季目標已經定好：鼓勵陽間老細，多啲喺凌晨兩點 send WhatsApp。'],
  ['阿福','我收到嗰個，係兩點十三分。'],
  ['黑無常','準時。'],
]},
{ id:'naicha', title:'孟婆湯斷貨', bg:'road', need:['ch6_mengpo'],
  cast:[['白無常','baiwu'],['孟婆','mengpo'],['阿福','afu']], lines:[
  ['白無常','唔得喇唔得喇！奈何橋塞到出返黃泉路喇！','argue'],
  ['孟婆','後生仔，唔關我事。今個月啲湯料冇貨，我老人家冇米點煮呀？','soup'],
  ['阿福','咁啲鬼過橋飲咩？'],
  ['孟婆','珍珠奶茶。半糖少冰。'],
  ['白無常','問題係，飲完佢哋唔記得前世，淨係記得打卡。個個企喺橋頭影相，影完仲要 post。'],
  ['孟婆','今朝有個後生，飲完第一句唔係問「我係邊個」，係問「可唔可以加多份珍珠」。'],
  ['阿福','咁都好啫，起碼佢唔記得自己點死。'],
  ['孟婆','前世就唔記得，會員卡就記得好清楚。仲叫我幫佢儲印花。'],
  ['白無常','飲夠十杯，送一次投胎。','laugh'],
 ], choice:{ q:'孟婆遞來一杯珍珠奶茶。', a:{ label:'喝（半糖）', lines:[['孟婆','乖。飲完記得做嘢，唔好淨係記得打卡。','soup']], give:() => ({ buns:rwd(18) }) },
   b:{ label:'不喝，要湯', lines:[['孟婆','冇湯，得返個心意。你個心意，老身收咗。'],['旁白','孟婆在阿福的會員卡上，蓋了第一個印。']], give:() => ({ exp:rwd(6) }) } } },
{ id:'inflation', form:'news', title:'陰間新聞台', need:['ch1_end'], lines:[
  ['主播','陰間新聞台，晚上好。地府銀行今日宣布：冥幣面額後面，再加三個零。'],
  ['主播','原因是陽間家屬越燒越大張，最新一張面額一百億，附防偽水印。'],
  ['主播','受此影響，一碗雲吞麵今日漲至三千億。記者在現場訪問了一位市民。'],
  ['主播','孤寒鬼：「我生前慳咗一世，死咗啲仔女燒咗一百億落嚟。我好感動，攞去買嘢——淨係夠買半碗腸粉。」'],
  ['主播','地府銀行呼籲陽間家屬：心意到就好，不必燒那麼大張。'],
  ['主播','另外，明日起化寶爐手續費由一成調至一成半。地府銀行強調，這不是加價，是優化。'],
  ['主播','以上。'],
]},
{ id:'itdown', title:'生死簿 down 機', bg:'hq', need:['prologue_sys'],
  cast:[['牛頭','niutou'],['馬面','mamian'],['阿福','afu']], lines:[
  ['牛頭','唔掂喇！生死簿 down 咗！','startle'],
  ['馬面','冷靜。上個月先搬咗上雲端，IT 話好穩陣。'],
  ['牛頭','穩陣到而家成個吉隆坡冇人死得！醫院啲醫生個個以為自己變咗神醫！','argue'],
  ['阿福','你哋試過熄咗佢再開未？'],
  ['馬面','IT 都係咁講。問題係我哋點熄？我哋本身已經熄咗。'],
  ['牛頭','仲有個視窗彈出嚟：「請輸入密碼」。密碼喺上一任 IT 度。'],
  ['阿福','咁搵佢囉。'],
  ['馬面','佢個名喺生死簿入面。要開到生死簿，先搵到佢。','look'],
 ], choice:{ q:'阿福生前是公司的 IT 救火隊。要幫忙嗎？', a:{ label:'按 Ctrl + Alt + Delete', lines:[['牛頭','好喇！上返線喇！','laugh'],['馬面','……等陣。佢 Delete 咗邊個？','startle']], give:() => ({ coins:rwd(22) }) },
   b:{ label:'叫他們等 IT 上班', lines:[['牛頭','IT 幾時返？'],['阿福','放完假囉。'],['馬面','佢放咗三百年假。']], give:() => ({ exp:rwd(6) }) } } },
{ id:'queue', title:'投胎打尖', bg:'road', need:['prologue_sys'],
  cast:[['黑無常','heiwu'],['遊魂阿強','youhun'],['阿福','afu']], lines:[
  ['黑無常','攞籌。'],
  ['阿福','……一百零三萬四千號？','startle'],
  ['黑無常','今日叫到三百號。'],
  ['遊魂阿強','兄弟，想快？我有計。投胎快線計劃，月供九十九，保證打尖。','wave'],
  ['阿福','你係咪生前賣保險嗰個阿強？'],
  ['遊魂阿強','死咗咪轉行囉。生前賣你未來，死後賣你來世。','spin'],
  ['黑無常','打尖。罰返去尾。','pose:strike',{ 遊魂阿強:'eek' }],
  ['遊魂阿強','大佬，我都有份計劃啱你：退休保障——'],
  ['黑無常','我唔會退休。'],
  ['遊魂阿強','咁……意外保障呢？'],
  ['黑無常','我就係意外。'],
]},
{ id:'fakephone', title:'紙紮 iPhone', bg:'village', need:['gift_xiaozhi2','side_tianhua'], src:'su16 紙紮店售後服務',
  cast:[['天花姐','tianhua'],['小紙','xiaozhi']], lines:[
  ['天花姐','小紙……我屋企人燒咗部 iPhone 落嚟，最新款。哎喲，幫我睇吓點開。','backrub'],
  ['小紙','（攞起嚟睇）天花姐，呢部唔係 iPhone，係 iPhome。'],
  ['天花姐','有咩分別？'],
  ['小紙','後面三個鏡頭係畫上去嘅。影出嚟，張張都係三個圈。'],
  ['天花姐','咁 Face ID 呢？'],
  ['小紙','開唔到。佢話認唔到你個樣——因為你個頭係倒轉嘅。'],
  ['天花姐','（反轉部電話）……開咗喇！','startle'],
  ['小紙','背面仲有張保用證：「保用一年，遇火即失效。」'],
  ['天花姐','佢係燒落嚟㗎喎……'],
  ['小紙','係呀。所以燒嗰一刻，已經過咗保。'],
]},
{ id:'dating', title:'牛頭玩 dating app', bg:'street', need:['prologue_sys'],
  cast:[['馬面','mamian'],['牛頭','niutou']], lines:[
  ['馬面','牛頭，你唔好再用我張相做 profile pic 喇。'],
  ['牛頭','你張相靚啲嘛。'],
  ['馬面','嗰張我開咗瘦面，塊面短咗三吋。人哋見到真人，會告我㗎。'],
  ['牛頭','嘩！有人 like 咗我！','startle'],
  ['馬面','佢講咩？'],
  ['牛頭','佢話佢喺外國做石油工程師，想同我認真發展。不過要先借五千蚊買機票嚟見我。'],
  ['馬面','牛頭，你俾人劏豬喇。'],
  ['牛頭','我係牛喎。'],
  ['馬面','佢哋唔理你係咩。照劏。'],
]},
{ id:'review', title:'黑白無常年度考核', bg:'village', need:['ch6_end'],
  cast:[['白無常','baiwu'],['黃總','huang'],['黑無常','heiwu']], lines:[
  ['黃總','好，年度考核。白無常先。你嘅問題係笑得太多，客戶以為你推銷。'],
  ['白無常','一見生財嘛。','wave'],
  ['黃總','黑無常，你嘅問題係完全唔笑，客戶以為你收數。'],
  ['黑無常','我係收命。'],
  ['黃總','總括嚟講，兩位都係「符合期望」。加薪：零。'],
  ['白無常','黃總，我哋做咗幾千年，從來冇遲過到。'],
  ['黃總','就係呢個問題。你哋太準時放工。'],
  ['黑無常','勾魂唔準時，就變咗醫生嘅 KPI。'],
]},
{ id:'buffet', title:'餓鬼食評', bg:'village', need:['ch1_end'],
  cast:[['撐死鬼','n30_chengsi'],['阿福','afu'],['餓鬼王','eguiking']], lines:[
  ['撐死鬼','（打咗個飽嗝）阿福，盂蘭節嗰餐 buffet，我寫咗篇食評。','n30:burp'],
  ['阿福','你當年點死㗎？'],
  ['撐死鬼','食 buffet 食死嘅。九十九蚊任食，我食咗三百蚊，賺咗。','n30:eat'],
  ['餓鬼王','我都有寫！環境：陰涼。服務：冇人理。味道：（停一停）……香。','eat'],
  ['阿福','得個香字？'],
  ['餓鬼王','我條喉嚨細過針，食唔落，淨係聞得。聞咗五百年，全陰間最專業嘅鼻就係我。','sniff'],
  ['撐死鬼','我畀五粒星。食到我想再死多次。'],
  ['餓鬼王','我畀一粒星。因為佢食晒。','argue'],
]},
{ id:'wagroup', form:'chat', title:'落魄村街坊群', group:'孟婆、小紙、天花姐、黑無常、阿福…', av:['街','#5a4a6a'], need:['ch6_mengpo','side_tianhua'], src:'gh03 安娣鬼群組', lines:[
  ['孟婆','07:00|早晨 🌸'],
  ['孟婆','07:00|一日之計在於晨，飲碗熱湯身體好'],
  ['天花姐','07:02|風油買一送一，要嘅 PM 我'],
  ['孟婆','07:15|早晨 🌸'],
  ['小紙','07:16|溫馨提示：本群只講村務，唔該大家唔好再 send 早晨圖，多謝合作'],
  ['孟婆','07:30|早晨 🌸'],
  ['阿福','07:31|孟婆，你今朝 send 咗三次早晨'],
  ['孟婆','07:33|咁你覆咗未？'],
  ['旁白','小紙 已將 孟婆 移出群組'],
  ['旁白','孟婆 已透過邀請連結加入'],
  ['孟婆','07:40|早晨 🌸'],
  ['黑無常','07:41|天下太平'],
  ['旁白','黑無常 已退出群組'],
  ['旁白','孟婆 已將群組名稱改為「早晨」'],
]},
{ id:'noface', title:'鬼門關人臉識別', bg:'road', need:['ch1_end'],
  cast:[['牛頭','niutou'],['無臉鬼','n30_nopperabo']], lines:[
  ['牛頭','七月鬼門開！出關嘅排好隊，逐個望住部機，人臉識別！'],
  ['無臉鬼','唔好意思，部機話「搵唔到面孔」。','n30:tie'],
  ['牛頭','你望正啲啦。'],
  ['無臉鬼','我已經望得好正。我冇面。'],
  ['牛頭','有冇其他證件？'],
  ['無臉鬼','有，公司員工證。'],
  ['牛頭','張相呢？'],
  ['無臉鬼','都係冇面。HR 話冇所謂，反正開會都冇人望我。','n30:watch'],
  ['牛頭','……你返咗幾耐工？','look'],
  ['無臉鬼','二十年。老細到今日，仲以為我係新嚟嘅。'],
]},
{ id:'fees', title:'冥幣手續費', bg:'street', need:['ch1_end'], src:'su17 冥幣手續費',
  cast:[['阿福','afu'],['白無常','baiwu']], lines:[
  ['阿福','白無常，我媽燒咗一百億落嚟，我想攞。'],
  ['白無常','歡迎光臨，一見生財！先扣火化手續費兩成。','wave'],
  ['阿福','……好。'],
  ['白無常','跨界轉賬費一成半，陰陽兩界匯率差價三成，再加地府服務稅八個巴仙。'],
  ['阿福','咁我仲剩幾多？'],
  ['白無常','（撥一撥算盤）仲剩一份心意。'],
  ['阿福','心意可以買嘢咩？'],
  ['白無常','可以！心意可以換積分。積分下個月到期。','laugh'],
]},
{ id:'typo', title:'延期申請', bg:'road', need:['prologue_sys'],
  cast:[['白無常','baiwu'],['阿福','afu'],['黑無常','heiwu']], lines:[
  ['白無常','阿福，講件事你知。你嗰晚，生死簿上面有兩個名：陳大福，同埋陳大富。'],
  ['阿福','陳大富係邊個？'],
  ['白無常','一個老細，個心臟仲衰過你。'],
  ['黑無常','我哋去到，佢喺遊艇飲緊香檳。'],
  ['白無常','佢請咗律師，申請延期。有錢人嘅死期，係可以 reschedule 嘅。'],
  ['阿福','咁我點解唔可以延期？','argue'],
  ['黑無常','你冇申請。'],
  ['阿福','我連有得申請都唔知！'],
  ['白無常','張表 send 咗去你個 inbox㗎。'],
  ['黑無常','未讀。排喺第三千封。'],
]},
{ id:'qingming', title:'清明到貨', bg:'village', need:['gift_xiaozhi2','ch1_end'],
  cast:[['小紙','xiaozhi'],['阿福','afu'],['餓鬼王','eguiking']], lines:[
  ['小紙','少爺！清明到，上面燒落嚟嘅嘢塞爆個倉喇！','wave'],
  ['阿福','有啲咩？'],
  ['小紙','一架 Tesla，紙紮嘅，冇得充電。仲有一個 Dyson 風筒，一開就吹走埋自己。'],
  ['餓鬼王','有冇食嘅？有冇食嘅？','sniff'],
  ['小紙','有盒鮑魚，都係紙紮嘅。'],
  ['餓鬼王','（咬咗一啖）……紙嘅都香。','eat'],
  ['小紙','仲有張 Netflix 年卡，同埋一個 Wi-Fi router。'],
  ['阿福','咁都好，起碼有得上網。'],
  ['小紙','冇條線。佢哋淨係燒咗個 router。'],
 ], choice:{ q:'小紙問：兩樣之中，少爺要哪一樣？', a:{ label:'紙紮鮑魚（分給大家）', lines:[['餓鬼王','少爺萬歲！（聞咗成晚）','sniff']], give:() => ({ buns:rwd(20) }) },
   b:{ label:'Netflix 年卡', lines:[['小紙','少爺，張卡寫住：「只限一部裝置。」你部手機係紙紮嘅，唔算裝置。'],['阿福','……咁攞去化寶爐燒返做冥幣。']], give:() => ({ coins:rwd(20) }) } } },
{ id:'grab', title:'陰間 Grab', bg:'street', need:['side_tianhua'],
  cast:[['天花姐','tianhua'],['牛頭','niutou']], lines:[
  ['天花姐','（扶住條腰）司機……我叫咗車半個鐘喇……','backrub'],
  ['牛頭','我到咗！我到咗！'],
  ['天花姐','你喺邊？'],
  ['牛頭','喺你後面三公里。'],
  ['天花姐','咁點叫到咗？'],
  ['牛頭','我個心已經到咗。'],
  ['天花姐','哎喲……可唔可以畀我瞓喺車頂？我條腰坐唔落。'],
  ['牛頭','得！不過車頂另外收錢，再加落雨 surge，車費三倍。'],
  ['天花姐','陰間邊度有落雨？'],
  ['牛頭','頭先水鬼行過。','look'],
]},
{ id:'subs', title:'死咗都續費', bg:'village', need:['ch1_end'], src:'KS 自動續費鬼（前提）',
  cast:[['孤寒鬼','n30_guhangui'],['遊魂阿強','youhun']], lines:[
  ['孤寒鬼','（打緊算盤）唔對路。我死咗三年，張信用卡每個月仲有數扣。','n30:abacus'],
  ['遊魂阿強','扣咩？'],
  ['孤寒鬼','Netflix、Spotify、雲端相簿，仲有一個我都唔記得係咩嘅 app。'],
  ['遊魂阿強','取消咪得囉。'],
  ['孤寒鬼','要 OTP。OTP send 去我部電話，部電話同我一齊火化咗。'],
  ['遊魂阿強','打去客服啦。'],
  ['孤寒鬼','客服話要本人親身去分行。我本人喺山頭，分行話要預約。','n30:count'],
  ['遊魂阿強','咁你點算？要唔要買份保障？','wave'],
  ['孤寒鬼','唔使。我一世人慳到盡，死咗先開始大使。'],
]},
{ id:'haze', title:'陰間空氣指數三百', bg:'field', need:['prologue_sys'], src:'su11 陰間空氣指數三百',
  cast:[['白無常','baiwu'],['黑無常','heiwu']], lines:[
  ['白無常','（咳咳）陽間啲煙霞飄咗落嚟，今日陰間空氣指數三百。'],
  ['黑無常','睇唔到人。','look'],
  ['白無常','上頭話能見度太低，今日勾魂暫停。'],
  ['黑無常','好。'],
  ['白無常','不過我頭先已經勾錯咗兩個。個個戴住口罩，個樣一模一樣。'],
  ['黑無常','放返。'],
  ['白無常','放唔返。佢哋落到嚟，話唔想返上去——上面仲大煙。'],
]},
{ id:'getai', title:'歌台第一行', bg:'street', need:['ch1_end'],
  cast:[['阿福','afu'],['餓鬼王','eguiking'],['笑死鬼','n30_xiaosi']], lines:[
  ['阿福','七月歌台，第一行點解冇人坐嘅？'],
  ['餓鬼王','留俾我哋㗎！陽間啲人好有禮貌，年年都留第一行。'],
  ['笑死鬼','哈哈哈哈！VIP 位呀！','n30:laugh'],
  ['阿福','咁點解你哋個樣咁痛苦？'],
  ['餓鬼王','第一行最近個喇叭。佢哋唱到走晒音，我哋又唔走得——坐第一行中途走人，好冇禮貌。'],
  ['笑死鬼','哈哈哈，又走音！又走音！','n30:slap'],
  ['餓鬼王','最慘係個主持每晚都多謝我哋：「多謝前排嘅朋友，年年都嚟捧場！」'],
  ['阿福','佢睇唔到你哋喎。'],
  ['餓鬼王','佢唔使睇到。佢知我哋唔敢走。'],
]},
{ id:'scary', title:'鬼故比賽', bg:'village', need:['side_tianhua','ch4_end'],
  cast:[['水鬼','shuigui'],['天花姐','tianhua'],['阿福','afu']], lines:[
  ['水鬼','今晚輪到我講鬼故。有一晚，有個人返到公司……老細同佢講：「今年冇花紅。」'],
  ['天花姐','哎喲——好恐怖！','startle'],
  ['水鬼','仲未完。老細再講：「不過，我哋係一家人。」','shake'],
  ['天花姐','到我。有個女人，供樓供咗三十年……銀行打電話嚟：「加息。」'],
  ['水鬼','（成身打冷震）……','shake'],
  ['阿福','我講個最恐怖嘅。'],
  ['天花姐','講。'],
  ['阿福','星期日夜晚十一點，部電話震咗一下。',null,{ 水鬼:'eek', 天花姐:'eek' },'shake'],
  ['旁白','兩隻鬼當場嚇得躺平。'],
]},
{ id:'hotline', form:'sys', title:'系統客服熱線', need:['ch1_end'], pre:true, lines:[
  ['阿福','我要投訴。'],
  ['系統','叮！歡迎致電陰司 KPI 系統客服熱線～查詢 KPI 請按 1，申請加班請按 2，投訴請按 3。'],
  ['阿福','3。'],
  ['系統','親，投訴熱線暫時繁忙，您是第九千九百九十九位。等候期間，可以按 2 申請加班哦～'],
  ['阿福','我等。'],
  ['系統','親，預計等候時間：三百年。為了不浪費您寶貴的時間，系統已自動幫您按了 2。'],
  ['阿福','……'],
  ['系統','感謝您的來電！您的投訴對我們非常重要，所以我們會好好保存，永遠不處理呢親～'],
]},
{ id:'parcel', title:'11.11 包裹', bg:'village', need:['gift_xiaozhi2'],
  cast:[['牛頭','niutou'],['小紙','xiaozhi']], lines:[
  ['牛頭','小紙！你個包裹！'],
  ['小紙','多謝牛頭大哥！咦，App 話三日前已經派咗喎。'],
  ['牛頭','係呀，我放咗喺你墳頭。'],
  ['小紙','我冇墳㗎，我係紙紮嘅。'],
  ['牛頭','……咁我放咗喺邊呢？','look'],
  ['牛頭','啊！記得喇，我見到個爐好似信箱，就塞咗入去。'],
  ['小紙','嗰個係化寶爐嚟㗎！','eek'],
  ['牛頭','放心，佢會燒返俾你。'],
  ['小紙','入面係我買嘅防火噴霧……'],
  ['牛頭','咁而家你知佢有冇效喇。'],
]},
{ id:'dream', title:'托夢', bg:'village', need:['gift_phone'], src:'su01 清明問萬字・su49 我媽直播帶貨',
  cast:[['小紙','xiaozhi'],['阿福','afu']], lines:[
  ['小紙','少爺，今晚可以托夢，你可以入夫人個夢同佢講兩句。'],
  ['阿福','好。我諗咗好耐要講咩——'],
  ['旁白','阿福一走進夢裡，發現媽媽在夢中……也在看直播。'],
  ['媽','等陣先，三、二、一，上鏈接！'],
  ['小紙','少爺，托夢時間得返一分鐘，你揀一句講。'],
 ], choice:{ q:'只剩一分鐘。你對媽媽說：', a:{ label:'「媽，記得食飯。」', lines:[['旁白','媽媽停下手，看著鏡頭，很久沒有說話。'],['媽','你先係。記得食飯。']], give:() => ({ buns:rwd(16), exp:rwd(4) }) },
   b:{ label:'「媽，下期萬字開 0247。」', lines:[['媽','好！你阿爸會好開心！'],['旁白','第二天早上，阿爸買了一百塊 0247。開彩：7420。'],['小紙','少爺，倒轉咗。']], give:() => ({ coins:rwd(18) }) } } },
{ id:'luckydraw', title:'地府年終晚宴', bg:'hq', need:['ch6_end'],
  cast:[['黃總','huang'],['白無常','baiwu'],['阿福','afu']], lines:[
  ['黃總','各位同事！年終晚宴，lucky draw 時間！'],
  ['黃總','三獎：有薪假一日。得主係……系統！'],
  ['白無常','系統放唔到假喎。'],
  ['黃總','所以話係心意。二獎：投胎優先證。得主……我外母。','golf'],
  ['阿福','你外母都喺下面？'],
  ['黃總','佢喺上面。佢係贊助人。'],
  ['白無常','咁頭獎呢？'],
  ['黃總','頭獎由我自己抽中，呢個叫 synergy。最後，所有冇抽中嘅同事都有份紀念品——','wave'],
  ['黃總','明年嘅 KPI。'],
]},
{ id:'hiring', title:'河底招聘', bg:'field', need:['ch4_end'],
  cast:[['水鬼','shuigui'],['阿福','afu']], lines:[
  ['水鬼','阿福，幫我睇吓份招聘廣告。三年都冇鬼 apply。','shake'],
  ['阿福','（讀出嚟）「誠聘河底巡邏員，限鬼。包食包住，永久合約，廿四小時候命。」'],
  ['水鬼','條件好好喎。'],
  ['阿福','你寫「廿四小時候命」，冇鬼敢嚟。'],
  ['水鬼','咁點寫？'],
  ['阿福','寫「work-life balance」、「彈性上班」、「年輕有活力嘅團隊」。'],
  ['旁白','水鬼照著改了。第二天早上，收到三百份 CV。'],
  ['水鬼','全部都係過勞死嘅……佢哋話，揀河底係因為部電話收唔到訊號。'],
]},
{ id:'smile', title:'黑無常學笑', bg:'village', need:['gift_xiaozhi2'],
  cast:[['白無常','baiwu'],['黑無常','heiwu'],['小紙','xiaozhi']], lines:[
  ['白無常','師弟，上頭做咗客戶滿意度調查。你嘅分數：零點三。'],
  ['黑無常','滿分呢？'],
  ['白無常','十分。客戶話你太嚴肅，要多啲笑容。嚟，跟住我笑：一見——生財！','wave'],
  ['黑無常','……'],
  ['白無常','嘴角向上。'],
  ['旁白','黑無常慢慢咧開了嘴。'],
  ['小紙','少爺——救命呀——！','eek',null,'flash'],
  ['白無常','好啲喇！以前啲客係悶死，而家起碼係嚇死。','laugh'],
  ['黑無常','天下太平。'],
]},
{ id:'debt', title:'討債鬼上門', bg:'village', need:['ch1_end'],
  cast:[['討債鬼','n30_taozhai'],['阿福','afu']], lines:[
  ['討債鬼','陳大福！還錢！你張信用卡欠四千二！','n30:knock'],
  ['阿福','我死咗喇。'],
  ['討債鬼','死咗都要還。利息照計，日日複息。','n30:shake'],
  ['阿福','我冇錢。'],
  ['討債鬼','冇問題，我哋有分期：分一千年，月供一蚊。'],
  ['阿福','……咁又幾抵。'],
  ['討債鬼','仲有，你個 PTPTN。'],
  ['阿福','我死咗都仲未還完？','startle'],
  ['討債鬼','PTPTN 係世上唯一一樣嘢，長命過我哋鬼。'],
]},
{ id:'gambler', title:'買字', bg:'village', need:['ch1_end'],
  cast:[['賭鬼','n30_dugui'],['阿福','afu']], lines:[
  ['賭鬼','阿福！你死咗冇耐，同上面仲有感應。報個字嚟！','n30:shuffle'],
  ['阿福','我生前連自己幾時死都唔知，點知開咩字？'],
  ['賭鬼','咁你幾點死㗎？'],
  ['阿福','兩點四十七分。'],
  ['賭鬼','0247！今鋪一定翻本！','n30:dice'],
 ], choice:{ q:'賭鬼邀你合資買 0247。', a:{ label:'合資', lines:[['旁白','開彩：7420。'],['賭鬼','又差少少！我呢世人，次次都係差少少！','n30:shuffle'],['阿福','你呢世人已經完咗喇。'],['賭鬼','所以下世一定翻本！']], give:() => ({ exp:rwd(6) }) },
   b:{ label:'不合資', lines:[['賭鬼','你唔夾，咁你就錯過咗成個人生！'],['阿福','我冇人生喇。'],['賭鬼','……咁你錯過咗成個死後。']], give:() => ({ coins:rwd(14) }) } } },
{ id:'hotdesk', title:'Hot desking', bg:'hq', need:['ch3_end','side_tianhua'],
  cast:[['白無常','baiwu'],['老殭','laojiang'],['天花姐','tianhua']], lines:[
  ['白無常','通告！地府集團實行 hot desking，以後冇固定座位，先到先得！'],
  ['老殭','本官膝頭唔識彎，從來都冇座位。'],
  ['天花姐','哎喲……我個位係天花板，冇人同我爭。','backrub'],
  ['白無常','天花板都要預約。（睇一睇平板）天花板 A 區，已經畀牛頭訂咗。'],
  ['天花姐','佢上唔到去㗎！'],
  ['白無常','佢訂嚟放雜物。'],
  ['老殭','那本官呢？'],
  ['白無常','大人你企喺度，即係 standing desk。全公司最健康嘅員工。','laugh'],
]},
{ id:'fengshui', title:'陳總嘅風水位', bg:'office', need:['ch1_end'],
  cast:[['阿福','afu'],['小紙','xiaozhi'],['陳總','npc_boss']], lines:[
  ['旁白','回陽間值夜班之前，阿福和小紙在二十三樓等人下班。陳總還沒走。'],
  ['陳總','Master Lee 話呢層陰氣重，叫我多擺三個水晶球。'],
  ['阿福','（細細聲）佢睇唔到我哋。'],
  ['小紙','少爺，佢將個水晶球擺咗喺你以前個位。'],
  ['陳總','Master Lee 仲話，以前有個員工喺呢度過咗身，佢個位風水最好——旺老細。'],
  ['阿福','……我個位旺佢？','startle'],
  ['陳總','由聽日開始，我坐呢個位。不過張櫈要換，坐過死人嘅櫈，唔吉利。'],
  ['小紙','少爺，佢要你嘅運，唔要你張櫈。'],
]},
{ id:'radio', form:'radio', title:'午夜怪談熱線 FM 4.44', need:['ch5_end','ch3_end'], lines:[
  ['DJ','午夜怪談熱線 FM 4.44。今晚個題目：「你最近有咩煩惱？」第一位聽眾。'],
  ['Penanggal','DJ，我個頭夜晚出去巡村，返到屋企，發現個身俾人移咗位。'],
  ['DJ','有冇報警？'],
  ['Penanggal','有。警察叫我出示身份證。張身份證喺個身度。'],
  ['DJ','明白。下一位。'],
  ['老殭','本官想問，世上有冇一種床，企住都瞓得著？'],
  ['DJ','有，叫 LRT 繁忙時間。最後一位。'],
  ['阿福','DJ，我死咗之後終於唔使返工，但係我瞓唔著。'],
  ['DJ','點解？'],
  ['阿福','我習慣咗每晚兩點四十七分醒一醒，睇吓老細有冇 WhatsApp。'],
  ['DJ','……下一首歌，送俾陳先生。祝你早日失憶。'],
]},
{ id:'hrmail', form:'mail', title:'收件匣', need:['ch6_intro'], pre:true, lines:[
  ['寄件人','地府集團人力資源部'],
  ['主旨','七月出差安排（請勿回覆）'],
  ['內文','各位同事：鬼門開放期間，全體員工須返回陽間出差三十日。交通津貼：零。膳食：自行尋找供奉。如家屬沒有燒東西，屬個人問題，公司概不負責。'],
  ['內文','另外，今年起出差也須打卡。打卡機設於陽間各大十字路口，遲到三次視為自動離職，下輩子再見。'],
  ['附件','七月 KPI.xlsx（三百 MB）'],
]},
{ id:'insure', title:'保障你條釘', bg:'banana', need:['ch4_end'],
  cast:[['遊魂阿強','youhun'],['Pontianak','pontianak']], lines:[
  ['遊魂阿強','Pontianak 小姐，你一百年冇買過保險，好危險㗎！','wave'],
  ['Pontianak','嘻——我已經死咗喇，sayang。','hair'],
  ['遊魂阿強','所以先要買嘛，鬼壽保險！保你後頸枝釘。萬一甩咗，全數賠償，仲包上門釘返。'],
  ['Pontianak','邊個上門？'],
  ['遊魂阿強','我囉。'],
  ['Pontianak','上一個話會嚟嘅男人，我等咗佢成晚。'],
  ['遊魂阿強','放心！我寫明喺條款入面：上門時間，七至十四個工作天。'],
  ['Pontianak','Alamak……你同佢一樣。','hair'],
]},
{ id:'jianshi_mrt', title:'殭屍拍卡', bg:'road', need:['ch3_end'], src:'gh02 殭屍不能彎腰（前提）',
  cast:[['殭屍兵','zombie'],['老殭','laojiang'],['馬面','mamian']], lines:[
  ['馬面','（擋住閘口）兩位大人，過關要拍卡。'],
  ['老殭','本官張卡在此。'],
  ['馬面','拍卡位喺腰咁低，你要彎低身。'],
  ['殭屍兵','……'],
  ['老殭','本官與部下，膝頭腰骨，皆是直的。'],
  ['馬面','咁你哋點樣過咗兩百年關？'],
  ['老殭','跳過去。'],
  ['馬面','我守咗咁多年閘口，第一次見有人逃票逃得咁理直氣壯。','look'],
]},
{ id:'attendance', title:'全勤獎', bg:'village', need:['ch2_end'], src:'su36 我還在上班',
  cast:[['阿福','afu'],['冼小姐','npc_hr',{ base:'ag:clip', talk:'ag:glasses' }]], lines:[
  ['冼小姐','親愛嘅同事～好消息！陽間公司嘅 HR 系統同我哋對接咗。你上個月：全勤。'],
  ['阿福','我死咗喎。'],
  ['冼小姐','打卡機每朝八點五十九分都認到你個樣，仲同你講「早晨」。'],
  ['阿福','可能我個樣同死之前冇分別：一樣白，一樣攰，一樣冇表情。'],
  ['冼小姐','年底仲有全勤獎。老細喺台上講：「大家要向佢學習。」台下同事全部低晒頭。'],
  ['阿福','咁人工呢？'],
  ['冼小姐','你死咗第二日已經停咗。成間公司，得呢個部門效率最高。','ag:stamp'],
  ['冼小姐','系統仲幫你打咗今年績效：「符合期望」。'],
  ['阿福','我生前拼死拼活，係「有待改進」。'],
  ['冼小姐','所以你而家先係公司最理想嘅員工：準時出現，唔出聲，唔使出糧。'],
]},
{ id:'ppt', title:'年度報告 PPT', bg:'village', need:['ch6_end'], src:'su48 我的告別式 PPT',
  cast:[['小紙','xiaozhi'],['阿福','afu'],['黃總','huang']], lines:[
  ['黃總','阿福，幫我整份落魄村年度報告 PPT。用公司模板，第一頁標題：「回顧與展望」。'],
  ['阿福','……我喪禮嗰份 PPT，都係用呢個模板。'],
  ['黃總','係咪好有效果？'],
  ['阿福','第三頁有個圖表，我每年 OT 時數，條線一路向上，最後一年斷咗。同事解釋：「呢條係佢嘅成長曲線。」台下有人抄筆記。'],
  ['小紙','少爺，第四頁「主要成就」寫咩？'],
  ['阿福','從不遲到，從不拒絕加班，喺會議上堅持到最後一刻。'],
  ['黃總','好！今次照抄！第五頁「經驗教訓」呢？','golf'],
  ['阿福','上次留空：「呢一頁，留俾大家自己諗。」全場同事第一次真係喺度諗。'],
  ['黃總','今次都留空，慳時間。最後一頁 Q&A。'],
  ['小紙','少爺，上次 Q&A 有冇人問嘢？'],
  ['阿福','有。我表姐舉手：「佢架車而家邊個揸緊？」'],
  ['黃總','（認真咁記低）好問題。架車而家邊個揸緊？'],
]},
{ id:'annual', form:'sys', title:'打工鬼年度報告', need:['ch1_end'], pre:true, src:'su28 打工人年度報告', lines:[
  ['系統','叮！親的《打工鬼年度報告》已生成～'],
  ['系統','本年度，親共回覆「收到」三千一百九十次。最後一次，未送達。'],
  ['阿福','……因為嗰陣我已經走咗。'],
  ['系統','親的加班時數，打敗了全公司 99% 的同事！'],
  ['阿福','剩低嗰 1% 係邊個？'],
  ['系統','是老闆養的魚呢親。牠也從沒下過班。'],
  ['系統','年度關鍵字：「好」。年度歌曲：鍵盤聲。年度最長相處對象：會議室的冷氣。'],
  ['阿福','可唔可以唔分享？'],
  ['系統','已自動分享至全地府，獲得一則留言：「同款。」'],
]},
{ id:'saturday', form:'sys', title:'系統：今日星期六', need:['ch6_reboot'], lines:[
  ['系統','叮。陰司好好系統提醒你：今天是星期六。'],
  ['阿福','咁又點？'],
  ['系統','意思是你可以不用做事呀，親。'],
  ['阿福','……我可以去砍兩棵樹先嗎？'],
  ['系統','為什麼？'],
  ['阿福','唔做嘢，我好驚。'],
  ['系統','親，這叫工傷。陰司好好系統已幫你預約：天花姐，按摩，三點。'],
  ['阿福','佢條腰仲衰過我。'],
  ['系統','所以她最明白你呀，親。'],
]},
];

// ===================== 觸發、存檔、重溫 =====================
const Skits = (() => {
  const OVERLAYS = ['#sheet', '#battle', '#scare', '#world', '#gyard', '#gstreet', '#dlg', '#phone', '#title', '#su-pick', '#webov'];
  let lastInput = 0, wasBattle = false, started = false;
  function st() {
    if (typeof S === 'undefined' || !S) return null;
    const s = S.skit = S.skit || {};
    s.seen = s.seen || {}; s.cyc = s.cyc || {}; if (typeof s.act !== 'number') s.act = 0; if (typeof s.next !== 'number') s.next = 100; s.n = s.n || 0; s.last = s.last || '';
    return s;
  }
  const seen = (id) => !!(S && S.seen && S.seen[id]);
  function artOk(sk) { return !sk.cast || sk.cast.every(c => typeof sprOk !== 'function' || sprOk(c[1])); }
  function ok(sk) {
    if (!S) return false;
    if (sk.need && !sk.need.every(seen)) return false;
    if (sk.pre && S.ended) return false;
    return artOk(sk);
  }
  function quiet() {
    if (typeof S === 'undefined' || !S || !seen('prologue_sys')) return false;
    if (document.hidden || Theater.on) return false;
    if (typeof Story !== 'undefined' && Story.busy()) return false;
    if (typeof Battle !== 'undefined' && Battle.active) return false;
    if (typeof Phone !== 'undefined' && Phone.on) return false;
    for (const q of OVERLAYS) { const e = document.querySelector(q); if (e && (e.classList.contains('on') || e.className === 'on')) return false; }
    return true;
  }
  function pickNext() {
    const s = st(), pool = SKITS.filter(ok); if (!pool.length) return null;
    let fresh = pool.filter(k => !s.cyc[k.id]);
    if (!fresh.length) { s.cyc = {}; fresh = pool.filter(k => k.id !== s.last); if (!fresh.length) fresh = pool; } // 全部睇晒：新一輪（唔會即刻重播上一段）
    const unseen = fresh.filter(k => !s.seen[k.id]); const from = unseen.length ? unseen : fresh; // 未睇過嘅優先
    return from[Math.floor(Math.random() * from.length)];
  }
  function storyScene(sk) {
    const base = { style:sk.form, title:sk.title, lines:sk.lines };
    if (sk.form === 'chat') Object.assign(base, { group:sk.group, av:sk.av });
    return base;
  }
  function reward(sk, ch) {
    const o = ch && sk.choice && sk.choice[ch]; if (!o || !o.give) return '';
    const r = o.give(); return r ? give(r) : '';
  }
  function play(sk, replay) {
    if (typeof sk === 'string') sk = SKITS.find(k => k.id === sk); if (!sk) return false;
    const s = st(); const first = s && !s.seen[sk.id];
    const finish = (res) => {
      if (s) { s.seen[sk.id] = 1; s.cyc[sk.id] = 1; s.last = sk.id; s.n++; }
      if (!replay && first && res && !res.skipped && res.choice) { const txt = reward(sk, res.choice); if (txt) Fx.toast(`陰間日常：<b>${txt}</b>`); UI.refresh && UI.refresh(); }
      try { save(); } catch (e) {}
    };
    if (sk.form) { Story.queue(storyScene(sk), () => finish({ skipped:false })); return true; }
    Theater.play({ tag:'陰間日常', title:sk.title, bg:sk.bg, cast:sk.cast, lines:sk.lines, choice:sk.choice }, finish);
    return true;
  }
  // 每秒檢查一次：有操作嘅時間先計；夠鐘又安靜就嚟一段
  function tick() {
    const s = st(); if (!s) return;
    const bat = typeof Battle !== 'undefined' && Battle.active;
    if (wasBattle && !bat) s.act = Math.max(s.act, s.next - 25); // 打完仗返到村：一陣就嚟
    wasBattle = bat;
    if (!quiet()) return;
    if (Date.now() - lastInput > 40000) return; // 放低咗部機：唔計
    s.act += 1;
    if (typeof Rivals !== 'undefined' && Rivals.tick()) { s.act = Math.min(s.act, Math.max(0, s.next - 90)); return; } // 死對頭（rivals.js）先問
    if (s.act >= s.next) { const sk = pickNext(); s.act = 0; s.next = 170 + Math.floor(Math.random() * 110); if (sk) play(sk); }
  }
  function nudge(sec) { const s = st(); if (s) s.act = Math.max(s.act, s.next - sec); }
  function init() {
    if (started) return; started = true;
    if (typeof Story !== 'undefined' && Story.showLine) { // 對白語言：Story 每顯示一句，用 L() 換成揀咗嘅語言（保留 WhatsApp 嘅時間）
      const osl = Story.showLine;
      Story.showLine = function () {
        const c = this.cur;
        if (c && c.sc && c.sc.lines) {
          if (!c.orig) c.orig = c.sc;
          const tr = (raw) => { const m = typeof raw === 'string' && raw.match(/^(\d\d:\d\d)\|(.*)$/); return m ? m[1] + '|' + L(m[2]) : L(raw); };
          c.sc = Object.assign({}, c.orig, { lines:c.orig.lines.map(l => [l[0], tr(l[1])].concat(l.slice(2))) });
        }
        return osl.apply(this, arguments);
      };
    }
    const mark = () => { lastInput = Date.now(); };
    ['pointerdown', 'keydown', 'wheel'].forEach(ev => document.addEventListener(ev, mark, true));
    setInterval(tick, 1000);
    if (typeof Quest !== 'undefined' && Quest.complete) { const oc = Quest.complete; Quest.complete = function () { const r = oc.apply(this, arguments); nudge(35); return r; }; } // 完成任務：早啲嚟
    if (typeof UI !== 'undefined' && UI.openStory) { // 劇情頁：重溫睇過嘅陰間日常
      const os = UI.openStory; UI.openStory = function () { const r = os.apply(this, arguments); try { Skits.storyHook(); } catch (e) {} return r; };
    }
  }
  function storyHook() {
    const body = document.querySelector('#sheet .sh-body'), hr = body && body.querySelector('hr'); if (!hr) return;
    const s = st(); const list = SKITS.filter(k => s.seen[k.id]);
    const div = document.createElement('div');
    div.innerHTML = `<h4 class="stand-h">陰間日常</h4><p class="desc">在村子裡玩，偶爾會上演一段。看過的可以在這裡重溫（${list.length}/${SKITS.length}）。</p><div class="slist">${list.map(k => `<button class="btn wide" data-skit="${k.id}">${L(k.title)}</button>`).join('') || '<p class="desc">還沒看過。在村子裡多玩一會兒。</p>'}</div>`;
    hr.parentNode.insertBefore(div, hr);
    div.querySelectorAll('[data-skit]').forEach(b => b.onclick = () => { UI.close(); setTimeout(() => play(b.dataset.skit, true), 60); });
  }
  return { st, ok, play, tick, nudge, init, storyHook, pickNext, quiet, list:SKITS };
})();
Skits.init();
