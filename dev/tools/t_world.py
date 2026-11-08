from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(800)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');G.S().seen.ch1_end=1;}")
    pg.evaluate("G.Village.tap(POS.gate[0],POS.gate[1]-20)"); pg.wait_for_timeout(700)
    pg.screenshot(path='/tmp/claude-0/world.png')
    pg.click('.wm-spot[data-id=yard]'); pg.wait_for_timeout(1200); pg.screenshot(path='/tmp/claude-0/world_street.png')
    print('street on', pg.evaluate("document.querySelector('#gyard').classList.contains('on')"), errs[:5]); b.close()
