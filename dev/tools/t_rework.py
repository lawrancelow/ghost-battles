from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1500)
    J(pg,"()=>{document.querySelector('#title').style.display='none';const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.lv=12;S.bld.camp=2;S.bld.home=2;S.res.buns=500;S.res.planks=500;for(const s of ['1-1','1-2','1-3','2-1','2-2','2-3','3-1']) S.cleared[s]=1;for(const k of ['xiaozhi','eguiking','toyol','laojiang','pontianak','tianhua']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);save()}")
    def drain(n=40):
        for i in range(n):
            J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){const d=document.querySelector('#dlg');d.click()}}"); pg.wait_for_timeout(250)
            if i>6 and not J(pg,"Presence.playing||Story.busy()||Presence.dev.scenes().length"): break
    drain()
    # 1) 地盤：被搶
    J(pg,"()=>{const t=Rework.turf();t.next=1;Rework.turfTick()}")
    print('lost', J(pg,"Object.keys(Rework.turf().lost)"), 'held', J(pg,"Rework.held().length"))
    J(pg,"()=>UI.open('battle')"); pg.wait_for_timeout(700); pg.screenshot(path='/tmp/claude-0/rw_select.png')
    sid=J(pg,"Object.keys(Rework.turf().lost)[0]")
    # 2) 戰鬥：用 Toyol（燈? 看嚇法）+ 天花姐，觀察連嚇
    J(pg,"()=>{UI.close();const S=G.S();S.team=['afu','toyol','tianhua'].map(k=>S.ghosts.find(g=>g.k===k).id);save()}")
    ci,si=[int(x)-1 for x in sid.split('-')]
    J(pg,f"()=>Battle.start({ci},{si})"); pg.wait_for_timeout(800)
    print('title', J(pg,"document.querySelector('#b-title').textContent"))
    J(pg,"()=>{window._tags=[];const o=Battle.fx.push.bind(Battle.fx);Battle._fxp=true}")
    # 連續放技能
    for i in range(10):
        J(pg,"()=>{for(const u of Battle.units.filter(u=>u.side===0&&!u.minion&&u.hp>0)){u.energy=100;Battle.cast(u)}}"); pg.wait_for_timeout(700)
        J(pg,"()=>{for(const f of Battle.fx) if(f.text&&/怕|連嚇|不怕|追嚇|失神/.test(f.text)&&!f._seen){f._seen=1;window._tags.push(f.text)}}")
        if i==3: pg.screenshot(path='/tmp/claude-0/rw_battle.png')
    print('tags', J(pg,"window._tags.slice(0,12)"))
    J(pg,"()=>{Battle.units.filter(u=>u.side===1).forEach(u=>u.hp=0)}"); pg.wait_for_timeout(3000)
    print('result', J(pg,"JSON.stringify(Battle.result)"), 'still lost', J(pg,f"Rework.isLost('{sid}')"))
    J(pg,"()=>{document.querySelector('#battle').classList.remove('on');Battle.active=false}"); drain()
    # 3) 嚇人訓練班
    J(pg,"()=>{const S=G.S();const g=S.ghosts.find(g=>g.k==='toyol');g.post='camp';save()}")
    J(pg,"()=>{for(let i=0;i<60;i++) produce(60)}")
    print('drill', J(pg,"JSON.stringify({xp:Math.round(Rework.drillXp('toyol')),lv:Rework.drillLv('toyol'),buns:Math.round(S.res.buns),troops:Math.round(S.res.troops)})"))
    J(pg,"()=>UI.openBuilding('camp')"); pg.wait_for_timeout(600); pg.screenshot(path='/tmp/claude-0/rw_camp.png')
    J(pg,"()=>UI.close()")
    # 4) 上供
    J(pg,"()=>{Presence.dev.set(S.ghosts.find(g=>g.k==='toyol'),50);Presence.openPanel()}"); pg.wait_for_timeout(400)
    J(pg,"()=>{const g=S.ghosts.find(g=>g.k==='toyol');document.querySelector(`[data-offer=\"${g.id}\"]`).click()}"); pg.wait_for_timeout(300)
    print('offer', J(pg,"Math.round(Presence.val(S.ghosts.find(g=>g.k==='toyol')))"), J(pg,"document.querySelector('[data-offer]:disabled')?.textContent"))
    pg.screenshot(path='/tmp/claude-0/rw_offer.png'); J(pg,"()=>UI.close()")
    # 5) 供品道具
    J(pg,"()=>Scare.open('office')"); pg.wait_for_timeout(500)
    J(pg,"()=>{document.querySelectorAll('[data-kit]').forEach(b=>b.click())}"); pg.screenshot(path='/tmp/claude-0/rw_kit.png')
    bb=J(pg,"[Math.round(S.res.buns),Math.round(S.res.planks)]")
    J(pg,"()=>document.querySelector('#sc-go').click()"); pg.wait_for_timeout(1200)
    print('kit', bb, J(pg,"[Math.round(S.res.buns),Math.round(S.res.planks),Math.round(Scare.mana),JSON.stringify(Scare.kit)]"))
    print('errs', errs[:6]); b.close()
