import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1;}")
    print(pg.evaluate("()=>S.ghosts.length"))
    pg.evaluate("()=>{Street.open(); Street.Turf.open('market');}"); pg.wait_for_timeout(2500)
    print(pg.evaluate("()=>S.ghosts.length+' '+S.ghosts.filter(g=>!SKILLS[g.k]).map(g=>g.k+':'+g.id).join(',')"))
    print(errs); b.close()
