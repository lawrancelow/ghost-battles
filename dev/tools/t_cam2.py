from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); ctx=b.new_context(viewport={'width':390,'height':844},has_touch=True); pg=ctx.new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    J(pg,"()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.seen.sc_intro=1;save();Scare.start('office',['afu','tianhua','pontianak'])}")
    for i in range(10):
        J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){document.querySelector('#dlg').click()}}"); pg.wait_for_timeout(300)
    c0=J(pg,"Scare.camX")
    # 1) 手機式「點人」：輕微滑動 12px，兩個 move 同一時間到
    J(pg,"""()=>{const cv=document.querySelector('#sc-cvs');const r=cv.getBoundingClientRect();const x=r.left+200,y=r.top+300;
      const ev=(t,dx)=>cv.dispatchEvent(new PointerEvent(t,{clientX:x+dx,clientY:y,pointerId:7,bubbles:true,pointerType:'touch'}));
      ev('pointerdown',0);ev('pointermove',-6);ev('pointermove',-12);ev('pointermove',-13);ev('pointerup',-13);}""")
    pg.wait_for_timeout(2500); c1=J(pg,"Scare.camX")
    print('tap-jitter drift', round(c1-c0,3), 'camV', J(pg,"Scare.camV"))
    # 2) 嚇跑阿Ken 之後：鏡頭唔應該自己走
    J(pg,"()=>{const n=Scare.npcs.find(m=>m.d.k==='ken');Scare.sel=n;Scare.selAuto=false;Scare.mana=100;ScareOps.act(Scare,n,ScareOps.OPS.ken.msgs[0],'msg')}"); pg.wait_for_timeout(1200)
    J(pg,"()=>{const n=Scare.npcs.find(m=>m.d.k==='ken');Scare.mana=100;Scare.cd={};Scare.useGhost('tianhua',n)}")
    c2=J(pg,"Scare.camX"); xs=[]
    for i in range(10): pg.wait_for_timeout(1000); xs.append(round(J(pg,"Scare.camX"),2))
    print('after scare cam', round(c2,2), xs, 'sel', J(pg,"Scare.sel&&Scare.sel.d.k"), 'auto', J(pg,"Scare.selAuto"))
    print(errs[:3]); b.close()
