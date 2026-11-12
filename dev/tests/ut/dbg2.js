const { chromium } = require('playwright');
(async()=>{ const b=await chromium.launch(); const ctx=await b.newContext({viewport:{width:390,height:844},isMobile:true,hasTouch:true,deviceScaleFactor:1}); const pg=await ctx.newPage(); const errs=[]; pg.on('pageerror',e=>errs.push(String(e)));
 await pg.goto('http://127.0.0.1:8765/unit.html'); await pg.waitForTimeout(5000);
 await pg.evaluate(()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Tower.open(); window._ev=[]; document.querySelector('.tw-cv').addEventListener('pointerdown',e=>_ev.push('pd '+e.pointerType+' '+e.clientX+','+e.clientY)); document.querySelector('.tw-cv').addEventListener('pointerup',e=>_ev.push('pu'));}); await pg.waitForTimeout(1500);
 await pg.touchscreen.tap(105,704); await pg.waitForTimeout(1500);
 console.log(await pg.evaluate(()=>[_ev, !!TW.G]));
 await pg.mouse.click(105,704); await pg.waitForTimeout(1500);
 console.log(await pg.evaluate(()=>[_ev, !!TW.G]));
 console.log(errs); await b.close(); })();
