const { chromium } = require('playwright');
async function boot(lv){ lv=lv||'flat';
  const b=await chromium.launch(); const ctx=await b.newContext({viewport:{width:390,height:844},isMobile:true,hasTouch:true,deviceScaleFactor:1});
  const pg=await ctx.newPage(); const errs=[];
  pg.on('pageerror',e=>errs.push('PE '+String(e).slice(0,300))); pg.on('console',m=>{ if(m.type()==='error') errs.push('CE '+m.text().slice(0,300)); });
  await pg.goto('http://127.0.0.1:8765/'+(process.env.QA_PAGE||'unit.html')); await pg.waitForFunction(()=>typeof S!=='undefined'&&typeof Tower!=='undefined'&&typeof save==='function',null,{timeout:60000}); await pg.waitForTimeout(2500);
  await pg.evaluate(()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Tower.open(); var ss=document.getElementById('st-street'); if (ss){ ss.classList.remove('on'); ss.style.display='none'; } var st0=document.createElement('style'); st0.textContent='#pol-tip,#pol-ov{display:none!important}'; document.head.appendChild(st0); window._hideSt=setInterval(function(){ var ss=document.getElementById('st-street'); if (ss&&ss.classList.contains('on')){ ss.classList.remove('on'); ss.style.display='none'; } },200);});
  await pg.waitForTimeout(1500);
  const bt=await pg.evaluate((lv)=>TW.btns().find(b=>b.id===lv),lv==='shop'?'lv_shop':'lv_flat');
  for (let k=0;k<6;k++){ await pg.touchscreen.tap(bt.x+bt.w/2,bt.y+bt.h/2); await pg.waitForTimeout(1200); const st=await pg.evaluate(()=>[!!TW.G, Tower.on, document.elementsFromPoint(105,704).slice(0,3).map(x=>x.tagName+'#'+x.id+'.'+x.className).join(' / '), TW.btns().map(b=>b.id).join(',')]); console.log(k,JSON.stringify(st)); if (st[0]) break; }
  await pg.evaluate(()=>{ window._autoCard=setInterval(()=>{ if (TW.G&&TW.G.choice) TW.choose(0); },250); });
  return {b,pg,errs};
}
module.exports={boot};
// 圖 key 追蹤：drawImage hook，靠 BG_SRC/SPR 反查
module.exports.hookImgs=async function(pg){ await pg.evaluate(()=>{ const W=new WeakMap(); let rev=null; window._imgUse={};
  function key(im){ if (W.has(im)) return W.get(im); if (!rev){ rev=new Map(); try{ const B=window.BG_SRC||{}; for (const k in B) rev.set(B[k],k); }catch(e){} }
    let k=rev.get(im.src)||null; if (!k&&im.src&&im.src.length<300) k=im.src; W.set(im,k); return k; }
  const o=CanvasRenderingContext2D.prototype.drawImage; CanvasRenderingContext2D.prototype.drawImage=function(im){ try{ if (im&&im.src){ const k=key(im); if (k) window._imgUse[k]=(window._imgUse[k]||0)+1; } }catch(e){} return o.apply(this,arguments); };
  if (window.PPLFX&&PPLFX.key){ const ok=PPLFX.key; window._pkey={}; PPLFX.key=function(k,s){ const r=ok.apply(this,arguments); window._pkey[r]=(window._pkey[r]||0)+1; return r; }; } }); };
