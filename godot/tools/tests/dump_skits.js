// skits.js：抽出 SKITS（give 函數 → {__rwd:{資源:基數}}）同 Theater 嘅 CSS，套轉譯品牌替換
const fs = require('fs');
const [src, out, cssOut, build, v2] = process.argv.slice(2);
let s = fs.readFileSync(src, 'utf8');
const b = fs.readFileSync(build, 'utf8');
const subs = JSON.parse(b.match(/for\(const \[a,b\] of (\[\[.*?\]\])\)/)[1]).concat(JSON.parse(fs.readFileSync(v2, 'utf8')).subs);
for (const [a, c] of subs) s = s.split(a).join(c);
const i0 = s.indexOf('const SKITS = ['), i1 = s.indexOf('// ===================== 觸發、存檔、重溫');
const SKITS = new Function('rwd', s.slice(i0, i1) + '\nreturn SKITS;')((n) => n);
const json = JSON.stringify({ SKITS }, (k, v) => typeof v === 'function' ? { __rwd: v() } : v);
fs.writeFileSync(out, json);
const c0 = s.indexOf("s.textContent = `", s.indexOf('const Theater')) + 17, c1 = s.indexOf('`;', c0);
fs.writeFileSync(cssOut, s.slice(c0, c1));
console.log('SKITS', SKITS.length, 'css', c1 - c0, 'give', (json.match(/__rwd/g) || []).length);
