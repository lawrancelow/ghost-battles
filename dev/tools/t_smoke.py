from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844}).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(800)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.lv=20;S.team=[S.ghosts[0].id,null,null];save();Battle.start(0,0)}")
    pg.wait_for_timeout(9000); pg.screenshot(path='/tmp/claude-0/smoke_b.png')
    print('result',pg.evaluate("Battle.result&&Battle.result.win"),'active',pg.evaluate("Battle.active"),errs[:5]); b.close()
