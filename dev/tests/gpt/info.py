import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    print(pg.evaluate("""()=>JSON.stringify({lv:S.lv,bld:S.bld,team:S.team,ghosts:S.ghosts.map(g=>[g.id,g.k,g.q,F.glv(g),g.st,GP.pow(g),+GP.mul(g).toFixed(2),Rework.drillLv(g.k),g.post])})"""))
    print(pg.evaluate("""()=>{const out=[];for(const k of Object.keys(GHOSTS)){const d=GHOSTS[k];for(const lv of [1,5,17,20,30,40]){const g={k,st:d.base.slice(),lv};out.push(k+':'+lv+'='+GP.mul(g).toFixed(2));}}return out.join(' ')}"""))
    print(errs); b.close()
