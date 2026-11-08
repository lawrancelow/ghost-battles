from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome'); pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=2).new_page(); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e))); pg.on('console',lambda m: errs.append(m.text) if m.type=='error' else None)
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone'); pg.wait_for_function('window.G'); pg.wait_for_timeout(800)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.seen.ch1_end=1;S.lv=10;save();Scare.open('office')}")
    pg.wait_for_timeout(600)
    btn=pg.query_selector('#sheet .btn.gold, #scare .btn.gold, button:has-text(\"開始\")')
    pg.evaluate("()=>{const b=[...document.querySelectorAll('button')].find(b=>/開始|出發|開工/.test(b.textContent));b&&b.click()}")
    pg.wait_for_timeout(3000); pg.screenshot(path='/tmp/claude-0/sc_m1.png')
    pg.wait_for_timeout(4000); pg.screenshot(path='/tmp/claude-0/sc_m2.png')
    print(errs[:5]); b.close()
