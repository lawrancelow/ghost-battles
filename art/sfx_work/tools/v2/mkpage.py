import json,base64,html
F=json.load(open('/home/claude/sfxwork/v2/out/final.json'))
O='/home/claude/sfxwork/v2/out/'
G=[('wk_chop_hit','伐木','斧頭砍樹（伐木場）','木質悶響「篤／咚」＋木纖維裂開的乾脆感，去掉金屬叮聲'),
   ('wk_reap_cut','割稻','鐮刀割稻（糯米田）','稻稈割斷「唰／嚓」＋稻葉沙沙，去掉刀鋒叮聲'),
   ('wk_knead_roll','揉麵團','揉麵搓包（包子鋪）','掌心揉壓麵團的軟悶「噗、啪」，不要硬物、金屬、水聲')]
b64=lambda p:'data:audio/mpeg;base64,'+base64.b64encode(open(p,'rb').read()).decode()
data=[]
for ev,short,zh,goal in G:
    ref=F['refs'][ev]
    items=[dict(id='ref',lab='對照',desc='目前遊戲用的 '+ref['cand']+'（先聽這個再比較）',ee=False,src=b64(O+f'ref_{ev}.mp3'),ref=True)]
    for r in [r for r in F['rep'] if r['event']==ev]:
        items.append(dict(id=r['cand'],lab=r['cand'],desc=r['desc'],ee=r['eerie'],src=b64(O+f"{ev}_{r['cand']}.mp3"),ref=False))
    data.append(dict(ev=ev,short=short,zh=zh,goal=goal,items=items))
J=json.dumps(data,ensure_ascii=False)
H='''<!DOCTYPE html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>伐木音效選擇</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@700;900&family=Noto+Sans+TC:wght@400;700&display=swap" rel="stylesheet">
<style>
/* VOICE 陰間作坊工單，安靜、清楚
   IDEA 貼在包子鋪牆上的「做工聲音試聽單」，每組一張紙條
   PICTURE 三張工單卡片，每個候選一枚可按的印章鍵
   COLOUR and TYPE 深墨底、舊紙米色卡、朱紅印章；Noto Serif TC 標題、Noto Sans TC 內文
   LAYOUT 單欄，頂部分組連結，底部固定「複製選擇結果」列 */
:root{color-scheme:dark;--bg:#15110f;--ink:#efe4d0;--paper:#2a221d;--line:#4a3c33;--red:#c8402e;--dim:#b3a38c;--gold:#d9b25f}
*{box-sizing:border-box;min-width:0}
body{margin:0;background:var(--bg);color:var(--ink);font:16px/1.55 "Noto Sans TC",system-ui,sans-serif;overflow-x:clip;padding-bottom:120px}
header{padding:28px max(5vw,16px) 8px;max-width:820px;margin:auto}
h1{font:900 clamp(30px,6vw,44px)/1.05 "Noto Serif TC",serif;margin:0 0 8px;text-wrap:balance}
.lead{color:var(--dim);margin:0 0 14px}
.scroll{display:flex;gap:8px;overflow-x:auto;padding:4px 0 10px}
.scroll a{flex:none;color:var(--ink);text-decoration:none;border:1px solid var(--line);border-radius:999px;padding:8px 14px;font-weight:700}
main{max-width:820px;margin:auto;padding:0 max(5vw,16px)}
section{background:var(--paper);border:1px solid var(--line);border-radius:14px;padding:18px 16px;margin:18px 0}
h2{font:700 26px/1.1 "Noto Serif TC",serif;margin:0 0 4px}
.goal{color:var(--dim);margin:0 0 12px;font-size:15px}
.row{display:grid;grid-template-columns:52px minmax(0,1fr) auto;gap:10px;align-items:center;padding:10px 0;border-top:1px dashed var(--line)}
.row.ref{background:#1d1814;border:1px solid var(--line);border-radius:10px;padding:10px;margin-bottom:6px}
.lab{font:900 22px/1 "Noto Serif TC",serif;text-align:center;color:var(--gold)}
.ref .lab{font-size:14px;color:var(--dim)}
.desc{font-size:15px}.tag{display:inline-block;font-size:13px;color:#d9a3ff;border:1px solid #6b4a86;border-radius:6px;padding:0 6px;margin-left:6px}
.btns{display:flex;gap:8px}
button{font:700 16px "Noto Sans TC",sans-serif;min-height:44px;min-width:44px;border-radius:10px;border:1px solid var(--line);background:#3a2f28;color:var(--ink);padding:0 14px;cursor:pointer}
button:focus-visible{outline:3px solid var(--gold);outline-offset:2px}
button.play.on{background:var(--gold);color:#1b140f}
button.pick.sel{background:var(--red);border-color:var(--red);color:#fff}
.chosen{margin-top:10px;font-weight:700;color:var(--gold)}
.bar{position:fixed;left:0;right:0;bottom:0;background:#0e0b09ee;border-top:1px solid var(--line);padding:10px max(5vw,16px)}
.bar .in{max-width:820px;margin:auto;display:flex;gap:10px;align-items:center;flex-wrap:wrap}
.bar .st{flex:1 1 200px;color:var(--dim);font-size:15px}
.bar button.copy{background:var(--red);border-color:var(--red);color:#fff}
textarea{width:100%;margin-top:8px;font:15px/1.5 monospace;background:#1d1814;color:var(--ink);border:1px solid var(--line);border-radius:8px;padding:8px;display:none}
.note{font-size:13px;color:var(--dim)}
@media(max-width:600px){.row{grid-template-columns:40px minmax(0,1fr)}.btns{grid-column:1/-1}.btns button{flex:1}}
@media(prefers-reduced-motion:reduce){*{transition:none!important}}
</style></head><body>
<header><h1>做工音效重選</h1><p class="lead">伐木、割稻、揉麵團三組，各 8 個新候選（D–K）。每組最上面是目前遊戲用的聲音，先聽它再比較。每組選一個，最後按「複製選擇結果」貼回對話。</p>
<nav class="scroll" id="nav"></nav><p class="note">第一次按播放沒聲音，請檢查手機是否靜音模式。</p></header>
<main id="main"></main>
<div class="bar"><div class="in"><div class="st" id="st">尚未選擇</div><button class="copy" id="copy">複製選擇結果</button></div><div class="in"><textarea id="out" rows="4" readonly></textarea></div></div>
<script>
{
const D=__DATA__;
let pick={};try{pick=JSON.parse(localStorage.getItem('gb_sfx_v2')||'{}')}catch(e){pick={}}
const save=()=>{try{localStorage.setItem('gb_sfx_v2',JSON.stringify(pick))}catch(e){}};
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const nav=document.getElementById('nav'),main=document.getElementById('main');
nav.innerHTML=D.map(g=>`<a href="#${g.ev}">${esc(g.short)}</a>`).join('');
main.innerHTML=D.map(g=>`<section id="${g.ev}"><h2>${esc(g.short)}</h2><p class="goal">${esc(g.zh)}：${esc(g.goal)}</p>
${g.items.map(it=>`<div class="row${it.ref?' ref':''}"><div class="lab">${esc(it.lab)}</div><div class="desc">${esc(it.desc)}${it.ee?'<span class="tag">陰間化</span>':''}</div>
<div class="btns"><button class="play" data-g="${g.ev}" data-i="${it.id}" aria-label="播放 ${esc(it.lab)}">▶ 播放</button>${it.ref?'':`<button class="pick" data-g="${g.ev}" data-i="${it.id}">選這個</button>`}</div></div>`).join('')}
<button class="all" data-g="${g.ev}">逐個試聽本組</button><div class="chosen" id="c_${g.ev}"></div></section>`).join('');
const audio={};D.forEach(g=>g.items.forEach(it=>{audio[g.ev+'|'+it.id]=it.src}));
let cur=null,curBtn=null,seq=null;
function stop(){if(cur){cur.pause();cur=null}if(curBtn){curBtn.classList.remove('on');curBtn=null}}
function play(g,i,btn){stop();const a=new Audio(audio[g+'|'+i]);cur=a;if(btn){btn.classList.add('on');curBtn=btn}
 a.onended=()=>{if(btn)btn.classList.remove('on');if(seq)seq()};const p=a.play();if(p&&p.catch)p.catch(()=>{})}
function render(){let n=0;D.forEach(g=>{const v=pick[g.ev];document.getElementById('c_'+g.ev).textContent=v?('已選：'+v):'';if(v)n++;
 document.querySelectorAll(`.pick[data-g="${g.ev}"]`).forEach(b=>{const s=b.dataset.i===v;b.classList.toggle('sel',s);b.textContent=s?'已選':'選這個'})});
 document.getElementById('st').textContent=n?`已選 ${n}/3 組`:'尚未選擇'}
function text(){return '做工音效重選結果\\n'+D.map(g=>`${g.short}（${g.ev}）：${pick[g.ev]||'未選（維持目前）'}`).join('\\n')}
document.addEventListener('click',e=>{const b=e.target.closest('button');if(!b)return;seq=null;
 if(b.classList.contains('play'))play(b.dataset.g,b.dataset.i,b);
 else if(b.classList.contains('pick')){pick[b.dataset.g]=b.dataset.i;save();render();play(b.dataset.g,b.dataset.i,null)}
 else if(b.classList.contains('all')){const g=D.find(x=>x.ev===b.dataset.g);const ids=g.items.map(x=>x.id);let k=0;
   const nxt=()=>{if(k>=ids.length){seq=null;return}const id=ids[k++];const btn=document.querySelector(`.play[data-g="${g.ev}"][data-i="${id}"]`);seq=()=>setTimeout(nxt,500);play(g.ev,id,btn);seq=()=>setTimeout(nxt,500)};nxt()}
 else if(b.id==='copy'){const t=text();const out=document.getElementById('out');out.value=t;out.style.display='block';
   const ok=()=>{b.textContent='已複製，貼回對話即可'};
   try{navigator.clipboard.writeText(t).then(ok,()=>{out.select();b.textContent='請長按上面文字複製'})}catch(err){out.select();b.textContent='請長按上面文字複製'}}
});
render();
}
</script></body></html>'''
open('/home/claude/sfxwork/v2/page/index.html','w').write(H.replace('__DATA__',J))
print(len(H)+len(J))
