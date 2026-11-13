// ===================== 出村：陰間地圖 =====================
// 從村口牌坊出去，先到這張地圖，再選要去哪裡。
const World = {
  YARD_READY: true, // 亂葬崗推理驗證完成後打開
  // 地圖上的去處：位置（圖的比例）、名稱、怎麼打開、什麼時候開放
  SPOTS: [
    { id:'battle', x:0.2, y:0.68, lx:0.25, ly:0.745, name:'夜班巡陰', sub:'帶部門巡陰間', go:() => (typeof Patrol !== 'undefined' ? Patrol.openPrep() : UI.open('battle')) },
    { id:'yard', x:0.76, y:0.7, lx:0.79, ly:0.745, name:'亂葬崗', sub:'無名墳', go:() => Graveyard.open(), ready:() => typeof Graveyard !== 'undefined' && World.YARD_READY },
    { id:'street', x:0.22, y:0.53, lx:0.25, ly:0.565, name:'冥街夜市', sub:'下班後的陰間', go:() => GhostStreet.open(), ready:() => typeof GhostStreet !== 'undefined' },
    { id:'station', x:0.8, y:0.52, lx:0.735, ly:0.555, name:'陽間站崗', sub:'派鬼嚇路人', go:() => Street.open(), ready:() => typeof Street !== 'undefined', need:() => S.seen.ch1_end || window.STN_TEST, lock:'打完第一章才開放' },
    { id:'scare', x:0.5, y:0.4, lx:0.5, ly:0.47, name:'回陽間', sub:'夜班嚇人', go:() => Scare.open('office'), need:() => S.seen.ch1_end, lock:'打完第一章才開放' },
    { id:'tower', x:0.22, y:0.24, lx:0.23, ly:0.325, name:'樓裡有鬼', sub:'揀一棟樓嚇到天光', go:() => Tower.open(), ready:() => typeof Tower !== 'undefined', need:() => S.seen.ch1_end || window.STN_TEST, lock:'打完第一章才開放' },
  ],
  // 保留地：之後開發新去處就由呢度補上（換成真嘅 SPOTS 項目）
  RESERVED: 3,
  ICON: { battle:'巡', yard:'墳', street:'市', scare:'嚇', station:'崗' },
  // 保留地喺地圖上嘅位置（霧鎖住嘅地方）
  DESC: { battle:'帶住部門巡陰間：遊魂可以送去投胎，亦可以遞合約收編。主線關卡嘅主管同總監都喺度。', yard:'無名墳一排排，聽清楚邊個講大話。', street:'收工後嘅陰間夜市，食嘢、行街、見老友。', station:'喺陽間地盤擺鬼站崗，嚇走路過嘅人。', scare:'返去陽間返夜班，一間間辦公室嚇過去。', tower:'揀一棟樓，由地下嚇到天台，天光前返陰間。' },
  RES_SPOTS: [ { x:0.78, y:0.27, lx:0.80, ly:0.325 }, { x:0.50, y:0.06, lx:0.50, ly:0.135 }, { x:0.15, y:0.07, lx:0.15, ly:0.135 } ],
  open() {
    document.querySelectorAll('#pol-tip').forEach(e => e.remove()); // 離開玩法返地圖：收起龐總現場提示
    let el = $('#world'); if (!el) { el = document.createElement('section'); el.id = 'world'; document.body.appendChild(el); }
    const src = typeof BG_SRC !== 'undefined' && (BG_SRC.worldmap2 || BG_SRC.worldmap) ? (BG_SRC.worldmap2 || BG_SRC.worldmap) : '';
    let h = `<div class="wm-scroll"><div class="wm-map2"><img class="wm-img" src="${src}" alt="">`;
    // 地標發光＋熱區
    for (const s of this.SPOTS) {
      const ready = !s.ready || s.ready(), open = !s.need || s.need();
      const dot = typeof Guide !== 'undefined' && Guide.dot(s.id);
      h += `<i class="wm-glow ${ready && open ? '' : 'dim'}" style="left:${s.x * 100}%;top:${s.y * 100}%"></i>`;
      h += `<button class="wm-hit" data-for="${s.id}" style="left:${s.x * 100}%;top:${s.y * 100}%" aria-label="${s.name}"></button>`;
      h += `<button class="wm-card wm-tag ${ready && open ? '' : 'off'} ${dot ? 'dot' : ''}" data-id="${s.id}" style="left:${s.lx * 100}%;top:${s.ly * 100}%"><b>${s.name}</b><small>${!ready ? '施工中' : !open ? s.lock : s.sub}</small></button>`;
    }
    this.RES_SPOTS.slice(0, this.RESERVED).forEach((r, i) => {
      h += `<i class="wm-fog" style="left:${r.x * 100}%;top:${r.y * 100}%"></i>`;
      h += `<button class="wm-card wm-tag res" data-res="1" style="left:${r.lx * 100}%;top:${r.ly * 100}%"><b>保留地</b><small>濃霧未散</small></button>`;
    });
    h += `<button class="wm-tag wm-gate" id="wm-gate" style="left:50%;top:88%"><b>落魄村</b><small>返村</small></button>`;
    h += `</div><div class="wm-info" id="wm-info"><p class="wm-hint">撳地圖上嘅木牌，揀今晚去邊度。</p></div></div><div class="wm-top"><button class="wm-home" id="wm-home">◀ 回村</button><b>陰間地圖</b><span>揀個去處</span><button class="wm-pol" id="wm-pol">📋 新政策</button></div>`;
    el.innerHTML = h; el.classList.add('on'); Sound.play && Sound.play('click');
    // 村口喺村莊頂部：手指放開時開地圖，瀏覽器跟住嗰下 click 會落喺新出嘅掣度。開咗 0.45 秒內唔收 click
    const t0 = performance.now(), ghost = () => performance.now() - t0 < 450;
    const go = (b) => { if (ghost()) return;
      if (b.dataset.res) { Fx.toast('呢塊地仲俾濃霧封住，遲啲再嚟'); return; }
      const s = this.SPOTS.find(x => x.id === b.dataset.id);
      if (b.classList.contains('off')) { Fx.toast(s.ready && !s.ready() ? `${s.name}還在施工，快好了` : s.lock || ''); return; }
      this.close(); if (typeof Guide !== 'undefined') Guide.visit(s.id); s.go();
    };
    // 撳一下：揀中（底下出資料＋出發掣）；再撳同一個：直接出發
    const pick = (b) => { if (ghost() || !b) return;
      if (b.classList.contains('sel')) { go(b); return; }
      el.querySelectorAll('.wm-tag.sel').forEach(x => x.classList.remove('sel')); b.classList.add('sel'); Sound.play && Sound.play('click');
      const info = $('#wm-info');
      if (b.dataset.res) { info.innerHTML = `<b>保留地</b><p>呢度仲俾濃霧封住。總部話遲啲會開發，敬請期待。</p>`; return; }
      const s = this.SPOTS.find(x => x.id === b.dataset.id), off = b.classList.contains('off');
      info.innerHTML = `<b>${s.name}</b><small>${s.sub}</small><p>${this.DESC[s.id] || ''}</p>${off ? `<div class="wm-lock">🔒 ${s.ready && !s.ready() ? '施工中' : s.lock || ''}</div>` : `<button class="wm-go" id="wm-go">出發 ▶</button>`}`;
      const g = $('#wm-go'); if (g) g.onclick = () => go(b);
    };
    el.querySelectorAll('.wm-card').forEach(b => b.onclick = () => pick(b));
    el.querySelectorAll('.wm-hit').forEach(b => b.onclick = () => pick(el.querySelector(`.wm-card[data-id="${b.dataset.for}"]`)));
    $('#wm-home').onclick = () => { if (!ghost()) this.close(); };
    $('#wm-gate').onclick = () => { if (!ghost()) this.close(); };
    $('#wm-pol').onclick = () => { if (!ghost() && window.Policy) Policy.announce(); };
    window.Policy && Policy.maybe();
  },
  close() { const el = $('#world'); if (el) { el.classList.remove('on'); el.innerHTML = ''; } UI.refresh && UI.refresh(); },
};
