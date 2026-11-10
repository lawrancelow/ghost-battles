// ===================== 戰鬥 =====================
const GIFT_REWARD = { gift_phone:{ coins:300 }, gift_car:{ coins:800, chest:'p' } };
const Battle = {
  active:false, units:[], fx:[], t:0, speed:1, auto:false, stage:null, sid:'', result:null,
  init() {
    this.cvs = $('#bcvs'); this.ctx = this.cvs.getContext('2d');
    try { this.auto = localStorage.getItem('gb_auto') === '1'; this.speed = +(localStorage.getItem('gb_speed') || 1); } catch (e) {}
    $('#b-auto').onclick = () => { this.auto = !this.auto; try { localStorage.setItem('gb_auto', this.auto ? '1' : '0'); } catch (e) {} this.syncBtns(); };
    $('#b-speed').onclick = () => { this.speed = this.speed === 1 ? 2 : 1; try { localStorage.setItem('gb_speed', this.speed); } catch (e) {} this.syncBtns(); };
    $('#b-quit').onclick = (e) => { if (this.result) return; if (!confirmInline(e.target, '確定撤退？')) return; this.finish(false, true); };
    window.addEventListener('resize', () => this.active && this.resize());
  },
  syncBtns() { $('#b-auto').classList.toggle('on', this.auto); $('#b-auto').textContent = this.auto ? '自動 ON' : '自動 OFF'; $('#b-speed').textContent = '×' + this.speed; },
  sidOf(ci, si) { return `${ci + 1}-${si + 1}`; },
  stageOpen(ci, si) {
    if (si > 0 && !S.cleared[this.sidOf(ci, si - 1)]) return false;
    if (si === 0 && ci > 0 && !S.cleared[this.sidOf(ci - 1, 2)]) return false;
    return true;
  },
  // ---------- 選關與佈陣 ----------
  openSelect() {
    const render = () => {
      let h = `<div class="team">`;
      for (let i = 0; i < 3; i++) { const g = ghostById(S.team[i]); h += `<div class="tslot" data-slot="${i}">${g ? `<canvas data-por="${g.k}"></canvas><b>${g.name}</b><small>Lv${F.glv(g)}</small>` : '<span>＋<br>出陣</span>'}</div>`; }
      const ad = ghostById(S.adviser);
      h += `<div class="tslot adv" data-slot="adv">${ad ? `<canvas data-por="${ad.k}"></canvas><b>${ad.name}</b><small>軍師</small>` : '<span>＋<br>軍師</span>'}</div></div>`;
      h += `<p class="desc">軍師不上場，坐鎮後方：全隊攻擊 +${ad ? Math.round(F.stat(ad, 1) / 8) : 0}%（看智力），能量滿了也能放技能。出征前可隨時換人。　</p><div class="troopbox"><b>帶上陣的陰兵</b><span>現有 ${fmt(S.res.troops)}，可組成 <em>${Math.min(8, Math.floor(S.res.troops / 25))}</em> 隊（每 25 個一隊，最多 8 隊）</span><small>${S.bld.home ? '村裡的遊魂見你有地盤，會自願當陰兵（民宅越高級來得越快）。戰死的會扣掉。' : '建好民宅，遊魂才會來投靠當陰兵。'}</small></div>`;
      if (S.seen.ch1_end) { const b = (S.scare && S.scare.best.office) || 0; h += `<div class="sc-entry"><div><b>回陽間・夜班嚇人</b><small>舊公司・二十三樓　最高 ${b}　${'★'.repeat(Scare.starsOf('office', b))}</small></div><button class="btn gold" id="sc-open">回去</button></div>`; }
      if (S.seen.ch1_end && typeof Sports !== 'undefined') h += `<div class="sc-entry sp-entry"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class="btn gold" id="sp-open">參加</button></div>`;
      h += typeof Station !== 'undefined' ? Station.entryHTML() : Rework.turfHead();
      CHAPTERS.forEach((ch, ci) => {
        h += `<div class="chap"><div class="ch-h">第${'一二三四五六'[ci]}章・${ch.name}</div>`;
        ch.stages.forEach((st, si) => {
          const sid = this.sidOf(ci, si), open = this.stageOpen(ci, si), done = S.cleared[sid], lvOk = S.lv >= st.req;
          h += `<div class="stg ${open ? '' : 'locked'} ${st.boss ? 'boss' : ''}"><span class="sn">${sid}</span><span class="st"><b>${st.name}</b><small>${open ? `需主公 Lv${st.req}　${Rework.turfTag(sid)}</small><small class="rw-efs">${Rework.enemyHint(st.en)}` : '先打通上一關'}</small></span>${open ? `<button class="btn sm ${done && !Rework.isLost(sid) ? '' : 'gold'}" data-go="${ci},${si}" ${lvOk ? '' : 'disabled'}>${done ? (Rework.isLost(sid) ? '奪回' : '巡場') : lvOk ? '搶地盤' : `Lv${st.req}`}</button>` : '<span class="lk">🔒</span>'}${done ? '<i class="ok">✓</i>' : ''}</div>`;
        });
        h += '</div>';
      });
      if (typeof N30W !== 'undefined') h += N30W.selectHtml();
      return h;
    };
    const bind = () => {
      paintPortraits($('#sheet'));
      if (typeof N30W !== 'undefined') N30W.bindSelect($('#sheet'));
      $('#sheet').querySelectorAll('.tslot').forEach(el => el.onclick = () => this.pickSlot(el.dataset.slot));
      const so = $('#sc-open'); if (so) so.onclick = () => Scare.open('office');
      const spo = $('#sp-open'); if (spo) spo.onclick = () => Sports.open();
      const sto = $('#stn-open'); if (sto) sto.onclick = () => Station.openPanel();
      $('#sheet').querySelectorAll('[data-go]').forEach(b => b.onclick = () => { const [ci, si] = b.dataset.go.split(',').map(Number); this.tryStart(ci, si); });
    };
    UI.sheet('陽間地盤', render()); bind();
    this._reSelect = () => { const sc = $('#sheet .sh-body').scrollTop; $('#sheet .sh-body').innerHTML = render(); bind(); $('#sheet .sh-body').scrollTop = sc; };
    // 自動捲到目前主線關卡
    setTimeout(() => { const b = $('#sheet .btn.gold[data-go]'); if (b) b.scrollIntoView({ block:'center' }); }, 30);
  },
  pickSlot(slot) {
    const cur = slot === 'adv' ? S.adviser : S.team[+slot];
    const used = new Set([...S.team, S.adviser].filter(Boolean));
    const list = S.ghosts.slice().sort((a, b) => F.glv(b) - F.glv(a));
    let h = `<p class="desc">選擇${slot === 'adv' ? '軍師（看智力）' : '出陣鬼怪'}。已在別的位置的，會互換。</p><div class="glist">`;
    if (cur) h += `<div class="gi" data-g=""><div><b>— 空著 —</b></div></div>`;
    for (const g of list) {
      const sk = SKILLS[g.k]; const where = S.team.includes(g.id) ? '出陣中' : S.adviser === g.id ? '軍師' : '';
      h += `<div class="gi ${g.id === cur ? 'sel' : ''}" data-g="${g.id}"><canvas data-por="${g.k}"></canvas><div><b>${g.name}</b> <i class="q q${g.q}">${g.q}</i> ${where ? `<i class="tag">${where}</i>` : ''}<small>Lv${F.glv(g)}　力${F.stat(g, 0)} 智${F.stat(g, 1)} 武${F.stat(g, 2)}　${gdef(g).range === 'ranged' ? '遠程' : '近戰'}<br>${Rework.teamHint(g)}</small><small class="sk">【${sk.name}】${sk.desc}</small></div></div>`;
    }
    h += `</div><button class="btn wide" id="pkback">返回</button>`;
    UI.sheet('佈陣', h); paintPortraits($('#sheet'));
    $('#pkback').onclick = () => this.openSelect();
    $('#sheet').querySelectorAll('.gi').forEach(el => el.onclick = () => {
      const id = el.dataset.g || null;
      const put = (s, v) => { if (s === 'adv') S.adviser = v; else S.team[+s] = v; };
      if (id) { // 互換
        const from = S.team.indexOf(id) >= 0 ? '' + S.team.indexOf(id) : S.adviser === id ? 'adv' : null;
        if (from !== null) put(from, cur || null);
      }
      put(slot, id); save(); this.openSelect();
    });
  },
  tryStart(ci, si) {
    if (!S.team.some(Boolean)) { Fx.toast('至少要派一位鬼怪出陣'); return; }
    const ch = CHAPTERS[ci], st = ch.stages[si], sid = this.sidOf(ci, si);
    UI.close();
    const go = () => this.start(ci, si);
    let any = false;
    if (si === 0) ch.intro.forEach(id => { if (!S.seen[id]) { Story.queue(id); any = true; } });
    if (st.before && !S.cleared[sid] && !S.seen[st.before]) { Story.queue(st.before); any = true; }
    if (any) Story.queue({ style:'narr', lines:[['旁白', `${sid}　${st.name}`]] }, go); else go();
  },
  // ---------- 開戰 ----------
  mkGhostUnit(g, i) {
    const lv = F.glv(g), P = F.stat(g, 0), I = F.stat(g, 1), A = F.stat(g, 2), d = gdef(g);
    const hp = 300 + P * 8 + A * 4;
    return { side:0, k:g.k, gid:g.id, name:g.name, hp, maxhp:hp, atk:20 + A * 1.4, range:d.range === 'ranged' ? 150 : 46, spd:d.range === 'ranged' ? 38 : 46, x:78 - i * 14, lane:i * 1.1, energy:20, sk:SKILLS[g.k], st:{}, cd:Math.random() * 0.5, lv };
  },
  start(ci, si, wild) { // wild：野鬼戰（n30_data.js 的 N30W.fight），{ stage, bg, sid }
    const ch = wild ? { bg:wild.bg } : CHAPTERS[ci], st = wild ? wild.stage : ch.stages[si];
    this.ci = ci; this.si = si; this.stage = st; this.sid = wild ? wild.sid : this.sidOf(ci, si); this.bg = ch.bg;
    this.units = []; this.fx = []; this.t = 0; this.result = null; this.combo = 0; this.comboT = 0; this.coinsWon = 0; this.timeLimit = 90;
    this.proj = []; this.hitStop = 0; this.slowT = 0; this.shakeA = 0; this.flashT = 0; this.advCast = null; this.comboCast = null; this.lastHS = -9; this.comboPop = 0; this.hsBank = 0.12;
    const team = S.team.map(ghostById).filter(Boolean);
    team.forEach((g, i) => this.units.push(this.mkGhostUnit(g, i)));
    const ad = ghostById(S.adviser);
    this.adviser = ad ? { k:ad.k, name:ad.name, energy:0, sk:SKILLS[ad.k], bonus:F.stat(ad, 1) / 8 / 100, atk:20 + F.stat(ad, 2) * 1.4, side:0 } : null;
    // 陰兵
    const sq = Math.min(8, Math.floor(S.res.troops / 25)); this.squads = sq;
    const tb = 1 + 0.08 * Math.max(0, S.bld.home - 1);
    for (let i = 0; i < sq; i++) { const hp = (90 + 14 * S.lv) * tb; this.units.push({ side:0, k:'youhun', name:'陰兵', minion:true, hp, maxhp:hp, atk:(9 + 2.2 * S.lv) * tb, range:38, spd:52, x:120 + Math.floor(i / 4) * 18, lane:(i % 4) * 0.95 + 0.4, energy:0, sk:null, st:{}, cd:Math.random() }); }
    // 敵人
    st.en.forEach((e, i) => {
      const T = ENEMY_T[e]; const hp = (260 + 90 * st.p) * T[0];
      this.units.push({ side:1, k:e, name:T[2], hp, maxhp:hp, atk:(16 + 7.5 * st.p) * T[1], range:['zhiren','penanggal'].includes(e) ? 140 : 46, spd:e === 'xiaogui' ? 58 : 42, x:318 + (i % 2) * 22, lane:i * 1.05, energy:e === st.boss ? 30 : 0, sk:SKILLS[e], st:{}, cd:Math.random() * 0.6, boss:e === st.boss });
    });
    if (typeof GhostStreet !== 'undefined') GhostStreet.battleBuffs(this.units);
    this.active = true; Sound.setMode('battle'); this.sndT = 0; $('#battle').classList.add('on'); this.resize(); this.buildCards(); this.syncBtns();
    $('#b-title').textContent = st.wild ? `野鬼　${st.name}` : `${this.sid}　${st.name}`;
  },
  resize() {
    const r = this.cvs.getBoundingClientRect(); this.dpr = Math.min(2, window.devicePixelRatio || 1);
    this.cvs.width = r.width * this.dpr; this.cvs.height = r.height * this.dpr; this.w = r.width; this.h = r.height; this.sc = this.w / 390;
  },
  buildCards() {
    const box = $('#b-cards'); box.innerHTML = '';
    const mk = (u, isAdv) => {
      const d = document.createElement('button'); d.className = 'bcard' + (isAdv ? ' adv' : '');
      d.innerHTML = `<canvas></canvas><b>${u.sk ? u.sk.name : ''}</b><small>${isAdv ? '軍師・' : ''}${u.name}</small><i class="en"><s></s></i>`;
      const p = ART.portrait(u.k, 56, { tamed:true, untied:true }); const c = d.querySelector('canvas'); c.width = p.width; c.height = p.height; c.getContext('2d').drawImage(p, 0, 0);
      d.onclick = () => this.cast(u); u.card = d; box.appendChild(d);
    };
    this.units.filter(u => u.side === 0 && !u.minion).forEach(u => mk(u, false));
    if (this.adviser) mk(this.adviser, true);
    this.comboSkill = null;
    if (S.lv >= 17) for (const c of COMBOS) {
      const a = this.units.find(u => u.side === 0 && u.k === c.a), b = this.units.find(u => u.side === 0 && u.k === c.b);
      if (a && b) { this.comboSkill = { c, a, b, energy:0 }; const d = document.createElement('button'); d.className = 'bcard combo'; d.innerHTML = `<b>合體技</b><b>${c.name}</b><small>${a.name}＋${b.name}</small><i class="en"><s></s></i>`; d.onclick = () => this.castCombo(); this.comboSkill.card = d; box.appendChild(d); break; }
    }
  },
  // ---------- 技能 ----------
  enemiesOf(u) { return this.units.filter(v => v.side !== u.side && v.hp > 0); },
  nearest(u) { let best = null, bd = 1e9; for (const v of this.enemiesOf(u)) { const d = Math.abs(v.x - u.x) + Math.abs(v.lane - u.lane) * 18; if (d < bd) { bd = d; best = v; } } return best; },
  stateOf(v) { return v.st.air > 0 ? 'air' : v.st.down > 0 ? 'down' : null; },
  // 打擊感：頓幀（凍結模擬）、震屏（依傷害）
  // 頓幀預算：每秒戰鬥時間最多約 0.07 秒凍結，避免整場戰鬥被拖長；技能/擊倒可稍微透支
  hitStopFor(sec, must) { const b = this.hsBank || 0; if (b < (must ? -0.04 : sec)) return; this.hsBank = b - sec; this.hitStop = Math.max(this.hitStop || 0, sec / this.speed); },
  kick(amp) { this.shakeA = Math.max(this.shakeA || 0, amp); },
  hit(src, v, mult, sk) {
    let m = mult; const bonus = src.side === 0 && this.adviser ? 1 + this.adviser.bonus : 1;
    let comboHit = false;
    if (sk && sk.follow && this.stateOf(v) === sk.follow) { m *= 1.8; comboHit = true; }
    const dmg = Math.round(src.atk * m * bonus * (0.9 + Math.random() * 0.2));
    v.hp -= dmg; if (sk || this.t - (this.sndT || 0) > 0.09) { this.sndT = this.t; Sound.play('hit'); }
    // ---- 受擊反應與特效 ----
    const dir = Math.sign(v.x - (src.x != null ? src.x : v.x - (v.side ? 1 : -1))) || (v.side ? 1 : -1);
    const s = this.scaleOf(v), hy = this.uy(v) - 30 * s;
    v.flash = 1; v.kbDir = src.k === 'heiwu' ? -dir : dir; v.kbT = 0; // 黑無常的鎖鏈是把人扯過來 v.kbAmp = Math.min(16, 4 + dmg / v.maxhp * 70) * (sk ? 1.3 : 1);
    if (!v.anim && !v.casting) v.hurtT = 0.25;
    this.spark(v.x - dir * 6 * s, hy, comboHit || sk ? 1.35 : v.minion ? 0.7 : 1, v.side === 0 ? '#ff9a7a' : comboHit ? '#ffd84a' : '#fff4c0');
    const big = comboHit || !!sk;
    this.fx.push({ kind:'num', x:v.x + (Math.random() - 0.5) * 14, y:this.uy(v) - 70 * s, vx:dir * (14 + Math.random() * 18), text:'' + dmg, col:comboHit ? '#ffd84a' : v.side === 0 ? '#ff8a8a' : '#fff', t:0, life:0.95, big });
    this.kick(Math.min(9, (sk ? 2.5 : 0.8) + dmg / v.maxhp * 26) * (v.minion && src.minion ? 0.4 : 1));
    if (sk) this.hitStopFor(0.12, true);
    else if ((!src.minion || !v.minion) && this.t - (this.lastHS || -9) > 0.4) { this.lastHS = this.t; this.hitStopFor(dmg > v.maxhp * 0.12 ? 0.08 : 0.055); }
    if (comboHit && src.side === 0) { Sound.play('combo', this.combo); this.combo = this.comboT > 0 ? this.combo + 1 : 1; this.comboT = 3; this.comboPop = 1; this.fx.push({ x:195, y:(this.H || 640) * 0.3, text:`連嚇 ×${this.combo + 1}！`, col:'#ffd84a', t:0, life:1.2, center:true }); }
    if (sk && sk.apply && v.hp > 0) {
      if (sk.apply === 'air') { v.st.air = v.st.airMax = 1.0; v.st.down = 0; }
      if (sk.apply === 'down') { v.st.down = v.st.downMax = 1.4; v.st.air = 0; this.dust(v.x, this.uy(v), 1.2); }
      if (sk.apply === 'push') { v.st.push = 0.25; }
      v.anim = null;
    }
    if (sk && sk.drain) src.hp = Math.min(src.maxhp, src.hp + dmg * sk.drain);
    if (sk && sk.sap) v.energy = Math.max(0, v.energy - sk.sap);
    if (sk && sk.steal && src.side === 0) this.coinsWon += sk.steal;
    if (!sk) src.energy = Math.min(100, src.energy + 8);
    v.energy = Math.min(100, v.energy + 4);
    if (v.hp <= 0) { v.hp = 0; v.deadT = 0; v.dieDir = dir; v.anim = null; v.casting = null; if (!v.minion) this.hitStopFor(sk ? 0.14 : 0.09, true); this.kick(v.minion ? 3 : 7); this.spark(v.x, hy, 1.6, '#fff'); }
    return dmg;
  },
  doSkill(u, sk, extraMult) {
    if (!sk) return;
    const mult = sk.mult * (extraMult || 1);
    if (sk.kind === 'heal') {
      this.units.filter(v => v.side === u.side && v.hp > 0).forEach(v => { const h = v.maxhp * sk.mult; v.hp = Math.min(v.maxhp, v.hp + h); this.fx.push({ x:v.x, y:this.uy(v) - 90, text:'+' + Math.round(h), col:'#8affb0', t:0, life:0.9 }); this.fx.push({ kind:'ring', x:v.x, y:this.uy(v) - 30, t:0, life:0.5, col:'#8affb0' }); });
      if (sk.forget) this.enemiesOf(u).forEach(v => v.energy = 0);
    } else if (sk.kind === 'aoe') { this.enemiesOf(u).forEach(v => this.hit(u, v, mult, sk)); }
    else { const v = this.nearest(u); if (v) { if (u.x != null) this.fx.push({ kind:'slash', x:v.x, y:this.uy(v) - 30 * this.scaleOf(v), dir:Math.sign(v.x - u.x) || 1, t:0, life:0.22, r:34, col:u.side === 0 ? '#bff' : '#f9a' });
      if (sk.hits > 1) { for (let i = 0; i < sk.hits; i++) if (v.hp > 0) this.hit(u, v, mult / sk.hits, i === sk.hits - 1 ? sk : Object.assign({}, sk, { apply:null, drain:sk.drain, sap:0, steal:0 })); } else this.hit(u, v, mult, sk); } } // hits：多段（總倍率不變，最後一下才帶狀態）
    this.fx.push({ x:u.x != null ? u.x : 60, y:u.x != null ? this.uy(u) - 115 : 90, text:sk.name, col:u.side === 0 ? '#bff' : '#f9a', t:0, life:1.1, skill:true });
    this.flashT = 0.12; this.kick(sk.kind === 'aoe' ? 8 : 5); Sound.play('skill');
  },
  // 施法：先蓄力 0.45 秒（光圈＋短暫慢動作），蓄滿才放出原本的技能效果
  CAST:0.45,
  beginCast(u) {
    u.energy = 0;
    if (u.x == null) { this.advCast = { u, t:0, dur:this.CAST, slow:false }; return; } // 軍師
    u.anim = null; u.walking = false; u.casting = { t:0, dur:this.CAST, slow:false };
  },
  tickCast(c, dt, u) { c.t += dt; if (!c.slow && c.t >= c.dur * 0.5) { c.slow = true; if (!u || u.side === 0 || u.boss) this.slowT = Math.max(this.slowT || 0, 0.25 / this.speed); } return c.t >= c.dur; },
  fireCast(u) { u.casting = null; this.doSkill(u, u.sk); },
  cast(u) {
    if (this.result || u.energy < 100) return;
    if (u.hp != null && u.hp <= 0) return;
    if (u.x != null && (u.st.air > 0 || u.st.down > 0 || u.casting)) return;
    if (u.x == null && this.advCast) return;
    this.beginCast(u);
  },
  castCombo() {
    const c = this.comboSkill; if (!c || c.energy < 100 || this.result || c.a.hp <= 0 || c.b.hp <= 0 || this.comboCast) return;
    c.energy = 0; this.comboCast = { t:0, dur:this.CAST, slow:false };
  },
  fireCombo() {
    const c = this.comboSkill; this.comboCast = null;
    const src = { atk:(c.a.atk + c.b.atk) / 2, side:0, hp:1, maxhp:1, x:(c.a.x + c.b.x) / 2, lane:1, energy:0 };
    this.enemiesOf(src).forEach(v => { this.hit(src, v, c.c.mult, { apply:'air' }); v.st.down = v.st.downMax = 1.6; v.st.air = 0; this.dust(v.x, this.uy(v), 1.3); });
    this.fx.push({ x:195, y:(this.H || 640) * 0.34, text:c.c.name, col:'#ffb0ff', t:0, life:1.5, center:true }); this.kick(11); this.flashT = 0.25;
  },
  uy(u) { const H = this.H || 640; return H * 0.5 + u.lane * H * 0.1; },
  scaleOf(u) { return u.minion ? 0.75 : u.boss ? 1.7 : 1.32; },
  // ---------- 出手節奏（只重新分配時間，DPS 不變）----------
  // 近戰：蓄力 0.22 → 出手 0.12（第 0.05 秒命中）→ 收招 0.25；遠程：蓄力 → 出手（後座、射出飛彈）→ 收招
  WIND:0.22, STRIKE:0.12, REC:0.25, IMPACT:0.05, PSPD:640,
  period(u) { return u.range > 60 ? 1.15 : 0.95; },
  leadOf(u, tg) { return u.range > 60 ? this.WIND + Math.max(0, Math.abs(tg.x - u.x) - 10) / this.PSPD : this.WIND + this.IMPACT; },
  lungeOf(u) { return u.boss ? 12 : u.minion ? 6 : 9; }, // 美術本身的出手已前衝約 18% 身寬，這裡只補一點
  stepAnim(u, dt) {
    const a = u.anim; a.t += dt; u.cd -= dt;
    const ranged = u.range > 60;
    if (a.name === 'windup' && a.t >= this.WIND) {
      u.anim = { name:'strike', t:a.t - this.WIND, dur:this.STRIKE, tg:a.tg };
      if (ranged) this.fire(u, a.tg); else this.dust(u.x, this.uy(u), 0.6);
      return;
    }
    if (a.name === 'strike') {
      if (!ranged && !a.done && a.t >= this.IMPACT) {
        a.done = true;
        let tg = a.tg && a.tg.hp > 0 && Math.abs(a.tg.x - u.x) <= u.range + 24 ? a.tg : null;
        if (!tg) { const n = this.nearest(u); if (n && Math.abs(n.x - u.x) <= u.range + 24) tg = n; }
        if (tg) { u.cd = this.period(u); const s = this.scaleOf(tg); this.fx.push({ kind:'slash', x:tg.x, y:this.uy(tg) - 30 * s, dir:Math.sign(tg.x - u.x) || (u.side ? -1 : 1), t:0, life:0.17, r:(u.minion ? 18 : 26) * (u.boss ? 1.4 : 1), col:u.side === 0 ? '#e8fbff' : '#ffd0c0' }); this.hit(u, tg, 1, null); }
      }
      if (a.t >= this.STRIKE) u.anim = { name:'recover', t:a.t - this.STRIKE, dur:this.REC };
      return;
    }
    if (a.name === 'recover' && a.t >= this.REC) u.anim = null;
  },
  fire(u, tg) {
    if (!tg || tg.hp <= 0) { tg = this.nearest(u); if (!tg) return; }
    const s = this.scaleOf(u), y = this.uy(u) - 34 * s, dist = Math.max(0, Math.abs(tg.x - u.x) - 10);
    u.cd = this.period(u) + dist / this.PSPD; // 讓「命中」的間隔維持原本的攻速
    this.proj.push({ src:u, tg, x:u.x + (u.side ? -14 : 14) * s, y, trail:[], col:u.side === 0 ? '#9ff3ff' : '#ff9ac0', side:u.side });
  },
  stepProj(dt) {
    this.proj = this.proj.filter(p => {
      if (!p.tg || p.tg.hp <= 0) { p.tg = this.nearest(p.src); if (!p.tg) return false; }
      const tx = p.tg.x, ty = this.uy(p.tg) - 30 * this.scaleOf(p.tg), dx = tx - p.x, dy = ty - p.y, d = Math.hypot(dx, dy), step = this.PSPD * dt;
      p.trail.push([p.x, p.y]); if (p.trail.length > 7) p.trail.shift();
      if (d <= step + 4) { this.hit(p.src, p.tg, 1, null); return false; }
      p.x += dx / d * step; p.y += dy / d * step; return true;
    });
  },
  // ---------- 特效產生 ----------
  spark(x, y, k, col) {
    const n = 7 + Math.floor(Math.random() * 4), rays = [];
    for (let i = 0; i < n; i++) rays.push({ a:(i / n) * Math.PI * 2 + (Math.random() - 0.5) * 0.5, len:(14 + Math.random() * 16) * k, j:Math.random() * 1000 });
    this.fx.push({ kind:'spark', x, y, t:0, life:0.24, rays, col, k, rot:Math.random() * Math.PI });
  },
  dust(x, y, k) {
    const puffs = []; for (let i = 0; i < 5; i++) puffs.push({ dx:(Math.random() - 0.5) * 18 * k, vx:(Math.random() - 0.5) * 60 * k, r:(4 + Math.random() * 4) * k });
    this.fx.push({ kind:'dust', x, y, t:0, life:0.45, puffs });
  },
  // ---------- 更新 ----------
  update(dtReal) {
    if (!this.active) return;
    this.shakeA = (this.shakeA || 0) * Math.exp(-dtReal * 13); if (this.shakeA < 0.15) this.shakeA = 0;
    this.flashT = Math.max(0, (this.flashT || 0) - dtReal); this.comboPop = Math.max(0, (this.comboPop || 0) - dtReal * 4);
    this.fx = this.fx.filter(f => (f.t += dtReal) < f.life);
    if (this.hitStop > 0) { this.hitStop -= dtReal; return; } // 頓幀：整個戰場停住
    let ts = 1; if (this.slowT > 0) { this.slowT -= dtReal; ts = 0.35; }
    const dt = dtReal * this.speed * ts;
    if (this.result) { for (const u of this.units) this.visTick(u, dt); return; }
    this.t += dt; this.comboT -= dt; this.hsBank = Math.min(0.16, (this.hsBank || 0) + dt * 0.07);
    this.stepProj(dt);
    for (const u of this.units) {
      this.visTick(u, dt);
      if (u.hp <= 0) continue;
      if (u.st.air > 0) { if (u.casting) this.fireCast(u); u.anim = null; u.st.air -= dt; if (u.st.air <= 0) { this.dust(u.x, this.uy(u), 1.1); this.kick(u.boss ? 5 : 2.5); } continue; }
      if (u.st.down > 0) { if (u.casting) this.fireCast(u); u.anim = null; u.st.down -= dt; continue; }
      if (u.st.push > 0) { u.anim = null; u.st.push -= dt; u.x += (u.side === 0 ? -1 : 1) * 160 * dt; u.x = Math.max(16, Math.min(374, u.x)); if (Math.random() < dt * 30) this.dust(u.x, this.uy(u), 0.5); continue; }
      if (u.sk) u.energy = Math.min(100, u.energy + (u.boss ? 11 : 9) * dt);
      if (u.casting) { u.cd -= dt; if (this.tickCast(u.casting, dt, u)) this.fireCast(u); continue; }
      // 敵人與自動模式的技能
      if (u.sk && u.energy >= 100 && !u.anim && (u.side === 1 || (this.auto && !u.minion))) { this.beginCast(u); continue; }
      if (u.anim) { this.stepAnim(u, dt); continue; }
      const tg = this.nearest(u); if (!tg) continue;
      const dx = tg.x - u.x, dist = Math.abs(dx);
      if (dist > u.range) { u.x += Math.sign(dx) * u.spd * dt; u.walking = true; }
      else { u.walking = false; u.cd -= dt; if (u.cd <= this.leadOf(u, tg)) u.anim = { name:'windup', t:0, dur:this.WIND, tg }; }
    }
    if (this.adviser) { this.adviser.energy = Math.min(100, this.adviser.energy + 7 * dt); if (this.auto && this.adviser.energy >= 100 && !this.advCast) this.cast(this.adviser); }
    if (this.advCast && this.tickCast(this.advCast, dt)) { const u = this.advCast.u; this.advCast = null; this.doSkill(u, u.sk); }
    if (this.comboSkill) { const c = this.comboSkill; if (c.a.hp > 0 && c.b.hp > 0) c.energy = Math.min(100, c.energy + 5 * dt); if (this.auto && c.energy >= 100) this.castCombo(); }
    if (this.comboCast && this.tickCast(this.comboCast, dt)) { const c = this.comboSkill; if (c.a.hp > 0 && c.b.hp > 0) this.fireCombo(); else this.comboCast = null; }
    // 分隔重疊
    const alive = this.units.filter(u => u.hp > 0);
    for (let i = 0; i < alive.length; i++) for (let j = i + 1; j < alive.length; j++) { const a = alive[i], b = alive[j]; if (a.side !== b.side) continue; if (Math.abs(a.x - b.x) < 22 && Math.abs(a.lane - b.lane) < 0.6) { const s = a.x < b.x ? -1 : 1; a.x += s * 10 * dt; b.x -= s * 10 * dt; } }
    // 卡片
    this.units.filter(u => u.card).forEach(u => { u.card.querySelector('.en s').style.height = u.energy + '%'; u.card.classList.toggle('ready', u.energy >= 100 && u.hp > 0 && !u.casting); u.card.classList.toggle('dead', u.hp <= 0); });
    if (this.adviser) { this.adviser.card.querySelector('.en s').style.height = this.adviser.energy + '%'; this.adviser.card.classList.toggle('ready', this.adviser.energy >= 100 && !this.advCast); }
    if (this.comboSkill) { const c = this.comboSkill; c.card.querySelector('.en s').style.height = c.energy + '%'; c.card.classList.toggle('ready', c.energy >= 100); }
    const heroes = this.units.filter(u => u.side === 0 && !u.minion && u.hp > 0).length, foes = this.units.filter(u => u.side === 1 && u.hp > 0).length;
    $('#b-time').textContent = Math.max(0, Math.ceil(this.timeLimit - this.t)) + 's';
    if (!foes) this.finish(true); else if (!heroes) this.finish(false); else if (this.t >= this.timeLimit) this.finish(false, false, true);
  },
  // 純視覺的計時（白閃、受擊、擊退、倒下）
  visTick(u, dt) {
    if (u.hp <= 0) u.deadT = (u.deadT || 0) + dt;
    u.flash = Math.max(0, (u.flash || 0) - dt / 0.18);
    u.hurtT = Math.max(0, (u.hurtT || 0) - dt);
    if (u.kbT != null) { u.kbT += dt; if (u.kbT > 0.3) u.kbT = null; }
  },
  finish(win, quit, timeout) {
    this.result = { win }; Sound.play(win ? 'win' : 'lose');
    const lost = Math.min(S.res.troops, this.units.filter(u => u.minion && u.hp <= 0).length * 25);
    S.res.troops = Math.max(0, S.res.troops - lost);
    const st = this.stage, sid = this.sid, first = win && !S.cleared[sid];
    let rew = {}, txt = '';
    if (win) {
      rew = first ? { coins:60 * st.p + 40, exp:30 * st.p + 40, chest:['g', 'b', 'p'][this.si] } : { coins:20 * st.p, exp:8 * st.p };
      if (this.coinsWon) rew.coins += this.coinsWon;
      S.cleared[sid] = true; txt = give(rew);
    }
    const box = $('#b-result');
    box.innerHTML = `<div class="br ${win ? 'win' : 'lose'}"><h2>${win ? (first ? '首次通關！' : '勝利') : quit ? '撤退' : timeout ? '時間到' : '戰敗'}</h2>
      ${win ? `<p class="quip">${WIN_QUIPS[Math.floor(Math.random() * WIN_QUIPS.length)]}</p><p>${txt}</p>` : `${quit ? '' : `<p class="quip">${LOSE_QUIPS[Math.floor(Math.random() * LOSE_QUIPS.length)]}</p>`}<p>${quit ? '' : '提示：用壽包升級鬼怪、換上嚇法對得上的陣容（看敵人怕什麼）、去嚇人訓練班練嚇功；先嚇到敵人失神，再接另一種他怕的，打出連嚇。'}</p>`}
      ${lost ? `<p class="lost">陰兵戰死 ${Math.floor(lost)}</p>` : ''}
      <button class="btn gold wide" id="b-ok">${win && first && st.after ? '繼續' : '回村子'}</button></div>`;
    box.classList.add('on');
    $('#b-ok').onclick = () => {
      box.classList.remove('on'); this.active = false; $('#battle').classList.remove('on');
      if (first && st.wild) { if (typeof N30W !== 'undefined') N30W.onWin(st); }
      else if (first) {
        const afters = (st.after || []).slice();
        // 加入：依劇情節點
        if (sid === '6-2') { Story.queue('ch6_wuchang', () => { joinGhost('baiwu'); joinGhost('heiwu'); }); Story.queue('ch6_mengpo', () => joinGhost('mengpo')); }
        else if (sid === '6-3') { Story.queue('ch6_end'); Story.queue('ch6_reboot', () => { S.ended = true; }); Story.queue('epilogue'); }
        else afters.forEach((id, i) => Story.queue(id, () => { if (i === 0) (st.join || []).forEach(joinGhost); if (GIFT_REWARD[id]) Fx.toast('媽媽燒來的禮物：' + give(GIFT_REWARD[id])); }));
      }
      if (!Story.busy()) Sound.setMode('village'); Quest.check(); save(); UI.refresh();
    };
    save();
  },
  // ---------- 繪製 ----------
  // 每個單位此刻的動作（姿勢名、進度、位移、旋轉、透明度）
  poseOf(u) {
    const fw = u.side ? -1 : 1, eo = p => 1 - Math.pow(1 - Math.min(1, Math.max(0, p)), 3), io = p => { p = Math.min(1, Math.max(0, p)); return p < 0.5 ? 4 * p * p * p : 1 - Math.pow(-2 * p + 2, 3) / 2; };
    let pose = u.walking ? 'move' : 'idle', pt = 0, ox = 0, oy = 0, rot = 0, alpha = 1;
    if (u.hp <= 0) {
      const p = Math.min(1, u.deadT / 0.8), d = u.dieDir || -fw; pose = 'die'; pt = p;
      ox = d * 24 * eo(p); oy = -Math.sin(Math.min(1, p * 1.4) * Math.PI) * 12; alpha = p < 0.45 ? 1 : Math.max(0, 1 - (p - 0.45) / 0.55);
    } else if (u.st.air > 0) {
      const p = 1 - u.st.air / (u.st.airMax || 1); pose = 'air'; pt = p;
      ox = -fw * 12 * Math.sin(p * Math.PI);
    } else if (u.st.down > 0) {
      const D = u.st.downMax || 1.4, el = D - u.st.down; pose = 'down'; pt = el / D;
      if (el < 0.25) oy = -Math.abs(Math.sin(el / 0.25 * Math.PI)) * 7;
    } else if (u.st.push > 0) { pose = 'hurt'; pt = 1 - u.st.push / 0.25; }
    else if (u.casting) { pose = 'cast'; pt = Math.min(1, u.casting.t / u.casting.dur); }
    else if (u.anim) {
      const a = u.anim, p = a.t / a.dur, L = this.lungeOf(u), ranged = u.range > 60; pose = a.name; pt = Math.min(1, p);
      if (a.name === 'windup') ox = -fw * (ranged ? 1 : 2) * eo(p);
      else if (a.name === 'strike') ox = ranged ? -fw * 5 * eo(p * 2) : fw * L * eo(p * 2.4);
      else ox = ranged ? -fw * 5 * (1 - io(p)) : fw * L * (1 - io(p));
    } else if (u.hurtT > 0) { pose = 'hurt'; pt = 1 - u.hurtT / 0.25; }
    if (u.kbT != null && u.hp > 0) { const p = u.kbT / 0.3, k = p < 0.25 ? eo(p / 0.25) : 1 - io((p - 0.25) / 0.75); ox += (u.kbDir || -fw) * (u.kbAmp || 6) * k; }
    // 戰場待機：沒在出手時，戰鬥姿態輕輕上下彈、偶爾挑釁（往前探一下）
    if (pose === 'idle' && u.hp > 0) {
      const ph = (u.lane || 0) * 1.7 + (u.side ? 0.9 : 0), tt = this.t + ph;
      oy += -Math.abs(Math.sin(tt * 4.2)) * 2.2;
      const tq = (tt % 4.6) / 4.6; if (!u.minion && tq > 0.82) { const k = Math.sin((tq - 0.82) / 0.18 * Math.PI); ox += fw * 4 * k; rot += -fw * 0.05 * k; }
    }
    return { pose, pt, ox, oy, rot, alpha };
  },
  draw() {
    if (!this.active) return;
    const ctx = this.ctx, k = this.sc * this.dpr, A = this.shakeA || 0;
    const shx = A ? (Math.random() - 0.5) * 2 * A : 0, shy = A ? (Math.random() - 0.5) * 1.2 * A : 0;
    ctx.setTransform(k, 0, 0, k, shx * k, shy * k);
    const H = this.H = this.h / this.sc;
    if (!SCENE.drawBg(ctx, 390, H, this.bg)) {
      paintBg(ctx, 390, H * 0.545, this.bg, this.t);
      const gy = H * 0.36; const gg = ctx.createLinearGradient(0, gy, 0, H); gg.addColorStop(0, '#2a2622'); gg.addColorStop(0.5, '#1c1a1a'); gg.addColorStop(1, '#121012'); ctx.fillStyle = gg; ctx.fillRect(0, gy, 390, H - gy);
    }
    if (this.slowT > 0) { ctx.fillStyle = `rgba(8,4,20,${Math.min(0.35, this.slowT * 2.4)})`; ctx.fillRect(-20, -20, 430, H + 40); }
    // 地面特效（塵土）先畫，在角色腳下
    for (const f of this.fx) if (f.kind === 'dust') this.drawDust(ctx, f);
    const list = this.units.slice().sort((a, b) => a.lane - b.lane);
    for (const u of list) {
      if (u.hp <= 0 && u.deadT > 0.8) continue;
      const P = this.poseOf(u), s = this.scaleOf(u), x = u.x + P.ox, y0 = this.uy(u), y = y0 + P.oy;
      if (u.casting) this.drawCharge(ctx, x, y0 - 28 * s, s, u.casting.t / u.casting.dur, u.side === 0 ? '#9ff3ff' : '#ff9ac0', false);
      const tg = u.anim && u.anim.tg && u.anim.tg.hp > 0 ? u.anim.tg : null;
      const o = { tdx:tg ? tg.x - u.x : (u.side ? -40 : 40), tdy:tg ? this.uy(tg) - this.uy(u) : 0, t:this.t + u.lane, walk:P.pose === 'move', pose:P.pose, pt:P.pt, flip:u.side === 1, enemy:u.side === 1, alpha:P.alpha, rot:P.rot, tamed:u.side === 0, untied:u.side === 0 };
      ART.drawChar(ctx, u.k, x, y, s, o);
      if (u.flash > 0) { ctx.save(); ctx.globalCompositeOperation = 'lighter'; ART.drawChar(ctx, u.k, x, y, s, Object.assign({}, o, { alpha:P.alpha * u.flash * 0.85, shadow:false })); ctx.restore(); }
      if (u.casting) this.drawCharge(ctx, x, y0 - 28 * s, s, u.casting.t / u.casting.dur, u.side === 0 ? '#9ff3ff' : '#ff9ac0', true);
      if (u.hp > 0) { const bx = u.x + P.ox * 0.4, bw = u.minion ? 26 : u.boss ? 64 : 46, by = y0 - (u.minion ? 36 : u.boss ? 92 : 72); ART.rr(ctx, bx - bw / 2, by, bw, 5, 2, 'rgba(0,0,0,.6)'); ART.rr(ctx, bx - bw / 2, by, bw * u.hp / u.maxhp, 5, 2, u.side ? '#e84a5f' : '#4ade80');
        if (u.sk && !u.minion) { ART.rr(ctx, bx - bw / 2, by + 6, bw * u.energy / 100, 3, 1.5, u.energy >= 100 ? '#ffd84a' : '#7dd3fc'); }
        if (u.boss) { ctx.fillStyle = '#ffd0d8'; ctx.font = 'bold 12px "PingFang TC","Noto Sans TC",sans-serif'; ctx.textAlign = 'center'; ctx.fillText(u.name, bx, by - 4); }
        if (u.st.air > 0 || u.st.down > 0) { ctx.fillStyle = u.st.air > 0 ? '#9ff' : '#fc9'; ctx.font = 'bold 11px sans-serif'; ctx.textAlign = 'center'; ctx.fillText(u.st.air > 0 ? '嚇彈起' : '腳軟', bx, by - (u.boss ? 18 : 4)); }
        if (u.side === 1 && u.fearT && u.fearT.until > this.t) { ctx.save(); ctx.font = 'bold 11px "PingFang TC","Noto Sans TC",sans-serif'; ctx.textAlign = 'center'; ctx.lineWidth = 3; ctx.strokeStyle = 'rgba(20,0,30,.8)'; ctx.fillStyle = '#e6c4ff'; const ty = by - (u.boss ? 18 : 6) - (u.st.air > 0 || u.st.down > 0 ? 13 : 0), tx = `失神・${Rework.word(u.fearT.t)}`; ctx.strokeText(tx, bx, ty); ctx.fillText(tx, bx, ty); ctx.restore(); } // 怕什麼連嚇（rework.js）
      }
    }
    // 軍師／合體技蓄力
    if (this.advCast) this.drawCharge(ctx, 34, H * 0.36, 1, this.advCast.t / this.advCast.dur, '#c8ffb0', true);
    if (this.comboCast) { const c = this.comboSkill, p = this.comboCast.t / this.comboCast.dur; [c.a, c.b].forEach(u => u.hp > 0 && this.drawCharge(ctx, u.x, this.uy(u) - 28 * this.scaleOf(u), this.scaleOf(u), p, '#ffb0ff', true)); }
    for (const p of this.proj) this.drawProj(ctx, p);
    if (this.flashT > 0) { ctx.fillStyle = `rgba(255,255,255,${this.flashT * 1.5})`; ctx.fillRect(-20, -20, 430, H + 40); }
    for (const f of this.fx) {
      if (f.kind === 'spark') this.drawSpark(ctx, f);
      else if (f.kind === 'slash') this.drawSlash(ctx, f);
      else if (f.kind === 'ring') { const p = f.t / f.life; ctx.save(); ctx.globalAlpha = 1 - p; ctx.strokeStyle = f.col; ctx.lineWidth = 3 * (1 - p) + 1; ctx.beginPath(); ctx.ellipse(f.x, f.y, 14 + p * 26, (14 + p * 26) * 0.5, 0, 0, Math.PI * 2); ctx.stroke(); ctx.restore(); }
      else if (f.kind !== 'dust') this.drawText(ctx, f);
    }
    if (this.comboT > 0 && this.combo > 0) { const z = 1 + (this.comboPop || 0) * 0.7; ctx.save(); ctx.translate(380, 40); ctx.scale(z, z); ctx.textAlign = 'right'; ctx.font = '900 16px sans-serif'; ctx.lineWidth = 4; ctx.strokeStyle = 'rgba(10,6,20,.9)'; ctx.strokeText(`COMBO ${this.combo}`, 0, 0); ctx.fillStyle = '#ffd84a'; ctx.fillText(`COMBO ${this.combo}`, 0, 0); ctx.restore(); }
  },
  // 跳字：彈出（過衝）後往上拋再落下
  drawText(ctx, f) {
    const t = f.t, a = t > f.life * 0.7 ? Math.max(0, 1 - (t - f.life * 0.7) / (f.life * 0.3)) : 1;
    const pop = t < 0.1 ? 0.35 + (t / 0.1) * 1.05 : t < 0.2 ? 1.4 - (t - 0.1) / 0.1 * 0.4 : 1;
    let x = f.x, y = f.y;
    if (f.kind === 'num') { x += (f.vx || 0) * t; y += -120 * t + 0.5 * 330 * t * t; }
    else if (!f.center) y -= t * 30;
    const size = f.center ? 30 : f.skill ? 16 : f.big ? 19 : 14;
    ctx.save(); ctx.globalAlpha = a; ctx.translate(x, y); ctx.scale(pop, pop); ctx.textAlign = 'center';
    ctx.font = `900 ${size}px "PingFang TC","Noto Sans TC",sans-serif`;
    ctx.lineWidth = f.big || f.center ? 5 : 4; ctx.lineJoin = 'round'; ctx.strokeStyle = 'rgba(10,6,20,.92)'; ctx.strokeText(f.text, 0, 0); ctx.fillStyle = f.col; ctx.fillText(f.text, 0, 0); ctx.restore();
  },
  // 蠟筆風火花：抖動的星芒線，粗描邊＋色線＋白芯，每條線畫兩三筆錯開
  drawSpark(ctx, f) {
    const p = f.t / f.life, e = 1 - Math.pow(1 - p, 2), a = 1 - p;
    ctx.save(); ctx.lineCap = 'round'; ctx.translate(f.x, f.y);
    const jit = (r, i) => Math.sin(r.j + i * 7.3) * 1.6;
    const pass = (col, w, al, off) => {
      ctx.strokeStyle = col; ctx.globalAlpha = al * a; ctx.lineWidth = w;
      for (const r of f.rays) {
        const r0 = r.len * (0.15 + e * 0.55), r1 = r.len * (0.45 + e * 0.75), c = Math.cos(r.a), sn = Math.sin(r.a);
        for (let i = 0; i < 2; i++) { ctx.beginPath(); ctx.moveTo(c * r0 + jit(r, i + off), sn * r0 + jit(r, i + off + 3)); ctx.lineTo(c * r1 + jit(r, i + off + 5), sn * r1 + jit(r, i + off + 1)); ctx.stroke(); }
      }
    };
    pass('rgba(20,10,30,.85)', 4.2 * f.k * (1 - p * 0.5), 0.8, 0); pass(f.col, 2.4 * f.k * (1 - p * 0.5), 1, 2); pass('#fff', 1 * f.k, 0.9, 4);
    // 中心十字閃光
    if (p < 0.5) { const q = (1 - p * 2) * 12 * f.k; ctx.globalAlpha = 1 - p * 2; ctx.rotate(f.rot); ctx.fillStyle = '#fff'; ctx.beginPath();
      for (let i = 0; i < 8; i++) { const ang = i * Math.PI / 4, rr = i % 2 ? q * 0.28 : q; ctx.lineTo(Math.cos(ang) * rr, Math.sin(ang) * rr); } ctx.closePath(); ctx.fill(); }
    ctx.restore();
  },
  // 刀光弧：由上往下掃過的新月
  drawSlash(ctx, f) {
    const p = f.t / f.life, r = f.r, sweep = Math.min(1, p * 2.2), a0 = -1.25, a1 = a0 + 2.5 * sweep, tail = Math.max(a0, a1 - 1.6);
    ctx.save(); ctx.translate(f.x - f.dir * r * 0.35, f.y); ctx.scale(f.dir, 1); ctx.globalAlpha = 1 - p * 0.9; ctx.lineCap = 'round';
    for (let i = 0; i < 3; i++) {
      ctx.strokeStyle = i === 0 ? 'rgba(20,10,30,.6)' : i === 1 ? f.col : '#fff'; ctx.lineWidth = [7, 4, 1.6][i] * (1 - p * 0.6);
      ctx.beginPath(); ctx.arc(0, 0, r - i * 1.2 + Math.sin(i * 3) * 0.8, tail, a1); ctx.stroke();
    }
    ctx.restore();
  },
  drawDust(ctx, f) {
    const p = f.t / f.life, e = 1 - Math.pow(1 - p, 2);
    ctx.save(); ctx.globalAlpha = 0.55 * (1 - p);
    for (const q of f.puffs) { ctx.fillStyle = 'rgba(190,176,150,1)'; ctx.beginPath(); ctx.arc(f.x + q.dx + q.vx * e * 0.4, f.y - 2 - e * 8, q.r * (0.6 + e * 0.9), 0, Math.PI * 2); ctx.fill(); }
    ctx.restore();
  },
  // 蓄力光圈：外圈收攏＋虛線旋轉＋聚氣光點；front=true 畫在角色前（光點），false 畫在角色後（光暈）
  drawCharge(ctx, x, y, s, p, col, front) {
    p = Math.min(1, p); ctx.save();
    if (!front) { const g = ctx.createRadialGradient(x, y, 0, x, y, 46 * s); g.addColorStop(0, col); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha = 0.25 + p * 0.45; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, 46 * s, 0, Math.PI * 2); ctx.fill(); ctx.restore(); return; }
    const R = (44 - p * 26) * s; ctx.strokeStyle = col; ctx.lineWidth = 2.5; ctx.globalAlpha = 0.4 + p * 0.6;
    ctx.setLineDash([7, 5]); ctx.lineDashOffset = -this.t * 60; ctx.beginPath(); ctx.ellipse(x, y + 20 * s, R * 1.1, R * 0.42, 0, 0, Math.PI * 2); ctx.stroke(); ctx.setLineDash([]);
    ctx.lineWidth = 1.6; ctx.beginPath(); ctx.arc(x, y, R, 0, Math.PI * 2); ctx.stroke();
    ctx.fillStyle = '#fff';
    for (let i = 0; i < 8; i++) { const ang = i * Math.PI / 4 + this.t * 3, rr = R * (1.25 - p * 0.6); ctx.globalAlpha = 0.9; ctx.beginPath(); ctx.arc(x + Math.cos(ang) * rr, y + Math.sin(ang) * rr * 0.8, 1.6 + p * 1.4, 0, Math.PI * 2); ctx.fill(); }
    ctx.restore();
  },
  drawProj(ctx, p) {
    ctx.save(); ctx.lineCap = 'round';
    for (let i = 1; i < p.trail.length; i++) { const [x0, y0] = p.trail[i - 1], [x1, y1] = p.trail[i], f = i / p.trail.length; ctx.globalAlpha = f * 0.7; ctx.strokeStyle = p.col; ctx.lineWidth = 1 + f * 5; ctx.beginPath(); ctx.moveTo(x0, y0); ctx.lineTo(x1, y1); ctx.stroke(); }
    if (p.trail.length) { const [x0, y0] = p.trail[p.trail.length - 1]; ctx.globalAlpha = 0.8; ctx.lineWidth = 6; ctx.beginPath(); ctx.moveTo(x0, y0); ctx.lineTo(p.x, p.y); ctx.stroke(); }
    ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'lighter'; const g = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, 11); g.addColorStop(0, '#fff'); g.addColorStop(0.35, p.col); g.addColorStop(1, 'rgba(0,0,0,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.arc(p.x, p.y, 11, 0, Math.PI * 2); ctx.fill();
    ctx.restore();
  },
};
