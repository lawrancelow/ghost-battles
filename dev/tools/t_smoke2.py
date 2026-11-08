from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(800)
    pg.evaluate("""()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.lv=30;
      for(const k of ['xiaozhi','eguiking','pontianak']) if(!S.ghosts.find(g=>g.k===k)) joinGhost(k);
      const ids=['afu','eguiking','pontianak'].map(k=>S.ghosts.find(g=>g.k===k).id);S.team=ids;save();Battle.start(2,1)}""")
    for i in range(3): pg.wait_for_timeout(1700); pg.screenshot(path=f'/tmp/claude-0/sb{i}.png')
    pg.wait_for_timeout(25000)
    print('result',pg.evaluate("Battle.result&&JSON.stringify(Battle.result).slice(0,80)"),errs[:5]); b.close()
