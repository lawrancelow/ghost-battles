// ===================== 新政策發佈會（policy.js）=====================
// 龐總喺陰間集團總部發佈《陽間業務拓展計劃》：①陽間站崗 ②樓裡有鬼。
// 演出：用 Theater.play（同 rivals.js 龐總察 KPI 一樣），角色原圖 npc_kpiboss（龐總）、afu（阿福），動作 ag:inspect / ag:tap / ag:yell / ag:sigh。
// 每講完一條，返去陰間地圖，用外框發光＋箭咀指住對應嘅卡（唔遮卡），對白框放喺卡上面唔遮位。
// Policy.maybe()：打完第一章（或 STN_TEST）第一次開地圖自動上演，S.seen.policy_v1。
// Policy.firstEnter('station'|'tower')：第一次入該玩法，龐總喺畫面底部細框講幾句操作重點（S.seen.policy_<mode>）。
const Policy = (() => {
  const BOSS = 'npc_kpiboss';
  const LOOK = { 龐總:{ base:'ag:inspect', talk:'ag:tap' } };
  const cast = () => [['阿福', 'afu'], ['龐總', BOSS, Object.assign({}, LOOK.龐總)]];
  const seen = (k) => !!(typeof S !== 'undefined' && S && S.seen && S.seen[k]);
  function mark(k) { try { S.seen = S.seen || {}; S.seen[k] = true; save(); } catch (e) {} }
  function stage(title, lines, cb) {
    Theater.play({ tag:'新政策', title, bg:'hq', cast:cast(), lines }, () => cb && cb());
  }

  // ---------- 對白（每句只出現一次，兩個角色唔會講同一句）----------
  const A = [
    ['旁白', '陰間集團總部，三樓會議室。投影機風扇嘅聲，大過成個部門。'],
    ['龐總', '各位，今日召開新政策發佈會。我只講一次，重複係浪費 resources。', 'ag:tap'],
    ['阿福', '成間會議室得我一個，你叫「各位」？'],
    ['龐總', '我係對住未來嘅編制講。下季呢度坐唔坐得滿，睇你啲數。'],
    ['龐總', '本集團正式推出《陽間業務拓展計劃》。陰間市場已經飽和，增長要去陽間搵。', 'ag:yell'],
    ['阿福', '講人話啦。'],
    ['龐總', '即係去陽間嚇人。第一條：「陽間站崗」。'],
    ['龐總', '陽間有幾個地盤，我已經 secure 咗位。你派鬼過去企位，路人行過就嚇佢。'],
    ['阿福', '企邊度有冇得揀㗎？'],
    ['龐總', '睇格仔。咩類型嘅格，就擺咩鬼。擺錯位，叫做資源錯配。'],
    ['阿福', '咁我啲小鬼，可唔可以一隻擺幾次？'],
    ['龐總', '普通鬼大把，重複擺冇問題。有名有姓嗰啲就唔同，一張地圖最多三隻，仲可以同設備勵鬼加持——物以罕為貴。'],
    ['阿福', '即係佢哋人工高啲？'],
    ['龐總', '即係佢哋要求多啲。另外，鬼嚇人會儲能量，儲滿就放大招，一嚇嚇一堆。呢個叫規模效應。', 'ag:tap'],
    ['阿福', '嚇完一間房，咪收得工囉？'],
    ['龐總', '收工？嚇得夠多，地圖會延伸，第二間、第三間房陸續開放。業務係要擴張嘅。'],
    ['龐總', '（指住窗外塊地圖）自己望吓。'],
  ];
  const A_MAP = [['龐總', '就係呢張卡：陽間站崗。'], ['阿福', '個框閃到咁，想睇唔到都難。']];
  const B = [
    ['龐總', '第二條：「樓裡有鬼」。呢條係我哋嘅 premium 產品線。', 'ag:tap'],
    ['阿福', '又 premium？上次 premium 係加班冇補水。'],
    ['龐總', '你揀一棟樓，組屋又得，老店屋又得，由地下開始，一層一層向上嚇住戶。'],
    ['阿福', '由下而上，好似升職咁喎。'],
    ['龐總', '升職係由上而下指派嘅，唔好亂比喻。重點：鬼要企定先出得手，郁緊嘅鬼嚇唔到人。', 'ag:sigh'],
    ['阿福', '同返工一樣，要坐定定扮忙。'],
    ['龐總', '仲有，見到門口有門神，或者貼住紅紙符，一律繞路。'],
    ['阿福', '唔可以硬闖？'],
    ['龐總', '唔可以。門神係守住戶嘅，神明要尊重。呢條係公司紅線，唔係 KPI，冇得 negotiate。'],
    ['阿福', '難得你都有一樣嘢係尊重嘅。'],
    ['龐總', '最後，開工時間係子時到寅時。天光之前，一定要返到陰間。'],
    ['阿福', '遲咗會點？'],
    ['龐總', '遲咗你就變晨運阿伯嘅話題。公司唔會幫你報工傷。', 'ag:yell'],
  ];
  const B_MAP = [['龐總', '呢張就係樓裡有鬼。揀棟樓，由地下嚇上去。'], ['阿福', '睇落層數唔少喎……']];
  const C = [
    ['龐總', '總結：兩條產品線同步推進。本季 KPI，陽間嚇人數字要按月增長。', 'ag:tap'],
    ['阿福', '增長幾多？'],
    ['龐總', '比上個月多。上個月係零，所以你做幾多都算增長——呢個就係領導藝術。'],
    ['阿福', '……你第一次講咗句對我有著數嘅嘢。'],
    ['龐總', '唔好誤會。下個月嘅 baseline，就係你今個月嘅數字。散會。', 'ag:sigh'],
    ['旁白', '投影機熄咗。風扇聲仲響緊。'],
  ];
  const TIPS = {
    station:[
      '站崗守則第一條：橙色格係路崗，放鬼拉腳、鬼打牆、卡到陰；紫色格貼牆，放驚嚇、氛圍、投擲。',
      '鬼打牆一圍，路人原地兜圈搵唔到路；佢哋合力衝破咗，要等佢重新圍返。',
      '升級要冥幣，唔夠錢個掣會灰咗。回靈速度愈快，出手愈密。',
      '雜鬼或者名鬼可以幫設備勵鬼加持，名鬼加持最勁。',
      '紙皮箱、手推車會擋住視線；保安阿伯嘅電筒會照停你啲設備，小心佢。',
    ],
    tower:[
      '由地下開始，一層一層向上嚇，唔好跳級。',
      '鬼企定咗先出得手，郁緊嘅唔計數。',
      '見到門神同紅紙符就繞路——神明要尊重，唔准亂嚟。',
      '子時開工，寅時前一定要返陰間，天光就遲。',
    ],
  };

  // ---------- 外觀 ----------
  (function css() {
    if (document.getElementById('pol-css')) return;
    const s = document.createElement('style'); s.id = 'pol-css';
    s.textContent = `
.wm-pol{margin-left:auto;flex:none;padding:6px 10px;border-radius:10px;border:2px solid #6b3b1f;background:rgba(248,232,196,.95);color:#3a2212;font-family:inherit;font-size:14px;font-weight:700;box-shadow:0 3px 10px rgba(0,0,0,.45);white-space:nowrap}
#pol-ov{position:absolute;inset:0;z-index:50;background:rgba(10,8,14,.25)}
#pol-ov .pol-ring{position:absolute;border-radius:18px;pointer-events:none;box-shadow:0 0 0 3px #ffd36a,0 0 18px 6px rgba(255,200,90,.85);animation:polPulse 1.1s ease-in-out infinite}
@keyframes polPulse{50%{box-shadow:0 0 0 3px #fff1b8,0 0 28px 10px rgba(255,210,110,.95)}}
#pol-ov .pol-arr{position:absolute;width:0;height:0;margin-left:-10px;border:10px solid transparent;border-top:13px solid #ffd36a;border-bottom:0;filter:drop-shadow(0 2px 3px rgba(0,0,0,.6));pointer-events:none;animation:polBob .8s ease-in-out infinite}
@keyframes polBob{50%{transform:translateY(6px)}}
.pol-box{position:absolute;left:16px;right:16px;padding:10px 14px 12px;background:#f6ecd2;color:#2a1a10;border-radius:14px;box-shadow:0 0 0 2px #3a2a1a,0 6px 16px rgba(0,0,0,.55);font-size:18px;line-height:1.5;font-weight:700;overflow-wrap:anywhere}
.pol-box b{display:block;font-family:var(--serif);font-size:14px;font-weight:900;color:var(--cinnabar,#b0302a);margin-bottom:2px;letter-spacing:1px}
.pol-box small{display:block;text-align:right;font-size:12px;font-weight:400;color:#8a6a4a;margin-top:2px}
#pol-tip{position:fixed;z-index:100050;bottom:calc(env(safe-area-inset-bottom) + 10px);font-size:16px;padding:8px 12px 9px;background:rgba(246,236,210,.96);cursor:pointer}
`;
    document.head.appendChild(s);
  })();

  // ---------- 喺地圖上指住張卡（外框發光＋箭咀，唔遮卡）----------
  function point(id, lines, cb) {
    const wm = document.getElementById('world'), card = wm && wm.querySelector(`.wm-card[data-id="${id}"]`);
    if (!card) { cb(); return; }
    try { card.scrollIntoView({ block:'nearest' }); } catch (e) {}
    const host = document.getElementById('app') || document.body;
    let ov = document.getElementById('pol-ov'); if (ov) ov.remove();
    ov = document.createElement('div'); ov.id = 'pol-ov'; host.appendChild(ov);
    const hr = ov.getBoundingClientRect(), r = card.getBoundingClientRect();
    const x = r.left - hr.left, y = r.top - hr.top, pad = 5;
    ov.innerHTML = `<i class="pol-ring" style="left:${x - pad}px;top:${y - pad}px;width:${r.width + pad * 2}px;height:${r.height + pad * 2}px"></i>
      <i class="pol-arr" style="left:${x + r.width / 2}px;top:${y - pad - 14}px"></i><div class="pol-box"><b></b><span></span><small>撳一下繼續 ▸</small></div>`;
    const box = ov.querySelector('.pol-box');
    let i = 0;
    const show = () => {
      const [w, t] = lines[i]; box.querySelector('b').textContent = w; box.querySelector('span').textContent = typeof L === 'function' ? L(t) : t;
      // 對白框放喺箭咀上面；位唔夠就放喺卡下面
      // 對白框放喺卡板上面（地圖位），唔遮任何卡；位唔夠先放喺卡下面
      const bd = wm.querySelector('.wm-board'), bt = bd ? bd.getBoundingClientRect().top - hr.top : y - pad - 30;
      const bh = box.offsetHeight, above = Math.min(bt, y - pad - 20) - bh - 8;
      if (above >= 56) { box.style.top = above + 'px'; box.style.bottom = ''; }
      else { box.style.top = (y + r.height + pad + 12) + 'px'; }
    };
    show();
    const t0 = performance.now();
    ov.onclick = (e) => { e.stopPropagation(); if (performance.now() - t0 < 350) return; Sound.play && Sound.play('click');
      if (++i < lines.length) show(); else { ov.remove(); cb(); } };
  }

  let busy = false;
  function announce() {
    if (busy || typeof Theater === 'undefined') return; busy = true;
    const end = () => { busy = false; };
    const hasTower = () => !!document.querySelector('#world .wm-card[data-id="tower"]');
    stage('新政策發佈會', A, () => point('station', A_MAP, () => {
      const b = hasTower() ? B.concat([['龐總', '地圖上面有張新卡，自己搵。']]) : B;
      stage('《陽間業務拓展計劃》', b, () => point('tower', B_MAP, () => stage('KPI', C, end)));
    }));
  }
  function maybe() {
    try {
      if (typeof S === 'undefined' || !S || !S.seen) return;
      if (!(S.seen.ch1_end || window.STN_TEST) || S.seen.policy_v1) return;
      mark('policy_v1');
      setTimeout(() => { if (document.querySelector('#world.on') && !(Theater.on)) announce(); }, 600);
    } catch (e) {}
  }

  // ---------- 第一次入玩法：底部細框 ----------
  function firstEnter(mode) {
    try {
      const k = 'policy_' + mode, tips = TIPS[mode]; if (!tips || seen(k)) return; mark(k);
      setTimeout(() => {
        let el = document.getElementById('pol-tip'); if (el) el.remove();
        el = document.createElement('div'); el.id = 'pol-tip'; el.className = 'pol-box';
        document.body.appendChild(el);
        let i = 0;
        const show = () => { el.innerHTML = `<b>龐總（${i + 1}/${tips.length}）</b><span></span><small>撳一下${i + 1 < tips.length ? '下一句' : '收埋'} ▸</small>`;
          el.querySelector('span').textContent = typeof L === 'function' ? L(tips[i]) : tips[i]; };
        show();
        el.onclick = (e) => { e.stopPropagation(); Sound.play && Sound.play('click'); if (++i < tips.length) show(); else el.remove(); };
        // 樓裡有鬼：一撳遊戲其他地方（例如揀樓開局）就收起提示，唔遮住遊戲
        // 所有玩法：一撳提示以外嘅地方就收起，唔遮住遊戲（之前站崗提示會一直留喺畫面，連村入面「派人」都撳唔到）
        const off = (ev) => { if (!document.body.contains(el)) { document.removeEventListener('pointerdown', off, true); return; } if (!el.contains(ev.target)) { el.remove(); document.removeEventListener('pointerdown', off, true); } }; document.addEventListener('pointerdown', off, true);
        // 離開咗嗰個玩法（畫面收埋）就即刻收起提示
        const ROOTS = { station: '#st-street', tower: '#tw-root' };
        const wt = setInterval(() => { if (!document.body.contains(el)) { clearInterval(wt); return; } const r = document.querySelector(ROOTS[mode] || '#none'); const vis = r && r.classList.contains('on') && getComputedStyle(r).display !== 'none'; if (!vis) { el.remove(); clearInterval(wt); } }, 400);
      }, 500);
    } catch (e) {}
  }
  return { announce, maybe, firstEnter, TIPS };
})();
window.Policy = Policy;
