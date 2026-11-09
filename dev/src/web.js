// ===================== 網址版（GitHub Pages）＋ 下載檔案當啟動器 =====================
// 下載的檔案：打開就把存檔搬到網址版，直接開始玩。網址版：可以加到手機桌面，離線也能玩，更新自動生效。
const GAME_VER = '2026.11.10d';
const WEB_URL = 'https://lawrancelow.github.io/ghost-battles/';
const IS_WEB = /^https?:$/.test(location.protocol) && /github\.io$/.test(location.hostname);
const IS_FILE = !/^https?:$/.test(location.protocol);
const isStandalone = () => { try { return matchMedia('(display-mode: standalone)').matches || navigator.standalone === true; } catch (e) { return false; } };
const IS_IOS = /iphone|ipad|ipod/i.test(navigator.userAgent), IS_SAMSUNG = /SamsungBrowser/i.test(navigator.userAgent);
let BIP = null;
window.addEventListener('beforeinstallprompt', (e) => { e.preventDefault(); BIP = e; });
window.addEventListener('appinstalled', () => { BIP = null; try { localStorage.setItem('gb_inst_seen', '1'); } catch (e) {} Fx.toast('裝好了！以後從手機桌面的「過勞鬼」圖示打開。'); });

const Web = {
  // 回傳 true = 已經接手（搬家或跳轉中），不要再開遊戲
  boot() {
    if (IS_FILE && !navigator.webdriver && !/[?&]local\b/.test(location.search)) return this.launcher();
    return false;
  },
  enc(o) { const b = new TextEncoder().encode(JSON.stringify(o)); let s = ''; for (let i = 0; i < b.length; i += 8192) s += String.fromCharCode.apply(null, b.subarray(i, i + 8192)); return btoa(s); },
  dec(t) { const s = atob(t), b = new Uint8Array(s.length); for (let i = 0; i < s.length; i++) b[i] = s.charCodeAt(i); return JSON.parse(new TextDecoder().decode(b)); },
  overlay(title, html, btns) {
    let el = $('#webov'); if (!el) { el = document.createElement('div'); el.id = 'webov'; document.body.appendChild(el); }
    el.innerHTML = `<div class="wo-box"><img src="${IS_WEB ? 'icon-192.png' : (SPR_SRC.cover || '')}" alt="" class="wo-ic"><h3>${title}</h3><div class="wo-b">${html}</div><div class="wo-btns">${(btns || []).map((b, i) => `<button class="btn ${i === 0 ? 'gold' : 'ghost'} wide" data-i="${i}">${b[0]}</button>`).join('')}</div></div>`;
    el.classList.add('on');
    el.querySelectorAll('[data-i]').forEach(b => b.onclick = () => { const f = btns[+b.dataset.i][1]; el.classList.remove('on'); f && f(); });
  },
  launcher() {
    let raw = null, moved = false; try { raw = localStorage.getItem(SAVE_KEY); moved = !!localStorage.getItem('gb_moved'); } catch (e) {}
    if (navigator.onLine === false) {
      if (moved) { this.overlay('需要網絡', '<p>你的進度已經搬到網址版了。</p><p>請連上網絡再打開這個檔案，或者從手機桌面的「過勞鬼」圖示打開（沒網絡也能玩）。</p>', []); return true; }
      return false; // 沒搬過又沒網絡：先在這裡玩
    }
    this.overlay(raw && !moved ? '過勞鬼搬家中' : '過勞鬼大作戰', raw && !moved ? '<p>你的鬼村和全部進度，正在搬到網址版……</p><p class="wo-s">以後我更新遊戲，你不用再下載。</p>' : '<p>正在打開網址版……</p>', []);
    // 先確定網址版打得開，才搬；打不開就留在這個檔案照常玩
    const ctl = typeof AbortController !== 'undefined' ? new AbortController() : null; const tm = setTimeout(() => ctl && ctl.abort(), 6000);
    fetch(WEB_URL + 'manifest.webmanifest?t=' + Date.now(), { cache:'no-store', signal:ctl && ctl.signal }).then(r => r.ok ? r.json() : Promise.reject()).then(m => {
      clearTimeout(tm); if (!m || !/過勞鬼/.test(m.name || '')) throw 0;
      if (raw && !moved) { try { localStorage.setItem('gb_moved', '1'); } catch (e) {} location.href = WEB_URL + '#save=' + encodeURIComponent(this.enc(JSON.parse(raw))); }
      else { try { location.replace(WEB_URL); } catch (e) { location.href = WEB_URL; } }
    }).catch(() => { clearTimeout(tm); $('#webov') && $('#webov').classList.remove('on'); this.local = true; (typeof SPR_READY !== 'undefined' ? SPR_READY : Promise.resolve()).then(startGame, startGame); });
    return true;
  },
  // 網址版：收到 #save= 就把存檔搬進來
  receive(done) {
    const h = location.hash || ''; if (!IS_WEB || !h.startsWith('#save=')) return done();
    history.replaceState(null, '', location.pathname + location.search);
    let o = null; try { o = this.dec(decodeURIComponent(h.slice(6))); } catch (e) { Fx.toast('搬家失敗：存檔讀不出來'); return done(); }
    const put = () => { try { localStorage.setItem(SAVE_KEY, JSON.stringify(o)); localStorage.setItem('gb_justmoved', '1'); } catch (e) { Fx.toast('存不進去：手機空間不夠'); } done(); };
    let cur = null; try { cur = localStorage.getItem(SAVE_KEY); } catch (e) {}
    if (!cur) return put();
    let c = null; try { c = JSON.parse(cur); } catch (e) {}
    if (c && (c.last || 0) >= (o.last || 0)) { done(); return; } // 這裡的進度比較新，就不蓋掉
    this.overlay('搬家', `<p>要把下載版的進度（主公 ${o.lv || 1} 級）搬進來嗎？</p><p><b>這裡現在的進度（主公 ${(c && c.lv) || 1} 級）會被取代。</b></p>`, [['搬進來', put], ['不要，留著這裡的', done]]);
  },
  init() {
    if (!IS_WEB) return;
    try { if ('serviceWorker' in navigator) navigator.serviceWorker.register('sw.js').catch(() => {}); } catch (e) {}
    try {
      const v = localStorage.getItem('gb_ver'); if (v && v !== GAME_VER) setTimeout(() => Fx.toast('遊戲已經自動更新到新版本 ✨'), 1800);
      localStorage.setItem('gb_ver', GAME_VER);
      if (localStorage.getItem('gb_justmoved')) { localStorage.removeItem('gb_justmoved'); setTimeout(() => this.installGuide(true), 600); return; }
    } catch (e) {}
    let seen = false; try { seen = !!localStorage.getItem('gb_inst_seen'); } catch (e) {}
    if (!seen && !isStandalone() && !navigator.webdriver) setTimeout(() => this.installGuide(false), 900);
  },
  steps() { return IS_IOS ? ['按下方「分享」', '選「加入主畫面」', '按「新增」'] : IS_SAMSUNG ? ['按下方「≡」', '選「加至 → 主屏幕」', '按「添加」'] : ['按右上角「⋮」', '選「加到主畫面」', '按「安裝」']; },
  installGuide(moved) {
    if (isStandalone()) { if (moved) Fx.toast('搬家完成，進度全部都在！'); return; }
    try { localStorage.setItem('gb_inst_seen', '1'); } catch (e) {}
    const top = moved ? '<p><b>搬家完成！</b>進度全部都在。</p>' : '';
    const how = BIP ? '<p>按下面的按鈕，就能把過勞鬼放到手機桌面。</p>' : `<ol class="wo-steps">${this.steps().map(s => `<li>${s}</li>`).join('')}</ol>`;
    this.overlay('放到手機桌面', `${top}<p>點桌面圖示就能玩，像 App 一樣；沒網絡也能玩，我更新了也會自動換成新版。</p>${how}`,
      BIP ? [['一鍵安裝到桌面', () => { const p = BIP; BIP = null; p.prompt(); }], ['以後再說', null]] : [['知道了', null]]);
  },
};
