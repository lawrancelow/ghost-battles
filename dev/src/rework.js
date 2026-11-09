// ===================== 改版：去掉《熱血大作戰》影子，全部為 KPI／存在感服務 =====================
// 1) 戰鬥連招改用「怕什麼」：技能帶嚇法類別（同回陽間一樣），敵鬼有怕／唔怕；先嚇到失神，再接另一種佢怕嘅＝連嚇
// 2) 陰兵營 → 嚇人訓練班：派鬼去練「嚇功」（每隻鬼自己嘅等級），回陽間招式更強更慳陰氣、戰鬥嚇法傷害更高；陰兵改由民宅遊魂自願加入
// 3) 壽包＝供品、棺材板＝道具：回陽間前可帶；壽包可上供補存在感（presence.js）
// 4) 推關 → 搶地盤：打下的關卡就是你的地盤，每日帶來 KPI 同存在感；鄰村鬼幫會來搶，要奪回
const Rework = (() => {
  const DAY = 864e5, HOUR = 36e5;
  const W = { breath:'吹氣', light:'燈', cold:'凍', sound:'怪聲', paper:'紙', phone:'電話', face:'鬼臉', shadow:'黑影' };
  const TYPES = Object.keys(W);
  const has = (o) => typeof o !== 'undefined';

  // ---------- 敵鬼的怕／唔怕 ----------
  const EFEAR = {
    youhun:   { w:['light', 'sound'],  i:['breath'], why:'飄慣了，吹氣嚇不到' },
    egui:     { w:['face', 'cold'],    i:['sound'],  why:'肚子叫得比你還大聲' },
    xiaogui:  { w:['shadow', 'sound'], i:['face'],   why:'自己最愛扮鬼臉' },
    zombie:   { w:['light', 'breath'], i:['cold'],   why:'屍體本來就是凍的' },
    shuigui:  { w:['light', 'paper'],  i:['cold'],   why:'泡在水裡泡慣了' },
    zhiren:   { w:['light', 'breath'], i:['paper'],  why:'自己就是紙' },
    niutou:   { w:['phone', 'paper'],  i:['face'],   why:'自己個樣已經夠嚇人' },
    mamian:   { w:['phone', 'sound'],  i:['face'],   why:'自己個樣已經夠嚇人' },
    eguiking: { w:['face', 'shadow'],  i:['sound'],  why:'肚子打鼓打了五百年' },
    toyol:    { w:['light', 'face'],   i:['sound'],  why:'偷錢從來不怕聲響' },
    laojiang: { w:['light', 'breath'], i:['cold'],   why:'躺了兩百年棺材' },
    pontianak:{ w:['phone', 'light'],  i:['sound'],  why:'笑聲是她的專利' },
    pocong:   { w:['shadow', 'paper'], i:['breath'], why:'包得密密實實' },
    penanggal:{ w:['light', 'cold'],   i:['face'],   why:'飛頭比你更嚇人' },
    baiwu:    { w:['phone', 'paper'],  i:['face'],   why:'舌頭比你長' },
    heiwu:    { w:['phone', 'light'],  i:['sound'],  why:'整天拖鐵鏈' },
    huang:    { w:['phone', 'paper'],  i:['face'],   why:'最怕電話響和新文件' },
  };
  function hash(s) { let h = 2166136261; for (const c of s) { h ^= c.charCodeAt(0); h = Math.imul(h, 16777619); } return h >>> 0; }
  function typesOf(k) { const g = has(SCARE_GHOSTS) && SCARE_GHOSTS[k]; return g ? (g.types || [g.type]) : null; }
  const cache = {};
  function fearOf(k) {
    if (EFEAR[k]) return EFEAR[k]; if (cache[k]) return cache[k];
    const own = typesOf(k) || [TYPES[hash(k) % 8]], rest = TYPES.filter(t => !own.includes(t)), h = hash(k);
    const a = rest[h % rest.length], r2 = rest.filter(t => t !== a), b = r2[(h >>> 8) % r2.length];
    return (cache[k] = { w:[a, b], i:own.slice(0, 1), why:'自己識玩的把戲不怕' });
  }
  const word = (t) => W[t] || t;
  function fearLine(k) { const f = fearOf(k); return `怕${f.w.map(word).join('、')}　不怕${f.i.map(word).join('、')}`; }
  function enemyHint(en) {
    const seen = []; for (const e of en) if (!seen.includes(e)) seen.push(e);
    return seen.map(e => `<span class="rw-ef"><b>${ENEMY_T[e] ? ENEMY_T[e][2] : e}</b> ${fearLine(e)}</span>`).join('');
  }
  function teamHint(g) { const ts = typesOf(g.k); return ts ? `嚇法：${ts.map(word).join('／')}　嚇功 Lv${drillLv(g.k)}` : ''; }

  // ---------- 嚇功（嚇人訓練班） ----------
  const DRILL = [0, 300, 1000, 2500, 5000];
  function drill() { if (!S.drill) S.drill = {}; return S.drill; }
  function drillXp(k) { return (S && S.drill && S.drill[k]) || 0; }
  function drillLv(k) { const x = drillXp(k); let lv = 1; while (lv < 5 && x >= DRILL[lv]) lv++; return lv; }
  function drillNext(k) { const lv = drillLv(k); return lv < 5 ? DRILL[lv] : null; }

  // ---------- 地盤 ----------
  const GANGS = [
    { name:'鄰村・夜冷村', boss:'Bryan', line:'Bryan：「呢度？我哋夜冷村接手喇。你慢慢跑，我哋慢慢嚇。」' },
    { name:'鄰村・夜冷村', boss:'Bryan', line:'Bryan：「你嗰度啲人怕咩我全部記低咗。多謝分享。」' },
    { name:'無牌鬼幫', boss:'', line:'一班無牌鬼插咗支旗：「呢度而家我哋話事，KPI 我哋計。」' },
    { name:'過江鬼聯盟', boss:'', line:'一群過江鬼：「我哋喺第二區冇人驚，過嚟借你地方用下。」' },
  ];
  function turf() { if (!S.turf) S.turf = { lost:{}, gang:{}, next:0, day:null, gain:0 }; const t = S.turf; t.lost = t.lost || {}; t.gang = t.gang || {}; return t; }
  function allSids() { const a = []; CHAPTERS.forEach((ch, ci) => ch.stages.forEach((st, si) => a.push(`${ci + 1}-${si + 1}`))); return a; }
  function stageOf(sid) { const [c, s] = sid.split('-').map(Number); return CHAPTERS[c - 1] && CHAPTERS[c - 1].stages[s - 1]; }
  function held() { const t = turf(); return allSids().filter(s => S.cleared && S.cleared[s] && !t.lost[s]); }
  function isLost(sid) { return !!turf().lost[sid]; }
  const clock = () => (has(Presence) && Presence.st && S.presence ? Date.now() + (S.presence.skew || 0) : Date.now());
  function gday(ms) { const d = new Date(ms); return Math.floor((ms - d.getTimezoneOffset() * 60000) / DAY); }
  function turfTick() {
    if (!S || !S.cleared) return; const t = turf(), now = clock(), h = held();
    // 每日：地盤帶來 KPI 同存在感
    const today = gday(now);
    if (t.day == null) t.day = today;
    if (today > t.day) {
      const days = Math.min(7, today - t.day); t.day = today;
      const kpi = Math.min(8, Math.floor(h.length / 3)) * days, pres = Math.min(6, h.length * 0.4) * days;
      if (kpi || pres) {
        if (S.contract && S.contract.state === 'active' && kpi) S.contract.kpi += kpi;
        if (has(Presence) && pres) for (const g of S.ghosts) if (g.k !== 'afu') Presence.add(g, pres);
        t.gain = kpi;
        try { Fx.toast(`地盤收租：${h.length} 個地盤${kpi ? `，合約 KPI +${kpi}` : ''}，全村存在感 +${Math.round(pres)}`); } catch (e) {}
      }
    }
    // 鄰村來搶：手上地盤夠多，每 8~14 小時搶一個（最多同時兩個被搶）
    if (!t.next) t.next = now + (8 + Math.random() * 6) * HOUR;
    if (now >= t.next) {
      t.next = now + (8 + Math.random() * 6) * HOUR;
      const lostN = Object.keys(t.lost).length;
      if (h.length >= 3 && lostN < 2 && S.lv >= 6) {
        const pool = h.filter(s => !stageOf(s).boss); const sid = pool[Math.floor(Math.random() * pool.length)];
        if (sid) { const gi = Math.floor(Math.random() * GANGS.length); t.lost[sid] = now; t.gang[sid] = gi;
          try { Fx.toast(`<b>${stageOf(sid).name}</b> 被${GANGS[gi].name}搶走了！到「地盤」奪回。`); } catch (e) {} }
      }
    }
  }
  function turfTag(sid) {
    if (!S.cleared || !S.cleared[sid]) return '';
    const t = turf(); if (t.lost[sid]) { const g = GANGS[t.gang[sid] || 0]; return `<em class="rw-lost">被${g.name}搶走</em>`; }
    return '<em class="rw-own">我方地盤</em>';
  }
  function turfHead() {
    const t = turf(), h = held(), lost = Object.keys(t.lost);
    let s = `<div class="rw-turf"><b>陽間地盤 ${h.length}</b><small>每日收租：合約 KPI +${Math.min(8, Math.floor(h.length / 3))}，全村存在感 +${Math.round(Math.min(6, h.length * 0.4))}。打下一關就多一個地盤；鄰村鬼幫會不時來搶。</small>`;
    if (lost.length) s += lost.map(sid => { const g = GANGS[t.gang[sid] || 0]; return `<p class="rw-raid">⚑ <b>${stageOf(sid).name}</b>（${sid}）被${g.name}搶走：<br><i>${g.line}</i></p>`; }).join('');
    return s + '</div>';
  }
  function retake(sid) {
    const t = turf(); if (!t.lost[sid]) return; delete t.lost[sid]; delete t.gang[sid];
    let kp = 0; if (S.contract && S.contract.state === 'active') { S.contract.kpi += 4; kp = 4; }
    if (has(Presence)) S.team.map(ghostById).filter(Boolean).forEach(g => Presence.add(g, 6));
    try { Fx.toast(`奪回地盤：<b>${stageOf(sid).name}</b>${kp ? `　合約 KPI +${kp}` : ''}，出陣的鬼存在感 +6`); } catch (e) {}
  }

  // ---------- 回陽間的供品與道具 ----------
  const KITS = {
    offer: { name:'供品', cost:{ buns:40 }, desc:'開局陰氣 +30' },
    props: { name:'道具箱', cost:{ planks:60 }, desc:'機關冷卻減半' },
  };
  function kitHTML() {
    S.scareKit = S.scareKit || {};
    return `<div class="rw-kit"><p class="desc"><b>帶上村裡的產出</b>（出發時扣）：</p>${Object.keys(KITS).map(k => { const K = KITS[k], on = !!S.scareKit[k], ok = canPay(K.cost);
      return `<button class="rw-kb ${on ? 'on' : ''} ${ok ? '' : 'dim'}" data-kit="${k}"><b>${K.name}</b><small>${costText(K.cost)}</small><i>${K.desc}</i></button>`; }).join('')}</div>`;
  }
  function bindKit(root) {
    root.querySelectorAll('[data-kit]').forEach(b => b.onclick = () => { const k = b.dataset.kit; S.scareKit = S.scareKit || {}; if (!S.scareKit[k] && !canPay(KITS[k].cost)) { Fx.toast('材料不夠'); return; } S.scareKit[k] = !S.scareKit[k]; b.classList.toggle('on', S.scareKit[k]); save(); });
  }

  // ---------- 接駁 ----------
  let started = false;
  function init() {
    if (started) return; started = true;
    // 戰鬥：嚇法命中
    const oh = Battle.hit;
    Battle.hit = function (src, v, mult, sk) {
      if (!sk || !src || src.side !== 0 || !v || v.side !== 1 || sk.kind === 'heal' || src.minion) return oh.call(this, src, v, mult, sk);
      const ts = typesOf(src.k); if (!ts) return oh.call(this, src, v, mult, sk);
      const f = fearOf(v.k), t = ts.find(x => f.w.includes(x)) || ts.find(x => !f.i.includes(x)) || ts[0];
      let m = mult * (1 + 0.05 * (drillLv(src.k) - 1)), tag = null, col = '#e8d0ff', chain = false;
      const marked = v.fearT && v.fearT.until > this.t;
      if (f.i.includes(t)) { m *= 0.6; tag = `不怕${word(t)}`; col = '#9aa'; }
      else if (f.w.includes(t)) {
        m *= 1.35;
        if (marked && v.fearT.t !== t) { m *= 1.8; chain = true; tag = `${word(v.fearT.t)}＋${word(t)}・連嚇`; col = '#ffd84a'; }
        else tag = `怕${word(t)}・失神`;
        v.fearT = { t, until:this.t + 3.2 };
      } else if (marked && v.fearT.t !== t) { m *= 1.3; tag = '追嚇'; col = '#ffe8a0'; }
      const dmg = oh.call(this, src, v, m, sk);
      if (tag && v.x != null) this.fx.push({ x:v.x, y:this.uy(v) - 100 * this.scaleOf(v), text:tag, col, t:0, life:1.1 });
      if (chain) { Sound.play('combo', this.combo); this.combo = this.comboT > 0 ? this.combo + 1 : 1; this.comboT = 3; this.comboPop = 1; this.fx.push({ x:195, y:(this.H || 640) * 0.3, text:`連嚇 ×${this.combo + 1}！`, col:'#ffd84a', t:0, life:1.2, center:true }); }
      return dmg;
    };
    // 搶地盤：奪回戰敵人強一點；打贏就奪回
    const os = Battle.start;
    Battle.start = function (ci, si, wild) { const r = os.apply(this, arguments); try { this.retake = !wild && isLost(this.sid); if (this.retake) { for (const u of this.units) if (u.side === 1) { u.hp *= 1.15; u.maxhp *= 1.15; u.atk *= 1.1; } $('#b-title').textContent = `奪回地盤　${this.stage.name}`; } } catch (e) {} return r; };
    const of = Battle.finish;
    Battle.finish = function (win) { const was = !this.result, rt = this.retake, sid = this.sid; const r = of.apply(this, arguments); try { if (was && win && rt) retake(sid); this.retake = false; } catch (e) {} return r; };
    // 回陽間：嚇功、供品、道具箱
    const ostart = Scare.start;
    Scare.start = function (siteId, team, headless, seed) {
      let kit = {}; if (!headless && S.scareKit) for (const k in S.scareKit) if (S.scareKit[k] && canPay(KITS[k].cost)) { pay(KITS[k].cost); kit[k] = true; }
      this.kit = kit;
      const r = ostart.apply(this, arguments);
      if (!headless) { this._drill = {}; for (const k of team) this._drill[k] = drillLv(k); }
      if (kit.offer) this.mana += 30;
      if (Object.keys(kit).length) { try { save(); this.toast(`帶上：${Object.keys(kit).map(k => KITS[k].name).join('、')}`); } catch (e) {} }
      return r;
    };
    const oug = Scare.useGhost;
    Scare.useGhost = function (k, n) { const g = SCARE_GHOSTS[k], lv = (this._drill && this._drill[k]) || 1; if (!g || lv <= 1) return oug.apply(this, arguments); const b = g.base, c = g.cost; g.base = Math.round(b * (1 + 0.1 * (lv - 1))); g.cost = Math.max(18, (c || 35) - 2 * (lv - 1)); try { return oug.apply(this, arguments); } finally { g.base = b; g.cost = c; } };
    const oup = Scare.useProp;
    Scare.useProp = function (k) { const before = this.pcd && this.pcd[k]; const r = oup.apply(this, arguments); try { if (this.kit && this.kit.props && this.pcd && this.pcd[k] > 0 && this.pcd[k] !== before) this.pcd[k] *= 0.5; } catch (e) {} return r; };
    setInterval(() => { try { turfTick(); } catch (e) {} }, 5000); turfTick();
  }
  (function boot() { if (typeof S === 'undefined' || !S || !has(Battle) || !Battle.hit || !has(Scare)) { setTimeout(boot, 300); return; } try { init(); } catch (e) { console.error(e); } })();
  return { W, TYPES, word, fearOf, fearLine, enemyHint, teamHint, typesOf, drillXp, drillLv, drillNext, DRILL, turf, held, isLost, turfTag, turfHead, turfTick, retake, GANGS, KITS, kitHTML, bindKit, stageOf };
})();
