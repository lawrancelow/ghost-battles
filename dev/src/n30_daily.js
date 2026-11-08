// ===================== 新鬼 40 隻：平日小動作（村裡／廣場閒著時）=====================
// DAILY['n30_<id>_<動作>']，用法同其他 daily：o.act = 動作名、o.at = 做了幾秒（會循環）。全部是原圖網格變形＋蠟筆小特效。
// N30D.ACTS[id] = [[動作名, 中文名, 一輪秒數, 說明], …]（樣板頁、之後接到廣場用）。刪一隻 = 刪它那一段 A('id', …)。
const N30D = (() => {
  const ACTS = {}, N = N30K, PI = Math.PI, TAU = PI * 2;
  const sw = (g, n, ph) => Math.sin(g * TAU * (n || 1) + (ph || 0));
  const env = (g, a, b, c, d) => N.E.io(N.seg(g, a, b)) * (1 - N.E.io(N.seg(g, c, d))); // a→b 進、c→d 出
  const bump = (g, a, b) => Math.sin(N.seg(g, a, b) * PI);
  function A(id, act, zh, dur, desc, fr, fx, idleK) {
    const key = 'n30_' + id + '_' + act; (ACTS[id] = ACTS[id] || []).push([key, zh, dur, desc]);
    DAILY[key] = function (ctx, a) {
      const S = N.setup(a); if (!S) return false;
      const H = S.H, at = a.o.at || 0, g = (at % dur) / dur, f = fr(g, H, S) || {};
      const m = N.bm(S, f);
      ctx.save(); N.K.enter(ctx, S); N.shadow(ctx, S, f.x || 0, 0, 1 - N.cl(-(f.y || 0) / H) * 0.5);
      if (fx && fx.pre) fx.pre(ctx, S, g, m, f, H);
      N.body(ctx, S, m, N.pose(S, f, idleK == null ? 1 : idleK), null, f.a != null ? f.a : null);
      const post = fx && (fx.post || (typeof fx === 'function' ? fx : null)); if (post) post(ctx, S, g, m, f, H);
      ctx.restore();
    };
  }
  const T = (ctx, S, x, y, s, str, col, al) => N.txt(ctx, S, x, y, str, s, col, al);
  const note = (ctx, S, p, g, a, b, H, col) => { const q = N.seg(g, a, b); if (q > 0 && q < 1) T(ctx, S, p[0] + q * 0.12 * H, p[1] - q * 0.2 * H, 0.09 * H, q < 0.5 ? '♪' : '♫', col || '#cfe8ff', Math.sin(q * PI)); };
  const zz = (ctx, S, p, g, H) => { for (let i = 0; i < 3; i++) { const q = (g * 2 + i / 3) % 1; T(ctx, S, p[0] + q * 0.12 * H, p[1] - q * 0.25 * H, (0.06 + i * 0.02) * H, 'z', '#c8d8ff', Math.sin(q * PI)); } };
  const sweat = (ctx, S, p, g, H) => N.drops(ctx, p[0], p[1], 0.25 * H, (g * 3) % 1, 'rgba(150,210,255,.9)', Math.floor(g * 3) * 7, 3);
  const flake = (ctx, x, y, r, rot, al) => { ctx.save(); ctx.globalAlpha *= al; ctx.translate(x, y); ctx.rotate(rot); ctx.strokeStyle = '#eaf6ff'; ctx.lineWidth = r * 0.22; ctx.lineCap = 'round'; ctx.beginPath(); for (let k = 0; k < 3; k++) { const an = k * PI / 3; ctx.moveTo(-Math.cos(an) * r, -Math.sin(an) * r); ctx.lineTo(Math.cos(an) * r, Math.sin(an) * r); } ctx.stroke(); ctx.restore(); };
  const coin = (ctx, x, y, r, sx) => { ctx.save(); ctx.translate(x, y); ctx.scale(sx, 1); ctx.fillStyle = '#e8b84a'; ctx.strokeStyle = '#6a4a10'; ctx.lineWidth = r * 0.18; ctx.beginPath(); ctx.arc(0, 0, r, 0, 7); ctx.fill(); ctx.stroke(); ctx.strokeRect(-r * 0.3, -r * 0.3, r * 0.6, r * 0.6); ctx.restore(); };
  const card = (ctx, x, y, w, rot, red) => { ctx.save(); ctx.translate(x, y); ctx.rotate(rot); ctx.fillStyle = '#fbf6ea'; ctx.strokeStyle = '#3a2a2a'; ctx.lineWidth = w * 0.1; ctx.beginPath(); ctx.roundRect(-w / 2, -w * 0.7, w, w * 1.4, w * 0.15); ctx.fill(); ctx.stroke(); ctx.fillStyle = red ? '#c8202a' : '#222'; ctx.font = `900 ${w * 0.8}px sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillText(red ? '♥' : '♠', 0, 0); ctx.restore(); };
  const at = (S, m, u, v) => N.at(S, m, u, v);

  // ---------- 吊死鬼 ----------
  A('diaosi', 'swing', '晃來晃去', 3.6, '像還吊著一樣，整個人慢慢鐘擺晃，繩子跟著甩。', (g, H) => ({ r:sw(g) * 6, px:0, py:-1.2 * H, rope:sw(g, 1, 0.8) * 0.4, head:sw(g, 1, 0.5) * 0.1 }));
  A('diaosi', 'tongue', '甩舌頭', 2.4, '頭左右甩，長舌頭跟著甩，口水亂噴。', (g, H) => ({ head:sw(g, 2) * 0.18 * env(g, 0, 0.1, 0.8, 1), body:sw(g, 2, 0.5) * 0.05 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.42, 0.58); N.drops(ctx, p[0], p[1], 0.25 * H, (g * 2) % 1, 'rgba(200,235,255,.9)', Math.floor(g * 2) * 3, 4); });
  A('diaosi', 'sigh', '嘆氣', 3.2, '肩膀一垂、頭低下去「唉……」。', (g, H) => ({ sy:1 - 0.04 * bump(g, 0.2, 0.8), head:0.2 * bump(g, 0.2, 0.9), armF:0.1 * bump(g, 0.2, 0.8), armB:-0.1 * bump(g, 0.2, 0.8) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.1 * H, '唉……', '#e0e0f0', bump(g, 0.25, 0.85)));
  // ---------- 無頭鬼 ----------
  A('wutou', 'polish', '擦亮自己的頭', 3.0, '另一隻手在捧著的頭上來回擦，擦到發亮。', (g, H) => ({ armF:-0.6 - sw(g, 4) * 0.2, body:-0.04, held:sw(g, 4) * 0.04 }), (ctx, S, g, m, f, H) => { if (g > 0.7) N.burst(ctx, at(S, m, 0.72, 0.38)[0], at(S, m, 0.72, 0.38)[1], 0.1 * H, 1 - (g - 0.7) / 0.3, '#fff6c0', 1, 6); });
  A('wutou', 'smoke', '脖子冒煙', 3.4, '領口一陣一陣冒煙，聳聳肩。', (g, H) => ({ sy:1 + 0.03 * bump(g, 0.1, 0.4), head:sw(g, 2) * 0.1 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.34, 0.2); for (let i = 0; i < 3; i++) N.puff(ctx, p[0], p[1] - 0.05 * H, 0.06 * H, (g + i / 3) % 1, 'rgba(200,200,215,.55)', i * 9, 3); });
  A('wutou', 'nod', '捧著頭點頭', 2.2, '用手把自己的頭上下點兩下，像在跟人打招呼。', (g, H) => ({ armB:sw(g, 2) * 0.12 * env(g, 0, 0.1, 0.8, 1), held:sw(g, 2, 0.5) * 0.15 * env(g, 0, 0.1, 0.8, 1) }));
  // ---------- 夜叉 ----------
  A('yecha', 'flex', '秀肌肉', 2.8, '雙臂一夾、胸口鼓起，紅毛一抖。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { sx:1 + 0.05 * k, sy:1 + 0.02 * k, armF:-0.25 * k, armB:0.3 * k, hairL:-0.2 * k + sw(g, 3) * 0.05, hairR:-0.2 * k }; }, (ctx, S, g, m, f, H) => { if (g > 0.3 && g < 0.7) N.burst(ctx, 0.3 * H, -0.7 * H, 0.12 * H, 1 - (g - 0.3) / 0.4, '#fff0a0', 3, 6); });
  A('yecha', 'scratch', '用叉搔背', 3.0, '鋼叉舉到背後上下搔，舒服到瞇眼扭身。', (g, H) => ({ armF:-0.3 + sw(g, 5) * 0.12, body:sw(g, 5, 1) * 0.04, r:sw(g, 2.5) * 2 }), (ctx, S, g, m, f, H) => T(ctx, S, -0.1 * H, -1.05 * H, 0.09 * H, '啊～', '#ffe0a0', bump(g, 0.4, 0.9)));
  A('yecha', 'roar', '仰天吼', 2.4, '頭往後一仰「吼！」，叉子往地上一頓。', (g, H) => { const k = bump(g, 0.15, 0.6); return { head:-0.3 * k, body:-0.08 * k, armF:0.1 * k, y:-0.02 * H * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.15 * H, -1.1 * H, 0.14 * H, '吼！', '#ff9a6a', bump(g, 0.2, 0.65)));
  // ---------- 旱魃 ----------
  A('hanba', 'fan', '熱到搧風', 2.4, '用手拚命搧臉，滿頭大汗，地上冒熱氣。', (g, H) => ({ armF:-0.8 + sw(g, 6) * 0.25, head:-0.05 }), (ctx, S, g, m, f, H) => { sweat(ctx, S, at(S, m, 0.5, 0.15), g, H); N.puff(ctx, 0.1 * H, -0.03 * H, 0.06 * H, g, 'rgba(255,220,180,.4)', 7, 3); });
  A('hanba', 'thirst', '找水喝', 3.4, '東張西望，舔舔乾裂的嘴「水……」。', (g, H) => ({ head:sw(g, 1) * 0.15, body:sw(g, 1, 0.3) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.3 * H, -1.05 * H, 0.1 * H, '水……', '#ffd0a0', bump(g, 0.3, 0.9)));
  // ---------- 倀鬼 ----------
  A('changgui', 'pet', '摸小老虎', 3.0, '彎腰摸摸小老虎的頭，老虎蹭回去，冒愛心。', (g, H) => ({ armB:-0.25 - sw(g, 3) * 0.08, body:-0.08, tiger:sw(g, 3, 1) * 0.08 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.8, 0.68); T(ctx, S, p[0], p[1] - (g % 0.5) * 0.3 * H, 0.08 * H, '♥', '#ff8aa8', Math.sin((g % 0.5) * 2 * PI)); });
  A('changgui', 'whistle', '吹口哨', 2.6, '手指放嘴邊吹口哨，小老虎跟著搖頭。', (g, H) => ({ armF:-0.7, head:-0.06, tiger:sw(g, 4) * 0.06 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.25, 0.33); note(ctx, S, p, g, 0, 0.5, H); note(ctx, S, p, g, 0.4, 0.9, H); });
  // ---------- 鬼新娘 ----------
  A('guixinniang', 'veil', '整理紅蓋頭', 3.2, '雙手扶一扶蓋頭兩邊，蓋頭輕飄。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { armF:-0.5 * k, armB:-0.5 * k, hairL:sw(g, 2) * 0.08, hairR:sw(g, 2, 1) * 0.08, head:-0.05 * k }; });
  A('guixinniang', 'twirl', '轉一圈', 2.6, '捧著繡球原地轉一圈，裙襬飄、花瓣落。', (g, H) => ({ sx:Math.cos(N.seg(g, 0.2, 0.7) * TAU) * 0.85 + 0.15 * Math.sign(Math.cos(N.seg(g, 0.2, 0.7) * TAU) || 1), hairL:-0.2 * bump(g, 0.2, 0.7), hairR:-0.2 * bump(g, 0.2, 0.7) }), (ctx, S, g, m, f, H) => { for (let i = 0; i < 5; i++) { const q = (g + i / 5) % 1; ctx.save(); ctx.globalAlpha *= Math.sin(q * PI) * 0.8; ctx.fillStyle = '#e8303a'; ctx.beginPath(); ctx.ellipse((i - 2) * 0.12 * H + Math.sin(q * 6) * 0.03 * H, -1.0 * H + q * 0.9 * H, 0.02 * H, 0.012 * H, q * 6, 0, 7); ctx.fill(); ctx.restore(); } });
  A('guixinniang', 'wait', '等新郎', 3.6, '踮著望遠方，嘆一句「良人呢……」。', (g, H) => ({ y:-0.02 * H * bump(g, 0.1, 0.6), head:-0.1 * bump(g, 0.1, 0.6) + sw(g, 1) * 0.05 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.08 * H, 0.09 * H, '老公呢……', '#ffb0b0', bump(g, 0.4, 0.95)));
  // ---------- 山魈 ----------
  A('shanxiao', 'hop', '原地單腳跳', 1.6, '單腳一蹦一蹦，長手跟著甩。', (g, H) => { const u = Math.abs(sw(g, 2)); return { y:-0.1 * H * u, sy:1 + 0.03 * u - (u < 0.15 ? 0.06 : 0), armF:u * 0.3, armB:-u * 0.3 }; });
  A('shanxiao', 'scratch', '抓癢', 2.6, '長手伸到頭頂抓抓抓，毛屑飛。', (g, H) => ({ armB:-1.0 - sw(g, 6) * 0.15, head:0.1 + sw(g, 6) * 0.04 }), (ctx, S, g, m, f, H) => N.puff(ctx, at(S, m, 0.5, 0.05)[0], at(S, m, 0.5, 0.05)[1], 0.05 * H, (g * 2) % 1, 'rgba(160,150,100,.5)', 9, 4));
  A('shanxiao', 'balance', '金雞獨立', 3.0, '單腳站著兩手張開，晃來晃去保持平衡。', (g, H) => ({ armF:-0.6, armB:0.6, r:sw(g) * 7, px:0, py:0 }));
  // ---------- 白骨精 ----------
  A('baigujing', 'hair', '攏頭髮', 3.0, '手指慢慢攏一下鬢髮，髮簪的墜子晃。', (g, H) => ({ armF:-0.4 * env(g, 0.1, 0.35, 0.6, 0.85), head:-0.08 * bump(g, 0.1, 0.85), orn:sw(g, 2) * 0.2 }));
  A('baigujing', 'laugh', '掩嘴笑', 2.4, '手掩著嘴「呵呵呵」，肩膀抖。', (g, H) => ({ armF:-0.3, body:sw(g, 6) * 0.03 * bump(g, 0.1, 0.8), head:sw(g, 6) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '呵呵呵', '#f0e0f0', bump(g, 0.1, 0.85)));
  A('baigujing', 'pose', '擺姿勢', 3.0, '腰一扭、頭一側，自我欣賞。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { r:-5 * k, head:0.15 * k, body:-0.06 * k, armB:0.2 * k }; }, (ctx, S, g, m, f, H) => { if (g > 0.3 && g < 0.6) N.burst(ctx, at(S, m, 0.45, 0.18)[0], at(S, m, 0.45, 0.18)[1], 0.12 * H, 1 - (g - 0.3) / 0.3, '#ffe0f0', 11, 6); });
  // ---------- 窮鬼 ----------
  A('qionggui', 'pockets', '翻空口袋', 2.8, '把兩個口袋翻出來抖一抖，只抖出灰塵。', (g, H) => ({ armF:0.15 + sw(g, 4) * 0.08, armB:-0.15 - sw(g, 4) * 0.08, sy:1 + sw(g, 4) * 0.01 }), (ctx, S, g, m, f, H) => { N.puff(ctx, at(S, m, 0.13, 0.66)[0], at(S, m, 0.13, 0.66)[1], 0.05 * H, (g * 2) % 1, 'rgba(190,175,150,.5)', 13, 3); N.puff(ctx, at(S, m, 0.66, 0.66)[0], at(S, m, 0.66, 0.66)[1], 0.05 * H, (g * 2 + 0.5) % 1, 'rgba(190,175,150,.5)', 14, 3); });
  A('qionggui', 'coin', '只剩一個銅板', 3.2, '翻出一個銅板，對著它嘆氣「一個……」。', (g, H) => ({ armF:-0.5 * env(g, 0.05, 0.2, 0.8, 0.95), head:0.12 }), (ctx, S, g, m, f, H) => { const k = env(g, 0.05, 0.2, 0.8, 0.95); if (k > 0.1) coin(ctx, at(S, m, 0.2, 0.45)[0], at(S, m, 0.2, 0.45)[1] - 0.05 * H * k, 0.035 * H, Math.cos(g * 20)); T(ctx, S, 0.2 * H, -1.0 * H, 0.09 * H, '得一個……', '#e8dcc0', bump(g, 0.3, 0.9)); });
  // ---------- 賭鬼 ----------
  A('dugui', 'shuffle', '洗牌', 2.0, '兩手之間一張張牌飛過去（洗牌），一臉老手。', (g, H) => ({ armF:-0.2 + sw(g, 4) * 0.05, armB:0.15 - sw(g, 4) * 0.05 }), (ctx, S, g, m, f, H) => { const A0 = at(S, m, 0.18, 0.5), B0 = at(S, m, 0.83, 0.43); for (let i = 0; i < 3; i++) { const q = (g * 3 + i / 3) % 1; card(ctx, N.lerp(B0[0], A0[0], q), N.lerp(B0[1], A0[1], q) - Math.sin(q * PI) * 0.15 * H, 0.05 * H, q * 6, i % 2); } });
  A('dugui', 'dice', '擲骰子', 2.8, '骰子往地上一擲，滾幾下，看點數，「六！」興奮。', (g, H) => ({ armF:g < 0.2 ? 0.3 : -0.3, head:0.1 * bump(g, 0.3, 0.9), y:-0.03 * H * bump(g, 0.6, 0.8) }), (ctx, S, g, m, f, H) => { const q = N.seg(g, 0.2, 0.55); if (q > 0) for (let i = 0; i < 2; i++) { const x = 0.15 * H + q * 0.3 * H + i * 0.06 * H, y = -Math.abs(Math.sin(q * 3 * PI)) * 0.12 * H * (1 - q); ctx.save(); ctx.translate(x, y - 0.02 * H); ctx.rotate(q * 12 * (1 - q)); ctx.fillStyle = '#fbf6ea'; ctx.strokeStyle = '#3a2a2a'; ctx.lineWidth = 0.004 * H; ctx.fillRect(-0.02 * H, -0.02 * H, 0.04 * H, 0.04 * H); ctx.strokeRect(-0.02 * H, -0.02 * H, 0.04 * H, 0.04 * H); ctx.restore(); } T(ctx, S, 0.3 * H, -1.05 * H, 0.12 * H, '六！', '#ffd84a', bump(g, 0.6, 0.95)); });
  A('dugui', 'pray', '求神拜佛', 2.6, '雙手合十拜三拜「發發發……」。', (g, H) => ({ armF:-0.45, armB:0.45, body:0.08 * Math.abs(sw(g, 1.5)), head:0.1 * Math.abs(sw(g, 1.5)) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '發發發', '#ffd84a', bump(g, 0.1, 0.9)));
  // ---------- 酒鬼 ----------
  A('jiugui', 'drink', '喝一口', 3.0, '抱著酒埕仰頭灌一口，「嗝～」冒泡泡。', (g, H) => { const k = env(g, 0.1, 0.3, 0.55, 0.7); return { r:-12 * k, head:-0.3 * k, armF:-0.3 * k, armB:-0.3 * k }; }, (ctx, S, g, m, f, H) => { T(ctx, S, 0.2 * H, -1.0 * H, 0.11 * H, '嗝～', '#ffb0c8', bump(g, 0.7, 0.98)); const p = at(S, m, 0.3, 0.3); for (let i = 0; i < 3; i++) { const q = N.seg(g, 0.7 + i * 0.05, 1); if (q > 0 && q < 1) N.ring(ctx, p[0], p[1] - q * 0.3 * H, 0.025 * H, 0.025 * H, 'rgba(200,220,255,.8)', 0.007 * H, 1 - q); } });
  A('jiugui', 'sway', '醉醺醺晃', 3.4, '東倒西歪，差點跌倒又站穩。', (g, H) => ({ r:sw(g) * 10 + sw(g, 3) * 3, px:0, py:0, head:sw(g, 1, 1) * 0.15 }));
  A('jiugui', 'sing', '唱歌', 2.8, '抱著酒埕打拍子唱歌，頭一點一點。', (g, H) => ({ head:sw(g, 4) * 0.1, body:sw(g, 4) * 0.03 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.28, 0.28); note(ctx, S, p, g, 0, 0.5, H, '#ffd0e0'); note(ctx, S, p, g, 0.45, 0.95, H, '#ffd0e0'); });
  // ---------- 煙鬼 ----------
  A('yangui', 'puff', '吐煙圈', 3.2, '煙斗湊到嘴邊吸一口，吐出三個煙圈慢慢飄走。', (g, H) => ({ armB:-0.25 * env(g, 0.05, 0.2, 0.35, 0.5), sy:1 + 0.03 * bump(g, 0.1, 0.4) }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.56, 0.36); for (let i = 0; i < 3; i++) { const q = N.seg(g, 0.45 + i * 0.08, 1); if (q > 0 && q < 1) N.ring(ctx, p[0] + q * 0.4 * H, p[1] - q * 0.3 * H, 0.04 * H * (1 + q), 0.02 * H * (1 + q), 'rgba(210,210,220,.85)', 0.015 * H, 1 - q); } });
  A('yangui', 'cough', '咳不停', 2.4, '彎腰咳咳咳，咳到整個人抖。', (g, H) => ({ body:0.15 * Math.abs(sw(g, 3)), head:0.15 * Math.abs(sw(g, 3)), r:3 * Math.abs(sw(g, 3)) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.3 * H, -0.95 * H, 0.1 * H, '咳咳！', '#d0d0d8', Math.abs(sw(g, 1.5))));
  // ---------- 孤寒鬼 ----------
  A('guhangui', 'count', '數錢', 3.0, '銅錢舉起來對著光看，一枚一枚數「一、二……」。', (g, H) => ({ armF:-0.2 + sw(g, 3) * 0.08, head:-0.05 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.18, 0.36); if (sw(g, 3) > 0.7) N.burst(ctx, p[0], p[1], 0.08 * H, (sw(g, 3) - 0.7) / 0.3, '#fff0a0', 17, 6); T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, ['一', '二', '三'][Math.floor(g * 3)] + '……', '#ffe08a', 0.9); });
  A('guhangui', 'abacus', '打算盤', 2.4, '算盤搖得嘩啦響，手指撥珠「啪啪啪」。', (g, H) => ({ armB:sw(g, 8) * 0.05, head:0.08 }), (ctx, S, g, m, f, H) => T(ctx, S, at(S, m, 0.66, 0.4)[0], at(S, m, 0.66, 0.4)[1] - 0.12 * H, 0.07 * H, '啪', '#ffe08a', Math.abs(sw(g, 4))));
  A('guhangui', 'bite', '咬錢驗真', 2.8, '銅錢放到嘴邊咬一口驗真假，滿意點頭。', (g, H) => { const k = env(g, 0.1, 0.3, 0.6, 0.8); return { armF:-0.6 * k, head:0.1 * k + 0.1 * bump(g, 0.75, 0.95) }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, '真㗎！', '#ffe08a', bump(g, 0.7, 1)));
  // ---------- 討債鬼 ----------
  A('taozhai', 'shake', '抖欠單', 2.4, '欠單舉高猛抖，一臉兇。', (g, H) => ({ armF:sw(g, 6) * 0.1, paper:sw(g, 6, 1) * 0.2, head:0.05 }));
  A('taozhai', 'knock', '拍門追數', 2.8, '對著空氣拍門「開門！還錢！」。', (g, H) => ({ armB:-0.6 + Math.abs(sw(g, 3)) * 0.3 * env(g, 0, 0.1, 0.7, 0.9), r:2 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.35 * H, -1.05 * H, 0.1 * H, '開門！還錢！', '#ff5050', bump(g, 0.1, 0.9)));
  A('taozhai', 'paint', '刷紅油', 3.0, '油漆刷沾一沾，在地上刷個「債」字。', (g, H) => ({ armB:-0.3 - sw(g, 3) * 0.2, body:0.12, head:0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.45 * H, -0.04 * H, 0.12 * H, '債', '#c8141e', N.cl(g * 1.5)));
  // ---------- 膽小鬼 ----------
  A('danxiao', 'shiver', '抖抖抖', 2.0, '抱著自己猛抖，汗一直流。', (g, H) => ({ x:sw(g, 18) * 0.012 * H, head:sw(g, 15) * 0.03, sy:1 - 0.02 }), (ctx, S, g, m, f, H) => sweat(ctx, S, at(S, m, 0.5, 0.15), g, H));
  A('danxiao', 'peek', '偷看', 3.0, '慢慢探頭往前看……「有、有鬼？」。', (g, H) => { const k = env(g, 0.1, 0.4, 0.7, 0.9); return { r:8 * k, head:0.2 * k, x:0.03 * H * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.35 * H, -1.05 * H, 0.09 * H, '有、有鬼呀？', '#bfe0ff', bump(g, 0.35, 0.85)));
  A('danxiao', 'startle', '自己嚇自己', 2.2, '踩到自己影子嚇一跳「哇！」跳起來。', (g, H) => { const j = bump(g, 0.2, 0.45); return { y:-0.18 * H * j, armF:-0.6 * j, armB:0.6 * j, sy:1 + 0.06 * j }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.15 * H, 0.12 * H, '哇！', '#ffffff', bump(g, 0.2, 0.6)));
  // ---------- 冒失鬼 ----------
  A('maoshi', 'trip', '跌倒又爬起', 3.0, '腳一絆整個人往前撲，趴一下，拍拍灰爬起來。', (g, H) => { const d = env(g, 0.1, 0.3, 0.6, 0.85); return { r:70 * d, px:0, py:0, x:0.15 * H * d, armF:-0.8 * d, armB:-0.6 * d }; }, (ctx, S, g, m, f, H) => { N.puff(ctx, 0.5 * H, -0.03 * H, 0.08 * H, N.seg(g, 0.25, 0.6), 'rgba(200,190,170,.55)', 19, 4); T(ctx, S, 0.3 * H, -1.0 * H, 0.1 * H, '哎喲！', '#ffe066', bump(g, 0.15, 0.45)); });
  A('maoshi', 'rub', '揉頭上的包', 2.6, '手按著頭上的包揉，眼冒金星。', (g, H) => ({ armB:-1.0, head:0.08 + sw(g, 4) * 0.03 }), (ctx, S, g, m, f, H) => N.stars(ctx, at(S, m, 0.4, 0.05)[0], at(S, m, 0.4, 0.05)[1], 0.12 * H, g * 3, 0.9));
  // ---------- Hantu Raya ----------
  A('hanturaya', 'loom', '漲大又縮回', 3.4, '黑影慢慢膨脹變高，再縮回來，邊緣黑煙翻滾。', (g, H) => { const k = bump(g, 0.1, 0.9); return { sy:1 + 0.1 * k, sx:1 + 0.05 * k, hairL:0.2 * k, hairR:0.2 * k }; }, { pre:(ctx, S, g, m, f, H) => { const gr = ctx.createRadialGradient(0, -0.5 * H, 0, 0, -0.5 * H, 0.7 * H); gr.addColorStop(0, `rgba(40,20,60,${0.35 * bump(g, 0.1, 0.9)})`); gr.addColorStop(1, 'rgba(40,20,60,0)'); ctx.fillStyle = gr; ctx.fillRect(-0.8 * H, -1.3 * H, 1.6 * H, 1.4 * H); } });
  A('hanturaya', 'wisp', '冒黑煙', 2.8, '肩上一縷縷黑煙往上飄。', (g, H) => ({ hairL:sw(g, 2) * 0.15, hairR:sw(g, 2, 1) * 0.15 }), (ctx, S, g, m, f, H) => { for (let i = 0; i < 4; i++) N.puff(ctx, (i - 1.5) * 0.25 * H, -0.85 * H, 0.08 * H, (g + i / 4) % 1, 'rgba(50,30,70,.45)', 21 + i, 3); });
  // ---------- Polong ----------
  A('polong', 'bob', '在瓶口探頭', 3.0, '縮回瓶口又探出來，左右張望。', (g, H) => ({ tail1:-0.15 * bump(g, 0.1, 0.5), tail2:-0.2 * bump(g, 0.1, 0.5), head:sw(g, 1.5) * 0.15 }));
  A('polong', 'hop', '瓶子跳一跳', 1.8, '整個瓶子蹦兩下，裡面的血絲晃。', (g, H) => { const u = Math.abs(sw(g, 2)); return { y:-0.08 * H * u, sy:1 + 0.04 * u - (u < 0.15 ? 0.06 : 0), tail1:sw(g, 2) * 0.1 }; });
  // ---------- Pelesit ----------
  A('pelesit', 'chirp', '唧唧叫', 2.2, '翅膀快速磨擦「唧唧」，觸鬚抖。', (g, H) => ({ cape:sw(g, 20) * 0.08, hairL:sw(g, 3) * 0.15, hairR:sw(g, 3, 1) * 0.15 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.1 * H, -1.1 * H, 0.18 * H, '唧唧', '#d8e8a0', Math.abs(sw(g, 1))));
  A('pelesit', 'clean', '洗觸鬚', 2.8, '低頭用前腳把觸鬚拉下來清一清。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { head:0.2 * k, hairL:0.5 * k, hairR:0.3 * k, legF:-0.2 * k + sw(g, 4) * 0.05 * k }; });
  A('pelesit', 'hop', '蹦一下', 1.6, '後腿一彈，原地蹦起來。', (g, H) => { const j = bump(g, 0.15, 0.6); return { y:-0.35 * H * j, r:-10 * j, legB:-0.3 * j, sy:1 - 0.12 * bump(g, 0, 0.15) }; });
  // ---------- Jenglot ----------
  A('jenglot', 'hairflip', '甩頭髮', 2.6, '一甩頭，整頭長髮甩到一邊再落回。', (g, H) => { const k = bump(g, 0.1, 0.6); return { head:0.2 * k, hairL:-0.4 * k, hairR:-0.4 * k, r:4 * k }; });
  A('jenglot', 'hiss', '嘶嘶叫', 2.4, '縮著身子露出尖牙「嘶——」。', (g, H) => ({ sy:0.95, head:-0.1, armF:-0.3, armB:0.3, x:sw(g, 10) * 0.005 * H }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -0.95 * H, 0.1 * H, '嘶——', '#d8c8b8', bump(g, 0.1, 0.9)));
  // ---------- Hantu Galah ----------
  A('hantugalah', 'peer', '從高處張望', 3.2, '手搭眉毛從很高的地方往遠處看。', (g, H) => ({ armB:-0.9, head:sw(g, 1) * 0.12, body:0.05 }));
  A('hantugalah', 'stretch', '伸懶腰', 3.0, '本來就很高，伸個懶腰又更高。', (g, H) => { const k = env(g, 0.1, 0.4, 0.6, 0.9); return { sy:1 + 0.06 * k, armF:-0.7 * k, armB:0.7 * k, head:-0.15 * k }; });
  // ---------- Jerangkung ----------
  A('jerangkung', 'rattle', '骨頭喀喀抖', 2.0, '全身骨頭抖一抖、喀喀響。', (g, H) => ({ x:sw(g, 14) * 0.008 * H, head:sw(g, 11) * 0.05, armF:sw(g, 9) * 0.08, armB:sw(g, 10) * 0.08 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.0 * H, 0.09 * H, '喀喀', '#f6efd8', Math.abs(sw(g, 1))));
  A('jerangkung', 'dance', '骷髏舞', 2.4, '扭腰甩手跳一段骷髏舞。', (g, H) => ({ r:sw(g, 2) * 6, px:0, py:0, armF:sw(g, 2) * 0.5, armB:-sw(g, 2) * 0.5, legF:sw(g, 2) * 0.2, legB:-sw(g, 2) * 0.2, y:-Math.abs(sw(g, 4)) * 0.03 * H }), (ctx, S, g, m, f, H) => note(ctx, S, [0.2 * H, -0.9 * H], g, 0, 0.9, H, '#f6efd8'));
  // ---------- Genderuwo ----------
  A('genderuwo', 'chest', '搥胸', 2.2, '兩手輪流搥胸口「咚咚咚」。', (g, H) => ({ armF:-0.5 - Math.max(0, sw(g, 3)) * 0.4, armB:0.5 + Math.max(0, -sw(g, 3)) * 0.4, head:-0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.3 * H, -1.05 * H, 0.1 * H, '咚咚', '#ffcf80', Math.abs(sw(g, 3))));
  A('genderuwo', 'scratch', '抓跳蚤', 2.8, '撓撓肚子，抓到一隻跳蚤彈走。', (g, H) => ({ armF:-0.2 + sw(g, 6) * 0.1 * (g < 0.7 ? 1 : 0), body:0.08, head:0.15 }), (ctx, S, g, m, f, H) => { if (g > 0.7) { const q = (g - 0.7) / 0.3; ctx.fillStyle = '#2a1a10'; ctx.beginPath(); ctx.arc(0.2 * H + q * 0.3 * H, -0.5 * H - Math.sin(q * PI) * 0.2 * H, 0.008 * H, 0, 7); ctx.fill(); } });
  // ---------- Orang Bunian ----------
  A('bunian', 'flicker', '時隱時現', 3.2, '身子一下透明一下現形，周圍金色光點飄。', (g, H) => ({ a:0.35 + 0.65 * (0.5 + 0.5 * Math.cos(g * TAU)) }), (ctx, S, g, m, f, H) => { for (let i = 0; i < 6; i++) { const q = (g + i / 6) % 1; ctx.save(); ctx.globalAlpha *= Math.sin(q * PI); ctx.fillStyle = '#ffe28a'; ctx.beginPath(); ctx.arc((N.rnd(i) - 0.5) * 0.6 * H, -0.2 * H - q * 0.8 * H, 0.012 * H, 0, 7); ctx.fill(); ctx.restore(); } });
  A('bunian', 'flower', '聞花', 3.0, '低頭聞頭上的花，閉眼一笑。', (g, H) => { const k = env(g, 0.1, 0.35, 0.65, 0.9); return { head:0.15 * k, armB:-0.4 * k, hairL:0.1 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.1 * H, -1.08 * H, 0.08 * H, '～♪', '#ffe28a', bump(g, 0.3, 0.8)));
  // ---------- Mae Nak ----------
  A('maenak', 'reach', '伸手摘芒果', 3.2, '長手往上一伸，在空中摘了什麼，收回來聞一聞。', (g, H) => { const k = env(g, 0.1, 0.35, 0.6, 0.85); return { armF:0.7 * k, head:-0.1 * k }; });
  A('maenak', 'hum', '哼歌搖擺', 3.0, '輕輕左右搖，哼著歌。', (g, H) => ({ r:sw(g) * 3, px:0, py:0, head:sw(g, 1, 0.5) * 0.08, hairL:sw(g, 1) * 0.06 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.6, 0.27); note(ctx, S, p, g, 0, 0.5, H, '#e8d0ff'); note(ctx, S, p, g, 0.5, 1, H, '#e8d0ff'); });
  A('maenak', 'wait', '等老公', 3.6, '望著遠方輕聲叫「Mak……」。', (g, H) => ({ head:-0.08 + sw(g, 1) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.15 * H, -1.05 * H, 0.09 * H, 'Mak……', '#e8d0ff', bump(g, 0.3, 0.9)));
  // ---------- Phi Am ----------
  A('phiam', 'yawn', '打哈欠', 3.0, '大大一個哈欠，睡帽的球甩一下。', (g, H) => { const k = bump(g, 0.1, 0.7); return { head:-0.25 * k, sy:1 + 0.05 * k, armF:-0.3 * k, armB:0.3 * k, tie:sw(g, 2) * 0.2 }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.3 * H, -0.95 * H, 0.1 * H, '呵～', '#ffd8f0', bump(g, 0.2, 0.7)));
  A('phiam', 'doze', '打瞌睡', 3.6, '頭慢慢垂下去、Zzz，突然驚醒。', (g, H) => ({ head:g < 0.8 ? 0.25 * N.seg(g, 0, 0.7) : -0.15 * bump(g, 0.8, 1), y:g > 0.8 ? -0.05 * H * bump(g, 0.8, 0.95) : 0 }), (ctx, S, g, m, f, H) => { if (g < 0.8) zz(ctx, S, [0.15 * H, -0.85 * H], g, H); });
  // ---------- Churel ----------
  A('churel', 'hair', '撥頭髮', 2.6, '手往後一撥長髮，手環叮噹響。', (g, H) => { const k = bump(g, 0.1, 0.6); return { armF:-0.8 * k, hairL:-0.3 * k, hairR:0.2 * k, head:-0.1 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.0 * H, 0.07 * H, '叮', '#ffd27a', bump(g, 0.3, 0.6)));
  A('churel', 'dance', '跳舞', 2.4, '扭腰擺手跳一小段舞，腳鈴叮叮響。', (g, H) => ({ r:sw(g, 2) * 5, px:0, py:0, armF:-0.4 + sw(g, 2) * 0.3, armB:0.4 + sw(g, 2) * 0.3, y:-Math.abs(sw(g, 4)) * 0.02 * H }), (ctx, S, g, m, f, H) => note(ctx, S, [0.2 * H, -0.9 * H], g, 0, 0.9, H, '#ffd27a'));
  // ---------- Vetala ----------
  A('vetala', 'doze', '拄杖打瞌睡', 3.6, '靠著樹枝杖，頭一點一點打瞌睡。', (g, H) => ({ head:0.15 + Math.abs(sw(g, 2)) * 0.1, body:0.05 }), (ctx, S, g, m, f, H) => zz(ctx, S, [0.1 * H, -0.9 * H], g, H));
  A('vetala', 'riddle', '出謎題', 3.0, '舉起手指搖一搖「猜猜看？」（屍鬼最愛出謎題）。', (g, H) => ({ armB:-0.8 * env(g, 0.05, 0.2, 0.8, 0.95) + sw(g, 4) * 0.08, head:-0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, '估吓先？', '#d8ffc8', bump(g, 0.1, 0.9)));
  // ---------- 河童 ----------
  A('kappa', 'refill', '補頭上的水', 3.0, '手捧一點水澆到頭頂的碟子，碟裡漾起水紋。', (g, H) => { const k = env(g, 0.1, 0.3, 0.6, 0.8); return { armB:-1.0 * k, head:-0.08 * k }; }, (ctx, S, g, m, f, H) => { const p = at(S, m, 0.47, 0.04); if (g > 0.35 && g < 0.75) { const q = (g - 0.35) / 0.4; N.ring(ctx, p[0], p[1], 0.05 * H * (0.3 + q), 0.015 * H * (0.3 + q), 'rgba(150,210,255,.9)', 0.006 * H, 1 - q); N.drops(ctx, p[0], p[1] - 0.05 * H, 0.15 * H, q, 'rgba(150,210,255,.9)', 23, 3); } });
  A('kappa', 'cucumber', '啃青瓜', 2.6, '青瓜送到嘴邊「喀嚓喀嚓」啃。', (g, H) => ({ armF:-0.35 - Math.abs(sw(g, 3)) * 0.1, head:0.08 + sw(g, 6) * 0.03 }), (ctx, S, g, m, f, H) => { T(ctx, S, 0.25 * H, -1.0 * H, 0.08 * H, '喀嚓', '#c8f0a0', Math.abs(sw(g, 1.5))); N.drops(ctx, at(S, m, 0.25, 0.32)[0], at(S, m, 0.25, 0.32)[1], 0.12 * H, (g * 3) % 1, '#9ad070', 25, 3); });
  // ---------- 轆轤首 ----------
  A('rokurokubi', 'stretch', '伸長脖子張望', 3.4, '脖子往上一伸，頭左右張望，再縮回來。', (g, H) => { const k = env(g, 0.1, 0.35, 0.65, 0.9); return { neck1:-0.2 * k, neck2:-0.15 * k + sw(g, 2) * 0.12 * k, head:sw(g, 2, 1) * 0.12 * k }; });
  A('rokurokubi', 'yawn', '打哈欠', 3.0, '頭往後一仰打個哈欠，脖子跟著扭。', (g, H) => { const k = bump(g, 0.1, 0.7); return { head:-0.3 * k, neck2:0.1 * k, armF:-0.2 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, -0.2 * H, -1.05 * H, 0.1 * H, '呵～', '#ffd0e0', bump(g, 0.2, 0.7)));
  // ---------- 裂口女 ----------
  A('kuchisake', 'snip', '空剪', 2.2, '剪刀在空中咔嚓咔嚓剪兩下。', (g, H) => ({ armF:-0.2 + Math.abs(sw(g, 2)) * 0.1, head:0.05 }), (ctx, S, g, m, f, H) => T(ctx, S, at(S, m, 0.05, 0.25)[0], at(S, m, 0.05, 0.25)[1] - 0.08 * H, 0.08 * H, '咔嚓', '#ffffff', Math.abs(sw(g, 2))));
  A('kuchisake', 'ask', '「我漂亮嗎？」', 3.2, '頭一歪，慢慢問「我漂亮嗎？」。', (g, H) => ({ head:-0.2 * env(g, 0.1, 0.3, 0.75, 0.95), r:-3 * env(g, 0.1, 0.3, 0.75, 0.95) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '我靚唔靚？', '#ffe0e0', bump(g, 0.2, 0.95)));
  // ---------- 雪女 ----------
  A('yukionna', 'snow', '變出雪花', 3.2, '手心向上，一朵雪花慢慢長大、轉著飄走。', (g, H) => ({ armF:-0.5 * env(g, 0.05, 0.2, 0.75, 0.9), head:0.1 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.25, 0.45), q = N.seg(g, 0.2, 0.9); if (q > 0 && q < 1) flake(ctx, p[0] + q * 0.1 * H, p[1] - 0.06 * H - q * 0.3 * H, 0.05 * H * Math.min(1, q * 3), q * 6, 1 - N.seg(q, 0.7, 1)); });
  A('yukionna', 'breath', '呵一口冷氣', 2.8, '輕輕呵一口白氣，氣裡結出小冰晶。', (g, H) => ({ head:0.1 * bump(g, 0.2, 0.7), sy:1 + 0.02 * bump(g, 0, 0.2) }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.42, 0.255); N.puff(ctx, p[0] + 0.1 * H, p[1], 0.06 * H, N.seg(g, 0.2, 0.9), 'rgba(220,240,255,.6)', 27, 4); });
  // ---------- 唐傘妖 ----------
  A('kasaobake', 'hop', '單腳跳', 1.6, '木屐一蹦一蹦，傘面跟著掀。', (g, H) => { const u = Math.abs(sw(g, 2)); return { y:-0.12 * H * u, sy:1 + 0.03 * u - (u < 0.15 ? 0.07 : 0), tie:u * 0.3, tongue:u * 0.2 }; });
  A('kasaobake', 'lick', '舔舔嘴', 2.4, '長舌頭甩上來舔一圈。', (g, H) => ({ tongue:sw(g, 2) * 0.35 * bump(g, 0, 1), head:sw(g, 2, 1) * 0.04 }));
  A('kasaobake', 'spin', '原地轉傘', 2.2, '整把傘原地轉一圈，破紙條飄。', (g, H) => { const c = Math.cos(N.seg(g, 0.15, 0.75) * TAU); return { sx:Math.abs(c) < 0.12 ? 0.12 * Math.sign(c || 1) : c, tie:0.3 * bump(g, 0.15, 0.75) }; });
  // ---------- 無臉鬼 ----------
  A('nopperabo', 'watch', '看手錶', 2.8, '舉起手腕看錶，跺腳「遲到了！」。', (g, H) => { const k = env(g, 0.05, 0.2, 0.75, 0.9); return { armB:-0.9 * k, head:0.12 * k, y:-0.01 * H * Math.abs(sw(g, 4)) * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '遲到喇！', '#e8e8ff', bump(g, 0.3, 0.9)));
  A('nopperabo', 'tie', '整理領帶', 2.6, '兩手拉一拉領帶，挺胸。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { armB:-0.6 * k + sw(g, 4) * 0.05 * k, head:-0.08 * k, sy:1 + 0.02 * k }; });
  // ---------- 提燈妖 ----------
  A('chochin', 'flicker', '火光忽明忽暗', 2.4, '燈籠裡的火一閃一閃，旁邊的鬼火繞著飄。', (g, H) => ({ flame:sw(g, 3) * 0.2, sy:1 + sw(g, 2) * 0.02 }), { pre:(ctx, S, g, m, f, H) => { const k = 0.5 + 0.5 * sw(g, 3); const gr = ctx.createRadialGradient(0, -0.5 * H, 0, 0, -0.5 * H, 0.5 * H); gr.addColorStop(0, `rgba(255,180,80,${0.25 + 0.2 * k})`); gr.addColorStop(1, 'rgba(255,180,80,0)'); ctx.fillStyle = gr; ctx.fillRect(-0.5 * H, -1.0 * H, H, H); } });
  A('chochin', 'tongue', '吐舌頭', 2.4, '大舌頭甩出來晃兩下又收回去。', (g, H) => ({ tongue:sw(g, 2) * 0.3, sx:1 + 0.03 * bump(g, 0, 0.5) }));
  // ---------- 餓者髑髏 ----------
  A('gashadokuro', 'rattle', '骨頭喀喀響', 2.4, '整副大骨架抖一抖，喀喀作響。', (g, H) => ({ x:sw(g, 12) * 0.006 * H, head:sw(g, 9) * 0.05, armF:sw(g, 7) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.1 * H, -1.05 * H, 0.1 * H, '喀喀喀', '#f6efd8', Math.abs(sw(g, 1))));
  A('gashadokuro', 'hungry', '肚子餓張望', 3.4, '頭慢慢左右轉，下巴一開一合「餓……」。', (g, H) => ({ head:sw(g, 1) * 0.15, body:sw(g, 1, 0.5) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, -0.1 * H, -1.05 * H, 0.1 * H, '餓……', '#f6efd8', bump(g, 0.3, 0.9)));
  // ---------- Banshee ----------
  A('banshee', 'comb', '梳頭', 3.2, '（傳說她拿著梳子）手一下一下順著長髮往下梳。', (g, H) => ({ armF:-0.6 + sw(g, 2) * 0.2, hairL:sw(g, 2, 1) * 0.1, head:0.08 }));
  A('banshee', 'weep', '低頭哭', 3.2, '低頭啜泣，肩膀一抖一抖，眼淚往下掉。', (g, H) => ({ head:0.2, body:0.05 + Math.abs(sw(g, 3)) * 0.03, sy:1 - Math.abs(sw(g, 3)) * 0.015 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.5, 0.22); N.drops(ctx, p[0], p[1], 0.15 * H, (g * 2) % 1, 'rgba(180,210,255,.9)', 29, 2, 0.6); });
  // ---------- 般若 ----------
  A('hannya', 'fume', '氣到冒煙', 2.6, '氣得發抖，頭頂冒煙、角尖冒火星。', (g, H) => ({ x:sw(g, 16) * 0.006 * H, head:-0.05, armF:-0.3, armB:0.3 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.42, 0.02); N.puff(ctx, p[0], p[1], 0.06 * H, g, 'rgba(240,240,240,.55)', 31, 3); N.puff(ctx, p[0] + 0.05 * H, p[1], 0.05 * H, (g + 0.5) % 1, 'rgba(240,240,240,.55)', 32, 3); });
  A('hannya', 'sulk', '哼！', 2.4, '把頭撇到一邊「哼！」。', (g, H) => ({ head:-0.25 * env(g, 0.1, 0.2, 0.7, 0.9), r:-3 * env(g, 0.1, 0.2, 0.7, 0.9) }), (ctx, S, g, m, f, H) => T(ctx, S, -0.2 * H, -1.05 * H, 0.11 * H, '哼！', '#ff7070', bump(g, 0.15, 0.75)));
  // ---------- Aswang ----------
  A('aswang', 'flap', '拍翅膀', 2.0, '背上的翅膀拍幾下，身子跟著一起一伏。', (g, H) => ({ cape:sw(g, 4) * 0.35, y:-Math.abs(sw(g, 4)) * 0.015 * H }));
  A('aswang', 'sniff', '嗅味道', 3.0, '頭往前伸，一下一下嗅空氣，舌頭甩。', (g, H) => ({ head:0.15 + Math.abs(sw(g, 4)) * 0.06, body:0.08, r:3 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.15, 0.25); for (let i = 0; i < 3; i++) N.crayon(ctx, [[p[0] + 0.05 * H + i * 0.03 * H, p[1] - 0.03 * H], [p[0] + 0.08 * H + i * 0.03 * H, p[1] + 0.03 * H]], 'rgba(220,220,230,.7)', 0.01 * H, 33 + i, Math.abs(sw(g, 4))); });
  // ---------- Tikbalang ----------
  A('tikbalang', 'smoke', '抽雪茄', 3.2, '深吸一口雪茄，鼻孔噴出兩道煙。', (g, H) => ({ head:-0.1 * bump(g, 0.1, 0.4), sy:1 + 0.02 * bump(g, 0.1, 0.4) }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.08, 0.27); N.puff(ctx, p[0], p[1], 0.06 * H, N.seg(g, 0.45, 1), 'rgba(210,210,220,.6)', 35, 4); });
  A('tikbalang', 'stomp', '踏蹄', 2.2, '前蹄在地上刨兩下，塵土飛。', (g, H) => ({ legF:-0.25 * Math.max(0, sw(g, 2)), head:0.05 }), (ctx, S, g, m, f, H) => N.puff(ctx, 0.15 * H, -0.02 * H, 0.05 * H, (g * 2) % 1, 'rgba(190,170,150,.55)', 37, 3));
  A('tikbalang', 'mane', '甩鬃毛', 2.4, '頭一甩，鬃毛和尾巴一起甩。', (g, H) => { const k = bump(g, 0.1, 0.6); return { head:sw(g, 2) * 0.15 * k, hairL:-0.3 * k, hairR:-0.3 * k, cape:0.3 * k }; });
  // ======== 第二批：各種死法 ========
  A('chehuo', 'mirror', '照倒後鏡', 2.8, '舉起手上那塊倒後鏡照一照，整理裂開的安全帽。', (g, H) => ({ armF:-0.35 * env(g, 0.05, 0.2, 0.8, 0.95), head:-0.1 * env(g, 0.05, 0.2, 0.8, 0.95) + sw(g, 2) * 0.04 }));
  A('chehuo', 'rev', '催油門', 2.2, '雙手握著空氣車把「嗚嗚～叭叭！」，屁股冒煙。', (g, H) => ({ armF:-0.45 + sw(g, 6) * 0.05, armB:-0.35, r:3, px:0, py:0, x:sw(g, 30) * 0.004 * H }), (ctx, S, g, m, f, H) => { N.puff(ctx, -0.3 * H, -0.2 * H, 0.06 * H, (g * 2) % 1, 'rgba(70,64,70,.5)', 41, 3); T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '嗚嗚～', '#ffe066', bump(g, 0.2, 0.9)); });
  A('diansi', 'zap', '又被電一下', 2.6, '插頭一閃，全身一抽、頭髮炸更高，冒一縷煙。', (g, H) => { const j = g > 0.3 && g < 0.45 ? Math.sin(g * 300) : 0; return { x:j * 0.01 * H, hairL:0.2 * bump(g, 0.3, 0.6), hairR:0.2 * bump(g, 0.3, 0.6), head:j * 0.08 }; }, (ctx, S, g, m, f, H) => { const p = at(S, m, 0.14, 0.32); if (g > 0.28 && g < 0.45) for (let i = 0; i < 3; i++) N30M.bolt(ctx, p, [p[0] + (N.rnd(i) - 0.5) * 0.2 * H, p[1] - 0.15 * H], 0.008 * H, 43 + i + Math.floor(g * 30), '#ffe14a', 1); N.puff(ctx, at(S, m, 0.55, 0.05)[0], at(S, m, 0.55, 0.05)[1], 0.06 * H, N.seg(g, 0.45, 1), 'rgba(110,100,100,.5)', 44, 3); });
  A('diansi', 'plug', '找插座', 3.0, '拿著插頭東張西望，想找地方插。', (g, H) => ({ armF:-0.3 + sw(g, 2) * 0.1, head:sw(g, 1) * 0.15 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '插蘇喺邊？', '#ffe14a', bump(g, 0.3, 0.9)));
  A('dongsi', 'shiver', '冷到發抖', 2.2, '抱緊毯子猛抖，鼻涕冰柱晃。', (g, H) => ({ x:sw(g, 20) * 0.008 * H, head:sw(g, 16) * 0.03, sy:0.98 }), (ctx, S, g, m, f, H) => { for (let i = 0; i < 2; i++) { const q = (g + i / 2) % 1; flake(ctx, (i - 0.5) * 0.4 * H, -1.0 * H + q * 0.8 * H, 0.03 * H, q * 5, Math.sin(q * PI)); } });
  A('dongsi', 'sneeze', '打噴嚏', 2.4, '「哈……哈啾！」噴出一團雪花。', (g, H) => { const k = bump(g, 0.1, 0.5), s2 = bump(g, 0.5, 0.65); return { head:-0.2 * k + 0.25 * s2, body:0.1 * s2 }; }, (ctx, S, g, m, f, H) => { T(ctx, S, 0.25 * H, -1.05 * H, 0.1 * H, g < 0.5 ? '哈……' : '哈啾！', '#cfeaff', bump(g, 0.1, 0.9)); const p = at(S, m, 0.40, 0.3); if (g > 0.5) for (let i = 0; i < 4; i++) flake(ctx, p[0] + (g - 0.5) * 0.6 * H + i * 0.03 * H, p[1] + (i - 1.5) * 0.04 * H, 0.025 * H, g * 8 + i, 1 - N.seg(g, 0.7, 1)); });
  A('yezi', 'dizzy', '頭暈轉圈', 2.6, '眼冒金星，整個人晃來晃去。', (g, H) => ({ r:sw(g) * 6, px:0, py:0, head:sw(g, 1, 1) * 0.1 }), (ctx, S, g, m, f, H) => N.stars(ctx, at(S, m, 0.42, 0.05)[0], at(S, m, 0.42, 0.05)[1], 0.15 * H, g * 6, 0.9));
  A('yezi', 'lookup', '緊張看天', 3.0, '抱著椰子緊張地抬頭看，怕再掉一顆。', (g, H) => ({ head:-0.2 * env(g, 0.1, 0.3, 0.7, 0.9) + sw(g, 3) * 0.03, sy:1 - 0.03 * env(g, 0.1, 0.3, 0.7, 0.9) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.1 * H, 0.1 * H, '……！', '#ffe066', bump(g, 0.3, 0.8)));
  A('liulian', 'sniff', '聞榴槤', 2.8, '把榴槤湊到鼻子前聞一聞，陶醉。', (g, H) => { const k = env(g, 0.1, 0.3, 0.7, 0.9); return { armF:-0.3 * k, head:0.12 * k }; }, (ctx, S, g, m, f, H) => { T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '好香～', '#d8e070', bump(g, 0.3, 0.85)); for (let i = 0; i < 2; i++) { const q = (g + i / 2) % 1, pts = []; for (let j = 0; j <= 5; j++) pts.push([-0.25 * H + i * 0.08 * H + Math.sin(j + g * 12) * 0.02 * H, -0.6 * H - j * 0.05 * H - q * 0.1 * H]); N.crayon(ctx, pts, 'rgba(150,190,80,.7)', 0.012 * H, 47 + i, Math.sin(q * PI)); } });
  A('liulian', 'rub', '揉頭上的刺孔', 2.6, '手摸摸頭上被刺的地方「痛痛痛」。', (g, H) => ({ armB:-0.9 + sw(g, 4) * 0.08, head:0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '痛痛痛', '#ffd0d0', Math.abs(sw(g, 1.5))));
  A('yesi', 'eat', '又夾一顆湯圓', 3.0, '筷子夾起碗裡的湯圓送進嘴，卡住，捶胸口。', (g, H) => { const k = env(g, 0.05, 0.25, 0.4, 0.55); return { armF:-0.6 * k, head:-0.1 * k + 0.1 * bump(g, 0.55, 0.9), armB:0.1 * Math.abs(sw(g, 4)) * (g > 0.55 ? 1 : 0) }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.05 * H, 0.09 * H, '噎……！', '#ffffff', bump(g, 0.55, 0.95)));
  A('yesi', 'cough', '咳咳', 2.2, '彎腰用力咳。', (g, H) => ({ body:0.12 * Math.abs(sw(g, 2)), head:0.15 * Math.abs(sw(g, 2)) }), (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.0 * H, 0.1 * H, '咳！', '#ffffff', Math.abs(sw(g, 1))));
  A('xiaosi', 'laugh', '笑到停不下', 2.4, '抱著肚子笑到彎腰、眼淚噴。', (g, H) => ({ body:0.15 + Math.abs(sw(g, 5)) * 0.08, head:0.15 + Math.abs(sw(g, 5)) * 0.1, y:-Math.abs(sw(g, 5)) * 0.02 * H }), (ctx, S, g, m, f, H) => { T(ctx, S, 0.2 * H, -1.0 * H, 0.1 * H, '哈哈哈', '#ffe066', 0.9); N.drops(ctx, at(S, m, 0.3, 0.2)[0], at(S, m, 0.3, 0.2)[1], 0.2 * H, (g * 2) % 1, 'rgba(150,210,255,.9)', 49, 3); });
  A('xiaosi', 'slap', '拍大腿', 2.6, '笑到拍大腿。', (g, H) => ({ armB:0.3 * Math.max(0, sw(g, 3)), body:0.1, head:0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.3 * H, -0.6 * H, 0.08 * H, '啪', '#ffe066', Math.max(0, sw(g, 3))));
  A('xiasi', 'jump', '自己嚇自己', 2.2, '聽到聲音嚇到彈起來，頭髮再炸一次。', (g, H) => { const j = bump(g, 0.2, 0.45); return { y:-0.15 * H * j, hairL:-0.3 * j, hairR:-0.3 * j, armF:-0.4 * j, armB:0.4 * j }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.15 * H, 0.12 * H, '哇！', '#ff5050', bump(g, 0.2, 0.6)));
  A('xiasi', 'look', '左顧右盼', 3.0, '緊張地左看右看。', (g, H) => ({ head:sw(g, 2) * 0.15, x:sw(g, 25) * 0.003 * H }));
  A('leipi', 'smoke', '頭頂冒煙', 2.8, '焦黑的頭冒著煙，咳出一團黑煙。', (g, H) => ({ head:0.05 + 0.1 * bump(g, 0.6, 0.8) }), (ctx, S, g, m, f, H) => { for (let i = 0; i < 2; i++) N.puff(ctx, at(S, m, 0.35, 0.05)[0] + i * 0.05 * H, at(S, m, 0.35, 0.05)[1], 0.06 * H, (g + i / 2) % 1, 'rgba(80,70,70,.5)', 51 + i, 3); });
  A('leipi', 'umbrella', '撐破傘', 3.0, '把破傘撐高看天「今天不會再打雷吧……」。', (g, H) => ({ armB:-0.4 * env(g, 0.1, 0.3, 0.7, 0.9), umb:-0.1, head:-0.15 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.1 * H, 0.08 * H, '唔會再行雷啩…', '#ffe14a', bump(g, 0.3, 0.9)));
  A('zipai', 'selfie', '自拍', 2.6, '舉高自拍棒擺個 YA，「咔嚓」閃一下。', (g, H) => ({ armF:-0.2, head:-0.08 + 0.06 * bump(g, 0.5, 0.6) }), (ctx, S, g, m, f, H) => { if (g > 0.5 && g < 0.62) { const p = at(S, m, 0.80, 0.14); N.burst(ctx, p[0], p[1], 0.15 * H, 1 - (g - 0.5) / 0.12, '#ffffff', 53, 8); } T(ctx, S, -0.1 * H, -1.05 * H, 0.09 * H, '茄子～', '#ffe0f0', bump(g, 0.1, 0.55)); });
  A('zipai', 'check', '看照片', 3.0, '把手機拉回來看照片，點點頭「讚！」。', (g, H) => ({ armB:0.3 * env(g, 0.1, 0.3, 0.7, 0.9), stick:0.2 * env(g, 0.1, 0.3, 0.7, 0.9), head:0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, '正！', '#ffe0f0', bump(g, 0.5, 0.95)));
  A('zhongshu', 'wipe', '抹汗', 2.6, '毛巾抹一把臉上的汗，汗水甩出去。', (g, H) => ({ armF:-0.6 * env(g, 0.1, 0.3, 0.5, 0.7), head:0.08 }), (ctx, S, g, m, f, H) => N.drops(ctx, at(S, m, 0.45, 0.2)[0], at(S, m, 0.45, 0.2)[1], 0.25 * H, N.seg(g, 0.45, 0.9), 'rgba(150,210,255,.9)', 55, 5));
  A('zhongshu', 'lick', '舔雪條', 2.8, '雪條在融，趕快舔一口，滴得到處都是。', (g, H) => ({ armB:-0.3 * env(g, 0.1, 0.3, 0.6, 0.8), head:-0.08 }), (ctx, S, g, m, f, H) => { const p = at(S, m, 0.75, 0.45); N.drops(ctx, p[0], p[1], 0.12 * H, (g * 2) % 1, 'rgba(255,160,110,.9)', 57, 2, 0.5); });
  A('chengsi', 'eat', '繼續吃', 2.4, '叉子叉一口塞進嘴，嚼嚼嚼。', (g, H) => ({ armF:-0.3 * Math.abs(sw(g, 2)), head:sw(g, 6) * 0.04 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.15 * H, -1.05 * H, 0.08 * H, '嚼嚼', '#ffe0b0', 0.8));
  A('chengsi', 'burp', '打飽嗝', 2.6, '肚子一挺「嗝～」，腰帶快爆開。', (g, H) => { const k = bump(g, 0.3, 0.6); return { sx:1 + 0.05 * k, sy:1 - 0.02 * k, head:-0.15 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.11 * H, '嗝～', '#ffe0b0', bump(g, 0.3, 0.75)));
  A('shedu', 'hop', '痛到跳腳', 2.0, '被咬著屁股一跳一跳。', (g, H) => { const u = Math.abs(sw(g, 2)); return { y:-0.08 * H * u, armF:-0.3 * u, snake:sw(g, 2) * 0.1 }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.15 * H, -1.1 * H, 0.09 * H, '哎喲哎喲', '#ffe066', 0.9));
  A('shedu', 'shake', '甩蛇', 2.6, '扭屁股想把蛇甩掉，甩不掉。', (g, H) => ({ r:sw(g, 3) * 5, px:0, py:0, snake:sw(g, 3, 1) * 0.2 }));
  A('shidu', 'cramp', '肚子痛', 2.6, '抱著肚子彎腰，臉更綠。', (g, H) => ({ body:0.15 + Math.abs(sw(g, 2)) * 0.05, head:0.15, sy:0.97 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.0 * H, 0.09 * H, '咕嚕嚕', '#b8e070', bump(g, 0.1, 0.9)));
  A('shidu', 'run', '急著找廁所', 2.0, '抱著廁紙原地小碎步，左右張望。', (g, H) => ({ legF:sw(g, 6) * 0.2, legB:-sw(g, 6) * 0.2, head:sw(g, 1) * 0.15, y:-Math.abs(sw(g, 6)) * 0.015 * H }), (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.09 * H, '廁所喺邊！', '#b8e070', 0.9));
  A('daji', 'play', '狂按手掣', 2.2, '低頭狂按，嘴巴開著流口水。', (g, H) => ({ armF:sw(g, 20) * 0.04, armB:-sw(g, 20) * 0.04, head:0.1 }), (ctx, S, g, m, f, H) => T(ctx, S, 0.15 * H, -1.05 * H, 0.08 * H, ['↑', '↓', 'A', 'B'][Math.floor(g * 8) % 4], '#9fe8ff', 0.9));
  A('daji', 'yawn', '通宵打呵欠', 3.0, '伸懶腰打個大呵欠，再拿起能量飲料。', (g, H) => { const k = bump(g, 0.1, 0.6); return { armF:-0.6 * k, armB:0.6 * k, head:-0.2 * k, sy:1 + 0.03 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.2 * H, -1.05 * H, 0.1 * H, '呵～', '#9fe8ff', bump(g, 0.15, 0.6)));
  A('xiangcai', 'flap', '被風吹', 2.4, '扁扁的身體被風吹得一飄一飄。', (g, H) => ({ sy:1 + sw(g, 2) * 0.1, r:sw(g, 2, 1) * 6, px:0, py:-0.3 * H, armF:sw(g, 4) * 0.2, armB:-sw(g, 4) * 0.2, y:-0.03 * H }));
  A('xiangcai', 'inflate', '吹氣復原', 3.0, '拼命吸氣想鼓回原形，鼓一下又扁回去。', (g, H) => { const k = bump(g, 0.1, 0.6); return { sy:1 + 0.35 * k, sx:1 - 0.1 * k }; }, (ctx, S, g, m, f, H) => T(ctx, S, 0.25 * H, -1.2 * H, 0.1 * H, g < 0.6 ? '呼——' : '噗', '#ffffff', bump(g, 0.1, 0.8)));
  return { ACTS };
})();
