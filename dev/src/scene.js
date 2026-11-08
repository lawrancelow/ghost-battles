// ===================== 場景：用 ChatGPT 蠟筆畫素材取代程序繪製（建築、樹、稻田、道具、烏鴉、背景）=====================
const SCENE = (() => {
  const img = (n) => { const s = (typeof SPR !== 'undefined') && SPR[n]; return s && s.complete && s.naturalWidth ? s : null; };
  // 以底邊中心 (x,y) 畫一張圖，寬 w；回傳實際矩形
  function put(ctx, im, x, y, w, h) {
    if (!h) h = w * im.naturalHeight / im.naturalWidth;
    if (!w) w = h * im.naturalWidth / im.naturalHeight;
    ctx.drawImage(im, x - w / 2, y - h, w, h); return { x:x - w / 2, y:y - h, w, h };
  }
  const SERIF = '"Songti TC","Noto Serif CJK TC","Noto Serif TC","STSong",serif';
  // 建築寬度（世界座標）與牌匾位置（佔圖片比例：中心 x、中心 y、牌匾寬）
  const BW = { house:150, gate:124, plank:106, bun:106, wood:108, rice:108, store:112, home:104, camp:108, altar:104, furnace:62 };
  const PLAQUE = { house:[0.47, 0.49, 0.24], gate:[0.50, 0.36, 0.30], plank:[0.44, 0.36, 0.32], store:[0.48, 0.43, 0.33], wood:[0.40, 0.36, 0.26] };
  function lvBadge(ctx, x, y, lv) {
    ctx.save(); ctx.translate(x, y); ctx.rotate(0.12);
    ART.rr(ctx, -1, -8, 22, 16, 2, '#c2362b', '#f0c8b4', 1);
    ctx.fillStyle = '#fff3e0'; ctx.font = '900 10px sans-serif'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(lv, 10, 0.5); ctx.restore();
  }
  // 在畫裡那塊空白牌匾上寫字
  function plaqueText(ctx, r, p, text, lv) {
    const cx = r.x + r.w * p[0], cy = r.y + r.h * p[1], pw = r.w * p[2];
    let fs = Math.min(15, pw / (text.length * 1.08)); fs = Math.max(7, fs);
    ctx.save(); ctx.font = `900 ${fs}px ${SERIF}`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.lineWidth = Math.max(2, fs * 0.28); ctx.strokeStyle = 'rgba(40,20,8,.95)'; ctx.lineJoin = 'round';
    ctx.strokeText(text, cx, cy + 0.5); ctx.fillStyle = '#f6d58a'; ctx.fillText(text, cx, cy + 0.5); ctx.restore();
    if (lv) lvBadge(ctx, cx + pw / 2 - 2, cy - 9, lv);
  }
  // 沒有牌匾的建築：在前方插一塊小木牌
  function signBoard(ctx, x, y, text, lv) {
    ctx.save(); ctx.font = `900 11.5px ${SERIF}`; const w = ctx.measureText(text).width + 14;
    ART.rr(ctx, x - 1.5, y - 6, 3, 10, 1, '#4a3020');
    ART.rr(ctx, x - w / 2, y - 21, w, 16, 2, '#7a5634', '#2a1a0e', 1.4);
    ctx.fillStyle = 'rgba(255,230,180,.15)'; ctx.fillRect(x - w / 2 + 2, y - 19, w - 4, 2);
    ctx.fillStyle = '#f6e2b0'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(text, x, y - 12.5); ctx.restore();
    if (lv) lvBadge(ctx, x + w / 2 - 1, y - 23, lv);
  }
  const origBuilding = ART.drawBuilding, origTree = ART.drawTree, origPaddy = ART.drawPaddy, origGate = ART.drawGate, origDecor = ART.drawDecor, origCrow = ART.drawCrow;
  ART.drawBuilding = function (ctx, id, x, y, lv, t, extra) {
    const im = img(id); if (!im) return origBuilding(ctx, id, x, y, lv, t, extra);
    ART.el(ctx, x, y + 1, BW[id] * 0.44, 7, 'rgba(0,0,0,.28)');
    const r = put(ctx, im, x, y + 6, BW[id]);
    const name = BUILDINGS[id].name;
    if (PLAQUE[id]) plaqueText(ctx, r, PLAQUE[id], name, lv);
    else signBoard(ctx, x + (id === 'furnace' ? 0 : BW[id] * 0.30), y + 12, name, lv);
    if (id === 'furnace' && extra) { // 爐火正旺
      const fx = r.x + r.w * 0.5, fy = r.y + r.h * 0.62, a = 0.35 + Math.sin(t * 7) * 0.12;
      const g = ctx.createRadialGradient(fx, fy, 2, fx, fy, 30); g.addColorStop(0, `rgba(255,170,60,${a})`); g.addColorStop(1, 'rgba(255,170,60,0)');
      ctx.fillStyle = g; ctx.fillRect(fx - 30, fy - 30, 60, 60);
    }
  };
  ART.drawGate = function (ctx, x, y, t) {
    const im = img('gate'); if (!im) return origGate(ctx, x, y, t);
    const r = put(ctx, im, x, y + 6, BW.gate); plaqueText(ctx, r, PLAQUE.gate, '出村', 0);
    if (typeof Guide !== 'undefined') Guide.drawGateDot(ctx, r.x + r.w * 0.78, r.y + r.h * 0.52, t); // 有新地方未去過：紅點
  };
  // 槐樹：有沒烏鴉的樹就另外畫停著的烏鴉；砍倒畫樹樁
  const PERCH = [[-0.22, 0.40, 1], [0.24, 0.30, -1]];
  ART.drawTree = function (ctx, x, y, hp, t, shake, perched, idx) {
    if (hp <= 0) { const st = img('stump'); if (!st) return origTree(ctx, x, y, hp, t, shake, perched, idx); put(ctx, st, x, y + 3, 38); return; }
    const bare = img('tree_bare'), full = img('tree'); if (!full && !bare) return origTree(ctx, x, y, hp, t, shake, perched, idx);
    const sx = shake ? Math.sin(t * 60) * 2.2 : 0, H = 80 + ((idx || 0) % 3) * 4;
    ART.el(ctx, x, y + 2, 20, 5, 'rgba(0,0,0,.35)');
    ctx.save(); if (shake) { ctx.translate(x, y); ctx.rotate(Math.sin(t * 60) * 0.02); ctx.translate(-x, -y); }
    const tree = bare || full, flip = (idx || 0) % 2 === 1;
    if (flip) { ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0); }
    const r = put(ctx, tree, x + sx, y + 4, 0, H);
    ctx.restore();
    if (bare && perched) { const cs = img('crowsit'); if (cs) PERCH.forEach(([fx, fy, d]) => { const cx = x + r.w * fx * (flip ? -1 : 1) + sx, cy = r.y + r.h * fy; ctx.save(); ctx.translate(cx, cy); ctx.scale(d * (flip ? -1 : 1), 1); put(ctx, cs, 0, 0, 13); ctx.restore(); }); }
  };
  ART.drawPaddy = function (ctx, x, y, ripe, t, i) {
    const ripeIm = img('paddy'), cut = img('paddy_cut'); if (!ripeIm) return origPaddy(ctx, x, y, ripe, t, i);
    if (ripe) { put(ctx, ripeIm, x, y + 9, 56); return; }
    if (cut) { put(ctx, cut, x, y + 9, 56); return; }
    ctx.save(); ctx.globalAlpha = 0.55; ctx.filter = 'brightness(.55) saturate(.4)'; put(ctx, ripeIm, x, y + 9, 56, 34); ctx.restore();
  };
  const DECO = { scarecrow:['scarecrow', 0, 62], grave:['grave', 26, 0], post:['lamppost', 0, 46], banana:['banana', 0, 64] };
  ART.drawDecor = function (ctx, kind, x, y, t) {
    const d = DECO[kind]; const im = d && img(d[0]);
    if (!im) return origDecor(ctx, kind, x, y, t);
    if (kind === 'banana') { ctx.save(); ctx.translate(x, y); ctx.rotate(Math.sin(t * 0.8 + x) * 0.02); put(ctx, im, 0, 2, d[1], d[2]); ctx.restore(); return; }
    if (kind === 'scarecrow') { ctx.save(); ctx.translate(x, y); ctx.rotate(Math.sin(t * 0.9) * 0.03); put(ctx, im, 0, 4, d[1], d[2]); ctx.restore(); return; }
    put(ctx, im, x, y + 3, d[1], d[2]);
    if (kind === 'post') { const a = 0.22 + Math.sin(t * 2 + x) * 0.06; const g = ctx.createRadialGradient(x + 6, y - 30, 1, x + 6, y - 30, 18); g.addColorStop(0, `rgba(255,236,190,${a})`); g.addColorStop(1, 'rgba(255,236,190,0)'); ctx.fillStyle = g; ctx.fillRect(x - 14, y - 50, 40, 40); }
  };
  // 烏鴉：飛的用 crowfly（上下壓扁做拍翅），停著的用 crowsit
  ART.drawCrow = function (ctx, x, y, s, ph, dir, perched) {
    const im = img(perched ? 'crowsit' : 'crowfly'); if (!im) return origCrow(ctx, x, y, s, ph, dir, perched);
    ctx.save(); ctx.translate(x, y); ctx.scale(dir < 0 ? -1 : 1, perched ? 1 : 0.55 + Math.abs(Math.sin(ph)) * 0.55);
    const w = (perched ? 12 : 20) * s; const h = w * im.naturalHeight / im.naturalWidth; ctx.drawImage(im, -w / 2, -h / 2, w, h); ctx.restore();
  };
  // 背景：cover 方式鋪滿
  function drawBg(ctx, w, h, bg) {
    const im = img('bg_' + bg); if (!im) return false;
    const s = Math.max(w / im.naturalWidth, h / im.naturalHeight), iw = im.naturalWidth * s, ih = im.naturalHeight * s;
    ctx.drawImage(im, (w - iw) / 2, (h - ih) / 2, iw, ih);
    const v = ctx.createLinearGradient(0, 0, 0, h); v.addColorStop(0, 'rgba(10,8,14,.18)'); v.addColorStop(0.5, 'rgba(10,8,14,0)'); v.addColorStop(1, 'rgba(10,8,14,.32)');
    ctx.fillStyle = v; ctx.fillRect(0, 0, w, h); return true;
  }
  return { drawBg, img };
})();
