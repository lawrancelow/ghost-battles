from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_page(viewport={'width':390,'height':844}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1500)
    J(pg,"()=>{document.querySelector('#title').style.display='none';const S=G.S();S.seen.prologue_sys=1;for(const k of ['toyol','mengpo']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);save()}")
    def drain(lim=40):
        for i in range(lim):
            J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){const d=document.querySelector('#dlg');d.click();d.querySelector('button')&&d.querySelector('button').click()}}")
            pg.wait_for_timeout(300)
    drain(10)
    J(pg,"()=>{Presence.dev.days(8);Presence.dev.set(S.ghosts.find(g=>g.k==='toyol'),20);Presence.dev.days(3)}")
    print('t', J(pg,"(()=>{const g=S.ghosts.find(g=>g.k==='toyol');return [Math.round(Presence.val(g)),Presence.daysLeft(g)]})()"))
    J(pg,"()=>Presence.dev.days(4)"); print("cd",J(pg,"Presence.daysLeft(S.ghosts.find(g=>g.k==='toyol'))")); J(pg,"()=>Presence.dev.days(3.2)")
    print('scenes', J(pg,"Presence.dev.scenes().map(s=>s.kind+(s.g?':'+s.g.k+':'+S.ghosts.includes(s.g):''))"))
    for i in range(40):
        J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){const d=document.querySelector('#dlg');d.click();d.querySelector('button')&&d.querySelector('button').click()}}")
        pg.wait_for_timeout(300)
        if i==6: pg.screenshot(path='/tmp/claude-0/fw.png')
    print('toyol', J(pg,"!!S.ghosts.find(g=>g.k==='toyol')"), 'gone', J(pg,"S.presence.gone.map(o=>o.k)"), 'sc', J(pg,"Presence.dev.scenes().map(s=>s.kind)"))
    # 重新招魂
    J(pg,"()=>{S.coins=1e6;S.buns=1e6;Presence.dev.resummon(0,true)}"); drain(20)
    print('back', J(pg,"(()=>{const g=S.ghosts.find(g=>g.k==='toyol');return g&&[g.lv,Math.round(Presence.val(g))]})()"))
    print(errs[:5]); b.close()
