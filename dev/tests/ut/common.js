const { chromium } = require('playwright');
async function boot(lv){
  const b=await chromium.launch(); const ctx=await b.newContext({viewport:{width:390,height:844},isMobile:true,hasTouch:true,deviceScaleFactor:1});
  const pg=await ctx.newPage(); const errs=[];
  pg.on('pageerror',e=>errs.push('PE '+String(e).slice(0,300))); pg.on('console',m=>{ if(m.type()==='error') errs.push('CE '+m.text().slice(0,300)); });
  await pg.goto('http://127.0.0.1:8765/unit.html'); await pg.waitForTimeout(5000);
  await pg.evaluate(()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Tower.open(); var ss=document.getElementById('st-street'); if (ss){ ss.classList.remove('on'); ss.style.display='none'; } var st0=document.createElement('style'); st0.textContent='#pol-tip,#pol-ov{display:none!important}'; document.head.appendChild(st0); window._hideSt=setInterval(function(){ var ss=document.getElementById('st-street'); if (ss&&ss.classList.contains('on')){ ss.classList.remove('on'); ss.style.display='none'; } },200);});
  await pg.waitForTimeout(1500);
  const bt=await pg.evaluate((lv)=>TW.btns().find(b=>b.id===lv),lv==='shop'?'lv_shop':'lv_flat');
  for (let k=0;k<6;k++){ await pg.touchscreen.tap(bt.x+bt.w/2,bt.y+bt.h/2); await pg.waitForTimeout(1200); const st=await pg.evaluate(()=>[!!TW.G, Tower.on, document.elementsFromPoint(105,704).slice(0,3).map(x=>x.tagName+'#'+x.id+'.'+x.className).join(' / '), TW.btns().map(b=>b.id).join(',')]); console.log(k,JSON.stringify(st)); if (st[0]) break; }
  await pg.evaluate(()=>{ window._autoCard=setInterval(()=>{ if (TW.G&&TW.G.choice) TW.choose(0); },250); });
  return {b,pg,errs};
}
module.exports={boot};
