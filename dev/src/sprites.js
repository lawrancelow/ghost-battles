// ===================== 蠟筆畫素材載入（帮手 A）=====================
const SPR = {};
const SPR_READY = (() => {
  const jobs = [];
  const load = (key, src) => {
    const img = new Image(); img.src = src; SPR[key] = img;
    jobs.push(new Promise(res => {
      const ok = () => { img._ok = true; res(); };
      if (img.decode) img.decode().then(ok, () => { img.onload = ok; img.onerror = () => res(); if (img.complete && img.naturalWidth) ok(); });
      else { img.onload = ok; img.onerror = () => res(); }
    }));
  };
  if (typeof SPR_SRC !== 'undefined') for (const k in SPR_SRC) load(k, SPR_SRC[k]);
  if (typeof BG_SRC !== 'undefined') for (const k in BG_SRC) load('bg_' + k, BG_SRC[k]);
  return Promise.all(jobs);
})();
function sprOk(k) { const i = SPR[k]; return !!(i && (i._ok || (i.complete && i.naturalWidth))); }
