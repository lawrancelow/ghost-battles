import sys
from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
O='/tmp/claude-0/pt/'
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    J(pg,"()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.seen.sc_intro=1;save();Scare.start('office',['afu','tianhua','pontianak'])}")
    for i in range(10):
        J(pg,"()=>{const b=[...document.querySelectorAll('button')].find(b=>b.offsetParent&&/跳過/.test(b.textContent));if(b)b.click();else if(Story.busy()){document.querySelector('#dlg').click()}}"); pg.wait_for_timeout(300)
    pg.wait_for_timeout(1500)
    def cam(off=0):
        J(pg,f"()=>{{Scare.follow=false;Scare.camTo=null;Scare.camX=Scare.clampCam(OFFMAP.RM.pantry.cx-Scare.viewW()/2+({off}))}}")
    for off,tag in [(-0.45,'L'),(0.3,'R')]:
        cam(off); pg.wait_for_timeout(600); pg.screenshot(path=O+f'idle_{tag}.png')
    if len(sys.argv)>1 and sys.argv[1]=='base': print(errs[:5]); b.close(); sys.exit()
    for k,off,w in [('fridge',0.3,1.0),('vend',0.4,1.3),('snack',0.4,2.2),('water',0.3,2.5),('coffee',0.0,1.6),('micro',-0.1,1.2),('fridgeloop',0.3,2.0)]:
        cam(off); J(pg,f"()=>Pantry.fx('{k}')"); pg.wait_for_timeout(int(w*1000)); pg.screenshot(path=O+f'fx_{k}.png')
    cam(-0.1); pg.wait_for_timeout(300)
    J(pg,"()=>{const n=Scare.npcs.find(n=>!n.out&&!n.d.guard);const s=Pantry.seats[1];n.x=s[0];n.y=s[1];n.step={x:s[0],y:s[1],wait:30,act:'idle',arrived:true};n.wait=30;n.act='idle'}"); pg.wait_for_timeout(600); pg.screenshot(path=O+'rest.png')
    # NPC use
    J(pg,"()=>{const n=Scare.npcs.find(n=>!n.out&&!n.d.guard);const s=OFFMAP.SPOT.coffee;n.x=s[0];n.y=s[1];n.step={x:s[0],y:s[1],wait:30,act:'idle',arrived:true};n.wait=30;n.act='idle'}"); pg.wait_for_timeout(2500)
    print('use',J(pg,"JSON.stringify(Pantry.state())"))
    # scare ops
    for o in J(pg,"ScareOps.PANTRY.map(o=>o.id)"):
        J(pg,f"()=>{{const n=Scare.npcs.find(n=>!n.out&&!n.d.guard);Scare.mana=999;Scare._opcd={{}};ScareOps.act(Scare,n,ScareOps.PANTRY.find(o=>o.id=='{o}'),'pantry')}}"); pg.wait_for_timeout(200)
    pg.wait_for_timeout(800); pg.screenshot(path=O+'ops.png')
    print(errs[:8]); b.close()
