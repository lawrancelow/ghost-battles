// ===== 鬼力（GP）：全遊戲統一嘅鬼能力計法 =====
// 村入面嘅成長（等級 F.glv、三圍 F.stat、訓練班嚇功 Rework.drillLv）→ 一個數「鬼力」同一個倍率「mul」。
// 所有玩法（主線戰鬥、陽間站崗、樓裡有鬼、入屋……）都經呢度攞能力，所以喺村升級，出面即刻變強。
//   GP.pow(g)      鬼力（整數，介面顯示用）
//   GP.mul(g)      能力倍率：一隻 1 級、嚇功 1 級嘅普通名鬼 ≈ 1.0；40 級＋嚇功 5 ≈ 2.9
//   GP.best(k)     村入面同種（k）鬼力最高嗰隻；冇就 null
//   GP.kindMul(k)  同種最強嗰隻嘅倍率；未招募就 GP.NONE（0.7，見習水平）
//   GP.hint(need)  打唔過時嘅提示字（返村升級）
// ---- 以下係各玩法接駁用（gpower 第二版加）----
//   GP.grow(g)     「同一隻鬼相對佢自己 1 級、嚇功 1」嘅成長倍率：1 級 = 1.0，17 級 ≈ 1.5，40 級 ≈ 2.06，40 級＋嚇功 5 ≈ 2.9
//                  （本身已經按品種分強弱嘅玩法用呢個，1 級手感完全唔變；冇品種差異嘅玩法用 mul）
//   GP.kindGrow(k) 同種最強嗰隻嘅 grow；未招募 = 1
//   GP.drillMul(k) 嚇功帶嚟嘅倍率（嚇功 1 = 1.0，嚇功 5 ≈ 1.42）—— 主線戰鬥用（三圍已經跟等級，嚇功之前只影響嚇法）
//   GP.top(n)      村入面最強 n 隻（唔計阿福）嘅平均鬼力
//   GP.avg(list)   一班鬼嘅平均鬼力
//   GP.stageNeed(st, sid) 主線／野鬼關卡建議鬼力（按自動戰鬥模擬校準，見下面 STAGE_NEED）
//   GP.turfNeed(lv)       陽間站崗：路人膽量 Lv → 建議鬼力
//   GP.tag(have, need)    「鬼力 X／建議 Y」嘅 HTML（唔夠紅字）
//   GP.failHTML(have, need) / GP.bindBack(root, before)   打唔過提示框＋「返村升級」掣
//   GP.goVillage(before)  關晒出面嘅畫面，直接打開村入面嘅鬼怪名冊（升級頁）
const GP = (() => {
  const REF = 45, NONE = 0.7, MIN = 0.6, MAX = 3.2;
  const ok = (x) => typeof x !== 'undefined';
  const T = (yue, zh) => { try { if (ok(LANG) && zh) LANG.add({ [yue]:zh }); return ok(L) ? L(yue) : yue; } catch (e) { return yue; } }; // [粵, 繁中]
  function drill(k) { try { return (ok(Rework) && Rework.drillLv) ? (Rework.drillLv(k) || 1) : 1; } catch (e) { return 1; } }
  function stats(g) {
    try { if (ok(F) && g && g.st) return [0, 1, 2].map(i => F.stat(g, i)); } catch (e) {}
    try { const d = (ok(GHOSTS) && GHOSTS[g.k]) || (ok(FODDER) && FODDER[g.k]); const lv = (ok(F) ? F.glv(g) : g.lv) || 1; if (d && d.base) return d.base.map(v => Math.round(v * (1 + 0.06 * (lv - 1)))); } catch (e) {}
    return [30, 30, 30];
  }
  function base(g) { // 1 級、嚇功 1 嘅三圍平均
    try { const s = g.st || ((ok(GHOSTS) && GHOSTS[g.k]) || (ok(FODDER) && FODDER[g.k]) || {}).base; if (s && s.length) return (s[0] + s[1] + s[2]) / 3; } catch (e) {}
    return 30;
  }
  function raw(g) { if (!g) return 0; const s = stats(g); return ((s[0] + s[1] + s[2]) / 3) * (1 + 0.2 * (drill(g.k) - 1)); }
  function pow(g) { return Math.round(raw(g) * 10); }
  function mul(g) { if (!g) return NONE; const m = Math.pow(raw(g) / REF, 0.6); return Math.max(MIN, Math.min(MAX, isFinite(m) ? m : 1)); }
  function grow(g) { if (!g) return 1; const m = Math.pow(raw(g) / Math.max(1, base(g)), 0.6); return Math.max(1, Math.min(MAX, isFinite(m) ? m : 1)); }
  function drillMul(k) { return Math.pow(1 + 0.2 * (drill(k) - 1), 0.6); }
  function best(k) { try { if (!ok(S) || !S.ghosts) return null; let b = null, bv = -1; for (const g of S.ghosts) if (g && g.k === k) { const v = raw(g); if (v > bv) { bv = v; b = g; } } return b; } catch (e) { return null; } }
  function kindMul(k) { const g = best(k); return g ? mul(g) : NONE; }
  function kindPow(k) { const g = best(k); return g ? pow(g) : 0; }
  function kindGrow(k) { const g = best(k); return g ? grow(g) : 1; }
  function avg(list) { const a = (list || []).filter(Boolean); return a.length ? Math.round(a.reduce((s, g) => s + pow(g), 0) / a.length) : 0; }
  function top(n) { try { const a = S.ghosts.filter(g => g && g.k !== 'afu').map(pow).sort((x, y) => y - x).slice(0, n || 3); return a.length ? Math.round(a.reduce((s, v) => s + v, 0) / a.length) : 0; } catch (e) { return 0; } }
  // 主線關卡建議鬼力：用自動戰鬥（冇軍師、4 隊陰兵、主公等級 = 該關要求）模擬，每關搵「三場贏兩場」嘅最低出陣平均鬼力，再 ×0.9（手動放技能、軍師、合體技會好打啲）
  const STAGE_NEED = { '1-1':450, '1-2':470, '1-3':500, '2-1':520, '2-2':540, '2-3':560, '3-1':580, '3-2':680, '3-3':920,
    '4-1':870, '4-2':1070, '4-3':1300, '5-1':870, '5-2':1160, '5-3':1300, '6-1':1500, '6-2':1560, '6-3':1900 };
  function stageNeed(st, sid) { if (sid && STAGE_NEED[sid]) return STAGE_NEED[sid]; const p = (st && st.p) || 1; return Math.round((420 + 50 * Math.max(0, p - 3) * (st && st.boss ? 1.15 : 1)) / 10) * 10; }
  // 陽間站崗：路人膽量 Lv1 = 450（1 級名鬼），Lv10 ≈ 840，Lv24（收益封頂）≈ 1610，之後再慢慢升
  function turfNeed(lv) { const d = Math.max(1, lv || 1); return Math.round(450 * Math.pow(1 + 0.05 * (d - 1), 1 / 0.6) / 10) * 10; }
  function tag(have, need) { const low = need && have < need; return `<span class="gp-tag ${low ? 'gp-low' : 'gp-ok'}">${T('鬼力', '鬼力')} <b>${have}</b>${need ? `／${T('建議', '建議')} ${need}` : ''}</span>`; }
  function hint(need) { return need ? T(`鬼力唔夠（建議 ${need}）。返村幫隻鬼升級、落訓練班練嚇功，再嚟過！`, `鬼力不足（建議 ${need}）。回村幫鬼升級、去訓練班練嚇功，再來一次！`) : T('打唔過？返村幫隻鬼升級、落訓練班練嚇功，再嚟過！', '打不過？回村幫鬼升級、去訓練班練嚇功，再來一次！'); }
  function failHTML(have, need, extra) {
    return `<div class="gp-fail"><p>${tag(have, need)}</p><p class="gp-hint">${extra || hint(need && have < need ? need : 0)}</p><button class="btn gold wide gp-back">${T('返村升級', '回村升級')}</button></div>`;
  }
  function goVillage(before) {
    try { if (before) before(); } catch (e) { console.error(e); }
    try { if (ok(Street) && Street.Turf && Street.Turf.on) Street.Turf.close(); } catch (e) {}
    try { if (ok(Street) && Street.close) Street.close(); } catch (e) {}
    try { if (ok(World) && World.close && document.querySelector('#world.on')) World.close(); } catch (e) {}
    try { if (ok(UI)) { UI.close(); if (UI.refresh) UI.refresh(); setTimeout(() => { try { UI.openRoster(); } catch (e) { console.error(e); } }, 60); } } catch (e) { console.error(e); }
  }
  function bindBack(root, before) { (root || document).querySelectorAll('.gp-back').forEach(b => b.onclick = (e) => { e.stopPropagation(); goVillage(before); }); }
  return { REF, NONE, pow, mul, best, kindMul, kindPow, hint, raw, grow, kindGrow, drillMul, avg, top, STAGE_NEED, stageNeed, turfNeed, tag, failHTML, goVillage, bindBack, T };
})();
if (typeof window !== 'undefined') window.GP = GP;
