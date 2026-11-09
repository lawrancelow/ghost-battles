// ===================== 遊戲核心：狀態、經濟、村子、介面 =====================
const $ = (q) => document.querySelector(q);
const fmt = (n) => { n = Math.floor(n); if (n >= 1e6) return (n / 1e6).toFixed(1) + 'M'; if (n >= 1e4) return (n / 1e3).toFixed(1) + 'K'; return '' + n; };
const RES_NAMES = { wood:'槐木', rice:'糯米', planks:'棺材板', buns:'壽包', coins:'冥幣', troops:'陰兵' };
const SPEAKER_ART = { '阿福':'afu','小紙':'xiaozhi','白無常':'baiwu','黑無常':'heiwu','黑白無常':'baiwu','黃總':'huang','餓鬼王':'eguiking','餓鬼':'egui','Toyol':'toyol','老殭':'laojiang','Pontianak':'pontianak','Pocong':'pocong','Penanggal':'penanggal','孟婆':'mengpo','遊魂阿強':'youhun','天花姐':'tianhua' };
const SAVE_KEY = 'ghostBattles_v1';
const DEBUG = /debug/.test(location.search);

let S; // 存檔狀態
let TIME_SCALE = 1;

function newState() {
  return {
    v:1, lv:1, exp:0,
    res:{ wood:0, rice:0, planks:0, buns:0, coins:0, troops:0 },
    bld:{ house:1, wood:1, rice:1, plank:0, bun:0, store:0, home:0, camp:0, altar:0, furnace:0 },
    ghosts:[{ id:'afu', k:'afu', name:'阿福', q:'主', lv:1, st:[30,30,30], post:null, spent:0 }],
    team:['afu', null, null], adviser:null,
    cleared:{}, qi:0, cnt:{ chop:0, rice:0, craftPlank:0, craftBun:0, recruit:0, feast:0, chest:0 },
    seen:{}, chests:{ g:0, b:0, p:0 }, furnaceAt:0, feastAt:0, last:Date.now(), ended:false,
    trees:[3,3,3,3,3,3,3,3], treeRegrow:[0,0,0,0,0,0,0,0], paddy:[1,1,1,1,1,1], paddyRegrow:[0,0,0,0,0,0],
    uid:1, prod:{},
  };
}
function save() { try { S.last = Date.now(); localStorage.setItem(SAVE_KEY, JSON.stringify(S)); } catch (e) {} }
function load() { try { const j = localStorage.getItem(SAVE_KEY); if (j) return JSON.parse(j); } catch (e) {} return null; }

// ---------------- 數值公式 ----------------
const F = {
  expNeed: (lv) => Math.round(30 * Math.pow(lv, 1.75)),
  ghostCap: () => S.lv >= 15 ? 40 : S.lv >= 7 ? 30 : 20,
  stat: (g, i) => Math.round(g.st[i] * (1 + 0.06 * (F.glv(g) - 1))),
  glv: (g) => g.k === 'afu' ? Math.min(F.ghostCap(), S.lv * 2) : g.lv,
  lvCost: (lv) => Math.floor(6 * Math.pow(lv, 1.5)) + 4,
  bldMax: (id) => id === 'house' ? 20 : S.bld.house,
  upCost: (id, lv) => { // lv = 現在等級 → lv+1
    const k = id === 'house' ? 1.1 : 0.9;
    let planks = Math.round(25 * Math.pow(lv, 1.72) * k), coins = Math.round(28 * Math.pow(lv, 1.8) * k);
    planks = Math.round(planks * (1 - F.builderDiscount()));
    return { planks, coins };
  },
  builderDiscount: () => { const g = workersAt('boss')[0]; return g ? Math.min(0.35, F.glv(g) * 0.012) : 0; },
  slots: (post) => { const p = POSTS[post]; const lv = S.bld[p.bld]; if (!lv) return 0; if (post === 'boss') return 1; return Math.min(4, 1 + Math.floor((lv - 1) / 3)); },
  mult: (bid) => 1 + 0.3 * (S.bld[bid] - 1),
  cap: () => { let c = 400 + (S.bld.store ? 400 * Math.pow(S.bld.store, 1.5) : 0) + (S.lv >= 9 ? 600 : 0); const m = workersAt('store')[0]; if (m) c *= 1 + F.stat(m, 2) / 100; return Math.round(c); },
  troopCap: () => 150 + 150 * S.bld.home + 50 * S.bld.camp,
  rosterCap: () => 5 + 2 * S.bld.home,
  walk: () => (S.lv >= 5 ? 150 : 95) * (typeof GhostStreet !== 'undefined' ? GhostStreet.mul('walk') : 1),
  chopTime: () => S.lv >= 2 ? 0.42 : 0.7,
  furnaceCD: 300, feastCD: 1200,
  furnaceCoins: () => 30 + 15 * S.bld.furnace + 6 * S.lv,
  chestGain: (c) => c === 'g' ? { buns: 40 + 30 * S.bld.bun } : c === 'b' ? { planks: 30 + 25 * S.bld.plank } : { coins: 120 + 60 * S.bld.house },
  recruitCost: () => ({ coins:150, buns:40 }),
  feastNeed: 350,
};
function fodderCount() { return S.ghosts.filter(g => g.q === '藍' || g.q === '紫').length; }
function workersAt(post) { return S.ghosts.filter(g => g.post === post); }
function ghostById(id) { return S.ghosts.find(g => g.id === id); }
function gdef(g) { return GHOSTS[g.k] || FODDER[g.k]; }

// 每分鐘產量（同時給介面顯示）
function ratesPerMin() {
  const r = { wood:0, rice:0, planks:0, buns:0, troops:0, coins:0, woodUse:0, riceUse:0, bunUse:0, exp:0 };
  for (const g of S.ghosts) {
    if (!g.post) continue; const lv = F.glv(g);
    switch (g.post) {
      case 'wood': r.wood += (9 + 0.7 * lv) * F.mult('wood'); break;
      case 'rice': r.rice += (9 + 0.7 * lv) * F.mult('rice'); break;
      case 'plank': { const o = (2.5 + F.stat(g, 0) * 0.05) * F.mult('plank'); r.planks += o; r.woodUse += o * 2; break; }
      case 'bun': { const o = (2.5 + F.stat(g, 1) * 0.05) * F.mult('bun'); r.buns += o; r.riceUse += o * 2; break; }
      case 'camp': { const o = (2 + F.stat(g, 2) * 0.04) * F.mult('camp'); r.drill = (r.drill || 0) + o; r.bunUse += o * 0.6; (r.drillBy = r.drillBy || []).push([g.k, o]); break; } // 嚇人訓練班：練嚇功（rework.js）
      case 'store': if (g.k === 'toyol') r.coins += 2 + lv * 0.25; break;
    }
    r.exp += 0.6;
  }
  if (S.bld.home) r.troops += 1.2 + 1.3 * S.bld.home; // 村裡的遊魂自願當陰兵（民宅）
  return r;
}
// 推進 dt 秒的產出（含加工鏈，原料不足時按比例）
let expAcc = 0;
function produce(dt) {
  const r = ratesPerMin(), m = dt / 60, cap = F.cap(), R = S.res;
  if (R.wood < cap) R.wood = Math.min(cap, R.wood + r.wood * m);
  if (R.rice < cap) R.rice = Math.min(cap, R.rice + r.rice * m);
  if (r.planks && R.planks < cap) { const need = r.woodUse * m; const k = need > 0 ? Math.min(1, R.wood / need) : 0; R.wood -= need * k; R.planks = Math.min(cap, R.planks + r.planks * m * k); }
  if (r.buns && R.buns < cap) { const need = r.riceUse * m; const k = need > 0 ? Math.min(1, R.rice / need) : 0; R.rice -= need * k; R.buns = Math.min(cap, R.buns + r.buns * m * k); }
  if (r.troops && R.troops < F.troopCap()) R.troops = Math.min(F.troopCap(), R.troops + r.troops * m);
  if (r.drillBy) { const need = r.bunUse * m; const k = need > 0 ? Math.min(1, R.buns / need) : 0; R.buns -= need * k; S.drill = S.drill || {}; for (const [gk, o] of r.drillBy) S.drill[gk] = (S.drill[gk] || 0) + o * m * k; }
  R.coins += r.coins * m;
  expAcc += r.exp * m; if (expAcc >= 1) { const e = Math.floor(expAcc); expAcc -= e; gainExp(e, true); }
}

// ---------------- 資源操作 ----------------
function canPay(c) { for (const k in c) if ((S.res[k] || 0) < c[k] - 1e-6) return false; return true; }
function pay(c) { for (const k in c) S.res[k] -= c[k]; }
function costText(c) { return Object.keys(c).filter(k => c[k]).map(k => `<span class="${(S.res[k] || 0) >= c[k] ? '' : 'lack'}">${RES_NAMES[k]} ${fmt(c[k])}</span>`).join('　'); }
function give(r, src) {
  const parts = [];
  for (const k in r) {
    if (k === 'exp') { gainExp(r.exp); parts.push(`好評 +${r.exp}`); }
    else if (k === 'chest') { S.chests[r.chest]++; parts.push({ g:'綠箱', b:'藍箱', p:'紫箱' }[r.chest] + ' ×1'); }
    else { S.res[k] = (S.res[k] || 0) + r[k]; parts.push(`${RES_NAMES[k]} +${fmt(r[k])}`); }
  }
  return parts.join('，');
}
function gainExp(n, silent) {
  S.exp += n; let up = false;
  while (S.lv < 20 && S.exp >= F.expNeed(S.lv)) { S.exp -= F.expNeed(S.lv); S.lv++; up = true; onLevelUp(S.lv); }
  if (S.lv >= 20) S.exp = Math.min(S.exp, F.expNeed(20));
  if (up) { UI.refresh(); }
}
function onLevelUp(lv) {
  const u = LEVEL_UNLOCKS[lv];
  Sound.play('levelUp'); Fx.banner(`升級！Lv ${lv}` + (u ? `　解鎖【${u.name}】` : ''));
  if (u) Story.queue({ style:'sys', lines:u.lines.concat([['旁白', `解鎖：${u.desc}`]]) });
  if (lv === 4 && !S.seen.gift_xiaozhi) {
    Story.queue('gift_xiaozhi'); Story.queue('gift_xiaozhi2', () => joinGhost('xiaozhi'));
  }
}
function joinGhost(k) {
  if (S.ghosts.some(g => g.k === k)) return;
  const d = GHOSTS[k];
  const g = { id:'g' + (S.uid++), k, name:d.name, q:'名', lv:Math.max(1, Math.min(F.ghostCap(), Math.floor(S.lv * 1.3))), st:d.base.slice(), post:null, spent:0 };
  S.ghosts.push(g);
  // 自動補上空的出陣位
  const i = S.team.indexOf(null); if (i >= 0) S.team[i] = g.id;
  Sound.play('gong'); Fx.banner(`【${d.name}】加入了落魄村！`);
  UI.refresh();
}

// ---------------- 任務 ----------------
const Quest = {
  cur() { return QUESTS[S.qi]; },
  progress(q) {
    switch (q.t) {
      case 'chop': return [S.cnt.chop, q.n];
      case 'rice': return [S.cnt.rice, q.n];
      case 'craftPlank': return [S.cnt.craftPlank, q.n];
      case 'craftBun': return [S.cnt.craftBun, q.n];
      case 'level': return [S.lv, q.n];
      case 'build': return [S.bld[q.b] ? 1 : 0, 1];
      case 'bLevel': return [S.bld[q.b], q.n];
      case 'assign': return [S.ghosts.filter(g => g.post).length, q.n];
      case 'stage': return [S.cleared[q.s] ? 1 : 0, 1];
      case 'recruit': return [S.cnt.recruit, q.n];
      case 'ghostLv': return [Math.max(...S.ghosts.filter(g => g.k !== 'afu').map(g => g.lv), 0), q.n];
      case 'troops': return [Math.floor(S.res.troops), q.n];
      case 'drill': { const m = Math.max(0, ...Object.values(S.drill || {}).concat([0])); return [Math.floor(Math.min(m, q.n)), q.n]; }
      case 'feast': return [S.cnt.feast, q.n];
      case 'visit': return [S.visit && S.visit[q.place] ? 1 : 0, 1]; // guide.js
    }
    return [0, 1];
  },
  done(q) { const [a, b] = this.progress(q); return a >= b; },
  check() {
    const q = this.cur(); if (!q) return;
    if (this.done(q) && !Story.busy()) { this.complete(); }
    // 支線：鬼宅天花板上的「哎喲」
    if (S.seen.ch2_end && S.bld.house >= 4 && !S.seen.side_tianhua && !Story.busy() && !Battle.active) Story.queue('side_tianhua', () => joinGhost('tianhua'));
  },
  complete() {
    const q = this.cur(); S.qi++;
    const txt = give(q.r); Sound.play('coin');
    Fx.toast(`任務完成：${q.text}<br><b>${txt}</b>` + (q.note ? `<br>${q.note}` : ''));
    const nq = this.cur();
    if (nq && nq.onStart) nq.onStart.forEach(id => { if (!S.seen[id]) Story.queue(id); });
    save(); UI.refresh();
  },
};

// ---------------- 村子場景 ----------------
const W = 390, WH = 1130;
const POS = {
  gate:[195,118], house:[195,300], furnace:[338,258],
  wood:[92,612], rice:[298,612], plank:[95,752], bun:[295,752], store:[195,872], home:[92,1000], camp:[300,1000], altar:[195,1092],
};
const DECOR = [['webTL',223,389],['webTR',375,389],['scarecrow',293,488],['willo',258,438],['willo',350,498],['willo',300,404],['post',160,180],['post',230,180],['post',160,690],['post',230,690],['post',160,945],['post',230,945],['grave',26,840],['grave',58,858],['grave',362,850],['banana',372,560],['banana',18,610],['banana',372,930],['banana',20,1060],['offer',150,320],['offer',240,320],['grave',360,1080],['offer',290,880]];
const TREE_POS = [[38,402],[92,392],[146,404],[62,452],[118,448],[168,458],[40,506],[100,512]];
const PADDY_POS = [[248,412],[338,412],[248,462],[338,462],[248,512],[338,512]];
const Village = {
  cvs:null, ctx:null, camY:0, w:390, h:600, dpr:1, t:0,
  hero:{ x:195, y:350, tx:195, ty:350, dir:1, act:null, actT:0, target:null },
  floats:[], crows:[], feathers:[], drag:null, workerPhase:{}, vis:[], bubble:null, chatT:6, chatUsed:{},
  init() {
    this.cvs = $('#village'); this.ctx = this.cvs.getContext('2d');
    this.resize(); window.addEventListener('resize', () => this.resize());
    const c = this.cvs;
    const down = (e) => { const p = this.pt(e); this.drag = { y0:p.cy, cam:this.camY, moved:false, x:p.cx, y:p.cy }; };
    const move = (e) => { if (!this.drag) return; const p = this.pt(e); const dy = p.cy - this.drag.y0; if (Math.abs(dy) > 8) this.drag.moved = true; if (this.drag.moved) this.setCam(this.drag.cam - dy); e.preventDefault(); };
    const up = (e) => { if (!this.drag) return; const d = this.drag; this.drag = null; if (!d.moved) this.tap(d.x, d.y + this.camY); };
    c.addEventListener('pointerdown', down); c.addEventListener('pointermove', move, { passive:false }); window.addEventListener('pointerup', up);
    c.addEventListener('wheel', (e) => { this.setCam(this.camY + e.deltaY * 0.6); e.preventDefault(); }, { passive:false });
    this.camY = 180;
  },
  resize() {
    const r = this.cvs.getBoundingClientRect(); this.dpr = Math.min(2, window.devicePixelRatio || 1);
    this.w = r.width; this.h = r.height; this.cvs.width = r.width * this.dpr; this.cvs.height = r.height * this.dpr;
    this.scale = this.w / W; this.setCam(this.camY);
  },
  setCam(y) { const vh = this.h / this.scale; this.camY = Math.max(0, Math.min(WH - vh, y)); },
  pt(e) { const r = this.cvs.getBoundingClientRect(); return { cx:(e.clientX - r.left) / this.scale, cy:(e.clientY - r.top) / this.scale }; },
  focus(x, y) { this.setCam(y - (this.h / this.scale) / 2); },
  hitTest(x, y) {
    for (let i = 0; i < TREE_POS.length; i++) { const [tx, ty] = TREE_POS[i]; if (Math.abs(x - tx) < 24 && y > ty - 72 && y < ty + 8) return { kind:'tree', i }; }
    for (let i = 0; i < PADDY_POS.length; i++) { const [px, py] = PADDY_POS[i]; if (Math.abs(x - px) < 26 && Math.abs(y - py + 4) < 16) return { kind:'paddy', i }; }
    for (const id of Object.keys(POS)) {
      const [bx, by] = POS[id]; const w = id === 'house' ? 70 : id === 'gate' ? 65 : id === 'furnace' ? 26 : 46, h = id === 'house' ? 115 : id === 'gate' ? 92 : 70;
      if (Math.abs(x - bx) < w && y > by - h && y < by + 10) return { kind:id === 'gate' ? 'gate' : 'bld', id };
    }
    return null;
  },
  tap(x, y) {
    if (Story.busy() || UI.modalOpen()) return;
    if (typeof HeroDaily !== 'undefined' && HeroDaily.tap(this, x, y)) return; // 阿福打瞌睡時點他：驚醒（daily_hero.js）
    const h = this.hitTest(x, y);
    if (!h) { this.walkTo(x, y, null); return; }
    if (h.kind === 'tree') { if (S.trees[h.i] > 0) this.walkTo(TREE_POS[h.i][0] + 20, TREE_POS[h.i][1] + 4, { kind:'tree', i:h.i }); else Fx.float(x, y - 30, '樹樁還在長…', '#ccc'); return; }
    if (h.kind === 'paddy') { if (S.paddy[h.i]) this.walkTo(PADDY_POS[h.i][0] - 30, PADDY_POS[h.i][1] + 4, { kind:'paddy', i:h.i }); else Fx.float(x, y - 20, '稻子還沒熟', '#ccc'); return; }
    if (h.kind === 'gate') { if (typeof World !== 'undefined') World.open(); else UI.open('battle'); return; }
    if (h.kind === 'bld') { UI.openBuilding(h.id); return; }
  },
  walkTo(x, y, target) { const H = this.hero; H.tx = Math.max(14, Math.min(W - 14, x)); H.ty = Math.max(150, Math.min(WH - 10, y)); H.target = target; H.act = null; },
  craft(bid, n) {
    n = Math.max(1, n | 0 || 1); const src = bid === 'plank' ? 'wood' : 'rice', can = Math.floor(S.res[src] / 4);
    if (can < 1) { Fx.float(this.hero.x, this.hero.y - 60, `${RES_NAMES[src]}不夠（要 4）`, '#ff9a9a'); return; }
    if (can < n) Fx.float(this.hero.x, this.hero.y - 60, `材料只夠做 ${can} 份`, '#ffb37a');
    const [bx, by] = POS[bid]; this.walkTo(bx + (bid === 'plank' ? 40 : -40), by + 14, { kind:'craft', bid, n, want:n, done:0, short:can < n, dur:0.9 });
  },
  update(dt) {
    if (this.hitstop > 0) { this.hitstop -= dt; this.updateParts(dt * 0.3, true); return; }
    this.t += dt; const H = this.hero;
    // 樹與稻子再生
    for (let i = 0; i < S.trees.length; i++) if (S.trees[i] <= 0) { S.treeRegrow[i] -= dt; if (S.treeRegrow[i] <= 0) S.trees[i] = 3; }
    for (let i = 0; i < S.paddy.length; i++) if (!S.paddy[i]) { S.paddyRegrow[i] -= dt; if (S.paddyRegrow[i] <= 0) S.paddy[i] = 1; }
    const dx = H.tx - H.x, dy = H.ty - H.y, d = Math.hypot(dx, dy);
    if (d > 2) { const sp = F.walk() * dt; H.x += dx / d * Math.min(sp, d); H.y += dy / d * Math.min(sp, d); if (Math.abs(dx) > 1) H.dir = dx > 0 ? 1 : -1; H.walking = true; }
    else {
      H.walking = false;
      if (H.target) { H.act = H.target; H.target = null; H.actT = 0; if (H.act.kind === 'tree') H.dir = -1; if (H.act.kind === 'paddy') H.dir = 1; if (H.act.kind === 'craft') H.dir = H.act.bid === 'plank' ? -1 : 1; }
      if (H.act) this.doAct(dt * (typeof GhostStreet !== 'undefined' ? GhostStreet.mul('work') : 1));
    }
    this.updateParts(dt);
    if (typeof HeroDaily !== 'undefined') HeroDaily.update(this, dt); // 阿福的平日動作排程（站著沒事 → 打呵欠、看手機、打瞌睡…）
    this.floats = this.floats.filter(f => (f.t += dt) < f.life);
    this.feathers = this.feathers.filter(f => { f.t += dt; f.x += f.vx * dt + Math.sin(f.t * 4) * 0.4; f.y += 14 * dt; f.rot += dt * 2; return f.t < f.life; });
    this.crows = this.crows.filter(c => { c.t += dt; c.x += c.vx * dt; c.y += c.vy * dt; c.vy -= 30 * dt; c.ph += dt * 22; return c.t < c.life; });
    // 村民碎碎念
    if (this.bubble && (this.bubble.t += dt) > 4.6) this.bubble = null;
    this.chatT -= dt; if (this.chatT <= 0 && !this.bubble) { this.chatT = 6 + Math.random() * 5; this.pickChatter(); }
  },
  doAct(dt) {
    const H = this.hero, a = H.act; H.actT += dt;
    if (a.kind === 'tree') {
      if (S.trees[a.i] <= 0) { H.act = null; return; }
      if (H.actT >= F.chopTime()) {
        H.actT = 0; const firstHit = S.trees[a.i] === 3; S.trees[a.i]--; a.shake = 0.15; Sound.play('chop'); { const [tx0, ty0] = TREE_POS[a.i]; this.impact(tx0 + 6, ty0 - 22, 'wood', firstHit ? 1.2 : 1); }
        if (firstHit) this.scatterCrows(a.i);
        const [tx, ty] = TREE_POS[a.i]; Fx.float(tx, ty - 50, '咚！', '#ffe9a8');
        if (S.trees[a.i] <= 0) {
          S.treeRegrow[a.i] = 25; S.cnt.chop++; S.res.wood += 4; gainExp(2); Sound.play('treeFall');
          Fx.float(tx, ty - 70, '槐木 +4　好評 +2', '#a8ffcf'); Fx.praise('chop'); H.act = null; this.proudT = 0.9; this.shk = 5; Quest.check();
        }
      }
    } else if (a.kind === 'paddy') {
      if (H.actT >= F.chopTime() * 1.4) {
        S.paddy[a.i] = 0; S.paddyRegrow[a.i] = 20; this.proudT = 0.8; S.cnt.rice++; S.res.rice += 3; gainExp(1); Sound.play('harvest');
        const [px, py] = PADDY_POS[a.i]; Fx.float(px, py - 30, '糯米 +3　好評 +1', '#a8ffcf'); Fx.praise('rice'); H.act = null; Quest.check();
      }
    } else if (a.kind === 'craft') {
      // 批量製作：每份照舊計算（材料、產出、S.cnt、好評、任務），第一份 0.9 秒，之後每份 0.6 秒。a.dur 給動畫同步用。
      if (a.n == null) { a.n = 1; a.want = 1; a.done = 0; }
      if (a.dur == null) a.dur = 0.9;
      if (H.actT >= a.dur) {
        const plank = a.bid === 'plank', src = plank ? 'wood' : 'rice', out = plank ? 'planks' : 'buns';
        if (S.res[src] < 4) { H.act = null; Fx.float(H.x, H.y - 60, a.done ? `${RES_NAMES[src]}用完了，做好 ${a.done} 份` : `${RES_NAMES[src]}不夠（要 4）`, '#ff9a9a'); return; }
        S.res[src] -= 4; S.res[out] += 2; S.cnt[plank ? 'craftPlank' : 'craftBun']++; gainExp(1); Sound.play('craft');
        a.done++; a.n--; Quest.check();
        const more = a.n > 0 && S.res[src] >= 4;
        if (a.want === 1) { Fx.float(H.x, H.y - 60, `${RES_NAMES[out]} +2　好評 +1`, '#a8ffcf'); Fx.praise('craft'); }
        else if (more) Fx.float(H.x + 26, H.y - 44, `${RES_NAMES[out]} ${a.done}/${a.short ? a.done + Math.min(a.n, Math.floor(S.res[src] / 4)) : a.want}`, '#ffe9a8');
        if (more) { H.actT = 0; a.dur = 0.6; return; }
        H.act = null;
        if (a.want > 1) {
          Fx.float(H.x, H.y - 66, `${RES_NAMES[out]} +${a.done * 2}　好評 +${a.done}`, '#a8ffcf');
          Fx.praise('craft');
        }
      }
    }
  },
  // 阿福現在在做什麼動作、做到哪裡（0~1）
  heroPose() {
    const H = this.hero, a = H.act;
    if (this.proudT > 0) return ['proud', 0];
    if (!a || H.walking) return [null, 0];
    if (a.kind === 'tree') return ['chop', Math.min(1, H.actT / F.chopTime())];
    if (a.kind === 'paddy') return ['reap', Math.min(1, H.actT / (F.chopTime() * 1.4))];
    if (a.kind === 'craft') return [a.bid === 'plank' ? 'hammer' : 'knead', Math.min(1, H.actT / (a.dur || 0.9))];
    return [null, 0];
  },
  // 打中的那一下：停格、震動、碎片
  impact(x, y, kind, power) {
    const P = this.parts = this.parts || []; power = power || 1;
    this.hitstop = Math.max(this.hitstop || 0, 0.05 * power); this.shk = Math.max(this.shk || 0, 2.5 * power);
    P.push({ k:'spark', x, y, t:0, life:0.16, s:0.07 * power, r:Math.random() * 6 });
    const n = kind === 'wood' ? 6 : kind === 'rice' ? 9 : kind === 'dough' ? 2 : 3;
    for (let i = 0; i < n; i++) P.push({ k:kind === 'wood' ? 'chip' : kind === 'rice' ? 'grain' : kind === 'dough' ? 'dough' : 'dust', x, y, vx:(Math.random() - 0.5) * 120 + (kind === 'wood' ? 50 : 0), vy:-60 - Math.random() * 90, g:kind === 'dust' ? -10 : 320, t:0, life:0.5 + Math.random() * 0.4, r:Math.random() * 6, vr:(Math.random() - 0.5) * 18, s:kind === 'dough' ? 0.022 : kind === 'dust' ? 0.035 : 0.04 + Math.random() * 0.03 });
    if (kind !== 'rice') P.push({ k:'dust', x, y:y + 4, vx:0, vy:-12, g:0, t:0, life:0.45, r:0, vr:0, s:0.05 });
  },
  updateParts(dt, frozen) {
    const P = this.parts || []; this.parts = P.filter(p => { p.t += dt; p.x += (p.vx || 0) * dt; p.y += (p.vy || 0) * dt; p.vy = (p.vy || 0) + (p.g || 0) * dt; p.r += (p.vr || 0) * dt; return p.t < p.life; });
    if (this.shk > 0) this.shk = Math.max(0, this.shk - dt * 18);
    if (this.proudT > 0) this.proudT -= dt;
    if (frozen) return;
    // 錘子、揉麵：每一下落下的瞬間出特效
    const H = this.hero, a = H.act;
    if (a && a.kind === 'craft' && !H.walking) {
      const p = Math.min(1, H.actT / (a.dur || 0.9)), hits = a.bid === 'plank' ? [0.5, 0.999] : [0.125, 0.375, 0.625, 0.875];
      const prev = this._pp == null ? p : this._pp;
      for (const h of hits) if (prev < h && p >= h) this.impact(H.x + (H.dir < 0 ? -16 : 16), H.y - 4, a.bid === 'plank' ? 'wood' : 'dough', a.bid === 'plank' ? 0.8 : 0.4);
      this._pp = p >= 0.999 ? 0 : p;
    } else if (a && a.kind === 'paddy' && !H.walking) {
      const p = Math.min(1, H.actT / (F.chopTime() * 1.4)), prev = this._pp == null ? p : this._pp;
      for (const h of [1 / 12, 5 / 12, 9 / 12]) if (prev < h && p >= h) { const [px, py] = PADDY_POS[a.i]; this.impact(px - 6 + Math.random() * 12, py - 8, 'rice', 0.5); }
      this._pp = p;
    } else this._pp = null;
  },
  drawParts(ctx) {
    for (const p of this.parts || []) {
      const f = p.t / p.life; ctx.save(); ctx.globalAlpha = Math.max(0, 1 - f * f); ctx.translate(p.x, p.y); ctx.rotate(p.r);
      const im = { spark:'fx_spark', chip:'fx_chips', dust:'fx_dust', dough:'fx_dough', grain:'fx_dough' }[p.k];
      if (p.k === 'grain') { ctx.fillStyle = '#e9cf7a'; ctx.fillRect(-1.5, -3, 3, 6); }
      else if (im && typeof sprOk === 'function' && sprOk(im)) { const I = SPR[im], sc = p.s * (p.k === 'spark' ? 1 + f * 0.8 : p.k === 'dust' ? 1 + f * 1.5 : 1); ctx.drawImage(I, -I.naturalWidth * sc / 2, -I.naturalHeight * sc / 2, I.naturalWidth * sc, I.naturalHeight * sc); }
      ctx.restore();
    }
  },
  draw() {
    const ctx = this.ctx, t = this.t; const sk = this.shk || 0, kx = (Math.random() - 0.5) * sk, ky = (Math.random() - 0.5) * sk; ctx.setTransform(this.dpr * this.scale, 0, 0, this.dpr * this.scale, kx * this.dpr * this.scale, (ky - this.camY) * this.dpr * this.scale);
    // 地面（靜態圖層只畫一次）
    ctx.drawImage(groundLayer(), 0, 0, W, WH);
    for (let i = 0; i < 9; i++) { const fx = (i * 47 + 20) % W, fy = 24 + (i * 31) % 112; drawLily(ctx, fx, fy, t + i); } // 彼岸花
    // 霧
    for (let i = 0; i < 6; i++) { const mx = ((t * 8 + i * 90) % (W + 200)) - 100, my = 160 + i * 170; const mg = ctx.createRadialGradient(mx, my, 5, mx, my, 90); mg.addColorStop(0, 'rgba(200,210,200,.06)'); mg.addColorStop(1, 'rgba(200,210,200,0)'); ctx.fillStyle = mg; ctx.fillRect(mx - 90, my - 90, 180, 180); }
    // 物件依 y 排序繪製
    const items = [];
    items.push({ y:POS.gate[1], f:() => ART.drawGate(ctx, POS.gate[0], POS.gate[1], t) });
    for (const id of BLD_ORDER) {
      const [x, y] = POS[id]; const lv = S.bld[id];
      if (lv) items.push({ y, f:() => ART.drawBuilding(ctx, id, x, y, lv, t, id === 'furnace' ? furnaceReady() : null) });
      else if (bldUnlocked(id)) items.push({ y, f:() => ART.drawSite(ctx, x, y, BUILDINGS[id].name) });
    }
    DECOR.forEach(([k, x, y]) => items.push({ y, f:() => ART.drawDecor(ctx, k, x, y, t) }));
    TREE_POS.forEach(([x, y], i) => items.push({ y, f:() => ART.drawTree(ctx, x, y, S.trees[i], t, this.hero.act && this.hero.act.kind === 'tree' && this.hero.act.i === i && this.hero.act.shake > 0 && (this.hero.act.shake -= 1 / 60) > 0, S.trees[i] === 3, i) }));
    PADDY_POS.forEach(([x, y], i) => items.push({ y:y - 10, f:() => ART.drawPaddy(ctx, x, y, S.paddy[i], t, i) }));
    // 打工中的鬼怪
    const spots = this.workerSpots(); const vis = this.vis = [];
    for (const s of spots) vis.push({ g:s.g, x:s.x, y:s.y });
    const workInfo = { furnace:S.bld.furnace ? [POS.furnace[0], POS.furnace[1] - 22] : null }; // 崗位打工（daily_work.js）：工頭在化寶爐蓋好後會走過去燒金紙
    for (const s of spots) items.push({ y:s.y, f:() => typeof WORK !== 'undefined' ? WORK.drawWorker(ctx, s, t, 0.62, workInfo) : ART.drawChar(ctx, s.g.k, s.x, s.y, 0.62, { t:t + s.ph, work:true, flip:s.flip, tamed:true, untied:true }) });
    // 閒著的鬼怪在廣場晃
    const idle = S.ghosts.filter(g => !g.post && g.k !== 'afu');
    // 廣場生活：有目的地走、停、做各自的小動作、碰面聊天（daily_plaza.js，狀態放在 this.plaza）
    if (typeof PlazaLife !== 'undefined') PlazaLife.frame(this, idle, items, vis, ctx, t);
    else idle.forEach((g, i) => { const a = t * 0.25 + i * 1.7; const x = 195 + Math.cos(a) * (60 + (i % 3) * 18), y = 400 + 130 + Math.sin(a * 1.3) * 18 + (i % 3) * 8; vis.push({ g, x, y }); items.push({ y, f:() => ART.drawChar(ctx, g.k, x, y, 0.58, { t:t + i, walk:true, flip:Math.sin(a) > 0, tamed:true, untied:true }) }); });
    const H = this.hero;
    vis.push({ g:S.ghosts[0], x:H.x, y:H.y, hero:true });
    const hp = this.heroPose(), hd = typeof HeroDaily !== 'undefined' ? HeroDaily.opts(this) : null; items.push({ y:H.y, f:() => ART.drawChar(ctx, 'afu', H.x, H.y, 0.72, Object.assign({ t, walk:H.walking, work:!!H.act, flip:H.dir < 0, mood:S.ended ? 'happy' : null, pose:hp[0], pt:hp[1] }, hd || {})) });
    items.sort((a, b) => a.y - b.y).forEach(i => i.f());
    // 飛散的烏鴉
    for (const f of this.feathers) { ctx.save(); ctx.globalAlpha = Math.max(0, 1 - f.t / f.life); ctx.translate(f.x, f.y); ctx.rotate(Math.sin(f.rot) * 0.8); ART.el(ctx, 0, 0, 1.4, 4, '#14111a', '#5a5068', 0.5); ctx.restore(); }
    this.drawParts(ctx);
    for (const c of this.crows) { ctx.globalAlpha = Math.min(1, (c.life - c.t) / 0.6); ART.drawCrow(ctx, c.x, c.y, c.s, c.ph, c.vx, false); ctx.globalAlpha = 1; }
    // 碎碎念泡泡
    if (this.bubble) this.drawBubble(ctx);
    // 任務指引箭頭
    this.drawPointer(ctx, t);
    // 浮字
    for (const f of this.floats) {
      ctx.globalAlpha = Math.max(0, 1 - f.t / f.life); ctx.font = 'bold 14px "PingFang TC","Noto Sans TC",sans-serif'; ctx.textAlign = 'center';
      ctx.lineWidth = 3.5; ctx.strokeStyle = 'rgba(10,6,20,.9)'; ctx.strokeText(f.text, f.x, f.y - f.t * 26); ctx.fillStyle = f.col; ctx.fillText(f.text, f.x, f.y - f.t * 26); ctx.globalAlpha = 1;
    }
  },
  scatterCrows(i) {
    const [tx, ty] = TREE_POS[i]; const n = 3 + Math.floor(Math.random() * 3);
    for (let k = 0; k < n; k++) {
      const dir = k % 2 ? 1 : -1; const sx = tx + (Math.random() - 0.5) * 40, sy = ty - 48 - Math.random() * 18;
      this.crows.push({ x:sx, y:sy, vx:dir * (50 + Math.random() * 90), vy:-(50 + Math.random() * 60), t:0, life:2 + Math.random() * 0.8, ph:Math.random() * 6, s:1.1 + Math.random() * 0.4 });
      this.feathers.push({ x:sx, y:sy, t:0, life:2.4, vx:(Math.random() - 0.5) * 20, rot:Math.random() * 6 });
    }
    Sound.play('crow', (tx - 195) / 195);
  },
  pickChatter() {
    const top = this.camY + 60, bot = this.camY + this.h / this.scale - 20;
    const cand = this.vis.filter(v => v.y > top + 120 && v.y < bot && CHATTER[v.g.k] && (!v.hero || S.qi > 3));
    if (!cand.length || Story.busy() || UI.modalOpen()) return;
    const v = cand[Math.floor(Math.random() * cand.length)], k = v.g.k;
    const used = this.chatUsed[k] = this.chatUsed[k] || []; let pool = CHATTER[k].filter(l => !used.includes(l));
    if (!pool.length) { used.length = 0; pool = CHATTER[k]; }
    const line = pool[Math.floor(Math.random() * pool.length)]; used.push(line);
    this.bubble = { id:v.g.id, hero:!!v.hero, text:line, t:0 };
  },
  drawBubble(ctx) {
    const b = this.bubble, v = this.vis.find(o => b.hero ? o.hero : (o.g.id === b.id && !o.hero)); if (!v) { this.bubble = null; return; }
    const a = Math.min(1, b.t * 5, (4.6 - b.t) * 3); ctx.save(); ctx.globalAlpha = Math.max(0, a);
    ctx.font = '600 12.5px "PingFang TC","Noto Sans TC",sans-serif';
    const maxW = 168, chars = [...b.text], lines = []; let cur = '';
    for (const ch of chars) { if (ctx.measureText(cur + ch).width > maxW) { lines.push(cur); cur = ch; } else cur += ch; } if (cur) lines.push(cur);
    const w = Math.max(...lines.map(l => ctx.measureText(l).width)) + 16, h = lines.length * 17 + 10;
    let bx = Math.max(6, Math.min(W - w - 6, v.x - w / 2)), by = v.y - 62 - h;
    ART.rr(ctx, bx, by, w, h, 4, '#ecd9a4', '#5a4030', 1.2);
    ART.poly(ctx, [v.x - 5, by + h - 0.5, v.x + 5, by + h - 0.5, v.x, by + h + 7], '#ecd9a4');
    ctx.strokeStyle = '#5a4030'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(v.x - 5, by + h); ctx.lineTo(v.x, by + h + 7); ctx.lineTo(v.x + 5, by + h); ctx.stroke();
    ctx.fillStyle = '#2b1d12'; ctx.textAlign = 'left'; ctx.textBaseline = 'top'; lines.forEach((l, i) => ctx.fillText(l, bx + 8, by + 6 + i * 17));
    ctx.restore();
  },
  workerSpots() {
    const out = [];
    const add = (post, pts) => workersAt(post).forEach((g, i) => { const p = pts[i % pts.length]; out.push({ g, x:p[0], y:p[1], flip:p[2], ph:i * 0.7, post }); });
    add('wood', [[130, 520, 1], [178, 430, 1], [70, 540, 0], [24, 460, 0]]);
    add('rice', [[290, 437, 0], [290, 487, 0], [290, 537, 1], [372, 487, 1]]);
    add('plank', [[45, 770, 0], [140, 772, 1], [60, 790, 0], [128, 794, 1]]);
    add('bun', [[250, 772, 0], [345, 770, 1], [262, 794, 0], [332, 794, 1]]);
    add('store', [[150, 890, 0]]); add('boss', [[260, 320, 1]]);
    add('camp', [[250, 1018, 0], [350, 1018, 1], [270, 1036, 0], [330, 1036, 1]]);
    return out;
  },
  questTarget() {
    const q = Quest.cur(); if (!q) return null;
    if (q.go === 'tree') { const i = S.trees.findIndex(v => v > 0); return i >= 0 ? TREE_POS[i] : TREE_POS[0]; }
    if (q.go === 'paddy') { const i = S.paddy.findIndex(v => v); return i >= 0 ? PADDY_POS[i] : PADDY_POS[0]; }
    if (q.go === 'gate') return POS.gate; if (POS[q.go]) return POS[q.go];
    return null;
  },
  drawPointer(ctx, t) {
    const p = this.questTarget(); if (!p || UI.tab !== 'village') return;
    const vh = this.h / this.scale; let [x, y] = p; let ty = y - (POS.house[0] === x && POS.house[1] === y ? 128 : 78) + Math.sin(t * 5) * 5;
    const top = this.camY + 8, bot = this.camY + vh - 12;
    let rot = 0; if (ty < top) { ty = top + 14; rot = Math.PI; } else if (ty > bot) { ty = bot - 14; rot = 0; }
    ctx.save(); ctx.translate(x, ty); ctx.rotate(rot);
    ART.poly(ctx, [-9, -14, 9, -14, 9, -2, 15, -2, 0, 12, -15, -2, -9, -2], '#ffd84a', '#3a2400', 2); ctx.restore();
  },
};
let _ground = null;
function groundLayer() {
  if (_ground) return _ground;
  const k = 2, c = document.createElement('canvas'); c.width = W * k; c.height = WH * k; const x = c.getContext('2d'); x.scale(k, k);
  let seed = 7; const R = () => (seed = (seed * 16807) % 2147483647) / 2147483647;
  // 底色：帶青的墨土
  const gr = x.createLinearGradient(0, 0, 0, WH); gr.addColorStop(0, '#140f12'); gr.addColorStop(0.13, '#211b19'); gr.addColorStop(0.5, '#26201b'); gr.addColorStop(1, '#221d1a');
  x.fillStyle = gr; x.fillRect(0, 0, W, WH);
  // 黃泉路（上方）
  const hr = x.createLinearGradient(0, 0, 0, 160); hr.addColorStop(0, 'rgba(110,30,30,.55)'); hr.addColorStop(1, 'rgba(70,30,30,0)');
  x.fillStyle = hr; x.beginPath(); x.moveTo(160, 0); x.lineTo(230, 0); x.lineTo(246, 160); x.lineTo(144, 160); x.fill();
  // 泥土斑
  for (let i = 0; i < 700; i++) { const px = R() * W, py = 140 + R() * (WH - 140), r = 2 + R() * 9; x.fillStyle = R() < 0.5 ? 'rgba(255,240,210,.025)' : 'rgba(0,0,0,.12)'; x.beginPath(); x.ellipse(px, py, r * 1.6, r, 0, 0, 6.3); x.fill(); }
  // 槐樹林的落葉地
  x.fillStyle = 'rgba(20,30,22,.55)'; x.beginPath(); x.ellipse(100, 455, 110, 92, 0, 0, 6.3); x.fill();
  for (let i = 0; i < 90; i++) { const a = R() * 6.3, d = R(); x.fillStyle = ['#3a3a20', '#4a3a1c', '#2e3a26'][i % 3]; x.beginPath(); x.ellipse(100 + Math.cos(a) * 100 * d, 455 + Math.sin(a) * 80 * d, 2.2, 1.2, R() * 3, 0, 6.3); x.fill(); }
  // 糯米田：泥水田與田埂
  x.fillStyle = '#18221f'; x.fillRect(222, 388, 154, 146);
  x.fillStyle = 'rgba(70,100,95,.18)'; for (let i = 0; i < 3; i++) x.fillRect(222, 388 + i * 50 + 34, 154, 4);
  x.strokeStyle = '#3a3a2c'; x.lineWidth = 3; x.strokeRect(222, 388, 154, 146);
  // 建築地基的夯土
  for (const id of Object.keys(POS)) { if (id === 'gate') continue; const [bx, by] = POS[id]; const w = id === 'house' ? 80 : id === 'furnace' ? 30 : 56; x.fillStyle = 'rgba(60,48,36,.35)'; x.beginPath(); x.ellipse(bx, by - 4, w, 16, 0, 0, 6.3); x.fill(); }
  // 石板路
  const slab = (sx, sy, w, h) => { const j = (R() - 0.5) * 2; x.fillStyle = ['#3c3a3e', '#36363a', '#413e40'][Math.floor(R() * 3)]; x.beginPath(); x.roundRect(sx + j, sy, w - 2, h - 2, 3); x.fill(); x.fillStyle = 'rgba(255,255,255,.05)'; x.fillRect(sx + j + 2, sy + 1, w - 6, 1.5); x.fillStyle = 'rgba(0,0,0,.35)'; x.fillRect(sx + j, sy + h - 3, w - 2, 1.5); };
  for (let y = 150; y < WH; y += 18) { const off = (y / 18) % 2 ? 0 : 12; slab(172 - off / 2, y, 24 + off / 2, 18); slab(196 + (off ? 0 : -6), y, 24 - (off ? 0 : -6) + (off ? 0 : 0), 18); }
  for (const ry of [678, 932]) for (let xx = 0; xx < W; xx += 22) { if (xx > 160 && xx < 222) continue; slab(xx, ry, 22, 11); slab(xx + 11, ry + 11, 22, 11); }
  // 草叢
  const tuft = (tx, ty) => { x.strokeStyle = R() < 0.5 ? '#34463a' : '#3e5040'; x.lineWidth = 1.3; for (let k = -2; k <= 2; k++) { x.beginPath(); x.moveTo(tx + k * 1.6, ty); x.quadraticCurveTo(tx + k * 2.2, ty - 4, tx + k * 3 + (R() - 0.5) * 2, ty - 6 - R() * 4); x.stroke(); } };
  for (let i = 0; i < 220; i++) { const tx = R() * W, ty = 150 + R() * (WH - 150); if (tx > 160 && tx < 230) continue; if (tx > 218 && ty > 384 && ty < 538) continue; if (Math.abs(ty - 690) < 16 || Math.abs(ty - 942) < 16) continue; tuft(tx, ty); }
  // 邊緣暗角
  const vg = x.createLinearGradient(0, 0, W, 0); vg.addColorStop(0, 'rgba(0,0,0,.35)'); vg.addColorStop(0.12, 'rgba(0,0,0,0)'); vg.addColorStop(0.88, 'rgba(0,0,0,0)'); vg.addColorStop(1, 'rgba(0,0,0,.35)');
  // 蠟筆質感：大量短斜筆觸 + 紙紋白點
  const strokeCols = ['rgba(120,92,62,.16)', 'rgba(70,56,40,.22)', 'rgba(150,120,80,.10)', 'rgba(60,80,58,.14)', 'rgba(20,14,10,.22)'];
  x.lineCap = 'round';
  for (let i = 0; i < 16000; i++) {
    const px = R() * W, py = 120 + R() * (WH - 120), len = 3 + R() * 7, a = -0.6 + (R() - 0.5) * 0.35;
    x.strokeStyle = strokeCols[Math.floor(R() * strokeCols.length)]; x.lineWidth = 0.6 + R() * 1.1;
    x.beginPath(); x.moveTo(px, py); x.lineTo(px + Math.cos(a) * len, py + Math.sin(a) * len); x.stroke();
  }
  for (let i = 0; i < 5000; i++) { x.fillStyle = R() < 0.6 ? 'rgba(235,220,190,.07)' : 'rgba(0,0,0,.18)'; x.fillRect(R() * W, R() * WH, 0.5 + R() * 0.9, 0.5 + R() * 0.9); }
  x.fillStyle = vg; x.fillRect(0, 0, W, WH);
  _ground = c; return c;
}
function drawLily(ctx, x, y, t) {
  ctx.strokeStyle = '#3a5a32'; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(x, y + 12); ctx.lineTo(x, y + 2); ctx.stroke();
  ctx.strokeStyle = 'rgba(214,40,52,.9)'; ctx.lineWidth = 1.5; ctx.lineCap = 'round';
  for (let k = 0; k < 6; k++) { const a = k / 6 * Math.PI * 2 + Math.sin(t * 0.6) * 0.15; ctx.beginPath(); ctx.moveTo(x, y); ctx.quadraticCurveTo(x + Math.cos(a) * 4, y + Math.sin(a) * 4 - 3, x + Math.cos(a) * 7, y + Math.sin(a) * 6 - 4); ctx.stroke(); }
  ctx.fillStyle = '#ff6060'; ctx.beginPath(); ctx.arc(x, y, 1.6, 0, 6.3); ctx.fill();
}
function bldUnlocked(id) {
  const b = BUILDINGS[id];
  if (b.unlockLv && S.lv < b.unlockLv) return false;
  if (b.unlockStage && !S.cleared[b.unlockStage]) return false;
  if (b.unlockQuest) { const qi = QUESTS.findIndex(q => q.t === 'build' && q.b === id); if (qi > S.qi) return false; }
  return true;
}
function furnaceReady() { return S.bld.furnace && Date.now() - S.furnaceAt >= F.furnaceCD * 1000 / TIME_SCALE; }

// ---------------- 化寶爐：金銀紙滿屏特效 ----------------
const JossFx = {
  play() {
    if (this.raf) { cancelAnimationFrame(this.raf); this.cv && this.cv.remove(); }
    const dpr = Math.min(2, window.devicePixelRatio || 1), vw = window.innerWidth, vh = window.innerHeight;
    const cv = document.createElement('canvas'); cv.id = 'jossfx'; cv.width = Math.round(vw * dpr); cv.height = Math.round(vh * dpr);
    cv.style.cssText = `position:fixed;left:0;top:0;width:${vw}px;height:${vh}px;pointer-events:none;z-index:65`;
    document.body.appendChild(cv); this.cv = cv; const x = cv.getContext('2d');
    // 爐子在螢幕上的位置（被面板擋住也照樣從那裡噴出）
    let ox = vw * 0.8, oy = vh * 0.55;
    try { const V = Village, r = V.cvs.getBoundingClientRect(), [fx, fy] = POS.furnace; ox = r.left + fx * V.scale; oy = r.top + (fy - 40 - V.camY) * V.scale; } catch (e) {}
    ox = Math.max(30, Math.min(vw - 30, ox)); oy = Math.max(vh * 0.25, Math.min(vh * 0.8, oy));
    const N = vw < 500 ? 140 : 170, P = [], R = Math.random, sz = Math.max(vw, vh) / 844;
    for (let i = 0; i < N; i++) {
      const burst = i < N * 0.55, gold = R() < 0.6, w = (16 + R() * 12) * sz;
      const p = { gold, w, h:w * (0.72 + R() * 0.14), rot:R() * 6.3, vr:(R() - 0.5) * 7, fl:R() * 6.3, vf:4 + R() * 8, sw:R() * 6.3, vs:1.5 + R() * 2.5, delay:0 };
      if (burst) { const ang = -Math.PI / 2 + (R() - 0.5) * 1.9, sp = (420 + R() * 520) * sz; p.x = ox; p.y = oy; p.vx = Math.cos(ang) * sp; p.vy = Math.sin(ang) * sp; p.delay = R() * 0.3; }
      else { p.x = R() * vw; p.y = -30 - R() * vh * 0.25; p.vx = (R() - 0.5) * 60; p.vy = 320 + R() * 160; p.delay = R() * 0.5; }
      p.term = 300 + R() * 160;
      P.push(p);
    }
    const S2 = []; for (let i = 0; i < 46; i++) S2.push({ x:ox + (R() - 0.5) * 60, y:oy, vx:(R() - 0.5) * 500 * sz, vy:-(200 + R() * 700) * sz, life:0.6 + R() * 0.9, t:0, d:R() * 0.5 });
    const T = 2.8; let t0 = performance.now(), last = t0;
    const paper = (p, a) => {
      const w = p.w, h = p.h, sx = Math.cos(p.fl); x.save(); x.translate(p.x, p.y); x.rotate(p.rot); x.scale(sx, 1); x.globalAlpha = a;
      const back = sx < 0, shade = 0.75 + 0.25 * Math.abs(sx);
      if (p.gold) {
        x.fillStyle = back ? `rgb(${190 * shade | 0},${140 * shade | 0},${50 * shade | 0})` : `rgb(${236 * shade | 0},${188 * shade | 0},${70 * shade | 0})`; x.fillRect(-w / 2, -h / 2, w, h);
        x.strokeStyle = 'rgba(140,80,10,.7)'; x.lineWidth = 1; x.strokeRect(-w / 2 + 1.5, -h / 2 + 1.5, w - 3, h - 3);
        if (!back) { const q = h * 0.42; x.fillStyle = '#c8281c'; x.fillRect(-q / 2, -q / 2, q, q); x.fillStyle = 'rgba(255,220,120,.85)'; x.fillRect(-q / 5, -q / 5, q * 0.4, q * 0.4); }
      } else {
        x.fillStyle = back ? `rgb(${170 * shade | 0},${172 * shade | 0},${178 * shade | 0})` : `rgb(${226 * shade | 0},${228 * shade | 0},${234 * shade | 0})`; x.fillRect(-w / 2, -h / 2, w, h);
        x.strokeStyle = 'rgba(90,95,110,.6)'; x.lineWidth = 1; x.strokeRect(-w / 2 + 1.5, -h / 2 + 1.5, w - 3, h - 3);
        if (!back) { const q = h * 0.42; x.fillStyle = '#7d828f'; x.fillRect(-q / 2, -q / 2, q, q); }
      }
      x.restore();
    };
    const step = (now) => {
      const el = (now - t0) / 1000, dt = Math.min(0.05, (now - last) / 1000); last = now;
      x.setTransform(dpr, 0, 0, dpr, 0, 0); x.clearRect(0, 0, vw, vh);
      const fade = el > T - 0.6 ? Math.max(0, (T - el) / 0.6) : 1;
      if (el < 0.5) { const g = x.createRadialGradient(ox, oy, 0, ox, oy, 160 * sz); g.addColorStop(0, `rgba(255,200,90,${0.55 * (1 - el / 0.5)})`); g.addColorStop(1, 'rgba(255,120,30,0)'); x.fillStyle = g; x.fillRect(0, 0, vw, vh); }
      for (const p of P) {
        if (el < p.delay) continue;
        p.vx *= Math.pow(0.35, dt); p.vy += 520 * sz * dt; const term = (p.term || 250) * sz; if (p.vy > term) p.vy += (term - p.vy) * Math.min(1, dt * 4);
        p.sw += p.vs * dt; p.x += (p.vx + Math.sin(p.sw) * 70 * sz) * dt; p.y += p.vy * dt; p.rot += p.vr * dt; p.fl += p.vf * dt;
        if (p.y < vh + 40) paper(p, fade);
      }
      x.globalCompositeOperation = 'lighter';
      for (const s of S2) {
        if (el < s.d) continue; s.t += dt; if (s.t > s.life) continue;
        s.vy += 600 * sz * dt; s.x += s.vx * dt; s.y += s.vy * dt; const k = 1 - s.t / s.life, r = 2 + 3 * k;
        x.globalAlpha = k; x.fillStyle = '#fff2b0'; x.beginPath(); x.moveTo(s.x, s.y - r * 2); x.lineTo(s.x + r * 0.5, s.y); x.lineTo(s.x, s.y + r * 2); x.lineTo(s.x - r * 0.5, s.y); x.closePath(); x.fill();
        x.fillRect(s.x - r * 2, s.y - 0.6, r * 4, 1.2);
      }
      x.globalCompositeOperation = 'source-over'; x.globalAlpha = 1;
      if (el < T) this.raf = requestAnimationFrame(step); else { cv.remove(); this.cv = null; this.raf = 0; }
    };
    this.raf = requestAnimationFrame(step);
  },
};

// ---------------- 特效與提示 ----------------
const Fx = {
  lastPraise:{},
  float(x, y, text, col) { Village.floats.push({ x, y, text, col:col || '#fff', t:0, life:1.6 }); },
  toast(html) { const box = $('#toasts'); while (box.children.length >= 3) box.firstChild.remove(); const d = document.createElement('div'); d.className = 'toast'; d.innerHTML = html; $('#toasts').appendChild(d); setTimeout(() => d.classList.add('out'), 2600); setTimeout(() => d.remove(), 3200); },
  banner(text) { const d = $('#banner'); d.textContent = text; d.classList.remove('show'); void d.offsetWidth; d.classList.add('show'); },
  praise(kind) {
    const pool = S.ended ? PRAISE_KIND : kind === 'chop' ? PRAISE_CHOP : kind === 'rice' ? PRAISE_RICE : PRAISE_CRAFT;
    let i; do { i = Math.floor(Math.random() * pool.length); } while (pool.length > 1 && i === this.lastPraise[kind]);
    this.lastPraise[kind] = i;
    const d = $('#praise'); d.innerHTML = `<canvas></canvas><span>${pool[i]}</span>`;
    const c = d.querySelector('canvas'); const ic = ART.sysIcon(30); c.width = ic.width; c.height = ic.height; c.style.width = '30px'; c.style.height = '30px'; c.getContext('2d').drawImage(ic, 0, 0);
    d.classList.remove('show'); void d.offsetWidth; d.classList.add('show'); Sound.play('praise');
    if (S.lv >= 3 && Math.random() < 0.04) { S.chests.g++; Fx.toast('系統太滿意了，掉落一個<b>綠箱</b>！'); }
  },
};

// ---------------- 劇情播放器 ----------------
const Story = {
  q:[], cur:null, li:0, typing:false, shown:'', timer:null, cb:null, actors:[],
  busy() { return !!this.cur || this.q.length > 0; },
  queue(sc, cb) { this.q.push({ sc, cb }); if (!this.cur) this.next(); },
  next() {
    if (this.cur && this.cur.cb) { const f = this.cur.cb; this.cur.cb = null; f(); }
    const it = this.q.shift();
    if (!it) { this.cur = null; $('#dlg').className = ''; $('#dlg').innerHTML = ''; if (!Battle.active && !Phone.on) Sound.setMode('village'); UI.refresh(); Quest.check(); save(); return; }
    const sc = typeof it.sc === 'string' ? SCENES[it.sc] : it.sc;
    if (typeof it.sc === 'string') S.seen[it.sc] = true;
    clearTimeout(this.chatT); this.chatWait = null; this.chatFast = null; this.lastMine = null;
    this.cur = { sc, cb:it.cb, id:typeof it.sc === 'string' ? it.sc : null }; this.li = 0;
    if (!Battle.active) Sound.setMode(this.cur.id === 'prologue_chat' ? 'office' : 'story');
    this.render(true);
  },
  render(first) {
    const { sc } = this.cur; const box = $('#dlg'); box.className = 'on st-' + sc.style;
    if (first) {
      box.innerHTML = this.frame(sc);
      box.onclick = (e) => { if (e.target.closest('.skip')) { this.skipScene(); return; } this.advance(e); };
      if (sc.style === 'talk') { this.actors = [...new Set(sc.lines.map(l => l[0]).filter(n => SPEAKER_ART[n] && n !== '黑白無常'))].slice(0, 6); this.drawStage(); }
    }
    this.showLine();
  },
  frame(sc) {
    const sk = '<button class="skip">跳過 ▸▸</button>';
    switch (sc.style) {
      case 'chat': return `${sk}<div class="wa wa-chat">${waStatus(this.cur.id === 'prologue_chat' ? '02:13' : nowHM(), this.cur.id === 'prologue_chat' ? '3%' : '∞', this.cur.id === 'prologue_chat')}<div class="wa-head"><span class="wa-back">${ICON.back}</span>${waAvatar(sc.av || ['?','#555'], 38)}<div class="wa-who"><b>${sc.title}</b><small class="wa-sub">${sc.group || '在線上'}</small></div><span class="ic">${ICON.video}</span><span class="ic">${ICON.call}</span><span class="ic">${ICON.dots}</span></div><div class="wa-body"><div class="wa-lock">🔒 訊息和通話皆已端對端加密。</div><div class="wa-day">今天</div></div><div class="wa-input"><div class="wa-field">${ICON.smile}<span class="wa-txt">輸入訊息</span>${ICON.clip}</div><button class="wa-send">${ICON.mic}</button></div><div class="wa-crack"></div></div><div class="tap" style="display:none">點擊繼續</div>`;
      case 'sys': return `${sk}<div class="syswin"><div class="sys-h">陰司 KPI 系統</div><div class="sys-body"></div></div><div class="tap">點擊繼續</div>`;
      case 'news': return `${sk}<div class="tv"><div class="tv-screen"><div class="tv-logo">陰間新聞台 <i>LIVE</i></div><canvas class="anchor" width="160" height="160"></canvas><div class="tv-sub"></div></div><div class="tv-ticker"><span>快訊：鬼門將開　落魄村徵求打工鬼　包吃（包子）　詳情請洽陰司 KPI 系統</span></div></div><div class="tap">點擊繼續</div>`;
      case 'notice': return `${sk}<div class="notice"><div class="nt-h">${sc.title}</div><div class="nt-body"></div><div class="nt-stamp">湘西</div></div><div class="tap">點擊繼續</div>`;
      case 'radio': return `${sk}<div class="radio"><div class="rd-h">${sc.title}</div><div class="rd-wave"></div><div class="rd-body"></div></div><div class="tap">點擊繼續</div>`;
      case 'report': return `${sk}<div class="term"><div class="tm-h">&gt; ${sc.title}</div><div class="tm-body"></div></div><div class="tap">點擊繼續</div>`;
      case 'mail': return `${sk}<div class="mail"><div class="ml-h">${sc.title}</div><div class="ml-body"></div></div><div class="tap">點擊繼續</div>`;
      case 'letter': return `${sk}<div class="letterwrap"><div class="letter-body"></div></div><div class="tap">點擊繼續</div>`;
      case 'narr': return `${sk}<div class="narr-body"></div><div class="tap">點擊繼續</div>`;
      default: return `${sk}<canvas class="stage"></canvas><div class="talkbox"><canvas class="pt" width="120" height="120"></canvas><div class="nm"></div><div class="tx"></div><div class="nx">▼</div></div>`;
    }
  },
  drawStage() {
    const box = $('#dlg'); const c = box.querySelector('canvas.stage'); if (!c) return;
    const r = box.getBoundingClientRect(); const dpr = Math.min(2, window.devicePixelRatio || 1);
    c.width = r.width * dpr; c.height = r.height * dpr; const ctx = c.getContext('2d'); ctx.scale(dpr, dpr);
    const w = r.width, h = r.height, bg = this.cur.sc.bg || 'village';
    paintBg(ctx, w, h, bg, 0);
    const n = this.actors.length; const speaker = this.cur.sc.lines[this.li] ? this.cur.sc.lines[this.li][0] : '';
    if (this.cur.sc.mic) { const g = ctx.createRadialGradient(w*0.5, h*0.62, 10, w*0.5, h*0.62, w*0.55); g.addColorStop(0,'rgba(255,236,190,.28)'); g.addColorStop(1,'rgba(0,0,0,.55)'); ctx.fillStyle = g; ctx.fillRect(0,0,w,h);
    }
    this.actors.forEach((a, i) => {
      const x = w * (n === 1 ? 0.5 : 0.16 + 0.68 * i / Math.max(1, n - 1)); const y = h * 0.66 + (n > 3 ? (i % 2) * 18 : 0); const base = n <= 2 ? 3.1 : n === 3 ? 2.7 : n === 4 ? 2.3 : 1.9;
      const on = a === speaker || (speaker === '黑白無常' && (a === '白無常' || a === '黑無常'));
      let type = SPEAKER_ART[a];
      const sid = this.cur.id || '';
      ART.drawChar(ctx, type, x, y + (on ? 0 : 6), on ? base : base * 0.9, { t:0.3, flip:x > w / 2, alpha:on ? 1 : 0.45, tamed:sid !== 'ch4_boss', untied:sid !== 'ch5_intro2', enemy:/boss/.test(sid) && a !== '阿福' && a !== '小紙' && on });
    });
  },
  showLine() {
    const { sc } = this.cur; const [who, raw] = sc.lines[this.li]; const box = $('#dlg');
    let text = raw, time = '';
    if (sc.style === 'chat') { const m = raw.match(/^(\d\d:\d\d)\|(.*)$/); if (m) { time = m[1]; text = m[2]; } }
    const typeInto = (el, cb) => { this.typing = true; let i = 0; clearInterval(this.timer); this.full = () => { clearInterval(this.timer); el.textContent = text; this.typing = false; cb && cb(); }; this.timer = setInterval(() => { i++; el.textContent = text.slice(0, i); if (i >= text.length) { clearInterval(this.timer); this.typing = false; cb && cb(); } }, 28); };
    const add = (container, cls, inner) => { const d = document.createElement('div'); d.className = cls; d.innerHTML = inner; container.appendChild(d); container.scrollTop = container.scrollHeight; return d; };
    switch (sc.style) {
      case 'chat': { this.chatLine(who, text, time); break; }
      case 'sys': { const d = add(box.querySelector('.sys-body'), 'sl ' + (who === '系統' ? 's' : who === '旁白' ? 'n' : 'u'), (who === '系統' ? '<b>【系統】</b>' : who === '旁白' ? '' : `<b>${who}：</b>`) + '<span class="tt"></span>'); typeInto(d.querySelector('.tt')); break; }
      case 'news': { const s = box.querySelector('.tv-sub'); s.innerHTML = '<span class="tt"></span>'; this.drawAnchor(); typeInto(s.querySelector('.tt')); break; }
      case 'notice': { const d = add(box.querySelector('.nt-body'), 'np', '<span class="tt"></span>'); typeInto(d.querySelector('.tt')); break; }
      case 'radio': { const d = add(box.querySelector('.rd-body'), 'rl ' + (who === 'DJ' ? 'dj' : 'call'), `<b>${who === 'DJ' ? 'DJ' : '來電・' + who}</b><span class="tt"></span>`); typeInto(d.querySelector('.tt')); break; }
      case 'report': { const d = add(box.querySelector('.tm-body'), 'tl', `<b>[${who}]</b> <span class="tt"></span>`); typeInto(d.querySelector('.tt')); break; }
      case 'mail': { const d = add(box.querySelector('.ml-body'), 'mr ' + (who === '內文' ? 'content' : ''), `<b>${who}</b><span class="tt"></span>`); typeInto(d.querySelector('.tt')); break; }
      case 'letter': { const d = add(box.querySelector('.letter-body'), who === '媽' ? 'lt-mom' : who === '旁白' ? 'lt-n' : 'lt-u', (who === '阿福' ? '<b>阿福：</b>' : '') + '<span class="tt"></span>'); typeInto(d.querySelector('.tt')); break; }
      case 'narr': { const d = add(box.querySelector('.narr-body'), 'nl', '<span class="tt"></span>'); typeInto(d.querySelector('.tt')); break; }
      default: {
        const nm = box.querySelector('.nm'), tx = box.querySelector('.tx'), pt = box.querySelector('canvas.pt');
        nm.textContent = who === '旁白' ? '' : who; nm.style.display = who === '旁白' ? 'none' : '';
        const pc = pt.getContext('2d'); pc.clearRect(0, 0, 120, 120);
        const art = who === '系統' ? 'sys' : SPEAKER_ART[who];
        if (art === 'sys') pc.drawImage(ART.sysIcon(120), 0, 0, 120, 120);
        else if (art) { const sid = this.cur.id || ''; pc.drawImage(ART.portrait(art, 120, { tamed:sid !== 'ch4_boss', untied:sid !== 'ch5_intro2' }), 0, 0, 120, 120); }
        pt.style.display = art ? '' : 'none'; tx.classList.toggle('narr', who === '旁白');
        this.drawStage(); typeInto(tx);
      }
    }
  },
  drawAnchor() {
    const c = $('#dlg canvas.anchor'); if (!c) return; const ctx = c.getContext('2d'); ctx.clearRect(0, 0, 160, 160);
    ART.drawChar(ctx, 'mamian', 80, 168, 2.3, { t:0.2, shadow:false });
    ART.rr(ctx, 10, 130, 140, 30, 4, '#26304a', '#4a5a8a', 2);
  },
  // ---------- 仿 WhatsApp 的即時對話 ----------
  chatLine(who, text, time) {
    const box = $('#dlg'), sc = this.cur.sc, body = box.querySelector('.wa-body'), sub = box.querySelector('.wa-sub');
    const add = (cls, html) => { const d = document.createElement('div'); d.className = cls; d.innerHTML = html; body.appendChild(d); body.scrollTop = body.scrollHeight; return d; };
    const nextLine = () => { this.chatT = null; this.li++; if (this.li >= sc.lines.length) { this.chatEnd(); return; } this.showLine(); };
    const tm = time || nowHM();
    this.chatWait = null; clearTimeout(this.chatT);
    if (who === '阿福') { // 主角要自己按「傳送」
      const field = box.querySelector('.wa-field'), txt = field.querySelector('.wa-txt'), btn = box.querySelector('.wa-send');
      let i = 0; field.classList.add('typing'); txt.textContent = '';
      const step = () => { i++; txt.textContent = text.slice(0, i); Sound.play('key'); if (i < text.length) this.chatT = setTimeout(step, 55); else { this.chatT = null; btn.innerHTML = ICON.send; btn.classList.add('await'); this.chatWait = 'send'; } };
      this.chatFast = () => { clearTimeout(this.chatT); txt.textContent = text; btn.innerHTML = ICON.send; btn.classList.add('await'); this.chatWait = 'send'; this.chatT = null; };
      this.chatSend = () => {
        this.chatWait = null; btn.classList.remove('await'); btn.innerHTML = ICON.mic; field.classList.remove('typing'); txt.textContent = '輸入訊息'; Sound.play('waOut');
        const d = add('bub me pop', `<span>${text}</span><i>${tm} ${TICK(false, false)}</i>`); this.lastMine = d;
        this.chatT = setTimeout(() => { d.querySelector('.tk').outerHTML = TICK(false, true); this.chatT = setTimeout(nextLine, 650); }, 600);
      };
      this.chatT = setTimeout(step, 350); return;
    }
    if (who === '旁白') { add('bub mid pop', text); this.chatT = setTimeout(nextLine, 1300); this.chatFast = () => { clearTimeout(this.chatT); nextLine(); }; return; }
    // 對方：先顯示「正在輸入…」
    const arrive = () => {
      this.chatT = null; sub.textContent = sc.group || '在線上'; sub.classList.remove('typing');
      if (this.lastMine) { this.lastMine.querySelectorAll('.tk').forEach(t => t.outerHTML = TICK(true, true)); this.lastMine = null; }
      add('bub them pop', (sc.group ? `<b class="nm">${who}</b>` : '') + `<span>${text}</span><i>${tm}</i>`); Sound.play('waIn');
      this.chatT = setTimeout(nextLine, Math.min(1800, 700 + text.length * 22));
      this.chatFast = () => { clearTimeout(this.chatT); nextLine(); };
    };
    if (this.li === 0) { arrive(); return; }
    sub.textContent = sc.group ? `${who} 正在輸入…` : '正在輸入…'; sub.classList.add('typing');
    this.chatT = setTimeout(arrive, Math.min(1600, 450 + text.length * 30)); this.chatFast = () => { clearTimeout(this.chatT); arrive(); };
  },
  chatEnd() {
    const box = $('#dlg'), sc = this.cur.sc;
    if (sc.end === 'crash') { // 已讀……然後手機掉在地上
      const sub = box.querySelector('.wa-sub');
      if (this.lastMine) this.chatT = setTimeout(() => { this.lastMine.querySelectorAll('.tk').forEach(t => t.outerHTML = TICK(true, true)); this.lastMine = null; sub.textContent = '正在輸入…'; sub.classList.add('typing'); }, 900);
      setTimeout(() => { Sound.play('heartbeat'); }, 2200);
      setTimeout(() => { Sound.play('heartbeat'); box.querySelector('.wa').classList.add('crash'); }, 3000);
      setTimeout(() => { Sound.play('flatline'); box.querySelector('.wa').classList.add('dead'); }, 3700);
      this.chatWait = 'crash'; this.chatT = setTimeout(() => this.next(), 7200); return;
    }
    this.chatWait = 'end'; box.querySelector('.tap').style.display = '';
  },
  advance(e) {
    if (this.cur && this.cur.sc.style === 'chat') {
      if (this.chatWait === 'crash') return;
      if (this.chatWait === 'end') { this.next(); return; }
      if (this.chatWait === 'send') { if (e && e.target.closest('.wa-input')) this.chatSend(); else { const b = $('#dlg .wa-send'); b.classList.remove('nudge'); void b.offsetWidth; b.classList.add('nudge'); } return; }
      if (this.chatFast) { const f = this.chatFast; this.chatFast = null; f(); }
      return;
    }
    if (this.typing) { this.full(); return; }
    this.li++;
    if (this.li >= this.cur.sc.lines.length) { this.next(); return; }
    this.showLine();
  },
  skipScene() { clearInterval(this.timer); clearTimeout(this.chatT); this.chatWait = null; this.chatFast = null; this.lastMine = null; this.typing = false; this.next(); },
};
function paintBg(ctx, w, h, bg, t) {
  if (SCENE.drawBg(ctx, w, h, bg)) return;
  const sky = { village:['#121016','#24222a'], road:['#1a0f22','#3a1a2a'], field:['#0f1a1a','#26332a'], kampung:['#0c1420','#1f2a33'], banana:['#0a140f','#1c2e22'], hq:['#0e0e1a','#26263c'], office:['#141420','#2c2c3a'] }[bg] || ['#120f22','#2a2440'];
  const g = ctx.createLinearGradient(0, 0, 0, h); g.addColorStop(0, sky[0]); g.addColorStop(1, sky[1]); ctx.fillStyle = g; ctx.fillRect(0, 0, w, h);
  ART.el(ctx, w * 0.78, h * 0.13, 28, 28, 'rgba(240,230,200,.85)'); ART.el(ctx, w * 0.78 + 8, h * 0.13 - 4, 26, 26, sky[0]);
  const gy = h * 0.66;
  ctx.fillStyle = 'rgba(0,0,0,.35)';
  if (bg === 'banana') for (let i = 0; i < 6; i++) { const x = i * w / 5; ctx.fillRect(x - 4, gy - 170, 8, 170); for (let k = 0; k < 5; k++) { ctx.save(); ctx.translate(x, gy - 170); ctx.rotate(-1.2 + k * 0.6); ART.el(ctx, 40, 0, 44, 10, 'rgba(10,30,18,.8)'); ctx.restore(); } }
  else if (bg === 'kampung') for (let i = 0; i < 4; i++) { const x = 20 + i * w / 3.6; ctx.fillRect(x, gy - 90, 90, 50); ctx.beginPath(); ctx.moveTo(x - 10, gy - 88); ctx.lineTo(x + 45, gy - 130); ctx.lineTo(x + 100, gy - 88); ctx.fill(); for (let k = 0; k < 4; k++) ctx.fillRect(x + k * 28, gy - 40, 5, 40); }
  else if (bg === 'hq' || bg === 'office') { for (let i = 0; i < 5; i++) { const x = i * w / 4.5, hh = 160 + (i % 3) * 70; ctx.fillRect(x, gy - hh, 70, hh); ctx.fillStyle = 'rgba(255,220,120,.18)'; for (let a = 0; a < 6; a++) for (let b = 0; b < 3; b++) if ((a * 3 + b + i) % 4) ctx.fillRect(x + 8 + b * 20, gy - hh + 12 + a * 22, 10, 12); ctx.fillStyle = 'rgba(0,0,0,.35)'; } if (bg === 'office') { ctx.fillStyle = 'rgba(30,24,20,.9)'; ctx.fillRect(0, gy - 10, w, 30); } }
  else if (bg === 'road') { ctx.fillStyle = 'rgba(120,40,60,.25)'; ctx.beginPath(); ctx.moveTo(w * 0.42, gy - 160); ctx.lineTo(w * 0.58, gy - 160); ctx.lineTo(w, gy); ctx.lineTo(0, gy); ctx.fill(); for (let i = 0; i < 14; i++) { const x = (i * 71) % w, y = gy - 20 - (i * 37) % 120; ctx.strokeStyle = 'rgba(230,50,70,.6)'; ctx.lineWidth = 1.5; for (let k = 0; k < 6; k++) { const a = k / 6 * Math.PI * 2; ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x + Math.cos(a) * 7, y + Math.sin(a) * 7); ctx.stroke(); } } }
  else { for (let i = 0; i < 7; i++) { const x = i * w / 6; ART.el(ctx, x, gy - 60, 40, 50, 'rgba(10,20,20,.6)'); ctx.fillStyle = 'rgba(10,20,20,.6)'; ctx.fillRect(x - 4, gy - 30, 8, 30); } }
  ctx.fillStyle = 'rgba(10,8,18,.55)'; ctx.fillRect(0, gy, w, h - gy);
  const mg = ctx.createLinearGradient(0, gy - 40, 0, gy + 20); mg.addColorStop(0, 'rgba(180,170,230,0)'); mg.addColorStop(1, 'rgba(180,170,230,.12)'); ctx.fillStyle = mg; ctx.fillRect(0, gy - 40, w, 60);
}

// ---------------- 介面 ----------------
const UI = {
  tab:'village',
  modalOpen() { return $('#sheet').classList.contains('on') || $('#battle').classList.contains('on'); },
  refresh() {
    if (!S) return;
    $('#lv').textContent = S.lv;
    const need = F.expNeed(S.lv); $('#expbar i').style.width = (S.lv >= 20 ? 100 : Math.min(100, S.exp / need * 100)) + '%';
    $('#exptxt').textContent = S.lv >= 20 ? '好評 MAX' : `好評 ${fmt(S.exp)}/${fmt(need)}`;
    const cap = F.cap();
    for (const k of ['wood','rice','planks','buns']) { const e = $('#r-' + k); e.textContent = fmt(S.res[k]); e.parentElement.classList.toggle('full', S.res[k] >= cap - 0.5); }
    $('#r-coins').textContent = fmt(S.res.coins); $('#r-troops').textContent = fmt(S.res.troops);
    const q = Quest.cur(); const qb = $('#quest');
    if (q) { const [a, b] = Quest.progress(q); qb.innerHTML = `<b>主線</b><span>${q.text}</span><em>${Math.min(a, b)}/${b}</em>`; qb.classList.toggle('done', a >= b); }
    else qb.innerHTML = `<b>主線</b><span>${S.ended ? '第一季完。村子由你慢慢經營。' : '—'}</span>`;
    const ch = S.chests.g + S.chests.b + S.chests.p; $('#nav [data-t=chest] i').textContent = ch || ''; $('#nav [data-t=chest] i').style.display = ch ? '' : 'none';
    document.querySelectorAll('#nav button').forEach(b => b.classList.toggle('pulse', q && ((q.go === 'roster' && b.dataset.t === 'roster') || (q.go === 'gate' && b.dataset.t === 'battle'))));
    if (this.sheetRefresh && $('#sheet').classList.contains('on')) this.sheetRefresh();
  },
  open(t) {
    if (t === 'village') { this.close(); return; }
    if (t === 'roster') this.openRoster();
    if (t === 'battle') this.openBattleSelect();
    if (t === 'chest') this.openChests();
    if (t === 'story') this.openStory();
    document.querySelectorAll('#nav button').forEach(b => b.classList.toggle('on', b.dataset.t === t));
  },
  sheet(title, html, refresher) {
    const sh = $('#sheet'); sh.classList.add('on');
    if (!sh.classList.contains('was')) Sound.play('paper'); sh.classList.add('was');
    sh.querySelector('.sh-title').textContent = title; sh.querySelector('.sh-body').innerHTML = html; this.sheetRefresh = refresher || null;
  },
  close() { $('#sheet').classList.remove('on', 'was'); this.sheetRefresh = null; document.querySelectorAll('#nav button').forEach(b => b.classList.toggle('on', b.dataset.t === 'village')); },

  // --- 建築面板 ---
  openBuilding(id) {
    const render = () => {
      const b = BUILDINGS[id], lv = S.bld[id]; let h = `<p class="flavor">${FLAVOR[id] || ''}</p><p class="desc">${b.desc}</p>`;
      if (!lv) {
        if (!bldUnlocked(id)) { h += `<p class="lack">尚未解鎖。</p>`; }
        else h += `<div class="row"><span>建造費用：${costText(b.build)}</span><button class="btn gold" data-act="build" ${canPay(b.build) ? '' : 'disabled'}>建造</button></div>`;
      } else {
        h += `<div class="stat">等級 <b>Lv ${lv}</b>${id !== 'house' ? `（上限 = 鬼宅等級 ${S.bld.house}）` : ''}</div>`;
        h += this.bldEffect(id);
        if (lv < F.bldMax(id)) { const c = F.upCost(id, lv); h += `<div class="row"><span>升級：${costText(c)}${F.builderDiscount() ? `<br><small>工頭省了 ${Math.round(F.builderDiscount() * 100)}% 棺材板</small>` : ''}</span><button class="btn gold" data-act="up" ${canPay(c) ? '' : 'disabled'}>升級</button></div>`; }
        else h += `<p class="desc">${id === 'house' ? '已達最高等級。' : '已達上限，先升級鬼宅。'}</p>`;
        if (id === 'plank' || id === 'bun') { const src = id === 'plank' ? 'wood' : 'rice', can = Math.floor(S.res[src] / 4), dis = can < 1 ? 'disabled' : ''; h += `<div class="row craft-row"><span>親手做：每份 4 ${id === 'plank' ? '槐木 → 2 棺材板' : '糯米 → 2 壽包'}　好評 +1<br><small>現有${RES_NAMES[src]} ${S.res[src]}，夠做 ${can} 份</small></span><div class="craft-btns"><button class="btn" data-act="craft" data-n="1" ${dis}>做1份</button><button class="btn" data-act="craft" data-n="5" ${dis}>一次做5份</button><button class="btn" data-act="craft" data-n="10" ${dis}>一次做10份</button></div></div>`; }
        if (id === 'furnace') { const left = Math.max(0, F.furnaceCD - (Date.now() - S.furnaceAt) * TIME_SCALE / 1000); h += `<div class="row"><span>${left > 0 ? `還要 ${Math.ceil(left / 60)} 分鐘` : '爐火正旺！'}　可燒出 冥幣 ${F.furnaceCoins()}</span><button class="btn gold" data-act="burn" ${left > 0 ? 'disabled' : ''}>燒</button></div>`; }
        if (id === 'altar') { const c = F.recruitCost(); h += `<div class="row"><span>招魂一次：${costText(c)}<br><small>雜鬼名額 ${fodderCount()}/${F.rosterCap()}（升級民宅增加；收服的名鬼不佔名額）</small></span><button class="btn gold" data-act="recruit" ${canPay(c) && fodderCount() < F.rosterCap() ? '' : 'disabled'}>招魂</button></div>`; const pool = Object.keys(FODDER).filter(k => !FODDER[k].unlock || S.cleared[FODDER[k].unlock]).map(k => FODDER[k].name).join('、'); h += `<p class="desc">目前可能招到：${pool}。收服更多鬼怪後，招魂池會變大。</p>`; }
        if (id === 'house' && S.lv >= 12) { const iq = S.ghosts.reduce((a, g) => a + F.stat(g, 1), 0); const left = Math.max(0, F.feastCD - (Date.now() - S.feastAt) * TIME_SCALE / 1000); h += `<div class="row"><span>盂蘭宴：壽包 300<br><small>全村智力總和 ${iq}/${F.feastNeed}${left > 0 ? `　冷卻 ${Math.ceil(left / 60)} 分` : ''}</small></span><button class="btn gold" data-act="feast" ${S.res.buns >= 300 && iq >= F.feastNeed && left <= 0 ? '' : 'disabled'}>擺宴</button></div>`; }
        for (const p of b.posts) h += this.postHtml(p);
      }
      return h;
    };
    const re = () => { $('#sheet .sh-body').innerHTML = render(); bind(); };
    const bind = () => {
      $('#sheet .sh-body').querySelectorAll('[data-act]').forEach(btn => btn.onclick = () => {
        const a = btn.dataset.act;
        if (a === 'build') { Sound.play('build'); pay(BUILDINGS[id].build); S.bld[id] = 1; gainExp(15); Fx.banner(`${BUILDINGS[id].name} 建好了！`); Quest.check(); }
        if (a === 'up') { Sound.play('build'); const c = F.upCost(id, S.bld[id]); pay(c); S.bld[id]++; gainExp(10 + 8 * S.bld[id]); Fx.banner(`${BUILDINGS[id].name} 升到 Lv ${S.bld[id]}`); Quest.check(); }
        if (a === 'craft') { this.close(); Village.craft(id, +btn.dataset.n || 1); return; }
        if (a === 'burn') { if (!furnaceReady()) return; Sound.play('coin'); JossFx.play(); S.furnaceAt = Date.now(); const c = F.furnaceCoins(); S.res.coins += c; Fx.toast(`化寶爐燒出 <b>冥幣 ${c}</b>`); }
        if (a === 'recruit') { Sound.play('whoosh'); pay(F.recruitCost()); const g = recruitFodder(false); S.cnt.recruit++; Fx.toast(`招來了 <b>${g.name}</b>（${g.q}）`); Quest.check(); }
        if (a === 'feast') { Sound.play('gong'); S.res.buns -= 300; S.feastAt = Date.now(); S.cnt.feast++; gainExp(150); if (fodderCount() < F.rosterCap()) { const g = recruitFodder(true); Fx.toast(`盂蘭宴請來了稀客 <b>${g.name}</b>（紫）！好評 +150`); } else { S.chests.p++; Fx.toast('盂蘭宴賓客滿座，可惜村裡住不下了。客人留下一個<b>紫箱</b>就走了。好評 +150'); } Quest.check(); }
        if (a === 'assign') { this.pickWorker(btn.dataset.post, id); return; }
        if (a === 'unassign') { const g = ghostById(btn.dataset.g); if (g) g.post = null; }
        save(); UI.refresh(); re();
      });
    };
    this.sheet(BUILDINGS[id].name, render(), null); bind();
    this.sheetRefresh = () => { if (!document.activeElement || !document.activeElement.closest || !document.activeElement.closest('#sheet')) { const sc = $('#sheet .sh-body').scrollTop; re(); $('#sheet .sh-body').scrollTop = sc; } };
  },
  bldEffect(id) {
    const r = ratesPerMin(); const L = (a) => `<div class="eff">${a}</div>`;
    switch (id) {
      case 'house': return L(`其他建築最高可升到 Lv ${S.bld.house}`);
      case 'wood': return L(`每崗產量 ×${F.mult('wood').toFixed(1)}　崗位 ${F.slots('wood')}　目前 槐木 +${r.wood.toFixed(1)}/分`);
      case 'rice': return L(`每崗產量 ×${F.mult('rice').toFixed(1)}　崗位 ${F.slots('rice')}　目前 糯米 +${r.rice.toFixed(1)}/分`);
      case 'plank': return L(`崗位 ${F.slots('plank')}　目前 棺材板 +${r.planks.toFixed(1)}/分（耗槐木 ${r.woodUse.toFixed(1)}/分）<br>藍箱可開出 棺材板 ${F.chestGain('b').planks}`);
      case 'bun': return L(`崗位 ${F.slots('bun')}　目前 壽包 +${r.buns.toFixed(1)}/分（耗糯米 ${r.riceUse.toFixed(1)}/分）<br>綠箱可開出 壽包 ${F.chestGain('g').buns}`);
      case 'store': return L(`槐木、糯米、棺材板、壽包 存放上限：${fmt(F.cap())}`);
      case 'home': return L(`雜鬼名額 ${F.rosterCap()}　遊魂自願當陰兵 +${r.troops.toFixed(1)}/分　陰兵上限 ${fmt(F.troopCap())}`);
      case 'camp': { const ws = workersAt('camp'); return L(`練習速度 ×${F.mult('camp').toFixed(1)}　崗位 ${F.slots('camp')}　耗壽包 ${r.bunUse.toFixed(1)}/分<br>嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。`) + (ws.length ? '<br>' + ws.map(g => { const lv = Rework.drillLv(g.k), nx = Rework.drillNext(g.k); return `${g.name} 嚇功 Lv${lv}${nx ? `（${Math.floor(Rework.drillXp(g.k))}/${nx}）` : '（滿）'}`; }).join('　') : ''); }
      default: return '';
    }
  },
  postHtml(post) {
    const P = POSTS[post], n = F.slots(post); if (!n) return '';
    if (post === 'wood' || post === 'rice' || post === 'plank' || post === 'bun' || post === 'camp' || post === 'store' || post === 'boss') {
      if (S.lv < 4) return `<div class="post"><div class="ph">${P.name}崗位</div><p class="lack">升到 4 級【略懂管理學】後可派鬼怪打工。</p></div>`;
    }
    let h = `<div class="post"><div class="ph">${P.name}崗位 <small>${P.desc}</small></div><div class="slots">`;
    const ws = workersAt(post);
    for (let i = 0; i < n; i++) {
      const g = ws[i];
      if (g) h += `<div class="slot"><canvas data-por="${g.k}"></canvas><div><b>${g.name}</b><small>Lv${F.glv(g)}　${this.postStatTxt(g, post)}</small></div><button class="btn sm" data-act="unassign" data-g="${g.id}">撤下</button></div>`;
      else h += `<div class="slot empty"><span>空崗位</span><button class="btn sm" data-act="assign" data-post="${post}">派人</button></div>`;
    }
    h += '</div></div>';
    setTimeout(() => paintPortraits($('#sheet')), 0);
    return h;
  },
  postStatTxt(g, post) { const s = POSTS[post].stat; return s >= 0 ? `${STAT_NAMES[s]} ${F.stat(g, s)}` : `等級 ${F.glv(g)}`; },
  pickWorker(post, back) {
    const s = POSTS[post].stat;
    const val = (g) => s >= 0 ? F.stat(g, s) : F.glv(g), fbd = (g) => (GHOSTS[g.k] && GHOSTS[g.k].forbid || []).includes(post) ? 1 : 0;
    const list = S.ghosts.filter(g => g.k !== 'afu' && g.post !== post).sort((a, b) => fbd(a) - fbd(b) || val(b) - val(a) || F.glv(b) - F.glv(a));
    let h = `<p class="desc">挑一位去「${POSTS[post].name}」。${s >= 0 ? `這份工看【${STAT_NAMES[s]}】。` : '這份工看等級。'}已在別處打工的，會被調過來。</p><p class="desc sortnote">▼ 已按【${s >= 0 ? STAT_NAMES[s] : '等級'}】由高到低排好</p><div class="glist">`;
    for (const g of list) {
      const fb = (GHOSTS[g.k] && GHOSTS[g.k].forbid || []).includes(post);
      h += `<div class="gi ${fb ? 'dis' : ''}" data-g="${g.id}"><canvas data-por="${g.k}"></canvas><div><b>${g.name}</b> <i class="q q${g.q}">${g.q}</i><small><span class="keystat">${s >= 0 ? STAT_NAMES[s] : '等級'} ${val(g)}</span>　${s >= 0 ? 'Lv' + F.glv(g) + '　' : ''}${[0, 1, 2].filter(i => i !== s).map(i => STAT_NAMES[i] + F.stat(g, i)).join(' ')}</small><small>${g.post ? '目前：' + POSTS[g.post].name : '閒著'}${fb ? '　<span class="lack">怕糯米，不肯去</span>' : ''}</small></div></div>`;
    }
    if (!list.length) h += '<p class="desc">沒有可以派的鬼怪。</p>';
    h += `</div><button class="btn wide" id="pkback">返回</button>`;
    this.sheet(`派人：${POSTS[post].name}`, h); paintPortraits($('#sheet'));
    $('#pkback').onclick = () => this.openBuilding(back);
    $('#sheet').querySelectorAll('.gi:not(.dis)').forEach(el => el.onclick = () => {
      const g = ghostById(el.dataset.g); if (workersAt(post).length >= F.slots(post)) { const old = workersAt(post)[0]; old.post = null; }
      g.post = post; Quest.check(); save(); UI.refresh(); this.openBuilding(back);
    });
  },

  // --- 鬼怪名冊 ---
  openRoster() {
    const render = () => {
      let h = `<p class="desc">用壽包升級鬼怪。等級上限 ${F.ghostCap()}。雜鬼名額 ${fodderCount()}/${F.rosterCap()}　壽包 ${fmt(S.res.buns)}</p>${typeof N30W !== 'undefined' ? `<button class="btn wide" id="n30cx">新鬼圖鑑（${N30W.ids().filter(k => N30W.owned(k)).length}/${N30W.ids().length}）</button>` : ''}<div class="glist">`;
      const order = S.ghosts.slice().sort((a, b) => (a.k === 'afu' ? -1 : b.k === 'afu' ? 1 : (a.q === '名' ? 0 : 1) - (b.q === '名' ? 0 : 1) || F.glv(b) - F.glv(a)));
      for (const g of order) {
        const lv = F.glv(g), cost = F.lvCost(lv), d = gdef(g), sk = SKILLS[g.k];
        const inTeam = S.team.includes(g.id) ? '出陣' : S.adviser === g.id ? '軍師' : '';
        h += `<div class="gcard"><canvas data-por="${g.k}"></canvas><div class="gc-main"><div><b>${g.name}</b> <i class="q q${g.q}">${g.q}</i> <span class="lvl">Lv${lv}</span> ${inTeam ? `<i class="tag">${inTeam}</i>` : ''}</div>
          <small>${GHOSTS[g.k] ? GHOSTS[g.k].title + '　' : ''}力 ${F.stat(g, 0)}　智 ${F.stat(g, 1)}　武 ${F.stat(g, 2)}　${d.range === 'ranged' ? '遠程' : '近戰'}</small>
          <small class="sk">【${sk.name}】${sk.desc}</small>
          ${GHOSTS[g.k] ? `<small class="tr">${typeof L === 'function' ? L(GHOSTS[g.k].trait) : GHOSTS[g.k].trait}</small>` : ''}${GHOSTS[g.k] && GHOSTS[g.k].lore ? `<small class="tr">${GHOSTS[g.k].lore}</small>` : ''}
          <small>${g.post ? '打工：' + POSTS[g.post].name : g.k === 'afu' ? '主公本人' : '閒著'}</small></div>
          <div class="gc-act">${g.k === 'afu' ? '<small>隨主公等級成長</small>' : lv < F.ghostCap() ? `<button class="btn sm gold" data-up="${g.id}" ${S.res.buns >= cost ? '' : 'disabled'}>升級<br><small>壽包 ${cost}</small></button>` : '<small>已達上限</small>'}
          ${g.q !== '名' && g.q !== '主' ? `<button class="btn sm ghost" data-rel="${g.id}">送去投胎</button>` : ''}</div></div>`;
      }
      return h + '</div>';
    };
    const bind = () => {
      $('#sheet').querySelectorAll('[data-up]').forEach(b => b.onclick = () => { const g = ghostById(b.dataset.up); const c = F.lvCost(g.lv); if (S.res.buns < c) return; S.res.buns -= c; g.spent += c; g.lv++; gainExp(2); Quest.check(); save(); UI.refresh(); re(); });
      $('#sheet').querySelectorAll('[data-rel]').forEach(b => b.onclick = () => { const g = ghostById(b.dataset.rel); if (!confirmInline(b, '確定？')) return; const back = Math.floor(g.spent * 0.6); S.res.buns += back; S.ghosts = S.ghosts.filter(x => x !== g); S.team = S.team.map(x => x === g.id ? null : x); if (S.adviser === g.id) S.adviser = null; Fx.toast(`${g.name} 去投胎了。退回 壽包 ${back}`); save(); UI.refresh(); re(); });
      paintPortraits($('#sheet'));
      const cx = $('#n30cx'); if (cx) cx.onclick = () => N30W.openCodex();
    };
    const re = () => { const sc = $('#sheet .sh-body').scrollTop; $('#sheet .sh-body').innerHTML = render(); bind(); $('#sheet .sh-body').scrollTop = sc; };
    this.sheet('鬼怪名冊', render()); bind(); this.sheetRefresh = null;
  },
  // --- 箱子 ---
  openChests() {
    const render = () => {
      const C = [['g','綠箱','壽包',`開出 壽包 ${F.chestGain('g').buns}（隨包子鋪等級提升）`],['b','藍箱','棺材板',`開出 棺材板 ${F.chestGain('b').planks}（隨棺材鋪等級提升）`],['p','紫箱','冥幣',`開出 冥幣 ${F.chestGain('p').coins}（隨鬼宅等級提升）`]];
      let h = `<p class="desc">小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。</p>`;
      for (const [k, n, , d] of C) h += `<div class="row chest"><span class="cb k-${k}"></span><span><b>${n} ×${S.chests[k]}</b><br><small>${d}</small></span><span class="btns"><button class="btn sm gold" data-open="${k}" data-n="1" ${S.chests[k] ? '' : 'disabled'}>開 1</button><button class="btn sm" data-open="${k}" data-n="all" ${S.chests[k] > 1 ? '' : 'disabled'}>全開</button></span></div>`;
      return h;
    };
    const bind = () => $('#sheet').querySelectorAll('[data-open]').forEach(b => b.onclick = () => {
      const k = b.dataset.open, n = b.dataset.n === 'all' ? S.chests[k] : 1; const tot = {};
      for (let i = 0; i < n; i++) { const g = F.chestGain(k); for (const r in g) tot[r] = (tot[r] || 0) + g[r]; }
      Sound.play('chest'); S.chests[k] -= n; S.cnt.chest += n; Fx.toast(`開箱：${give(tot)}`); save(); UI.refresh(); $('#sheet .sh-body').innerHTML = render(); bind();
    });
    this.sheet('箱子', render()); bind();
  },
  // --- 劇情回顧 ---
  openStory() {
    let h = '<p class="desc">看過的劇情，可以在這裡重溫。</p><div class="slist">';
    SCENE_ORDER.forEach(([name, ids], i) => { const ok = ids.some(id => S.seen[id]); h += `<button class="btn wide ${ok ? '' : 'ghost'}" data-sc="${i}" ${ok ? '' : 'disabled'}>${ok ? name : '？？？'}</button>`; });
    h += '</div><h4 class="stand-h">開麥之夜・陰間脫口秀</h4><p class="desc">村裡的鬼，入了村就能上台。</p><div class="slist">';
    STANDUP.forEach((st, i) => { const ok = standOk(st); h += `<button class="btn wide ${ok ? '' : 'ghost'}" data-st="${i}" ${ok ? '' : 'disabled'}>${ok ? `<small>${st.who}</small>　${st.title}` : '？？？（' + st.hint + '）'}</button>`; });
    h += `</div><hr>${IS_WEB && !isStandalone() ? '<button class="btn wide gold" id="instbtn">放到手機桌面（自動更新）</button>' : ''}<button class="btn wide" id="phonebtn">看手機</button><button class="btn wide" id="sndbtn">聲音：${Sound.isOn() ? '開' : '關'}</button><button class="btn wide ghost" id="resetbtn">重新開始（刪除存檔）</button>`;
    this.sheet('劇情', h);
    $('#sheet').querySelectorAll('[data-sc]').forEach(b => b.onclick = () => { this.close(); SCENE_ORDER[+b.dataset.sc][1].filter(id => S.seen[id]).forEach(id => Story.queue(id)); });
    $('#sheet').querySelectorAll('[data-st]').forEach(b => b.onclick = () => { this.close(); const st = STANDUP[+b.dataset.st]; Story.queue({ style:'talk', bg:st.bg, mic:true, title:st.title, lines:[...st.lines, ['旁白', st.end]] }); });
    const ib = $('#instbtn'); if (ib) ib.onclick = () => { this.close(); Web.installGuide(false); };
    $('#phonebtn').onclick = () => { this.close(); Phone.home('post'); };
    $('#sndbtn').onclick = (e) => { const on = Sound.toggle(); e.target.textContent = '聲音：' + (on ? '開' : '關'); syncSnd(); };
    $('#resetbtn').onclick = (e) => { if (!confirmInline(e.target, '再按一次確定刪檔')) return; localStorage.removeItem(SAVE_KEY); location.reload(); };
  },
  openBattleSelect() { Battle.openSelect(); },
};
function standOk(st) { return !st.need || !!S.seen[st.need]; }
function syncSnd() { const b = $('#sndtop'); if (b) { b.textContent = Sound.isOn() ? '🔊' : '🔇'; b.classList.toggle('off', !Sound.isOn()); } }
function confirmInline(btn, msg) { if (btn.dataset.armed) return true; btn.dataset.armed = 1; const o = btn.innerHTML; btn.innerHTML = msg; setTimeout(() => { delete btn.dataset.armed; btn.innerHTML = o; }, 2500); return false; }
function paintPortraits(root) {
  root.querySelectorAll('canvas[data-por]').forEach(c => { if (c.dataset.done) return; c.dataset.done = 1; const p = ART.portrait(c.dataset.por, 64, { tamed:true, untied:true }); c.width = p.width; c.height = p.height; c.getContext('2d').drawImage(p, 0, 0); });
}
function recruitFodder(rare) {
  const pool = Object.keys(FODDER).filter(k => !FODDER[k].unlock || S.cleared[FODDER[k].unlock]);
  const k = pool[Math.floor(Math.random() * pool.length)];
  const purple = rare || Math.random() < 0.15; const m = purple ? 1.45 : 1;
  const st = [0, 0, 0].map(() => Math.round((15 + Math.random() * 32) * m));
  const used = new Set(S.ghosts.map(g => g.name)); let name;
  for (let i = 0; i < 40; i++) { name = FODDER[k].name + '・' + NICKS[Math.floor(Math.random() * NICKS.length)]; if (!used.has(name)) break; }
  const g = { id:'g' + (S.uid++), k, name, q:purple ? '紫' : '藍', lv:1, st, post:null, spent:0 };
  S.ghosts.push(g); return g;
}

// ---------------- 主迴圈 ----------------
let lastT = performance.now(), saveT = 0, uiT = 0;
function loop(now) {
  let dt = Math.min(0.1, (now - lastT) / 1000); lastT = now;
  if (!Battle.active) {
    produce(dt * TIME_SCALE); Village.update(dt);
    Village.draw();
  } else { produce(dt * TIME_SCALE); Battle.update(dt); Battle.draw(); }
  uiT += dt; if (uiT > 0.5) { uiT = 0; UI.refresh(); Quest.check(); }
  saveT += dt; if (saveT > 5) { saveT = 0; save(); }
  requestAnimationFrame(loop);
}
function offlineGain() {
  const sec = Math.min(8 * 3600, Math.max(0, (Date.now() - (S.last || Date.now())) / 1000));
  if (sec < 60) return;
  const before = Object.assign({}, S.res); const lv0 = S.lv, e0 = S.exp;
  for (let s = 0; s < sec; s += 60) produce(Math.min(60, sec - s));
  const parts = []; for (const k of ['wood','rice','planks','buns','troops','coins']) { const d = Math.floor(S.res[k] - before[k]); if (d > 0) parts.push(`${RES_NAMES[k]} +${fmt(d)}`); }
  S.last = Date.now();
  if (parts.length) Story.queue({ style:'sys', lines:[['系統', `親，你離開了 ${Math.floor(sec / 3600)} 小時 ${Math.floor(sec % 3600 / 60)} 分鐘。鬼怪們沒有偷懶哦～（最多計 8 小時）`], ['旁白', '離線收益：' + parts.join('，')]] });
}
function start() { if (Web.boot()) return; Web.receive(() => (typeof SPR_READY !== 'undefined' ? SPR_READY : Promise.resolve()).then(startGame, startGame).then(() => Web.init())); }
function startGame() {
  S = load();
  const fresh = !S;
  if (!S) S = newState();
  // 舊存檔補欄位
  const d = newState(); for (const k in d) if (S[k] === undefined) S[k] = d[k];
  if (typeof Guide !== 'undefined') Guide.migrate(fresh); // 新手引導任務插入後，舊存檔的任務索引要搬
  Village.init(); Battle.init();
  document.querySelectorAll('#nav button').forEach(b => b.onclick = () => { Sound.play('click'); if (b.dataset.t === 'battle' && typeof World !== 'undefined') { UI.close(); World.open(); return; } UI.open(b.dataset.t); });
  $('#sndtop').onclick = () => { Sound.toggle(); syncSnd(); }; syncSnd();
  $('#sheet .sh-close').onclick = () => UI.close();
  const RES_HELP = {
    '槐木':'槐木：主公親手砍樹，或派鬼怪去<b>伐木場</b>伐木。',
    '糯米':'糯米：主公親手收割，或派鬼怪去<b>糯米田</b>割稻。',
    '棺材板':'棺材板：在<b>棺材鋪</b>把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。',
    '壽包':'壽包：在<b>包子鋪</b>把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級鬼怪、練陰兵。',
    '冥幣':'冥幣：打關卡、開紫箱、燒<b>化寶爐</b>。Toyol 管倉庫時也會「撿到」冥幣。',
    '陰兵':'陰兵：村裡的遊魂見你有地盤，自願加入。<b>民宅</b>越高級來得越快、上限越高。搶地盤時每 25 個組成一隊（最多 8 隊），戰死的會扣掉。',
  };
  document.querySelectorAll('#resbox .rs').forEach(el => el.onclick = () => Fx.toast(RES_HELP[el.title] + (el.title === '陰兵' && !S.bld.home ? '<br>（建好民宅，遊魂才會來）' : '')));
  $('#quest').onclick = () => { const p = Village.questTarget(); const q = Quest.cur(); if (q && q.go === 'roster') { UI.open('roster'); return; } if (q && q.go === 'gate' && Quest.cur().t === 'stage') { UI.open('battle'); return; } if (p) { UI.close(); Village.focus(p[0], p[1]); } };
  if (!(DEBUG && /nophone/.test(location.search))) Title.show(fresh);
  UI.refresh(); requestAnimationFrame(loop);
  window.addEventListener('beforeunload', save);
  document.addEventListener('visibilitychange', () => { if (document.hidden) save(); else if (S && !Phone.on) { offlineGain(); } });
  if (DEBUG) window.G = { JossFx, Phone, Sound, S:() => S, F, Quest, Village, Battle, Story, UI, give, setScale:(k) => TIME_SCALE = k, produce, joinGhost, recruitFodder, ratesPerMin, save };
}
