from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch();pg=b.new_page(viewport={'width':390,'height':844})
    errs=[];pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///home/claude/ghost-battles/index.html');pg.wait_for_timeout(2500)
    pg.evaluate("()=>{try{Story.skipAll&&Story.skipAll()}catch(e){}}")
    pg.evaluate("()=>{document.querySelectorAll('#story,.story').forEach(e=>e.remove())}")
    pg.evaluate("()=>document.querySelector('#nav button[data-t=battle]').click()")
    pg.wait_for_timeout(800)
    print('world on:',pg.evaluate("()=>!!document.querySelector('#world.on')"), 'spots:',pg.evaluate("()=>[...document.querySelectorAll('.wm-card b')].map(x=>x.textContent)"))
    pg.screenshot(path='navmap.png');print('errs',errs);b.close()
