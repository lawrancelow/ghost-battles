// ===================== 出村：陰間地圖 =====================
// 從村口牌坊出去，先到這張地圖，再選要去哪裡。
const World = {
  YARD_READY: true, // 亂葬崗推理驗證完成後打開
  // 地圖上的去處：位置（圖的比例）、名稱、怎麼打開、什麼時候開放
  SPOTS: [
    { id:'battle', x:0.48, y:0.20, lx:0.46, ly:0.23, name:'搶地盤', sub:'陽間地盤', go:() => UI.open('battle') },
    { id:'yard', x:0.76, y:0.30, lx:0.73, ly:0.37, name:'亂葬崗', sub:'無名墳', go:() => Graveyard.open(), ready:() => typeof Graveyard !== 'undefined' && World.YARD_READY },
    { id:'street', x:0.20, y:0.38, lx:0.17, ly:0.50, name:'冥街夜市', sub:'下班後的陰間', go:() => GhostStreet.open(), ready:() => typeof GhostStreet !== 'undefined' },
    { id:'station', x:0.34, y:0.66, lx:0.32, ly:0.76, name:'陽間站崗', sub:'派鬼嚇路人', go:() => Street.open(), ready:() => typeof Street !== 'undefined', need:() => S.seen.ch1_end || window.STN_TEST, lock:'打完第一章才開放' },
    { id:'scare', x:0.80, y:0.50, lx:0.79, ly:0.63, name:'回陽間', sub:'夜班嚇人', go:() => Scare.open('office'), need:() => S.seen.ch1_end, lock:'打完第一章才開放' },
    { id:'tower', x:0.60, y:0.80, lx:0.58, ly:0.88, name:'樓裡有鬼', sub:'揀一棟樓嚇到天光', go:() => Tower.open(), ready:() => typeof Tower !== 'undefined', need:() => S.seen.ch1_end || window.STN_TEST, lock:'打完第一章才開放' },
  ],
  // 保留地：之後開發新去處就由呢度補上（換成真嘅 SPOTS 項目）
  RESERVED: 3,
  ICON: { battle:'戰', yard:'墳', street:'市', scare:'嚇', station:'崗' },
  open() {
    let el = $('#world'); if (!el) { el = document.createElement('section'); el.id = 'world'; document.body.appendChild(el); }
    const src = typeof BG_SRC !== 'undefined' && BG_SRC.worldmap ? BG_SRC.worldmap : '';
    let h = `<div class="wm-map" style="background-image:url('${src}')">`;
    for (const s of this.SPOTS) h += `<i class="wm-glow" style="left:${s.x * 100}%;top:${s.y * 100}%"></i>`;
    h += `</div><div class="wm-top"><button class="wm-home" id="wm-home">◀ 回村</button><b>陰間地圖</b><span>揀個去處</span><button class="wm-pol" id="wm-pol">📋 新政策</button></div>`;
    h += `<div class="wm-board"><div class="wm-grid">`;
    for (const s of this.SPOTS) {
      const ready = !s.ready || s.ready(), open = !s.need || s.need();
      const dot = typeof Guide !== 'undefined' && Guide.dot(s.id);
      h += `<button class="wm-card ${ready && open ? '' : 'off'} ${dot ? 'dot' : ''} ${s.id === 'station' ? 'new' : ''}" data-id="${s.id}"><i>${this.ICON[s.id] || '鬼'}</i><b>${s.name}</b><small>${!ready ? '施工中' : !open ? s.lock : s.sub}</small></button>`;
    }
    for (let i = 0; i < this.RESERVED; i++) h += `<button class="wm-card res" data-res="1"><i>？</i><b>保留地</b><small>敬請期待</small></button>`;
    h += `</div></div>`;
    el.innerHTML = h; el.classList.add('on'); Sound.play && Sound.play('click');
    // 村口喺村莊頂部：手指放開時開地圖，瀏覽器跟住嗰下 click 會落喺新出嘅掣度。開咗 0.45 秒內唔收 click
    const t0 = performance.now(), ghost = () => performance.now() - t0 < 450;
    el.querySelectorAll('.wm-card').forEach(b => b.onclick = () => { if (ghost()) return;
      if (b.dataset.res) { Fx.toast('呢塊地仲未開發，遲啲再嚟'); return; }
      const s = this.SPOTS.find(x => x.id === b.dataset.id);
      if (b.classList.contains('off')) { Fx.toast(s.ready && !s.ready() ? `${s.name}還在施工，快好了` : s.lock || ''); return; }
      this.close(); if (typeof Guide !== 'undefined') Guide.visit(s.id); s.go();
    });
    $('#wm-home').onclick = () => { if (!ghost()) this.close(); };
    $('#wm-pol').onclick = () => { if (!ghost() && window.Policy) Policy.announce(); };
    window.Policy && Policy.maybe();
  },
  close() { const el = $('#world'); if (el) { el.classList.remove('on'); el.innerHTML = ''; } UI.refresh && UI.refresh(); },
};
