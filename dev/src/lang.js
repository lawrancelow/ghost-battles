// ===================== 對白語言：中文（預設）／粵語（lang.js）=====================
// 粵語原句一句都冇改；中文版放喺對照表 LANG.ZH[粵語原句] = 中文句（lang_zh.js）。
// L(句子)：揀中文時查表，查唔到就照原句（旁白、系統、介面本身已經係書面語）。Lf(句子, {n:…})：有 {n} 之類嘅位要填。
// 設定存 localStorage 'gb_dialogue_lang'：'zh' | 'yue'；讀唔到就用中文。
const LANG = (() => {
  let cur = 'zh';
  try { const v = localStorage.getItem('gb_dialogue_lang'); if (v === 'zh' || v === 'yue') cur = v; } catch (e) {}
  const ZH = {}, subs = [];
  return {
    ZH,
    get cur() { return cur; },
    set(v) { cur = v === 'yue' ? 'yue' : 'zh'; try { localStorage.setItem('gb_dialogue_lang', cur); } catch (e) {} subs.forEach(f => { try { f(cur); } catch (e) {} }); },
    toggle() { this.set(cur === 'zh' ? 'yue' : 'zh'); return cur; },
    on(f) { subs.push(f); },
    add(t) { for (const k in t) ZH[k] = t[k]; },
    name() { return cur === 'zh' ? '中文' : '粵語'; },
  };
})();
function L(s) { if (typeof s !== 'string' || LANG.cur !== 'zh') return s; const t = LANG.ZH[s]; return t != null && t !== '' ? t : s; }
function Lf(s, v) { let r = L(s); if (v) for (const k in v) r = r.split('{' + k + '}').join(v[k]); return r; }
