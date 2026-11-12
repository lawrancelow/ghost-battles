import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{LANG.set('yue'); UI.openRoster();}"); pg.wait_for_timeout(600)
    print(pg.evaluate("()=>document.querySelector('.gp-line').innerText"))
    pg.evaluate("()=>{UI.close(); S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1; Street.open();}"); pg.wait_for_timeout(1200)
    print(pg.evaluate("()=>document.querySelector('.sts-gp').innerText"))
    pg.evaluate("()=>{Street.Turf.open('market');}"); pg.wait_for_timeout(2000)
    pg.evaluate("()=>{Street.Turf.gpWarn('occ', 'x');}")
    print(pg.evaluate("()=>document.getElementById('gp-warn').innerText"))
    pg.screenshot(path='/tmp/claude-0/out/gp_yue_warn.png')
    pg.evaluate("()=>{ LANG.set('zh'); }")
    print(errs); b.close()
