import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1; Street.open();}"); pg.wait_for_timeout(1500)
    print(pg.evaluate("""()=>{ const out=[]; const els=[document.querySelector('.sts-plate .gp-need'), document.querySelector('.sts-gp .gp-tag'), document.querySelector('.sts-plate small')];
      for(const el of els){ const r=el.getBoundingClientRect(); out.push(el.className+' '+JSON.stringify([r.top,r.bottom])+' pos '+getComputedStyle(el).position);
        for(const sh of document.styleSheets){ let rs; try{rs=sh.cssRules}catch(e){continue} for(const ru of rs){ if(ru.selectorText && ru.style && (ru.style.position||ru.style.top||ru.style.transform)){ try{ if(el.matches(ru.selectorText)) out.push('   '+ru.cssText.slice(0,200)); }catch(e){} } } } }
      const pl=document.querySelector('.sts-plate'); out.push('plate '+JSON.stringify(pl.getBoundingClientRect())+' h '+getComputedStyle(pl).height);
      return out.join('\\n'); }"""))
    b.close()
