from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1500)
    J(pg,"()=>{document.querySelector('#title').style.display='none';const S=G.S();S.seen.ch1_end=1;S.seen.prologue_sys=1;S.lv=20;for(const k of ['tianhua','pontianak','xiaozhi','toyol','mengpo','n30_maoshi']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);save()}")
    def drain(lim=40):
        for i in range(lim):
            J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){const d=document.querySelector('#dlg');d.click();d.querySelector('button')&&d.querySelector('button').click()}}")
            pg.wait_for_timeout(300)
            if i>8 and not J(pg,"Presence.playing||Story.busy()||Presence.dev.scenes().length"): break
    C=lambda: J(pg,"JSON.stringify({s:S.contract.state,r:S.contract.rank,k:S.contract.kpi,t:S.contract.target})")
    drain(); print('1 issue', C())
    J(pg,"()=>{Scare.open('office')}"); pg.wait_for_timeout(500)
    J(pg,"()=>{document.querySelector('#sc-go').click()}"); pg.wait_for_timeout(1500)
    J(pg,"()=>{Scare.mana=999;for(const k of Object.keys(Scare.cd)){Scare.cd[k]=0;const n=Scare.npcs.find(m=>!m.gone&&!m.out);if(n&&k!=='afu')Scare.useGhost(k,n)}}"); pg.wait_for_timeout(3500)
    J(pg,"()=>Scare.finish(false)"); pg.wait_for_timeout(800); pg.screenshot(path='/tmp/claude-0/p2_end.png')
    J(pg,"()=>{$('#scare').classList.remove('on');$('#scare').innerHTML=''}"); drain(); print('2 night', C())
    J(pg,"()=>{S.contract.kpi=S.contract.target}"); pg.wait_for_timeout(2500); drain(); print('3 promote', C(), 'perk', J(pg,"Presence.perk('squad')"))
    J(pg,"()=>{Scare.open('office')}"); pg.wait_for_timeout(500)
    J(pg,"()=>{const S=G.S();ScareX.squad.set(['tianhua','pontianak'])}"); J(pg,"()=>{UI.close();Scare.open('office')}"); pg.wait_for_timeout(400)
    J(pg,"()=>{[...document.querySelectorAll('#sheet .sq-g:not([disabled]):not(.on)')].slice(0,3).forEach(b=>b.click())}"); pg.wait_for_timeout(300)
    print('4 squad', J(pg,"[...document.querySelectorAll('#sheet .desc')].map(e=>e.textContent).filter(t=>/最多|已選/.test(t)).map(t=>t.slice(-22))"))
    pg.screenshot(path='/tmp/claude-0/p2_squad.png'); J(pg,"()=>UI.close()")
    J(pg,"()=>Presence.dev.days(8)"); pg.wait_for_timeout(2500); drain(); print('5 crisis', C(), 'afu', J(pg,"Math.round(Presence.val(S.ghosts.find(g=>g.k==='afu')))"))
    J(pg,"()=>{window.dispatchEvent(new CustomEvent('gb:nightEnd',{detail:{loc:'office',score:900,stars:2,legendLv:2,ghosts:['afu'],perGhost:{}}}))}"); pg.wait_for_timeout(2500); drain(); print('6 redeem', C(), 'afu', J(pg,"Math.round(Presence.val(S.ghosts.find(g=>g.k==='afu')))"))
    J(pg,"()=>Presence.openPanel()"); pg.wait_for_timeout(500); pg.screenshot(path='/tmp/claude-0/p2_panel.png')
    print('errs',errs[:6]); b.close()
