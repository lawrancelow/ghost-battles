import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true; Scare.open('office');}"); pg.wait_for_timeout(1000)
    pg.screenshot(path='/tmp/claude-0/out/gp_scare_pick.png')
    print(pg.evaluate("()=>[...document.querySelectorAll('.sq-g .gp-sub')].map(e=>e.innerText).slice(0,4).join(' | ')"))
    pg.evaluate("()=>{const g=[...document.querySelectorAll('.sq-g:not([disabled])')][0]; g&&g.click(); const go=document.getElementById('sc-go'); go&&go.click();}"); pg.wait_for_timeout(4000)
    r=pg.evaluate("""()=>{ const k=Scare.team.find(x=>x!=='afu'); const n=Scare.npcs.find(m=>!m.d.guard&&!m.gone&&!m.out); Scare.mana=999; const f0=n.fear; Scare.useGhost(k,n); return JSON.stringify({k, cd:Scare.cd[k], gq:Scare.gpq(k)}); }""")
    print(r); pg.wait_for_timeout(2500)
    pg.screenshot(path='/tmp/claude-0/out/gp_scare_night.png')
    # 運動會
    pg.evaluate("()=>{ try{Scare.close&&Scare.close();}catch(e){} Sports.start('jump'); }"); pg.wait_for_timeout(1200)
    print('sports', pg.evaluate("()=>document.getElementById('sp-rule').innerText"), pg.evaluate("()=>Sports._g().gpf"))
    pg.screenshot(path='/tmp/claude-0/out/gp_sports.png')
    print(errs); b.close()
