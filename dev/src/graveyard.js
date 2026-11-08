// ===================== 亂葬崗・無名墳（推理：把忘了自己是誰的遊魂送回自己的墳） =====================
// 公平原則：每一晚只有一種擺法說得通；每句記憶的字面意思 = 檢查器實際算的東西；沒有運氣。
// 方位全部以背景上五塊空地為準（畫面比例座標，0~1）：
//   A 左上 (0.24,0.45)  B 右上 (0.78,0.46)  C 正中間 (0.51,0.58)  D 左下 (0.27,0.72)  E 右下 (0.78,0.73)
//   排（高低）：上排 = A、B；正中間 = C；下排 = D、E。「X 在 Y 上面」= X 的排比 Y 高，同一排不算。
//   側（左右）：左側 = A、D；正中間 = C；右側 = B、E。「X 在 Y 左邊」= X 的側比 Y 左，同一側不算。
//   牌坊旁邊那座 = D（石牌坊在左下角，D 就在牌坊上面）。
//   「我走的時候 X 十幾歲」= 卒年 − 生年 落在 X1~X9；生成時歲數個位只用 2~8，實歲、虛歲都不會跨十位。
//   「早走 / 晚走」= 卒年比較早 / 比較晚（同一晚卒年全不相同，至少差兩年）。
//   碑文 = 墓碑卡上「碑文」那一行；『…』裡的字一字不差地出現在碑文裡。
//   只有立了碑的空地才算墳；沒立碑的空地不算。
const GY_SPOTS = {
  A:{ x:0.25, y:0.375, row:0, side:0, name:'左上' },
  B:{ x:0.76, y:0.37, row:0, side:2, name:'右上' },
  C:{ x:0.52, y:0.475, row:1, side:1, name:'正中間' },
  D:{ x:0.24, y:0.585, row:2, side:0, name:'左下' },
  E:{ x:0.76, y:0.58, row:2, side:2, name:'右下' },
};
// 四款墓碑圖裡「碑」的位置：[中心x, 上, 下, 左, 右]（圖的比例）
const GY_TOMB_TAB = [[0.50, 0.29, 0.52, 0.38, 0.62], [0.49, 0.24, 0.55, 0.37, 0.61], [0.50, 0.30, 0.52, 0.38, 0.62], [0.50, 0.24, 0.52, 0.38, 0.62]];
const GY_TAGS = ['①', '②', '③', '④', '⑤'];
const GY_LEVELS = { 1:{ n:3, g:3, direct:2 }, 2:{ n:4, g:4, direct:1 }, 3:{ n:4, g:5, direct:1 }, 4:{ n:5, g:5, direct:1 } };
// 職業：碑文（每句附可以被記住的片段）＋安息時最後一句話
const GY_JOBS = {
  '會計':     { ep:[['數了一輩子別人的錢', ['一輩子', '別人的錢']], ['帳終於對平了', ['對平']]], last:'帳……對平了。' },
  '保安':     { ep:[['守了三十年大門，今天準時下班', ['大門', '準時下班']], ['大家都回家了，我也回家', ['回家']]], last:'可以關燈了。' },
  '外賣員':   { ep:[['這一單，終於送到了', ['送到了', '這一單']], ['風雨無阻，請給五星', ['五星', '風雨無阻']]], last:'這一單……送到了。' },
  '補習老師': { ep:[['下課鐘響了，不用再補', ['下課', '不用再補']], ['考試範圍：無', ['考試範圍']]], last:'今天，不留功課。' },
  '茶室頭手': { ep:[['最後一杯，走甜', ['走甜', '最後一杯']], ['爐火熄了，人也歇了', ['爐火']]], last:'Kopi-O，走甜。' },
  '地產經紀': { ep:[['此地永久地契，不設轉售', ['永久地契', '不設轉售']], ['風水一流，近地鐵站', ['風水', '地鐵站']]], last:'這個單位……我自己住。' },
  '夜班護士': { ep:[['換班了，這次真的睡了', ['換班', '真的睡了']], ['不用再叫醒我了', ['叫醒']]], last:'下一更，交給你們了。' },
  '羅里司機': { ep:[['跑了一百萬公里，終於泊好', ['泊好', '一百萬公里']], ['前路不再塞車', ['塞車']]], last:'引擎，熄了。' },
  '收銀員':   { ep:[['找你零錢，不用謝', ['零錢', '不用謝']], ['收工了，抽屜對數', ['抽屜']]], last:'下一位……沒有了。' },
  '銀行櫃員': { ep:[['請取號，下一位', ['取號', '下一位']], ['本櫃台暫停服務', ['暫停服務']]], last:'本櫃台，暫停服務。' },
  '文員':     { ep:[['影印了半生，終於原件歸檔', ['原件歸檔', '影印']], ['已讀，不回', ['已讀']]], last:'這份，不用再改了。' },
  'Grab司機': { ep:[['目的地：已抵達', ['已抵達', '目的地']], ['乘客已下車，請給好評', ['下車', '好評']]], last:'目的地，到了。' },
  '小販':     { ep:[['今天早點收檔', ['收檔', '早點']], ['賣完了，明天請早', ['明天請早']]], last:'今天，賣完了。' },
  '人事專員': { ep:[['您的離職申請已批准', ['離職申請', '已批准']], ['恭喜轉正，永不續約', ['轉正', '永不續約']]], last:'這次，是我自己批准的。' },
};
const GY_OFFERS = ['榴槤', '麻將牌', '一封沒拆的公司信', '老花眼鏡', 'Milo 罐', '椰漿飯', '計算機', '粉筆', '安全帽', '一串鑰匙', '舊手機', '萬字票', '紅包', '藍白拖鞋'];
const GY_SURN = ['陳', '林', '黃', '李', '張', '王', '吳', '劉', '蔡', '楊', '鄭', '何', '謝', '羅', '梁', '周', '許', '曾', '蕭', '郭'];
const GY_GIVEN = ['美玲', '志強', '國華', '秀英', '家豪', '淑芬', '偉明', '亞清', '文傑', '麗珠', '金水', '月娥', '俊傑', '寶珠', '德福', '玉蘭', '振興', '素貞', '建國', '惠敏'];
const GY_DEC = ['', '', '二', '三', '四', '五', '六', '七', '八'];
// 句型（驗證器用正則一字不差地反解，所以每一種寫法都要能唯一對回語意）
const GY_TPL = {
  job_is:['我生前是{job}。', '每天上班、下班……我是{job}。'],
  job_not:['我生前不是{job}。', '我沒做過{job}。'],
  ojob_not:['{J}生前不是{job}。', '{J}沒做過{job}。'],
  off_is:['我的墳前，有人放了{off}。', '我記得墳前放著{off}。'],
  off_not:['我的墳前放的不是{off}。'],
  quote:['碑文我只記得『{q}』。', '我的碑文裡有『{q}』。'],
  quote_not:['我的碑文裡沒有『{q}』。'],
  age:['我走的時候{d}十幾歲。'],
  surname:['我姓{sn}。'],
  row_is:['我睡在{row}。'], row_not:['我不是睡在{row}。'],
  side_is:['我睡在{side}。'], side_not:['我不是睡在{side}。'],
  tree:['我睡在牌坊旁邊那座。'], tree_not:['我不是睡在牌坊旁邊那座。'],
  rel:['我的墳在{J}的墳{dir}。'],
  same_row:['我和{J}睡在同一排。'],
  died:['我比{J}{when}。'],
};
const GY_ROWW = ['上排', '正中間那座', '下排'], GY_SIDEW = ['左側', null, '右側'];

const GY_GEN = {
  rng(seed) { let a = seed >>> 0; return () => { a = (a + 0x6D2B79F5) >>> 0; let t = a; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; },
  levelOf(night) { return night <= 2 ? 1 : night <= 4 ? 2 : night <= 7 ? 3 : 4; },
  // 一條記憶 c 在「說話的魂 i 睡 gi、其他魂的位置 asg」下是否成立
  holds(c, asg, graves) {
    const me = graves[asg[c.who]], o = c.j != null ? graves[asg[c.j]] : null, sp = GY_SPOTS[me.spot], so = o && GY_SPOTS[o.spot];
    switch (c.t) {
      case 'job_is': return me.job === c.v; case 'job_not': return me.job !== c.v; case 'ojob_not': return o.job !== c.v;
      case 'off_is': return me.off === c.v; case 'off_not': return me.off !== c.v;
      case 'quote': return me.ep.includes(c.v); case 'quote_not': return !me.ep.includes(c.v);
      case 'age': return Math.floor((me.death - me.birth) / 10) === c.v;
      case 'surname': return me.name[0] === c.v;
      case 'row_is': return sp.row === c.v; case 'row_not': return sp.row !== c.v;
      case 'side_is': return sp.side === c.v; case 'side_not': return sp.side !== c.v;
      case 'tree': return me.spot === 'D'; case 'tree_not': return me.spot !== 'D';
      case 'rel': return c.v === 'up' ? sp.row < so.row : c.v === 'down' ? sp.row > so.row : c.v === 'left' ? sp.side < so.side : sp.side > so.side;
      case 'same_row': return sp.row === so.row;
      case 'died': return c.v === 'early' ? me.death < o.death : me.death > o.death;
    }
    return false;
  },
  // 暴力列舉：n 個魂 → g 座墳（單射），回傳所有說得通的擺法
  solve(n, graves, clues, cap) {
    const out = [], asg = [], used = new Array(graves.length).fill(false);
    const byWho = []; for (let i = 0; i < n; i++) byWho.push([]);
    for (const c of clues) byWho[Math.max(c.who, c.j != null ? c.j : -1)].push(c); // 兩個魂都擺好才檢查
    const rec = (i) => {
      if (cap && out.length >= cap) return;
      if (i === n) { out.push(asg.slice()); return; }
      for (let g = 0; g < graves.length; g++) {
        if (used[g]) continue; used[g] = true; asg[i] = g;
        if (byWho[i].every(c => this.holds(c, asg, graves))) rec(i + 1);
        used[g] = false;
      }
    };
    rec(0); return out;
  },
  text(c, rnd) {
    const tp = GY_TPL[c.t], s = tp[Math.floor(rnd() * tp.length)];
    const J = c.j != null ? GY_TAGS[c.j] : '';
    let v = c.v;
    if (c.t === 'age') v = GY_DEC[c.v];
    return s.replace('{job}', c.v).replace('{off}', c.v).replace('{q}', c.v).replace('{d}', v).replace('{sn}', c.v)
      .replace('{row}', GY_ROWW[c.v]).replace('{side}', GY_SIDEW[c.v]).replace('{J}', J)
      .replace('{dir}', { up:'上面', down:'下面', left:'左邊', right:'右邊' }[c.v]).replace('{when}', c.v === 'early' ? '早走' : '晚走');
  },
  // 生成一晚。回傳 { level, souls:[{tag, grave, lines:[...], clues:[...]}], graves:[...] }
  gen(night, seed) {
    const level = this.levelOf(night), L = GY_LEVELS[level];
    for (let tries = 0; tries < 400; tries++) {
      const r = this.rng((seed >>> 0) + tries * 7919);
      const p = this.tryGen(L, r);
      if (p) { p.level = level; p.night = night; p.seed = seed; p.tries = tries; return p; }
    }
    throw new Error('graveyard gen failed');
  },
  shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; },
  tryGen(L, r) {
    const pickN = (arr, k) => this.shuffle(arr.slice(), r).slice(0, k);
    const spots = pickN(Object.keys(GY_SPOTS), L.g).sort();
    const sn = pickN(GY_SURN, L.g), gv = pickN(GY_GIVEN, L.g), jobs = pickN(Object.keys(GY_JOBS), L.g), offs = pickN(GY_OFFERS, L.g);
    // 卒年：彼此至少差兩年
    const deaths = []; while (deaths.length < L.g) { const d = 1986 + Math.floor(r() * 39); if (deaths.every(x => Math.abs(x - d) >= 2)) deaths.push(d); }
    const graves = spots.map((s, i) => {
      const dec = 2 + Math.floor(r() * 7), age = dec * 10 + 2 + Math.floor(r() * 7); // 個位 2~8
      const eps = GY_JOBS[jobs[i]].ep, e = eps[Math.floor(r() * eps.length)];
      return { spot:s, name:sn[i] + gv[i], job:jobs[i], off:offs[i], ep:e[0], keys:e[1], death:deaths[i], birth:deaths[i] - age };
    });
    // 碑文要彼此不同
    if (new Set(graves.map(g => g.ep)).size !== graves.length) return null;
    const n = L.n, truth = this.shuffle(graves.map((_, i) => i), r).slice(0, n); // truth[soul] = 墳的索引
    // ---- 所有真話（候選記憶） ----
    const pool = [];
    const add = (c) => { if (this.holds(c, truth, graves)) pool.push(c); };
    const usedRows = new Set(graves.map(g => GY_SPOTS[g.spot].row)), usedSides = new Set(graves.map(g => GY_SPOTS[g.spot].side));
    for (let i = 0; i < n; i++) {
      const me = graves[truth[i]], others = graves.filter(g => g !== me), sp = GY_SPOTS[me.spot];
      add({ t:'job_is', who:i, v:me.job });
      for (const o of others) { add({ t:'job_not', who:i, v:o.job }); add({ t:'off_not', who:i, v:o.off }); }
      add({ t:'off_is', who:i, v:me.off });
      for (const q of me.keys) add({ t:'quote', who:i, v:q });
      for (const o of others) for (const q of o.keys) if (!me.ep.includes(q)) add({ t:'quote_not', who:i, v:q });
      add({ t:'age', who:i, v:Math.floor((me.death - me.birth) / 10) });
      add({ t:'surname', who:i, v:me.name[0] });
      for (const rw of usedRows) { if (rw === sp.row) add({ t:'row_is', who:i, v:rw }); else add({ t:'row_not', who:i, v:rw }); }
      for (const sd of usedSides) { if (sd === 1) continue; if (sd === sp.side) add({ t:'side_is', who:i, v:sd }); else add({ t:'side_not', who:i, v:sd }); }
      if (graves.some(g => g.spot === 'D')) add({ t:me.spot === 'D' ? 'tree' : 'tree_not', who:i });
      for (let j = 0; j < n; j++) {
        if (j === i) continue;
        for (const v of ['up', 'down', 'left', 'right']) add({ t:'rel', who:i, j, v });
        add({ t:'same_row', who:i, j });
        for (const v of ['early', 'late']) add({ t:'died', who:i, j, v });
        for (const o of graves) if (o !== graves[truth[j]]) add({ t:'ojob_not', who:i, j, v:o.job });
      }
    }
    // 只留「真的有過濾作用」的句子：單看這句，說話的魂（或被說的魂）可以排除至少一座墳
    const useful = pool.filter(c => {
      const ok = [];
      for (let g = 0; g < graves.length; g++) for (let h = 0; h < graves.length; h++) {
        if (c.j == null && h > 0) break; if (c.j != null && g === h) continue;
        const asg = []; asg[c.who] = g; if (c.j != null) asg[c.j] = h; ok.push(this.holds(c, asg, graves));
      }
      return ok.some(x => !x);
    });
    // 「直接指認」：單看這句就只剩一座墳
    const isDirect = (c) => c.j == null && graves.filter((_, g) => { const asg = []; asg[c.who] = g; return this.holds(c, asg, graves); }).length === 1;
    const W = { job_is:1, job_not:3, ojob_not:2, off_is:1, off_not:2, quote:3, quote_not:2, age:3, surname:1, row_is:2, row_not:2, side_is:2, side_not:2, tree:1, tree_not:2, rel:5, same_row:4, died:4 };
    if (L.n === 3) Object.assign(W, { rel:2, died:2, same_row:1, ojob_not:1, quote:4, age:3, job_not:3, off_not:3 }); // 第一、二夜：多講自己，少講別人
    // 先按權重挑句型，再在該句型裡隨機挑一句（避免某一型句子數量多就洗版）
    const wpick = (arr) => { const by = {}; for (const c of arr) (by[c.t] = by[c.t] || []).push(c); const ts = Object.keys(by); let s = 0; for (const t of ts) s += W[t]; let x = r() * s; for (const t of ts) { x -= W[t]; if (x <= 0) return by[t][Math.floor(r() * by[t].length)]; } const l = by[ts[ts.length - 1]]; return l[Math.floor(r() * l.length)]; };
    const per = []; for (let i = 0; i < n; i++) per.push(useful.filter(c => c.who === i));
    const chosen = [], key = (c) => JSON.stringify([c.t, c.who, c.j, c.v]);
    const has = new Set(); let nDirect = 0;
    // 同一晚不能有兩個魂講同一件事（換個說法也不行）：同句型＋同內容＋同對象 只能出現一次
    const sig = (c) => { // 同一件事的各種說法 → 同一個「事實」
      const a = c.who, b = c.j;
      switch (c.t) {
        case 'job_is': return JSON.stringify(['job', a, c.v]); case 'job_not': return JSON.stringify(['job', a, c.v]); case 'ojob_not': return JSON.stringify(['job', b, c.v]);
        case 'same_row': return JSON.stringify(['row=', Math.min(a, b), Math.max(a, b)]);
        case 'died': return JSON.stringify(['died', c.v === 'early' ? a : b, c.v === 'early' ? b : a]);
        case 'rel': return JSON.stringify(c.v === 'up' ? ['above', a, b] : c.v === 'down' ? ['above', b, a] : c.v === 'left' ? ['leftof', a, b] : ['leftof', b, a]);
        default: return JSON.stringify([c.t, a, c.v]);
      }
    }, said = new Set();
    const take = (c) => { chosen.push(c); has.add(key(c)); said.add(sig(c)); if (isDirect(c)) nDirect++; };
    const avail = (i) => per[i].filter(c => !has.has(key(c)) && !said.has(sig(c)) && (!isDirect(c) || nDirect < L.direct));
    for (let i = 0; i < n; i++) for (let k = 0; k < 2; k++) { const a = avail(i); if (!a.length) return null; take(wpick(a)); }
    let sols = this.solve(n, graves, chosen, 3);
    let guard = 0;
    while (sols.length > 1 && guard++ < 20) {
      // 在還沒滿三句的魂裡，挑一句最能減少解數的（同分隨機）
      const cand = [];
      for (let i = 0; i < n; i++) if (chosen.filter(c => c.who === i).length < 3) for (const c of avail(i)) cand.push(c);
      if (!cand.length) return null;
      this.shuffle(cand, r);
      let best = null, bs = 1e9;
      for (const c of cand.slice(0, 24)) { const s = this.solve(n, graves, chosen.concat([c]), 0).length; const sc = s * 10 - W[c.t]; if (s >= 1 && sc < bs) { bs = sc; best = c; } }
      take(best); sols = this.solve(n, graves, chosen, 3);
    }
    if (sols.length !== 1) return null;
    // 精簡：拿掉多餘的句子（每個魂至少留兩句）
    for (const c of this.shuffle(chosen.slice(), r)) {
      if (chosen.filter(x => x.who === c.who).length <= 2) continue;
      const rest = chosen.filter(x => x !== c);
      if (this.solve(n, graves, rest, 2).length === 1) chosen.splice(chosen.indexOf(c), 1);
    }
    // 第二關起至少要有一句魂與魂之間的關係
    if (L.n >= 4 && !chosen.some(c => c.j != null)) return null;
    // 文字：同一晚不能有兩句一樣
    const lines = new Set();
    const souls = [];
    for (let i = 0; i < n; i++) {
      const mine = this.shuffle(chosen.filter(c => c.who === i), r);
      const ls = mine.map(c => { let t, k = 0; do { t = this.text(c, r); } while (lines.has(t) && k++ < 8); return t; });
      if (ls.some(t => lines.has(t))) return null;
      ls.forEach(t => lines.add(t));
      souls.push({ tag:GY_TAGS[i], grave:truth[i], clues:mine, lines:ls });
    }
    const sol = this.solve(n, graves, chosen, 0);
    if (sol.length !== 1 || sol[0].some((g, i) => g !== truth[i])) return null;
    return { graves, souls };
  },
};
// 墓碑卡上實際顯示的字（遊戲畫面與驗證器共用這一份）
GY_GEN.card = (g) => ({ spot:g.spot, name:g.name, years:`${g.birth} – ${g.death}`, job:g.job, ep:g.ep, off:g.off });

const GY_COLORS = ['#9fe8ff', '#ffd27a', '#d0b0ff', '#a8ffb8', '#ffa8c0'];
const GY_ALPHA = [0.9, 0.84, 0.88, 0.86, 0.8];
const GY_RULES = [
  ['他們記得的，都是真的', '每一晚只有一種擺法說得通。擺錯了，就是哪一步想錯了。'],
  ['排（高低）', '上排＝上面兩座（左上、右上）；正中間那座自成一排；下排＝下面兩座（左下、右下）。'],
  ['側（左右）', '左側＝左上、左下；右側＝右上、右下。正中間那座不算左側，也不算右側。'],
  ['上面／下面', '只比排：上排在正中間上面，正中間在下排上面。同一排不算上下，不用對正。'],
  ['左邊／右邊', '只比側：左側在正中間左邊，正中間在右側左邊。同一側不算左右，不用對齊。'],
  ['同一排', '兩座都在上排，或都在下排。'],
  ['牌坊旁邊那座', '左下那座（就在石牌坊旁邊）。'],
  ['幾十幾歲', '卒年減生年。'],
  ['早走／晚走', '卒年比較早／比較晚。'],
  ['碑文', '墓碑卡上「碑文」那一行；『』裡的字一字不差出現在碑文裡。'],
  ['只算立了碑的', '沒立碑的空地不是墳。有時會多一座墳，裡面的人早就安息了，不屬於今晚任何一個魂。'],
];

const Graveyard = {
  active:false,
  ensure() {
    if (!S.yard || typeof S.yard !== 'object') S.yard = {};
    const y = S.yard;
    if (!(y.night >= 1)) y.night = 1; y.night = Math.floor(y.night);
    if (!(y.best >= 0)) y.best = 0;
    if (!Array.isArray(y.rested)) y.rested = [];
    if (!(y.seed > 0)) y.seed = 1 + Math.floor(Math.random() * 2e9);
    return y;
  },
  open() {
    const y = this.ensure(); save();
    this.p = GY_GEN.gen(y.night, y.seed);
    const n = this.p.souls.length;
    Object.assign(this, { active:true, t:0, tries:0, phase:'play', sel:null, view:{ k:'soul', i:0 }, drag:null, parts:[], crows:[], crowT:4, bub:null, restT:0, guide:false });
    this.souls = this.p.souls.map((s, i) => ({ i, tag:s.tag, place:null, x:0, y:0, ph:Math.random() * 6, rx:null, col:GY_COLORS[i], a:GY_ALPHA[i] }));
    this.wisps = []; for (let i = 0; i < 7; i++) this.wisps.push({ x:Math.random(), y:0.35 + Math.random() * 0.55, ph:Math.random() * 9, sp:0.3 + Math.random() * 0.5 });
    this.stones = this.p.graves.map((g, gi) => { const r = GY_GEN.rng(this.p.seed + gi * 101), st = []; for (let k = 0; k < 26; k++) st.push([r(), r(), (r() - 0.5) * 0.5, r()]); return st; });
    const el = $('#gyard'); el.classList.add('on');
    el.innerHTML = `<div id="gy-top"><button class="btn sm ghost" id="gy-quit">收工</button><b>亂葬崗・第 ${y.night} 夜</b><span id="gy-tries"></span><button class="btn sm" id="gy-rule">規矩</button></div>
      <div id="gy-hint"></div><div id="gy-stage"><canvas id="gy-cvs"></canvas></div>
      <div id="gy-panel"><div id="gy-chips"></div><div id="gy-info"></div><div class="gy-acts"><button class="btn" id="gy-reset">全部退回</button><button class="btn gold" id="gy-go">送他們安息</button></div></div><div id="gy-end"></div>`;
    $('#gy-quit').onclick = () => { if (this.phase !== 'play') return; if (!confirmInline($('#gy-quit'), '確定收工？')) return; this.close(); };
    $('#gy-rule').onclick = () => { if (this.view.k === 'rules') { this.view = this.sel != null ? { k:'soul', i:this.sel } : { k:'soul', i:0 }; this.guide = false; } else { this.view = { k:'rules' }; this.guide = true; } this.renderPanel(); };
    $('#gy-reset').onclick = () => { if (this.phase !== 'play') return; this.souls.forEach(s => s.place = null); this.sel = null; this.renderPanel(); };
    $('#gy-go').onclick = () => this.submit();
    const cv = $('#gy-cvs');
    cv.addEventListener('pointerdown', (e) => this.down(e)); cv.addEventListener('pointermove', (e) => this.move(e));
    cv.addEventListener('pointerup', (e) => this.up(e)); cv.addEventListener('pointercancel', () => { if (this.drag) { this.drag = null; } });
    if (!this._rs) { this._rs = true; window.addEventListener('resize', () => { if (this.active) this.resize(); }); }
    Sound.setMode('story'); Sound.play('crow', -0.6);
    this.renderPanel(); this.resize();
    if (!this._ro && typeof ResizeObserver !== 'undefined') { this._ro = new ResizeObserver(() => { if (this.active && $('#gy-stage')) this.resize(); }); }
    if (this._ro) this._ro.observe($('#gy-stage'));
    if (!y.seen) { y.seen = 1; save(); this.hint('點魂，聽他記得什麼；點墓碑，看碑文。把每個魂拖到自己的墳前（或先點魂再點墳）。方位怎麼算，按右上「規矩」。', 14); }
    else this.hint(`今晚 ${n} 個魂${this.p.graves.length > n ? `，${this.p.graves.length} 座墳（有一座不是他們的）` : ''}。`, 5);
    const tok = this._tok = {}; this.last = performance.now(); requestAnimationFrame((now) => this.frame(now, tok));
  },
  close() {
    this.active = false; this._tok = null; if (this._ro) this._ro.disconnect(); const el = $('#gyard'); el.classList.remove('on'); el.innerHTML = '';
    Sound.setMode('village'); UI.refresh();
  },
  hint(text, sec) {
    const h = $('#gy-hint'); if (!h) return; h.innerHTML = `<span>${text}</span><button aria-label="關閉">✕</button>`; h.classList.add('on');
    h.querySelector('button').onclick = () => h.classList.remove('on');
    clearTimeout(this._ht); this._ht = setTimeout(() => h.classList.remove('on'), (sec || 6) * 1000);
  },
  resize() {
    const c = $('#gy-cvs'), box = $('#gy-stage').getBoundingClientRect(), dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = box.width * dpr; c.height = box.height * dpr; c.style.width = box.width + 'px'; c.style.height = box.height + 'px';
    this.W = box.width; this.H = box.height; this.dpr = dpr;
  },
  // 鋪滿、貼底；矮螢幕上至少要看得到圖的 y 0.25~1（含上排墓碑頂）（五塊空地都在裡面），不夠就縮小（兩邊留黑）
  bgScale() { const img = SPR.bg_graveyard; const iw = img && img.naturalWidth || 768, ih = img && img.naturalHeight || 1152, W = this.W || 390, H = this.H || 560; let s = Math.max(W / iw, H / ih); if (ih * s * 0.75 > H) s = H / (ih * 0.75); return { s, iw, ih, ox:(W - iw * s) / 2, oy:H - ih * s }; },
  pt(fx, fy) { const b = this.bgScale(); return [fx * b.iw * b.s + b.ox, fy * b.ih * b.s + b.oy]; },
  unit() { const b = this.bgScale(); return b.iw * b.s / 390; },

  // ---------- 位置 ----------
  soulH() { return 64 * this.unit(); },
  homeOf(i) { const n = this.souls.length, x0 = 0.32, x1 = 0.9; return [x0 + (n === 1 ? 0.5 : i / (n - 1)) * (x1 - x0), 0.955]; },
  graveAt(gi) { const g = this.p.graves[gi], s = GY_SPOTS[g.spot]; return [s.x, s.y]; },
  standOf(gi) { const [x, y] = this.graveAt(gi); return [x + 0.13, y + 0.045]; }, // 站在墓碑右前方，不擋碑文
  targetOf(s) { return s.place != null ? this.standOf(s.place) : this.homeOf(s.i); },
  stoneRect(gi) { const [x, y] = this.pt(...this.graveAt(gi)), u = this.unit(), w = 50 * u, h = 64 * u; return { x:x - w / 2, y:y - h + 6 * u, w, h, cx:x, by:y + 6 * u }; },

  // ---------- 操作 ----------
  local(e) { const r = $('#gy-cvs').getBoundingClientRect(); return [e.clientX - r.left, e.clientY - r.top]; },
  soulAtPx(mx, my) {
    const hh = this.soulH(); let best = null, bd = 1e9;
    for (const s of this.souls) { const x = s.px, y = s.py; if (x == null) continue; if (mx > x - hh * 0.42 && mx < x + hh * 0.42 && my > y - hh * 1.05 && my < y + 8) { const d = Math.abs(mx - x) + Math.abs(my - (y - hh / 2)); if (d < bd) { bd = d; best = s; } } }
    return best;
  },
  graveAtPx(mx, my) {
    let best = null, bd = 1e9, u = this.unit();
    this.p.graves.forEach((g, gi) => { const r = this.stoneRect(gi), cy = r.by - 10 * u, d = Math.hypot((mx - r.cx) / 1.25, my - cy); if (d < 58 * u && d < bd) { bd = d; best = gi; } });
    return best;
  },
  down(e) {
    if (this.phase !== 'play') return;
    const [mx, my] = this.local(e), s = this.soulAtPx(mx, my);
    if (s) { this.drag = { s, x0:mx, y0:my, mx, my, moved:false }; try { $('#gy-cvs').setPointerCapture(e.pointerId); } catch (er) {} return; }
    const g = this.graveAtPx(mx, my);
    if (g != null) { if (this.sel != null) this.place(this.sel, g); else { this.view = { k:'grave', i:g }; this.guide = false; Sound.play('paper'); this.renderPanel(); } return; }
    if (this.sel != null) { this.sel = null; this.renderPanel(); }
  },
  move(e) { const d = this.drag; if (!d) return; const [mx, my] = this.local(e); d.mx = mx; d.my = my; if (Math.hypot(mx - d.x0, my - d.y0) > 9) d.moved = true; },
  up(e) {
    const d = this.drag; if (!d) return; this.drag = null;
    const [mx, my] = this.local(e);
    if (!d.moved) { this.sel = this.sel === d.s.i ? null : d.s.i; if (this.sel != null) { this.view = { k:'soul', i:d.s.i }; this.guide = false; Sound.play('click'); } this.renderPanel(); return; }
    const g = this.graveAtPx(mx, my - 20 * this.unit());
    if (g != null) this.place(d.s.i, g);
    else { d.s.place = null; this.renderPanel(); }
  },
  place(si, gi) {
    if (this.phase !== 'play') return;
    for (const o of this.souls) if (o.place === gi && o.i !== si) o.place = null; // 那裡原本的魂回到下面排隊
    this.souls[si].place = gi; this.sel = null; this.view = { k:'grave', i:gi, who:si }; this.guide = false;
    Sound.play('whoosh'); this.renderPanel();
  },
  allPlaced() { return this.souls.every(s => s.place != null); },
  correct() { return this.souls.filter(s => s.place === this.p.souls[s.i].grave).length; },
  submit() {
    if (this.phase !== 'play' || !this.allPlaced()) return;
    const k = this.correct(), n = this.souls.length;
    if (k === n) { this.rest(); return; }
    this.tries++;
    this.souls.forEach((s, j) => s.rx = { k:'hurt', t:-j * 0.08, dur:1.3 });
    Sound.play('lose');
    if (this.tries >= 2) { this.phase = 'fail'; this.say(`還是不對……只有 ${k} 個擺對了。天快亮了。`, 3); setTimeout(() => this.finish(false, k), 1900); }
    else { this.say(`他們不肯躺下。只有 ${k} 個擺對了。`, 4.5); this.hint(`只有 ${k} 個擺對了（不告訴你是哪幾個）。還有一次機會。`, 8); }
    this.renderPanel();
  },
  say(text, sec) { this.bub = { text, life:sec || 3, max:sec || 3 }; },
  rest() {
    this.phase = 'rest'; this.restT = 0; this.sel = null;
    Sound.play('gong'); setTimeout(() => Sound.play('crow', -0.4), 900); setTimeout(() => Sound.play('crow', 0.3), 1400);
    for (let i = 0; i < 6; i++) this.crows.push({ x:0.08 + Math.random() * 0.2, y:0.12 + Math.random() * 0.12, vx:0.16 + Math.random() * 0.12, vy:-0.05 - Math.random() * 0.06, ph:Math.random() * 6, s:0.9 + Math.random() * 0.5, delay:0.8 + i * 0.18, life:4 });
    this.say('都對了。去吧，下班了。', 3);
    this.renderPanel();
    setTimeout(() => this.finish(true, this.souls.length), 3600);
  },

  // ---------- 結算 ----------
  finish(ok, k) {
    if (!this.active || this.phase === 'end') return;
    const y = this.ensure(), n = this.souls.length, night = y.night, perfect = ok && this.tries === 0;
    this.phase = 'end'; clearTimeout(this._ht); const hn = $('#gy-hint'); if (hn) hn.classList.remove('on');
    let rw;
    if (ok) { rw = { coins:Math.round((25 * n + 5 * Math.min(night, 20)) * (perfect ? 1 : 0.6)), exp:Math.round((5 * n + night) * (perfect ? 1 : 0.6)) }; if (perfect) rw.chest = night >= 5 ? 'b' : 'g'; }
    else rw = { coins:Math.max(5, 8 * k), exp:2 * k };
    let got = give(rw), stay = '';
    if (ok) {
      y.best = Math.max(y.best, night);
      for (const s of this.p.souls) y.rested.push(this.p.graves[s.grave].name);
      if (y.rested.length > 200) y.rested = y.rested.slice(-200);
      if (Math.random() < 0.12) {
        const s = this.p.souls[Math.floor(Math.random() * n)], nm = this.p.graves[s.grave].name;
        if (!S.ghosts.some(g => g.k === 'youhun')) { stay = `${s.tag}（${nm}）回頭看了一眼：「村子裡……還缺人嗎？」`; this._join = true; }
        else { stay = `${s.tag}（${nm}）本來想留下，可是村裡已經有遊魂了。他把身上的冥幣都留給你。`; got += '，' + give({ coins:30 }); }
      }
      if (!stay && typeof N30W !== 'undefined') { const v = N30W.graveVisit(); if (v) { stay = v.text; this._joinK = v.k; } } // 意外鬼偶遇（n30_data.js）
    }
    y.night = night + 1; y.seed = 1 + Math.floor(Math.random() * 2e9); save();
    const rows = this.p.souls.map((s, i) => { const g = this.p.graves[s.grave], wrong = this.souls[i].place !== s.grave;
      return `<li><b style="color:${GY_COLORS[i]}">${s.tag}</b> <span>${g.name}・${g.job}・${g.birth}–${g.death}<br><small>${ok ? `「${GY_JOBS[g.job].last}」` : `${wrong ? '其實睡在' : '睡在'}${GY_SPOTS[g.spot].name}那座${wrong ? '' : '，你擺對了'}`}</small></span></li>`; }).join('');
    const title = ok ? (perfect ? '一次就全對' : '都安息了') : '天亮了';
    const word = ok ? (perfect ? '陰司 KPI 系統：零投訴，五星好評。' : '陰司 KPI 系統：有投訴，但最後都結案了。') : '陰司 KPI 系統：未結案。他們明晚還會在這裡等。';
    $('#gy-end').innerHTML = `<div class="gy-card"><h3>${title}</h3><p class="desc">${word}</p><ul class="gy-who">${rows}</ul>${stay ? `<p class="desc gy-stay">${stay}</p>` : ''}<p class="desc">獎勵：${got}</p><div class="gy-acts"><button class="btn" id="gy-back">回村子</button><button class="btn gold" id="gy-next">下一夜</button></div></div>`;
    $('#gy-end').classList.add('on');
    const after = () => { if (this._join) { this._join = false; joinGhost('youhun'); save(); } if (this._joinK) { const k = this._joinK; this._joinK = null; joinGhost(k); save(); } };
    $('#gy-back').onclick = () => { this.close(); after(); };
    $('#gy-next').onclick = () => { after(); if (this._ro) this._ro.disconnect(); this.open(); };
  },

  // ---------- 面板 ----------
  renderPanel() {
    if (!this.active || !$('#gy-panel')) return;
    const n = this.souls.length;
    $('#gy-tries').innerHTML = `機會 ${'●'.repeat(2 - this.tries)}${'○'.repeat(this.tries)}`;
    $('#gy-chips').innerHTML = this.souls.map(s => { const g = s.place != null ? this.p.graves[s.place] : null;
      return `<button class="gy-chip ${this.sel === s.i ? 'sel' : ''} ${this.view.k === 'soul' && this.view.i === s.i ? 'on' : ''}" data-i="${s.i}" style="--c:${s.col}"><b>${s.tag}</b><small>${g ? g.name[0] + '家墳前' : '還沒安置'}</small></button>`; }).join('');
    $('#gy-chips').querySelectorAll('.gy-chip').forEach(b => b.onclick = () => { const i = +b.dataset.i; this.view = { k:'soul', i }; this.guide = false; this.sel = this.phase === 'play' ? (this.sel === i ? null : i) : null; this.renderPanel(); });
    const v = this.view; let h = '';
    if (v.k === 'rules') {
      h = `<div class="gy-rules">${GY_RULES.map(r => `<p><b>${r[0]}</b>${r[1]}</p>`).join('')}</div>`;
    } else if (v.k === 'grave') {
      const g = this.p.graves[v.i], c = GY_GEN.card(g), who = this.souls.find(s => s.place === v.i);
      h = `<div class="gy-grave"><div class="gy-gh"><b>${c.name}</b><span>${c.years}</span><em>${GY_SPOTS[g.spot].name}</em></div>
        <p><i>生前</i>${c.job}</p><p><i>碑文</i>${c.ep}</p><p><i>祭品</i>${c.off}</p>
        <p class="gy-note">${who ? `<b style="color:${who.col}">${who.tag}</b> 站在這座墳前。` : this.sel != null ? '' : '先點一個魂，再點這座墳，就能把他送過來。'}</p></div>`;
    } else {
      const s = this.souls[v.i], d = this.p.souls[v.i];
      h = `<div class="gy-soul"><div class="gy-sh" style="--c:${s.col}"><b>${s.tag}</b><span>${this.sel === s.i ? '選好了：點一座墳，把他送過去' : '他記得的事'}</span></div><ul>${d.lines.map(l => `<li>${l}</li>`).join('')}</ul></div>`;
    }
    $('#gy-info').innerHTML = h;
    const go = $('#gy-go'); go.disabled = this.phase !== 'play' || !this.allPlaced();
    go.textContent = this.allPlaced() ? '送他們安息' : `送他們安息（差 ${this.souls.filter(s => s.place == null).length}）`;
    $('#gy-reset').disabled = this.phase !== 'play';
  },

  // ---------- 每一幀 ----------
  frame(now, tok) {
    if (!this.active || tok !== this._tok) return;
    const dt = Math.min(0.05, (now - this.last) / 1000); this.last = now;
    this.step(dt); this.draw(this.t);
    requestAnimationFrame((n) => this.frame(n, tok));
  },
  step(dt) {
    this.t += dt;
    if (this.phase === 'rest') this.restT += dt;
    for (const s of this.souls) {
      if (s.rx) { s.rx.t += dt; if (s.rx.t >= s.rx.dur) s.rx = null; }
      const [tx, ty] = this.targetOf(s);
      if (s.x === 0 && s.y === 0) { s.x = tx; s.y = ty; }
      const k = Math.min(1, dt * 6); s.x += (tx - s.x) * k; s.y += (ty - s.y) * k;
    }
    for (const w of this.wisps) { w.ph += dt * w.sp; w.x += Math.sin(w.ph * 0.7) * dt * 0.02; w.y += Math.cos(w.ph * 0.5) * dt * 0.012; if (w.x < -0.05) w.x = 1.05; if (w.x > 1.05) w.x = -0.05; }
    this.crowT -= dt; if (this.crowT <= 0 && this.phase === 'play') { this.crowT = 8 + Math.random() * 8; this.crows.push({ x:-0.05, y:0.08 + Math.random() * 0.1, vx:0.13, vy:-0.01, ph:0, s:0.8, delay:0, life:9 }); }
    this.crows = this.crows.filter(c => { if (c.delay > 0) { c.delay -= dt; return true; } c.life -= dt; c.x += c.vx * dt; c.y += c.vy * dt; c.ph += dt * 14; return c.life > 0 && c.x < 1.2; });
    this.parts = this.parts.filter(p => { p.life -= dt; p.x += p.vx * dt; p.y += p.vy * dt; return p.life > 0; });
    if (this.phase === 'rest' && Math.random() < dt * 40) { const s = this.souls[Math.floor(Math.random() * this.souls.length)]; this.parts.push({ x:s.x + (Math.random() - 0.5) * 0.08, y:s.y - 0.05 - this.restT * 0.07, vx:(Math.random() - 0.5) * 0.03, vy:-0.08 - Math.random() * 0.06, life:1.4, col:s.col }); }
    if (this.bub) { this.bub.life -= dt; if (this.bub.life <= 0) this.bub = null; }
  },
  draw(t) {
    const c = $('#gy-cvs'); if (!c) return; const ctx = c.getContext('2d'); ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    const W = this.W, H = this.H, b = this.bgScale(), img = SPR.bg_graveyard, u = this.unit();
    ctx.fillStyle = '#0d0b10'; ctx.fillRect(0, 0, W, H);
    if (img && sprOk('bg_graveyard')) ctx.drawImage(img, b.ox, b.oy, b.iw * b.s, b.ih * b.s);
    else { const g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, '#1c2030'); g.addColorStop(1, '#2a2a22'); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H); for (const k in GY_SPOTS) { const [x, y] = this.pt(GY_SPOTS[k].x, GY_SPOTS[k].y); ctx.fillStyle = '#6a5038'; ctx.beginPath(); ctx.ellipse(x, y, 62 * u, 30 * u, 0, 0, Math.PI * 2); ctx.fill(); } }
    ctx.fillStyle = 'rgba(10,12,34,.18)'; ctx.fillRect(0, 0, W, H);
    // 掛著的燈籠：一呼一吸的暖光
    { const [lx, ly] = this.pt(0.25, 0.29), r = 60 * u * (1 + 0.06 * Math.sin(t * 2.3)), g = ctx.createRadialGradient(lx, ly, 2, lx, ly, r);
      g.addColorStop(0, 'rgba(255,170,90,.32)'); g.addColorStop(1, 'rgba(255,140,60,0)'); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.fillRect(lx - r, ly - r, r * 2, r * 2); ctx.globalCompositeOperation = 'source-over'; }
    // 霧（後層）
    this.fog(ctx, t, 0);
    // 規矩模式：每塊空地標出它的排與側
    if (this.guide) for (const k in GY_SPOTS) { const sp = GY_SPOTS[k], [x, y] = this.pt(sp.x, sp.y), lab = [GY_ROWW[sp.row].replace('那座', ''), sp.side === 1 ? '' : GY_SIDEW[sp.side]].filter(Boolean).join('・') + (k === 'D' ? '・牌坊旁' : '');
      ctx.font = `800 ${Math.round(13 * u)}px sans-serif`; ctx.textAlign = 'center'; const w = ctx.measureText(lab).width + 12; ctx.fillStyle = 'rgba(20,14,30,.82)'; ctx.beginPath(); ctx.roundRect(x - w / 2, y + 14 * u, w, 20 * u, 6); ctx.fill(); ctx.fillStyle = '#ffe9a8'; ctx.fillText(lab, x, y + 29 * u); }
    // 墓碑
    const restK = this.restT > 0 ? Math.min(1, this.restT / 2.6) : 0; // 安息之後就不再出現
    this.p.graves.forEach((g, gi) => this.drawStone(ctx, g, gi, t));
    // 選了魂之後：每座墳一圈虛線，告訴玩家可以點
    if (this.sel != null || (this.drag && this.drag.moved)) this.p.graves.forEach((g, gi) => { const r = this.stoneRect(gi); const al = 0.75 + 0.25 * Math.sin(t * 4); ctx.fillStyle = `rgba(160,255,200,${0.10 * al})`; ctx.strokeStyle = `rgba(200,255,225,${al})`; ctx.lineWidth = 3; ctx.setLineDash([7, 5]); ctx.beginPath(); ctx.ellipse(r.cx, r.by - 4 * u, 54 * u, 22 * u, 0, 0, Math.PI * 2); ctx.fill(); ctx.stroke(); ctx.setLineDash([]); });
    // 阿福提燈
    { const [ax, ay] = this.pt(0.12, 0.965), s = 1.2 * u;
      if (typeof ART !== 'undefined') ART.drawChar(ctx, 'afu', ax, ay, s, { t, pose:'idle', shadow:false });
      const lx = ax + 30 * u, ly = ay - 46 * u + Math.sin(t * 1.8) * 1.5 * u, g = ctx.createRadialGradient(lx, ly + 6 * u, 1, lx, ly + 6 * u, 46 * u);
      g.addColorStop(0, 'rgba(255,190,110,.42)'); g.addColorStop(1, 'rgba(255,160,80,0)'); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.fillRect(lx - 46 * u, ly - 40 * u, 92 * u, 92 * u); ctx.globalCompositeOperation = 'source-over';
      ctx.strokeStyle = '#3a2a1a'; ctx.lineWidth = 2 * u; ctx.beginPath(); ctx.moveTo(ax + 14 * u, ay - 36 * u); ctx.lineTo(lx, ly - 12 * u); ctx.stroke();
      ctx.save(); ctx.translate(lx, ly); ctx.scale(1.6 * u, 1.6 * u); if (ART.lantern) ART.lantern(ctx, 0, 0, t, '#e0a040'); ctx.restore();
      if (this.bub) this.bubble(ctx, this.bub.text, ax + 10 * u, ay - 80 * u, Math.min(1, this.bub.life * 2)); }
    // 魂（後面的先畫）
    const order = this.souls.slice().sort((a, c2) => a.y - c2.y);
    for (const s of order) this.drawSoul(ctx, s, t, restK);
    // 拖曳中的魂：跟著手指
    // 粒子
    for (const p of this.parts) { const [x, y] = this.pt(p.x, p.y); ctx.globalAlpha = Math.min(1, p.life); ctx.fillStyle = p.col || '#fff'; ctx.beginPath(); ctx.arc(x, y, 2.4 * u, 0, Math.PI * 2); ctx.fill(); ctx.globalAlpha = 1; }
    // 鬼火
    for (const w of this.wisps) { const [x, y] = this.pt(w.x, w.y + Math.sin(w.ph * 2) * 0.01), a = 0.45 + 0.35 * Math.sin(w.ph * 3), r = 14 * u, g = ctx.createRadialGradient(x, y, 0, x, y, r);
      g.addColorStop(0, `rgba(170,255,240,${a})`); g.addColorStop(0.35, `rgba(90,220,210,${a * 0.45})`); g.addColorStop(1, 'rgba(60,200,200,0)'); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fill(); ctx.globalCompositeOperation = 'source-over'; }
    // 烏鴉
    for (const cw of this.crows) { if (cw.delay > 0) continue; const [x, y] = this.pt(cw.x, cw.y); ctx.globalAlpha = Math.min(1, cw.life); if (ART.drawCrow) ART.drawCrow(ctx, x, y, cw.s * 1.4 * u, cw.ph, 1, false); ctx.globalAlpha = 1; }
    // 霧（前層）
    this.fog(ctx, t, 1);
    // 安息：一道光
    if (restK > 0) { ctx.fillStyle = `rgba(255,240,200,${0.12 * Math.sin(restK * Math.PI)})`; ctx.fillRect(0, 0, W, H); }
    const vg = ctx.createRadialGradient(W / 2, H * 0.55, H * 0.3, W / 2, H * 0.55, H * 0.85); vg.addColorStop(0, 'rgba(0,0,0,0)'); vg.addColorStop(1, 'rgba(0,0,0,.5)'); ctx.fillStyle = vg; ctx.fillRect(0, 0, W, H);
  },
  fog(ctx, t, front) {
    const W = this.W, u = this.unit();
    for (let i = 0; i < 4; i++) {
      const fy = front ? 0.86 + i * 0.03 : 0.5 + i * 0.09, sp = (front ? 0.012 : 0.008) * (i % 2 ? 1 : -1), fx = ((i * 0.37 + t * sp) % 1.4 + 1.4) % 1.4 - 0.2;
      const [x, y] = this.pt(fx, fy), rx = W * 0.55, ry = 34 * u, a = front ? 0.10 : 0.09;
      ctx.save(); ctx.translate(x, y); ctx.scale(1, ry / rx); const g = ctx.createRadialGradient(0, 0, 0, 0, 0, rx); g.addColorStop(0, `rgba(200,210,230,${a})`); g.addColorStop(1, 'rgba(200,210,230,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(0, 0, rx, 0, Math.PI * 2); ctx.fill(); ctx.restore();
    }
  },
  drawStone(ctx, g, gi, t) {
    const r = this.stoneRect(gi), u = this.unit(), view = this.view.k === 'grave' && this.view.i === gi;
    ctx.save();
    // 地上的影子、三支香
    ctx.fillStyle = 'rgba(0,0,0,.35)'; ctx.beginPath(); ctx.ellipse(r.cx, r.by, r.w * 0.62, 7 * u, 0, 0, Math.PI * 2); ctx.fill();
    const tk = 'tomb' + (gi % 4 + 1);
    let tab = null; // 華人椅子墳：碑在中間，名字寫在碑上
    if (sprOk(tk)) { const im = SPR[tk], w = r.w * 2.25, h = w * im.naturalHeight / im.naturalWidth, x0 = r.cx - w / 2, y0 = r.by + 4 * u - h, T = GY_TOMB_TAB[gi % 4];
      ctx.drawImage(im, x0, y0, w, h); tab = { cx:x0 + T[0] * w, top:y0 + T[1] * h, bot:y0 + T[2] * h, w:(T[4] - T[3]) * w }; }
    else {
      const x = r.x, y = r.y, w = r.w, h = r.h, rr = w / 2;
      const path = () => { ctx.beginPath(); ctx.moveTo(x, r.by - 6 * u); ctx.lineTo(x, y + rr); ctx.arc(x + rr, y + rr, rr, Math.PI, 0); ctx.lineTo(x + w, r.by - 6 * u); ctx.closePath(); };
      const gr = ctx.createLinearGradient(x, y, x + w, r.by); gr.addColorStop(0, '#9aa0a6'); gr.addColorStop(1, '#5c6168'); ctx.fillStyle = gr; path(); ctx.fill();
      ctx.save(); path(); ctx.clip(); // 蠟筆紋
      for (const [a, b2, ang, k] of this.stones[gi]) { ctx.strokeStyle = k > 0.5 ? 'rgba(255,255,255,.13)' : 'rgba(30,30,40,.16)'; ctx.lineWidth = 1.6 * u; const sx = x + a * w, sy = y + b2 * h; ctx.beginPath(); ctx.moveTo(sx, sy); ctx.lineTo(sx + 10 * u, sy + ang * 10 * u); ctx.stroke(); }
      ctx.fillStyle = 'rgba(80,110,60,.5)'; ctx.beginPath(); ctx.ellipse(x + w * 0.2, r.by - 7 * u, 9 * u, 4 * u, 0, 0, Math.PI * 2); ctx.fill();
      ctx.restore();
      ctx.strokeStyle = '#26232a'; ctx.lineWidth = 2.4 * u; path(); ctx.stroke();
      ctx.fillStyle = '#4a4e55'; ctx.fillRect(x - 5 * u, r.by - 7 * u, w + 10 * u, 7 * u); ctx.strokeRect(x - 5 * u, r.by - 7 * u, w + 10 * u, 7 * u);
    }
    // 刻字：直書姓名
    if (tab) { // 碑上紅字直書，字大小配合碑的高度
      const chs = [...g.name], fs = Math.min(tab.w * 0.62, (tab.bot - tab.top) / (chs.length + 0.6)); ctx.font = `900 ${fs}px "Songti TC","Noto Serif CJK TC",serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
      const y1 = (tab.top + tab.bot) / 2 - (chs.length - 1) * fs * 0.52;
      chs.forEach((ch, k) => { const yy = y1 + k * fs * 1.04; ctx.fillStyle = 'rgba(255,255,255,.3)'; ctx.fillText(ch, tab.cx + 0.7, yy + 0.7); ctx.fillStyle = '#8a1e16'; ctx.fillText(ch, tab.cx, yy); });
      ctx.textBaseline = 'alphabetic';
    } else {
    const fs = Math.round(12.5 * u); ctx.font = `900 ${fs}px "Songti TC","Noto Serif CJK TC",serif`; ctx.textAlign = 'center';
    [...g.name].forEach((ch, k) => { const yy = r.y + 20 * u + k * (fs + 1); ctx.fillStyle = 'rgba(255,255,255,.25)'; ctx.fillText(ch, r.cx + 0.8, yy + 0.8); ctx.fillStyle = '#1e1c22'; ctx.fillText(ch, r.cx, yy); });
    }
    // 香（墓碑圖本身有香爐就不畫）
    if (!tab) for (let k = -1; k <= 1; k++) { const hx = r.cx + k * 5 * u - r.w * 0.66, hy = r.by + 2 * u; ctx.strokeStyle = '#b8742a'; ctx.lineWidth = 1.4 * u; ctx.beginPath(); ctx.moveTo(hx, hy); ctx.lineTo(hx + k * 1.5 * u, hy - 14 * u); ctx.stroke(); ctx.fillStyle = `rgba(255,${120 + 60 * Math.sin(t * 5 + k + gi)},60,.95)`; ctx.beginPath(); ctx.arc(hx + k * 1.5 * u, hy - 14 * u, 1.6 * u, 0, Math.PI * 2); ctx.fill(); }
    if (view) { ctx.strokeStyle = 'rgba(255,230,140,.9)'; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.roundRect(r.x - 6 * u, r.y - 6 * u, r.w + 12 * u, r.h + 8 * u, 10 * u); ctx.stroke(); }
    // 墳前祭品：直接寫在墳前的小紙牌上，一眼看得到（線索會提到）
    if (g.off) {
      const fs = Math.max(11, Math.round(11.5 * u)); ctx.font = `800 ${fs}px "PingFang TC","Noto Sans CJK TC",sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
      const txt = '祭品・' + g.off, tw = ctx.measureText(txt).width + 12 * u, th = fs + 8 * u, ty = r.by + 10 * u + th / 2;
      ctx.fillStyle = 'rgba(250,240,214,.94)'; ctx.strokeStyle = '#6b4a2b'; ctx.lineWidth = 1.6 * u; ctx.beginPath(); ctx.roundRect(r.cx - tw / 2, ty - th / 2, tw, th, 5 * u); ctx.fill(); ctx.stroke();
      ctx.fillStyle = '#3a2614'; ctx.fillText(txt, r.cx, ty + 0.5); ctx.textBaseline = 'alphabetic';
    }
    ctx.restore();
  },
  drawSoul(ctx, s, t, restK) {
    const u = this.unit(), hh = this.soulH(), d = this.drag && this.drag.s === s && this.drag.moved ? this.drag : null;
    let [x, y] = this.pt(s.x, s.y);
    if (d) { x = d.mx; y = d.my + 18 * u; }
    let pose = s.place != null ? 'idle' : 'idle', pt = 0, alpha = s.a, lift = 0, flip = false;
    if (d) pose = 'move';
    if (s.place != null) { flip = true; } // 面向自己的墓碑
    if (s.rx && s.rx.t >= 0) { pose = 'hurt'; pt = Math.min(1, s.rx.t / s.rx.dur); x += Math.sin(s.rx.t * 40) * 3 * u * (1 - pt); }
    if (restK > 0) { pose = 'cast'; pt = restK; lift = restK * restK * hh * 1.6; alpha = s.a * (1 - Math.max(0, (restK - 0.45) / 0.55)); }
    s.px = x; s.py = y;
    if (alpha <= 0.01) return;
    // 顏色光暈（每個魂一種顏色）
    const g = ctx.createRadialGradient(x, y - hh * 0.5 - lift, 2, x, y - hh * 0.5 - lift, hh * (0.75 + restK * 0.8));
    g.addColorStop(0, this.rgba(s.col, (this.sel === s.i ? 0.55 : 0.3) * alpha + restK * 0.3)); g.addColorStop(1, this.rgba(s.col, 0));
    ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y - hh * 0.5 - lift, hh * (0.75 + restK * 0.8), 0, Math.PI * 2); ctx.fill(); ctx.globalCompositeOperation = 'source-over';
    if (this.sel === s.i) { ctx.strokeStyle = this.rgba(s.col, 0.9); ctx.lineWidth = 2.5; ctx.setLineDash([5, 4]); ctx.beginPath(); ctx.ellipse(x, y, hh * 0.4, hh * 0.11, 0, 0, Math.PI * 2); ctx.stroke(); ctx.setLineDash([]); }
    if (typeof ART !== 'undefined') ART.drawChar(ctx, 'youhun', x, y - lift, hh / 50, { t:t * (pose === 'hurt' ? 1.5 : 1) + s.ph, pose, pt, flip, alpha, shadow:false });
    // 號碼牌
    const ty = y - hh * 1.1 - lift + Math.sin(t * 2 + s.ph) * 3 * u, r = 13 * u;
    ctx.globalAlpha = Math.min(1, alpha * 1.15);
    ctx.fillStyle = 'rgba(14,10,20,.85)'; ctx.beginPath(); ctx.arc(x, ty, r, 0, Math.PI * 2); ctx.fill(); ctx.strokeStyle = s.col; ctx.lineWidth = 2.2; ctx.stroke();
    ctx.font = `900 ${Math.round(18 * u)}px sans-serif`; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillStyle = s.col; ctx.fillText(s.tag, x, ty + 1); ctx.textBaseline = 'alphabetic';
    ctx.globalAlpha = 1;
  },
  rgba(hex, a) { const v = parseInt(hex.slice(1), 16); return `rgba(${v >> 16 & 255},${v >> 8 & 255},${v & 255},${Math.max(0, Math.min(1, a))})`; },
  bubble(ctx, text, x, y, a) {
    const u = this.unit(); ctx.save(); ctx.globalAlpha = a; ctx.font = `700 ${Math.round(14 * u)}px sans-serif`;
    const maxW = this.W * 0.62, lines = []; let cur = '';
    for (const ch of text) { if (ctx.measureText(cur + ch).width > maxW) { lines.push(cur); cur = ch; } else cur += ch; } lines.push(cur);
    const lh = 19 * u, w = Math.max(...lines.map(l => ctx.measureText(l).width)) + 18, h = lines.length * lh + 12, bx = Math.max(6, Math.min(this.W - w - 6, x - 20)), by = y - h;
    ctx.fillStyle = 'rgba(255,250,236,.95)'; ctx.strokeStyle = '#3a2a1a'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, by, w, h, 9); ctx.fill(); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(x - 6, by + h); ctx.lineTo(x - 2, by + h + 9); ctx.lineTo(x + 6, by + h); ctx.fill();
    ctx.fillStyle = '#2a1a10'; ctx.textAlign = 'left'; lines.forEach((l, i) => ctx.fillText(l, bx + 9, by + 6 + lh * (i + 0.78)));
    ctx.restore();
  },
};
