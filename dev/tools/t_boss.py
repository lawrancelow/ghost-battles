from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_page(viewport={'width':390,'height':844}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    J(pg,"()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.seen.sc_intro=1;save();Scare.start('office',['afu','tianhua','pontianak'])}")
    for i in range(10):
        J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){document.querySelector('#dlg').click()}}"); pg.wait_for_timeout(300)
    print('boss state', J(pg,"(()=>{const n=Scare.npcs.find(m=>m.d.k==='boss');return [n.out,n.gone,n.act]})()"))
    for k,i in [('unknown',0),('master paper',2),('master shadow',1)]:
        J(pg,f"()=>{{const n=Scare.npcs.find(m=>m.d.k==='boss');n.out=false;n.x=OFFMAP.SPOT.bossDesk[0];n.y=OFFMAP.SPOT.bossDesk[1];ScareOps.intel(Scare,'boss').add('master');Scare.mana=100;Scare._opcd={{}};ScareOps.act(Scare,n,ScareOps.OPS.boss.msgs[{i}],'msg')}}"); pg.wait_for_timeout(1500)
        print(k, J(pg,"(()=>{const n=Scare.npcs.find(m=>m.d.k==='boss');return [Math.round(n.fear),n.bub,Scare.kpi]})()"))
    print(errs[:3]); b.close()
