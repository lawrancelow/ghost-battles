import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1; Street.open(); Street.Turf.open('market');}"); pg.wait_for_timeout(2500)
    pg.evaluate("()=>{const T=Street.Turf; T.gpWarn('occ','測試標題');}")
    print(pg.evaluate("""()=>[...document.querySelectorAll('#gp-warn, #gp-warn *')].map(e=>{const r=e.getBoundingClientRect(), cs=getComputedStyle(e); return e.tagName+'.'+e.className+' '+Math.round(r.top)+'-'+Math.round(r.bottom)+' pos:'+cs.position+' top:'+cs.top}).join('\\n')"""))
    b.close()
