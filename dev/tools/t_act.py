from playwright.sync_api import sync_playwright
f='file:///home/claude/gb/GhostBattles.html'
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome')
    ctx=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2)
    pg=ctx.new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.on('console',lambda m: errs.append('console:'+m.text) if m.type=='error' else None)
    pg.goto(f+'?debug&nophone');pg.wait_for_function('window.G');pg.wait_for_timeout(800)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.lv=8;S.bld.plank=1;S.bld.bun=1;S.res.wood=40;S.res.rice=40;for(const g of S.ghosts)g.post=null;save();}")
    V="G.Village"
    def shot(name, n, dt):
        for i in range(n):
            pg.wait_for_timeout(dt); pg.screenshot(path=f'/tmp/claude-0/{name}{i}.png', clip=pg.evaluate("(()=>{const H=G.Village.hero,c=document.querySelector('#village');const r=c.getBoundingClientRect();const sc=G.Village.scale;return {x:Math.max(0,r.x+(H.x-60)*sc),y:Math.max(0,r.y+(H.y-G.Village.camY-75)*sc),width:110*sc,height:95*sc}})()"))
    pg.evaluate(V+".tap(TREE_POS[0][0],TREE_POS[0][1]-20)")
    pg.wait_for_function("G.Village.hero.act",timeout=8000)
    shot('chop',6,110)
    pg.wait_for_function("!G.Village.hero.act",timeout=15000)
    pg.evaluate(V+".craft('plank')"); pg.wait_for_function("G.Village.hero.act",timeout=8000); shot('ham',4,180)
    pg.wait_for_function("!G.Village.hero.act",timeout=15000)
    pg.evaluate(V+".craft('bun')"); pg.wait_for_function("G.Village.hero.act",timeout=8000); shot('kn',3,250)
    print(errs[:5]); b.close()
