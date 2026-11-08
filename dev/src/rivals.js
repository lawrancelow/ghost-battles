// ===================== 三個死對頭（rivals.js）：龐總（察 KPI）、Bryan（偷功勞＋搬弄是非）、冼小姐（HR）=====================
// 同陰間日常共用排程（Skits.tick 每秒問 Rivals.tick()）：只喺村子安靜、玩家有操作時先計時；唔會打斷戰鬥、彈窗、劇情；全部可以跳過。
// 「偶爾、辛辣」：三個人加埋，最少隔 6 分鐘（有操作嘅時間）先出一次；龐總嚟收 KPI、Bryan 偷功勞就快啲。
// 懲罰一律細：少少冥幣，或者幾分鐘產量慢少少；每次都有聰明嘅選擇可以避開，仲有獎。
// 原圖：npc_kpiboss（龐總）、npc_rival（Bryan）、npc_hr（冼小姐）。原圖未到：遊戲入面唔會出（Theater 只畫個影）。
// 存檔：S.antag（見 st()），舊存檔自動補。
const Rivals = (() => {
  const ART = { boss:'npc_kpiboss', rival:'npc_rival', hr:'npc_hr' };
  const NM = { boss:'龐總', rival:'Bryan', hr:'冼小姐' };
  const GAP = 360, REVIEW_GAP = 45;
  const art = (k) => typeof sprOk !== 'function' || sprOk(k);
  const seen = (id) => !!(S && S.seen && S.seen[id]);
  const R = Math.random;
  function st() {
    if (typeof S === 'undefined' || !S) return null;
    const a = S.antag = S.antag || {};
    a.clock = a.clock || 0; if (typeof a.gap !== 'number') a.gap = 200; a.n = a.n || {};
    a.boss = Object.assign({ task:null, visits:0, pass:0, fail:0, slowUntil:0 }, a.boss || {});
    a.rival = Object.assign({ met:false, arc:0, pend:null, rumor:null, stolen:0, grudge:0, peaceUntil:0, beaten:false, duels:0 }, a.rival || {});
    a.hr = Object.assign({ met:false, warn:0, visits:0, done:{} }, a.hr || {});
    return a;
  }
  // 台詞池：輪住用，同一個人唔會連續講同一句
  function rot(key, pool) { const a = st(); const i = (a.n[key] = ((a.n[key] || 0) + 1)) - 1; return pool[i % pool.length]; }
  const now = () => Date.now();
  const mins = (ms) => Math.max(1, Math.round(ms / 60000));
  // 三個人嘅招牌動作（npc_antag.js 嘅 ag_ 狀態）：講嘢時、企定時、某啲句子
  const LOOK = { 龐總:{ base:'ag:inspect', talk:'ag:tap' }, Bryan:{ base:'ag:spin', talk:'ag:dribble' }, 冼小姐:{ base:'ag:clip', talk:'ag:glasses' } };
  function deco(lines) {
    return lines.map(l => { if (!Array.isArray(l) || l[2]) return l; const [w, t] = l; let a = null;
      if (w === '冼小姐' && /蓋印|批。|駁回|警告信/.test(t)) a = 'ag:stamp';
      else if (w === '龐總' && /未達標|差少少|失禮|冇用/.test(t)) a = 'ag:yell';
      else if (w === '龐總' && /唔達標|罰/.test(t)) a = 'ag:sigh';
      else if (w === 'Bryan' && /轉述|唔好話我講|不值|私底下|細細聲/.test(t)) a = 'ag:gossip';
      else if (w === 'Bryan' && /假波|助攻！|沖茶點計/.test(t)) a = 'ag:jump';
      else if (w === 'Bryan' && /承讓|我入嘅|三分/.test(t)) a = 'ag:jumpshot';
      return a ? [w, t, a].concat(l.slice(3)) : l; });
  }
  function play(sc, cb) {
    sc.cast = sc.cast.map(c => LOOK[c[0]] ? [c[0], c[1], Object.assign({}, LOOK[c[0]], c[2] || {})] : c);
    sc.lines = deco(sc.lines);
    const wrapC = (c) => { if (!c) return c; for (const k of ['a', 'b', 'c']) if (c[k]) { const o = c[k]; o.lines = deco(o.lines || []); if (o.on) { const on = o.on; o.on = (p) => { const r = on(p); return Array.isArray(r) ? deco(r) : r; }; } if (o.next) { const nx = o.next; o.next = typeof nx === 'function' ? (p) => wrapC(nx(p)) : wrapC(nx); } } return c; };
    sc.choice = wrapC(sc.choice);
    Theater.play(sc, cb);
  }
  function toast(h) { try { Fx.toast(h); } catch (e) {} }
  function done() { try { save(); UI.refresh(); } catch (e) {} }

  // ---------- 產量影響（包住 ratesPerMin，唔改 game.js）----------
  // 龐總罰：全村慢 15%；Bryan 謠言：被造謠嗰隻鬼做嘢慢一半
  if (typeof ratesPerMin === 'function') {
    const orig = ratesPerMin;
    ratesPerMin = function () {
      const r = orig.apply(this, arguments); const a = typeof S !== 'undefined' && S && S.antag; if (!a) return r;
      const ru = a.rival && a.rival.rumor;
      if (ru && ru.until > now()) {
        const g = S.ghosts.find(x => x.id === ru.gid);
        if (g && g.post) { const p = g.post; g.post = null; const wo = orig.apply(this, arguments); g.post = p; for (const k in r) r[k] = wo[k] + 0.5 * (r[k] - wo[k]); }
      }
      if (a.boss && a.boss.slowUntil > now()) for (const k in r) r[k] *= 0.85;
      return r;
    };
  }

  // ===================== 龐總：察 KPI =====================
  function stageOpen() {
    try {
      for (let ci = 0; ci < CHAPTERS.length; ci++) for (let si = 0; si < CHAPTERS[ci].stages.length; si++) {
        const sid = Battle.sidOf(ci, si), stg = CHAPTERS[ci].stages[si]; if (S.cleared[sid]) continue;
        const prev = si > 0 ? Battle.sidOf(ci, si - 1) : ci > 0 ? Battle.sidOf(ci - 1, CHAPTERS[ci - 1].stages.length - 1) : null;
        if ((!prev || S.cleared[prev]) && S.lv >= stg.req) return true; return false;
      }
    } catch (e) {} return false;
  }
  const TASKS = {
    chop:  { ok:() => true, n:() => 3 + Math.floor(R() * 3), m:5, val:() => S.cnt.chop, unit:'棵', what:'親手砍槐樹',
      lines:(n, m) => [['龐總', Lf('今次 KPI：{m} 分鐘之內，你親手斬 {n} 棵槐樹。唔准叫人幫，我要睇到你把斧頭有熱情。', { n, m })], ['阿福', '斧頭點會有熱情？'], ['龐總', '所以先要你補返。']] },
    rice:  { ok:() => true, n:() => 3 + Math.floor(R() * 3), m:5, val:() => S.cnt.rice, unit:'次', what:'親手收割糯米',
      lines:(n, m) => [['龐總', Lf('{m} 分鐘之內，割 {n} 次糯米。糯米係本季戰略物資：殭屍好驚，投資者好鍾意。', { n, m })], ['阿福', '投資者係邊個？'], ['龐總', '你唔使知。你淨係要知，佢哋唔開心。']] },
    bun:   { ok:() => S.bld.bun > 0, n:() => 3 + Math.floor(R() * 3), m:6, val:() => S.cnt.craftBun, unit:'次', what:'親手包壽包',
      lines:(n, m) => [['龐總', Lf('{m} 分鐘之內，你親手包 {n} 次壽包。', { n, m })], ['阿福', '包子鋪有鬼包㗎。'], ['龐總', '佢哋包嘅係佢哋嘅 KPI。你包嘅，先係你嘅。']] },
    plank: { ok:() => S.bld.plank > 0, n:() => 3 + Math.floor(R() * 3), m:6, val:() => S.cnt.craftPlank, unit:'次', what:'親手做棺材板',
      lines:(n, m) => [['龐總', Lf('{m} 分鐘之內，你親手做 {n} 次棺材板。', { n, m })], ['阿福', '點解要我親手做？'], ['龐總', '棺材係我哋嘅核心產品。客戶一世人只用一次，所以唔准有第二次機會。']] },
    stock: { ok:() => S.bld.bun > 0, n:() => Math.min(Math.floor(F.cap() * 0.9), Math.floor(S.res.buns) + Math.max(12, Math.round(ratesPerMin().buns * 4))), m:7, val:() => Math.floor(S.res.buns), abs:true, unit:'個', what:'倉庫存有壽包',
      lines:(n, m) => [['龐總', Lf('我下次嚟嘅時候，倉入面要有 {n} 個壽包。少一個，我都會知。', { n })], ['阿福', '你點會知？'], ['龐總', '（拍一拍部平板）佢話我知。']] },
    stage: { ok:stageOpen, n:() => 1, m:10, val:() => Object.keys(S.cleared).length, unit:'關', what:'打通新關卡',
      lines:(n, m) => [['龐總', '下次我嚟之前，你要打通一關新關卡。市場佔有率，係打返嚟嘅。'], ['阿福', '係真係打仗嚟㗎喎。'], ['龐總', '所以先叫市場。']] },
  };
  const ABSURD = [
    { ask:'下個月，全村 KPI 要增長三百個巴仙。', smart:'「龐總，咁上個月嘅 baseline 係幾多？」', dodge:[['龐總', '（睇平板）落魄村上個月啱啱開張……baseline 係零。'], ['阿福', '零嘅三倍係幾多？'], ['龐總', '……我返去 align 一下。']] },
    { ask:'由今日起，全村鬼要朝九晚五返工。', smart:'「冇問題，朝九晚五：晚上九點到朝早五點。」', dodge:[['龐總', '……即係同而家一樣？'], ['阿福', '一樣。不過而家有制度。'], ['龐總', '好。我要寫入報告：已落實制度化。']] },
    { ask:'每隻鬼每日要交一份手寫日報，一式三份。', smart:'「要紙，紙要燒落嚟，燒要冥幣。預算批咗未？」', dodge:[['龐總', '預算……'], ['阿福', '冇預算，就冇紙。冇紙，就冇日報。'], ['龐總', '（收埋平板）呢個 project，下季再議。']] },
    { ask:'我要你哋 work harder，同時 work smarter，同時 work-life balance。', smart:'「三樣揀兩樣。龐總你揀邊兩樣？」', dodge:[['龐總', '……harder 同 smarter。'], ['阿福', '咁 balance 呢？'], ['龐總', '……smarter 同 balance。'], ['阿福', '咁 harder 呢？'], ['旁白', '龐總站在原地想了一個鐘頭，想到下班。']] },
    { ask:'清明之前，我要見到陽間家屬滿意度提升。', smart:'「好，我叫家屬填問卷。問卷燒落嚟，答案燒返上去，每份手續費你批？」', dodge:[['龐總', '燒返上去要幾多手續費？'], ['阿福', '陰陽兩界轉賬費，一成半。'], ['龐總', '……滿意度呢個指標，我決定唔追。']] },
  ];
  const BOSS_OPEN = ['又係我。唔使驚，驚都冇用，數字唔會因為你驚而升。', '突擊巡查。我唔預約，預約咗你哋就會準備，準備咗啲數就唔真。', '我順路經過。通常我順路經過嘅地方，都會順手裁人。', '我今日心情好，所以只係察 KPI，唔係察你。'];
  const BOSS_PASS = [[['龐總', '（望住平板好耐）……達標。我唔會讚你，讚咗你下季就鬆懈。']], [['龐總', '做到。好，下季目標我加倍——呢個係對你嘅肯定。']], [['龐總', '合格。唔好笑。你一笑，我就覺得目標定得太低。']], [['龐總', '……過關。（細細聲）點解每個都過關嘅？係咪我太善良？']]];
  const BOSS_FAIL = [[['龐總', '未達標。你知唔知，你嘅效率輸畀殭屍跳？佢哋膝頭都唔識彎㗎。']], [['龐總', '差少少。我哋公司冇「差少少」呢個欄位，只有「得」同「你」。']], [['龐總', '你生前過勞死，死咗又唔過勞。你自己諗吓邊樣比較失禮。']], [['龐總', '我見過好多冇用嘅員工。你係第一個，冇用得咁有規律。']]];
  function bossVisit() {
    const a = st(), b = a.boss, first = !b.visits; b.visits++;
    const cast = [['阿福', 'afu'], ['龐總', ART.boss]];
    const open = first ? [['旁白', '一隻矮矮胖胖、頭髮梳得發亮的鬼，拿著一部平板飄進村子。平板上，一條紅線一路向下。'], ['龐總', '阿福。我係地府集團營運總監，龐總。我唔係針對你，我係針對你嘅數字。']] : [['龐總', rot('bossOpen', BOSS_OPEN)]];
    if (!first && R() < 0.3) { // 荒謬要求：揀得聰明就避開，仲有獎
      const d = rot('absurd', ABSURD), smartIsA = R() < 0.5;
      const smart = { label:d.smart, lines:[['阿福', L(d.smart).replace(/[「」]/g, '')]].concat(d.dodge), on:() => { const t = give({ coins:rwd(18) }); return [['旁白', `阿福躲過了。${t}`]]; } };
      const dumb = { label:'「收到。」', lines:[['阿福', '收到。'], ['龐總', '好。我就鍾意你呢種員工。']], on:() => { b.slowUntil = now() + 5 * 60000; return [['旁白', '阿福一句「收到」，全村陪他加班。懲罰：全村工作速度 −15%（5 分鐘）。']]; } };
      play({ tag:'察 KPI', title:'龐總：要求', bg:'village', cast, lines:open.concat([['龐總', d.ask]]), choice:{ plain:true, q:'龐總要求：' + L(d.ask), a:smartIsA ? smart : dumb, b:smartIsA ? dumb : smart } }, () => done());
      return;
    }
    const kinds = Object.keys(TASKS).filter(k => TASKS[k].ok()); const k = kinds[Math.floor(R() * kinds.length)], T = TASKS[k];
    const n = T.n(), m = T.m;
    b.task = { k, n, base:T.abs ? 0 : T.val(), due:a.clock + m * 60, set:a.clock, what:T.what, unit:T.unit };
    play({ tag:'察 KPI', title:'龐總：突擊巡查', bg:'village', cast, lines:open.concat(T.lines(n, m)).concat([['旁白', `KPI：${m} 分鐘內${T.what} ${n}${T.unit}。進度見左下角。`]]) }, () => { done(); hud(); });
  }
  // 地府集團優化小組（su46）：半夜收到龐總訊息，終於可以已讀不回
  function bossGroup() {
    const a = st(); a.boss.group = 1;
    const chat = { style:'chat', title:'地府集團優化小組', group:'龐總、白無常、黑無常、阿福…', av:['優', '#6a3a3a'], lines:[
      ['龐總', '23:58|各位，由聽日起，每隻鬼每日要嚇夠三個人，計入 KPI'], ['白無常', '23:58|收到！一見生財！'], ['黑無常', '23:59|知道。'],
      ['龐總', '00:01|仲有，聽朝大家提早半個鐘出嚟'], ['白無常', '00:02|龐總，我哋係鬼，朝早出唔到嚟喎'], ['龐總', '00:02|唔好俾藉口我'], ['龐總', '00:03|@阿福 你呢？']] };
    const choice = { plain:true, q:'凌晨十二點零三分。龐總在等你回覆。',
      a:{ label:'回覆：「收到。」', lines:[['旁白', '手指比腦袋快，「收到」已經送出。'], ['旁白', '龐總秒回：「好。順便交埋份報告。」']], on:() => { a.boss.slowUntil = now() + 4 * 60000; return [['旁白', '懲罰：全村陪你熬夜，工作速度 −15%（4 分鐘）']]; } },
      b:{ label:'已讀。不回。把手機放下。', lines:[['旁白', '已讀，不回。'], ['旁白', '那是阿福做鬼以來，睡得最好的一個晚上。']], on:() => [['旁白', `睡飽了：${give({ coins:rwd(20), exp:rwd(8) })}`]] } };
    if (R() < 0.5) { const x = choice.a; choice.a = choice.b; choice.b = x; }
    Story.queue(chat, () => setTimeout(() => play({ tag:'察 KPI', title:'已讀不回', bg:'village', cast:[['阿福', 'afu', { onstage:true }]], lines:[['旁白', '阿福看著手機，手指在發抖。三年來，他每晚都是這樣，馬上回覆「收到」。']], choice }, () => done()), 80));
  }
  function taskProg() { const a = st(), t = a.boss.task; if (!t) return null; const T = TASKS[t.k]; const v = T.val() - t.base; return { v:Math.max(0, v), n:t.n, left:Math.max(0, t.due - a.clock) }; }
  function bossReview() {
    const a = st(), b = a.boss, p = taskProg(), pass = p.v >= p.n; const t = b.task; b.task = null;
    let lines = [['龐總', Lf('嚟收數。KPI：{w} {n}{u}。你做到 {v}{u}。', { w:t.what, n:t.n, u:t.unit, v:Math.min(p.v, 999) })]];
    if (pass) { b.pass++; lines = lines.concat(rot('bossPass', BOSS_PASS)); const r = give({ coins:rwd(30), exp:rwd(6) }); lines.push(['旁白', `達標獎勵：${r}`]); }
    else {
      b.fail++; lines = lines.concat(rot('bossFail', BOSS_FAIL));
      if (b.fail % 2) { const c = Math.min(Math.floor(S.res.coins), rwd(20)); S.res.coins -= c; lines.push(['旁白', c ? `懲罰：冥幣 −${c}` : '懲罰：冥幣——可惜你身上沒有冥幣。龐總在平板上記下：「此員工連罰都罰唔落。」']); }
      else { b.slowUntil = now() + 5 * 60000; lines.push(['旁白', '懲罰：全村工作速度 −15%（5 分鐘）']); }
    }
    play({ tag:'察 KPI', title:pass ? '龐總：收數（達標）' : '龐總：收數（唔達標）', bg:'village', cast:[['阿福', 'afu'], ['龐總', ART.boss]], lines }, () => { done(); hud(); });
  }

  // ===================== Bryan：偷功勞、搬弄是非、最後決鬥 =====================
  const BRYAN_CLAIM = [
    '兄弟！頭先（{w}），好在有我幫你 cover 住。呢球，我入嘅。',
    'Bro～恭喜晒！不過頭先（{w}），其實係我助攻。助攻都計分㗎嘛。',
    '嘩，{w}！我哋做得好呀！我已經同上面報咗，寫我個名先，方便啲嘛。',
    '{w}？呢個 play 係我喺白板度畫嘅。你只係照住跑啫，兄弟。',
  ];
  const ALIBI = ['茶水間度練緊三分波', '廁所度影緊 selfie', '同冼小姐飲緊下午茶', '天台度同龐總影緊合照'];
  const BRYAN_LOSE = [['Bryan', '……呢個係假波！我要睇重播！']];
  const BRYAN_RUN = ['好，好，今次當我傳失波。', '你哋玩得咁認真，冇 team spirit 㗎。', '我去熱吓身先，你哋繼續。'];
  function smartest() { let best = null, v = -1; for (const g of S.ghosts) { if (g.k === 'afu') continue; const x = F.stat(g, 1); if (x > v) { v = x; best = g; } } return best ? { g:best, v } : null; }
  function rivalIntro() { const a = st(); if (a.rival.met) return []; a.rival.met = true;
    return [['旁白', '一隻高高瘦瘦、留著銀灰色平頭的鬼，一邊拍著籃球一邊飄過來。'], ['阿福', '……Bryan？你點會喺度？'],
      ['Bryan', '兄弟！好耐冇見！上個月公司籃球賽，我入咗個 slam dunk，太興奮，就落咗嚟。'], ['Bryan', '而家我喺地府集團做業務拓展。我哋又係同事喇！'],
      ['阿福', '（細細聲）生前佢坐我隔籬。我做嘅 report，佢 present。']]; }
  function rivalTheft() {
    const a = st(), r = a.rival, p = r.pend; r.pend = null;
    let amt = Math.min(Math.floor(S.res.coins), rwd(25)), res = 'coins'; if (amt < 8) { amt = Math.min(Math.floor(S.res.buns), rwd(20)); res = 'buns'; }
    const amtTxt = `${RES_NAMES[res]} ${amt}`, need = 60 + 12 * Math.min(3, r.arc), sm = smartest();
    const cast = [['阿福', 'afu'], ['Bryan', ART.rival]]; if (sm) cast.splice(1, 0, [sm.g.name, sm.g.k]);
    const lines = rivalIntro().concat([['Bryan', Lf(rot('claim', BRYAN_CLAIM), { w:p.what }), 'wave'], ['Bryan', Lf('所以呢份獎勵，我攞返我應得嗰份：{a}。大家隊友，唔好計得咁盡啦。', { a:amtTxt })]]);
    const okEv = sm && sm.v >= need;
    const choice = { plain:true, q:`Bryan 想分走你的獎勵（${amtTxt}）。`,
      a:{ label:sm ? (okEv ? `派${sm.g.name}出示證據（智 ${sm.v}，需 ${need}）` : `出示證據（${sm.g.name}智 ${sm.v}，不足 ${need}）`) : '出示證據（沒有幫手）', disabled:!okEv,
        lines:okEv ? [[sm.g.name, Lf('（攤開一疊紙）記錄喺度：{w}，由頭到尾都係少爺做嘅。嗰陣你喺{a}。', { w:p.what, a:L(rot('alibi', ALIBI)) })]].concat(BRYAN_LOSE, [[sm.g.name, '重播都喺度。你個波，三次都出界。']]) : [],
        on:() => { r.arc++; r.grudge = Math.max(0, r.grudge - 1); const t = give({ [res]:rwd(15) }); return [['Bryan', rot('run', BRYAN_RUN)], ['旁白', `證據確鑿，一分也沒被拿走。另外獲得：${t}`]]; } },
      b:{ label:'跟他爭（不給，但他會記仇）', lines:[['阿福', 'Bryan，嗰陣你喺邊？'], ['Bryan', '我……我喺精神上支持你！'], ['阿福', '精神上支持，冇獎金。'], ['Bryan', '好，好。兄弟，你小心啲。']], on:() => { r.arc++; r.grudge++; return []; } },
      c:{ label:`給他（${amtTxt}；他會安靜一陣子）`, lines:[['阿福', '攞去啦。'], ['Bryan', '爽快！我就話你係好隊友！下次我一定 pass 波俾你。'], ['旁白', '他從來沒有傳過球給任何人。']],
        on:() => { S.res[res] -= amt; r.stolen += res === 'coins' ? amt : 0; r.arc++; r.peaceUntil = a.clock + 15 * 60; return []; } } };
    play({ tag:'死對頭', title:'Bryan：搶功勞', bg:'village', cast, lines, choice }, (res2) => { if (res2.skipped && !res2.picks.length) r.grudge++; done(); });
  }
  const RUMORS = [
    '{n}，我唔係想搬弄是非，不過阿福話你做嘢慢過殭屍跳。我淨係轉述，我好中立㗎。',
    '{n}，聽講下季你個位要俾 AI 取代。唔好話我講㗎，我只係 pass 個波俾你。',
    '{n}，你知唔知全村個個都加咗人工？淨係你冇。我都係為你不值啫。',
    '{n}，阿福私底下話，你係全村最易替代嘅鬼。佢原話係：「隨便搵隻都得。」',
  ];
  const HURT = ['……少爺真係咁講？', '（手上啲嘢跌晒落地）', '我……我做咗咁耐……', '原來我喺佢心目中係咁……'];
  function rivalGossip() {
    const a = st(), r = a.rival, cand = S.ghosts.filter(g => g.post && g.k !== 'afu' && art(g.k)); if (!cand.length) return false;
    const g = cand[Math.floor(R() * cand.length)], cost = rwd(15);
    const lines = rivalIntro().concat([['旁白', `Bryan 摟著${g.name}的肩膀，壓低聲音說話。`], ['Bryan', Lf(rot('rumor', RUMORS), { n:g.name })], [g.name, rot('hurt', HURT), 'look'],
      ['阿福', 'Bryan，你同佢講咩？'], ['Bryan', '冇呀，打吓氣嘛。我哋要有 team spirit。']]);
    const set = () => { r.rumor = { gid:g.id, name:g.name, until:now() + 8 * 60000 }; hud(); };
    const choice = { plain:true, q:`${g.name}聽信謠言，工作速度減半。怎麼處理？`,
      a:{ label:`請全村吃宵夜澄清（壽包 ${cost}）`, disabled:S.res.buns < cost, lines:[['阿福', '今晚宵夜我請，順便講清楚：冇呢回事。'], [g.name, '……少爺，我信你。'], ['Bryan', '（揸住個波）宵夜有冇我份？'], ['阿福', '冇。']], on:() => { S.res.buns -= cost; r.rumor = null; r.arc++; return [['旁白', '謠言澄清了。']]; } },
      b:{ label:`請冼小姐發澄清通告（行政費：冥幣 ${rwd(8)}）`, disabled:S.res.coins < rwd(8), lines:[['冼小姐', '澄清通告，一式三份：正本貼公告板，一份副本俾當事人，一份俾造謠者。'], ['Bryan', '點解有我份？'], ['冼小姐', '因為通告上面寫住你個名呀，親愛嘅同事～']], on:() => { S.res.coins -= rwd(8); r.rumor = null; r.arc++; return [['旁白', '謠言澄清了。Bryan 收到人生第一封澄清通告。']]; } },
      c:{ label:'不理會（清者自清）', lines:[['阿福', '清者自清。']], on:() => { set(); r.arc++; return [['旁白', `${g.name}工作速度減半，持續 8 分鐘。`]]; } } };
    const cast = [['阿福', 'afu'], [g.name, g.k], ['Bryan', ART.rival]];
    play({ tag:'死對頭', title:'Bryan：搬弄是非', bg:'village', cast, lines, choice }, (res) => { if (!res.picks.length) set(); done(); });
    return true;
  }
  // 最後決鬥：一對一三球。每球 Bryan 自己會漏口風，聽清楚就揀得啱（贏兩球就贏）
  const ROUNDS = [
    { tell:'呢球我唔使郁，自然有人傳俾我。', q:'第一球：Bryan 守在籃下一動不動。', right:'自己運球上籃，不傳球', wrong:'傳給隊友', win:[['旁白', '阿福自己運球上籃。Bryan 在籃下等了整場，沒人傳球給他。']], lose:[['旁白', '球一傳出去，就被 Bryan 截走：「多謝助攻！」']] },
    { tell:'你掂我一下，我即刻搵冼小姐。', q:'第二球：Bryan 衝了過來。', right:'站定不動，等他自己衝過來', wrong:'貼身防守', win:[['旁白', 'Bryan 衝過來，發現沒人可撞，自己摔在地上。冼小姐舉起印章，無處可蓋。']], lose:[['旁白', '阿福一貼身，Bryan 立刻倒地。冼小姐蓋印：「犯規～」']] },
    { tell:'龐總望緊，呢球我一定要入。', q:'最後一球：Bryan 望著場邊的龐總起跳。', right:'請龐總看看平板上的數據', wrong:'跳起來封阻', win:[['旁白', '龐總一低頭看平板，就沒人看著 Bryan 了。他一慌，球連籃框都沒碰到。']], lose:[['旁白', 'Bryan 比阿福高一個頭，假動作騙阿福起跳，再慢慢把球放進去。']] },
  ];
  function rivalShowdown() {
    const a = st(), r = a.rival; r.duels++;
    const cast = [['阿福', 'afu'], ['Bryan', ART.rival], ['龐總', ART.boss]];
    const intro = [['Bryan', '兄弟，我哋咁樣拗落去都唔係辦法。一對一，三球。你贏，我認晒以前啲功勞係你嘅。'], ['阿福', '我輸呢？'], ['Bryan', '你輸，以後你啲功勞都係我嘅。'], ['阿福', '……同而家有咩分別？'], ['Bryan', '有。以後係正式嘅。'], ['龐總', '我做旁證。Data 唔會呃人。']];
    let wins = 0;
    const round = (i) => { const d = ROUNDS[i], ra = R() < 0.5;
      const mk = (right) => ({ label:right ? d.right : d.wrong, lines:right ? d.win : d.lose, on:() => { if (right) wins++; const out = [['旁白', `比數：阿福 ${wins}：${i + 1 - wins} Bryan`]]; if (i < 2) out.push(['Bryan', ROUNDS[i + 1].tell, 'wave']); return out; }, next:i < 2 ? () => round(i + 1) : null });
      return { plain:true, q:d.q, a:mk(ra), b:mk(!ra) }; };
    const lines = intro.concat([['Bryan', ROUNDS[0].tell, 'wave']]);
    const tail = () => {
      if (wins >= 2) { r.beaten = true; const back = Math.min(r.stolen, rwd(120)); const t = give(Object.assign({ chest:'p', coins:rwd(60) + back }));
        return [['龐總', '（揭開平板）順便講埋：我睇過數據。Bryan 呢三年嘅 KPI，九成係人哋做嘅。'], ['Bryan', '龐總，嗰啲係……助攻！'], ['龐總', '由今日起，你調去落魄村茶水間。職位：茶水間主任。KPI：沖茶。'], ['Bryan', '……沖茶點計 KPI？'], ['龐總', '你沖嘅每一杯，都要寫你自己個名。'], ['旁白', `Bryan 被揭穿。之前被他拿走的冥幣全數追回。獎勵：${t}`]]; }
      return [['Bryan', '承讓承讓！兄弟，下次再嚟過，我隨時候教。'], ['龐總', '（喺平板寫低）Bryan：勝。阿福：仲有改善空間。'], ['旁白', '輸了沒有損失。過一陣子，Bryan 會再來挑戰。']];
    };
    const choice = round(0);
    // 最後一球揀完，接埋結局
    const last = (c) => { for (const k of ['a', 'b']) { const o = c[k]; if (o.next) { const nx = o.next; o.next = () => last(nx()); } else { const on = o.on; o.on = (p) => on(p).concat(tail()); } } return c; };
    play({ tag:'死對頭', title:'Bryan：一對一，三球', bg:'office', cast, lines, choice:last(choice) }, () => done());
  }

  // ===================== 冼小姐：HR =====================
  const HR_INTRO = [['旁白', '一隻梳著髮髻、戴著貓眼眼鏡的女鬼飄進村子，手拿文件夾，腰間掛著一個大紅印。她的笑容很標準，標準得像是印上去的。'], ['冼小姐', '親愛嘅同事～我係人力資源部冼小姐。由今日起，落魄村納入集團員工手冊管理。'], ['冼小姐', '溫馨提示：手冊有三千頁。冇睇過，唔係藉口。']];
  const warn = (lines) => { const h = st().hr; h.warn++; if (h.warn >= 3) { h.warn = 0; const c = Math.min(Math.floor(S.res.coins), rwd(12)); S.res.coins -= c; return lines.concat([['冼小姐', '恭喜你～集齊三封警告信，可以換一個大過！'], ['旁白', `記大過：冥幣 −${c}。警告信歸零。`]]); } return lines.concat([['旁白', `警告信 +1（集滿三封記大過）。目前：${h.warn} 封。`]]); };
  const HR_EV = [
    { id:'mc', title:'冼小姐：病假紙', lines:[['冼小姐', '親愛嘅同事～上個禮拜三你冇出席晨會。根據手冊第 214 條，缺席要補交病假紙。'], ['阿福', '我死咗喇。'], ['冼小姐', '死亡唔係病，係一種長期狀態。長期狀態，要交長期病假紙，一式三份。']],
      q:'冼小姐要你交病假單。', smart:{ label:'「手冊第一條：員工須在生。我唔在生，手冊唔適用。」', lines:[['冼小姐', '（揭返去第一頁）……第一條……'], ['冼小姐', '呢條係邊個寫㗎？'], ['阿福', '你。'], ['冼小姐', '（蓋印）批。今次當我冇嚟過。']], give:() => ({ coins:rwd(15) }) },
      dumb:{ label:'「好，我補交。」', lines:[['冼小姐', '好乖～七個工作天內交到，逾期當自動辭職。'], ['阿福', '辭職可以去邊？'], ['冼小姐', '返陽間囉，親愛嘅同事～'], ['旁白', '沒有醫生肯替鬼開病假單。']], warn:true } },
    { id:'gps', title:'冼小姐：打卡', lines:[['冼小姐', '打卡系統顯示：你返工時間，GPS 喺墳場。屬擅離職守。'], ['阿福', '我住喺墳場。']],
      q:'冼小姐說你擅離職守。', smart:{ label:'「我喺屋企返工，即係 WFH。」', lines:[['冼小姐', 'WFH 要預先申請。'], ['阿福', '申請表喺邊？'], ['冼小姐', '喺公司，要返公司攞。'], ['阿福', '咁我返公司攞表嗰陣，係咪就唔算擅離職守？'], ['冼小姐', '（諗咗好耐，蓋印）……批。你好煩。']], give:() => ({ exp:rwd(8) }) },
      dumb:{ label:'「我即刻返去補打卡。」', lines:[['冼小姐', '打卡時間已過，而家打屬於遲到。'], ['阿福', '咁遲到嘅定義係？'], ['冼小姐', '你出現嘅時候。']], warn:true } },
    { id:'team', title:'冼小姐：強制 team-building', lines:[['冼小姐', '強制性 team-building！今日活動：信任跌。一個向後跌，其他人接住。'], ['阿福', '我哋係鬼，會穿過去。'], ['冼小姐', '所以先要練呀～']],
      q:'怎麼應付這次 team-building？', smart:{ label:'「參加。」', lines:[['旁白', '十二隻鬼輪流往後倒，十二次都穿過地面掉了下去。'], ['冼小姐', '好！大家建立咗「冇人會接住你」嘅共識，非常真實。']], give:() => ({ exp:rwd(8) }) },
      dumb:{ label:'「我今日請病假。」', lines:[['冼小姐', '病假紙呢？'], ['阿福', '……']], warn:true },
      third:{ label:'「改做宵夜啦，增進感情。」', lines:[['冼小姐', '好主意～預算你出。'], ['旁白', '全村吃了一頓宵夜，大家都很開心，除了冼小姐的預算表。']], give:() => ({ exp:rwd(10) }), cost:{ buns:12 } } },
    { id:'forms', title:'冼小姐：一式三份', lines:[['阿福', '冼小姐，我想申請一日假。'], ['冼小姐', '當然可以～請填 A 表。A 表要附 B 表副本，B 表要先有 C 表批核，C 表要附 A 表正本。'], ['阿福', '……咁我由邊張開始？'], ['冼小姐', '由你諗清楚嗰陣開始。']],
      q:'怎樣才拿得到這一天假？', smart:{ label:'「我填 D 表：申請豁免填表。」', lines:[['冼小姐', 'D 表？我哋冇 D 表。'], ['阿福', '冇 D 表，即係冇規定唔准。'], ['冼小姐', '（揭咗好耐手冊，蓋印）……批。下年我會加 D 表。']], give:() => ({ buns:rwd(15) }) },
      dumb:{ label:'「我逐張填。」', lines:[['旁白', '阿福填了三天三夜，填到第三張才發現：需要第一張的正本，而正本附在第三張上。'], ['冼小姐', '表格有錯，駁回～']], slow:true } },
    { id:'happy', title:'冼小姐：快樂指數', lines:[['冼小姐', '年度員工快樂指數問卷！一至十分，低過七分要強制參加快樂工作坊。'], ['冼小姐', '溫馨提示：十分屬於異常。異常要寫報告，解釋點解咁開心。']],
      q:'你填幾分？', smart:{ label:'七分', lines:[['冼小姐', '七分，標準。你係一個非常正常嘅員工。'], ['阿福', '多謝。'], ['冼小姐', '正常員工下年冇加薪，因為你已經夠快樂～']], give:() => ({ coins:rwd(12) }) },
      dumb:{ label:'三分', lines:[['冼小姐', '好～快樂工作坊逢星期六朝早九點。'], ['阿福', '我哋夜晚先出得嚟。'], ['冼小姐', '所以要早啲出門呀～']], warn:true },
      third:{ label:'十分', lines:[['冼小姐', '十分？好可疑。請寫一千字報告，解釋你點解咁開心。'], ['阿福', '寫完我就唔開心喇。'], ['冼小姐', '咁就啱喇～']], slow:true } },
    { id:'notice', title:'冼小姐：病假通告', lines:[['冼小姐', '溫馨提示～新通告：由今日起，請病假要提早三日通知。'], ['阿福', '我上次請病假，你哋未批，我就直接放咗永久嗰種。'], ['冼小姐', '所以先要提早通知呀，親愛嘅同事～'], ['冼小姐', '另外，你三年前申請嘅年假，今日批咗。請注意：放假期間，請保持電話暢通。']],
      q:'冼小姐要大家遵守新通告。', smart:{ label:'「好。我禮拜五會病，病因未知。」', lines:[['冼小姐', '……（望住板夾好耐）'], ['冼小姐', '呢份通告，一個鐘之後收回。']], give:() => ({ coins:rwd(15) }) },
      dumb:{ label:'「收到。」', lines:[['冼小姐', '好乖～三日之後，記得準時病。'], ['旁白', '三天後，阿福忘了病。']], warn:true } },
    { id:'toilet', title:'冼小姐：廁所計時器', lines:[['冼小姐', '新政策！村口茅廁裝咗計時器，每次唔准超過十五分鐘，超時自動 email 龐總。'], ['阿福', '我生前加班到半夜，冇人幫我計時。去個廁所，就有人計。'], ['冼小姐', '所以話公司好關心你呀～']],
      q:'冼小姐要你簽名確認新政策。', smart:{ label:'「你哋規定唔准超過十五分鐘，冇規定死喺入面點計。」', lines:[['冼小姐', '（揭手冊）……死喺入面……'], ['冼小姐', '手冊冇寫。（蓋印）呢條，下年先加。'], ['旁白', '計時器暫停使用。門上貼著：「故障，請勿使用」。其實沒有故障，裡面有人。']], give:() => ({ exp:rwd(8) }) },
      dumb:{ label:'「好，我簽。」', lines:[['旁白', '計時器每十五分鐘響一次，全村的鬼在茅廁門口排起長龍。']], slow:true } },
    { id:'cctv', title:'冼小姐 × Bryan：舉報', team:true, lines:[['冼小姐', '阿福，有同事舉報你上班時間玩手機，有相為證。'], ['Bryan', '我都唔想㗎，兄弟。不過公司利益行先。'], ['阿福', '張相係邊個影㗎？'], ['Bryan', '……一位熱心同事。']],
      q:'冼小姐要發警告信給你。', smart:{ label:'「調 CCTV 睇吓。」', lines:[['旁白', 'CCTV：Bryan 在辦公室運了一整天球，中途停下來拍了阿福一張照片，然後繼續運球。'], ['冼小姐', '……Bryan，你上班時間打波。'], ['Bryan', '嗰個係 team-building 嚟㗎！'], ['冼小姐', 'Team-building 要預先申請～（蓋印）警告信。'], ['Bryan', '……兄弟，呢球算你入。']], give:() => ({ coins:rwd(18) }), arc:true },
      dumb:{ label:'「認咗佢，算數。」', lines:[['Bryan', '好隊友！我會記住你嘅犧牲。'], ['旁白', '他不會。']], warn:true } },
  ];
  function hrEvent(force) {
    const a = st(), h = a.hr; h.visits++;
    const pool = HR_EV.filter(e => !e.team || (a.rival.met && !a.rival.beaten && a.rival.arc >= 2 && seen('ch4_end') && art(ART.rival)));
    let e = force ? HR_EV.find(x => x.id === force) : null;
    if (!e) { const fresh = pool.filter(x => !h.done[x.id]); if (!fresh.length) h.done = {}; const p2 = fresh.length ? fresh : pool; e = p2[Math.floor(R() * p2.length)]; }
    h.done[e.id] = 1;
    const intro = h.met ? [] : HR_INTRO; h.met = true;
    const cast = [['阿福', 'afu'], ['冼小姐', ART.hr]]; if (e.team) cast.push(['Bryan', ART.rival]);
    const mk = (o) => o && { label:o.label + (o.cost ? `（壽包 ${rwd(o.cost.buns)}）` : ''), disabled:o.cost ? S.res.buns < rwd(o.cost.buns) : false, lines:o.lines, on:() => {
      let out = [];
      if (o.cost) S.res.buns -= rwd(o.cost.buns);
      if (o.give) out.push(['旁白', `出了一口氣：${give(o.give())}`]);
      if (o.warn) out = warn(out);
      if (o.slow) { a.boss.slowUntil = Math.max(a.boss.slowUntil, now() + 4 * 60000); out.push(['旁白', '懲罰：全村陪你處理文件，工作速度 −15%（4 分鐘）']); }
      if (o.arc) a.rival.arc++;
      return out; } };
    const sA = R() < 0.5, opts = [mk(e.smart), mk(e.dumb)]; if (!sA) opts.reverse();
    const choice = { plain:true, q:e.q, a:opts[0], b:opts[1] }; if (e.third) choice.c = mk(e.third);
    play({ tag:'HR', title:e.title, bg:'village', cast, lines:intro.concat(e.lines), choice }, () => done());
  }

  // ===================== 排程 =====================
  function tick() { // Skits.tick 每秒（安靜＋有操作時）呼叫；回傳 true = 今次出咗場
    const a = st(); if (!a || !seen('ch1_end')) return false;
    a.clock++; a.gap++;
    const b = a.boss, r = a.rival;
    if (b.task && a.gap >= REVIEW_GAP && art(ART.boss)) { const p = taskProg(); if (p.v >= p.n || p.left <= 0) { a.gap = 0; bossReview(); return true; } }
    if (r.pend && !r.beaten && a.gap >= 25 && art(ART.rival)) { a.gap = 0; rivalTheft(); return true; }
    if (a.gap < GAP || R() > 1 / 90) return false;
    const opts = [];
    if (!b.task && art(ART.boss)) opts.push([3, bossVisit]);
    if (!b.group && b.visits >= 2 && seen('gift_phone')) opts.push([3, bossGroup]);
    if (!r.beaten && r.met && seen('ch2_end') && !(r.rumor && r.rumor.until > now()) && a.clock > r.peaceUntil && art(ART.rival)) opts.push([1.5 + r.grudge, rivalGossip]);
    if (!r.beaten && r.arc >= 3 && seen('ch5_end') && art(ART.rival)) opts.push([4, rivalShowdown]);
    if (seen('ch2_end') && art(ART.hr)) opts.push([2.5, () => hrEvent()]);
    if (!opts.length) return false;
    let tot = 0; for (const o of opts) tot += o[0]; let x = R() * tot; let f = opts[opts.length - 1][1]; for (const o of opts) { if ((x -= o[0]) <= 0) { f = o[1]; break; } }
    a.gap = 0; if (f() === false) return false; return true;
  }
  // 完成任務／首次通關：Bryan 有機會嚟搶功
  function credit(what) {
    const a = st(); if (!a || !seen('ch1_end')) return; const r = a.rival;
    if (r.beaten || r.pend || a.clock < r.peaceUntil) return;
    if (R() < (r.met ? 0.3 : 0.6)) r.pend = { what };
  }
  function init() {
    if (typeof Quest !== 'undefined' && Quest.complete) { const oc = Quest.complete; Quest.complete = function () { const q = Quest.cur && Quest.cur(); const r = oc.apply(this, arguments); try { if (q) credit(q.text); } catch (e) {} return r; }; }
    let lastCleared = -1;
    setInterval(() => { // 首次通關（包括野鬼戰）
      if (typeof S === 'undefined' || !S || !S.cleared) return; const n = Object.keys(S.cleared).length;
      if (lastCleared >= 0 && n > lastCleared && !Battle.active) credit('打通新關卡'); if (!Battle.active) lastCleared = n; hud();
    }, 1000);
  }
  // ---------- 左下角小牌：KPI 進度、謠言、懲罰剩幾耐 ----------
  function hud() {
    const wrap = document.getElementById('stagewrap'); if (!wrap || typeof S === 'undefined' || !S) return;
    let el = document.getElementById('antag-chip');
    const a = S.antag; const rows = [];
    if (a && a.boss.task) { const p = taskProg(); rows.push(`<b>龐總 KPI</b> ${a.boss.task.what} ${Math.min(p.v, p.n)}/${p.n}　⏱${Math.floor(p.left / 60)}:${String(p.left % 60).padStart(2, '0')}`); }
    if (a && a.rival.rumor && a.rival.rumor.until > now()) rows.push(`<b>謠言</b> ${a.rival.rumor.name}工作速度減半　${mins(a.rival.rumor.until - now())} 分鐘`);
    if (a && a.boss.slowUntil > now()) rows.push(`<b>懲罰</b> 全村工作速度 −15%　${mins(a.boss.slowUntil - now())} 分鐘`);
    if (!rows.length) { if (el) el.remove(); return; }
    if (!el) { el = document.createElement('div'); el.id = 'antag-chip'; wrap.appendChild(el); el.onclick = () => toast('龐總 KPI：時限內達標有獎勵，未達標有輕微懲罰。時限只計算你在村子裡遊玩的時間。<br>謠言：8 分鐘後自行消散。'); }
    const h = rows.join('<br>'); if (el.innerHTML !== h) el.innerHTML = h;
  }
  (function css() {
    const s = document.createElement('style');
    s.textContent = '#antag-chip{position:absolute;left:8px;bottom:8px;z-index:4;max-width:78%;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13.5px;line-height:1.5;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45)}#antag-chip b{color:#ff8a6a;margin-right:4px}';
    document.head.appendChild(s);
  })();
  init();
  // 示範頁／測試用
  function demo(kind) {
    const a = st();
    if (kind === 'boss') { a.boss.task = null; a.n.absurd = 0; const o = Math.random; Math.random = () => 0.9; try { bossVisit(); } finally { Math.random = o; } }
    else if (kind === 'absurd') { a.boss.visits = Math.max(1, a.boss.visits); const o = Math.random; let i = 0; Math.random = () => (i++ === 0 ? 0.1 : 0.5); try { bossVisit(); } finally { Math.random = o; } }
    else if (kind === 'group') bossGroup();
    else if (kind === 'review') { if (!a.boss.task) { const T = TASKS.chop; a.boss.task = { k:'chop', n:3, base:T.val() - 1, due:a.clock, set:a.clock, what:T.what, unit:T.unit }; } bossReview(); }
    else if (kind === 'theft') { a.rival.pend = { what:'砍倒 3 棵槐樹' }; rivalTheft(); }
    else if (kind === 'gossip') { a.rival.met = true; if (!rivalGossip()) toast('要先派一隻鬼到崗位工作，Bryan 才有造謠對象。'); }
    else if (kind === 'showdown') { a.rival.met = true; rivalShowdown(); }
    else if (kind && kind.indexOf('hr:') === 0) hrEvent(kind.slice(3));
  }
  return { st, tick, credit, hud, demo, taskProg, HR_EV, ABSURD, TASKS, ROUNDS, RUMORS, BRYAN_CLAIM, BOSS_OPEN, BOSS_PASS, BOSS_FAIL, NM, ART };
})();
