from playwright.sync_api import sync_playwright
J=lambda pg,s: pg.evaluate(s)
BOT={
'jump_good':"if(G.fly)return;if(G.hop<6){const land=0.56-G.hopT;if(land<0.035&&!G.tapped[G.hop])G.down()}else{if(G.lineX-G.x<8)G.down()}",
'jump_bad':"if(G.fly)return;if(G.hop<6){if(Math.random()<0.03)G.down()}else{if(G.lineX-G.x<-4)G.down()}",
'tug_good':"if(G.taut<=0&&Math.random()<0.7)G.down()",
'tug_bad':"G.down()",
'hang_good':"if(!G.hold&&!G.fall)G.down({x:195,y:300});if(G.fall)return;G.move({x:G.fx0+90*Math.max(-2,Math.min(2,G.sw*1.4+G.v*1.0)),y:300});if(G.time>30)G.up()",
'hang_bad':"if(!G.hold&&!G.fall)G.down({x:195,y:300})",
'swim_good':"if(G.t-G.lastT>0.3){G.stroke_(G.lastSide===1?-1:1)}",
'swim_bad':"if(G.t-G.lastT>0.12)G.stroke_(1)",
'swim_fast':"if(G.t-G.lastT>0.16){G.stroke_(G.lastSide===1?-1:1)}",
}
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(1200)
    J(pg,"()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.prologue_sys=1;S.seen.ch1_end=1;S.lv=15;for(const k of ['laojiang','tianhua','n30_kappa']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);save()}")
    J(pg,"()=>UI.open('battle')"); pg.wait_for_timeout(500)
    J(pg,"()=>document.querySelector('#sp-open').click()"); pg.wait_for_timeout(600); pg.screenshot(path='/tmp/claude-0/sp_menu.png')
    for key,code in BOT.items():
        ev=key.split('_')[0]
        J(pg,f"()=>{{UI.close();Sports.start('{ev}');clearInterval(window._bot);window._bot=setInterval(()=>{{const G=Sports._g();if(!G||G.phase!=='play'||G.done)return;{code}}},16)}}")
        for i in range(200):
            pg.wait_for_timeout(500)
            if i==8 and key.endswith('good'): pg.screenshot(path=f'/tmp/claude-0/sp_{ev}.png')
            if J(pg,"!!document.querySelector('.sp-end')"): break
        print(key, J(pg,"(document.querySelector('.sp-end h3')||{}).textContent+' | '+(document.querySelector('.sp-big')||{}).textContent"))
        if key=='swim_good': pg.screenshot(path='/tmp/claude-0/sp_end.png')
    J(pg,"()=>clearInterval(window._bot)")
    print('targets',J(pg,"['jump','hang','swim'].map(Sports.target)"), J(pg,"JSON.stringify(S.sports)"))
    print('errs',errs[:6]); b.close()
