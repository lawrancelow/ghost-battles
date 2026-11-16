// 由網頁原碼讀出純資料（const 宣告），套轉譯腳本嘅品牌替換，輸出 JSON
// node dump_js_data.js <src.js> <截到呢句之前> <名1,名2,...> <out.json> <build.sh> <story_v2.json>
const fs = require('fs');
const [src, cut, names, out, build, v2] = process.argv.slice(2);
let s = fs.readFileSync(src, 'utf8');
const i = s.indexOf(cut); if (i < 0) { console.error('cut not found'); process.exit(1); }
s = s.slice(0, i);
const b = fs.readFileSync(build, 'utf8');
const list = JSON.parse(b.match(/for\(const \[a,b\] of (\[\[.*?\]\])\)/)[1]);
const subs = list.concat(JSON.parse(fs.readFileSync(v2, 'utf8')).subs);
for (const [a, c] of subs) s = s.split(a).join(c);
const rwd = (n) => n;   // 只係俾資料檔求值用
const o = new Function('rwd', s + '\nreturn {' + names + '};')(rwd);
fs.writeFileSync(out, JSON.stringify(o));
console.log('ok', Object.keys(o).map(k => k + ':' + (Array.isArray(o[k]) ? o[k].length : Object.keys(o[k]).length)).join(' '));
