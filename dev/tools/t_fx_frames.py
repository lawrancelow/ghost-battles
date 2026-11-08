from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(executable_path='/usr/bin/google-chrome')
    pg=b.new_context(viewport={'width':390,'height':844},device_scale_factor=1).new_page()
    pg.goto('file:///home/claude/gb/GhostBattles.html?debug&nophone');pg.wait_for_function('window.G');pg.wait_for_timeout(500)
    pg.evaluate("()=>{document.querySelectorAll('#title,#dlg,#phone').forEach(e=>e.style.display='none');const S=G.S();S.bld.furnace=1;S.furnaceAt=0;G.UI.openBuilding('furnace')}")
    pg.wait_for_timeout(400); pg.click("#sheet [data-act=burn]")
    for t in (400,500,500,500):
        pg.wait_for_timeout(t); pg.screenshot(path=f'/tmp/claude-0/fxf_{t}_{pg.evaluate("performance.now()|0")}.png')
    b.close()
