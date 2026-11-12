import sys; sys.path.insert(0,'/tmp/claude-0/gpt')
from load import *
with sync_playwright() as p:
    b,pg,errs=open_game(p)
    print(pg.evaluate("""()=>{const s=Street.st();return JSON.stringify(Object.keys(s.sites).map(k=>{const d=s.sites[k];return [k,d.lv,d.maxLv,d.scared,d.leaked,(d.posts||[]).filter(Boolean).map(p=>p.role+p.lv+(p.staff?'*'+p.staff:'')).join(' '),d.bosses,d.occH&&d.occH.length, d.unlocked]}))}"""))
    print(pg.evaluate("()=>JSON.stringify({cleared:S.cleared, troops:S.res.troops, adv:S.adviser, buns:S.res.buns, drill:S.ghosts.map(g=>Rework.drillXp(g.k))})"))
    print(errs); b.close()
