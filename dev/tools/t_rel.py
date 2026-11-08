import sys
from playwright.sync_api import sync_playwright
f=sys.argv[1]
with sync_playwright() as p:
    b=p.chromium.launch();pg=b.new_page(viewport={'width':390,'height':844})
    errs=[];pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file://'+f);pg.wait_for_timeout(2500);pg.get_by_text('開始新遊戲').click();pg.wait_for_timeout(2500)
    pg.evaluate("()=>{document.querySelectorAll('#story,.story').forEach(e=>e.remove())}")
    pg.evaluate("()=>document.querySelector('#nav button[data-t=battle]').click()");pg.wait_for_timeout(600)
    print('map', pg.evaluate("()=>[...document.querySelectorAll('.wm-spot b')].map(x=>x.textContent)"))
    for sp in ['street','yard','scare']:
        pg.evaluate("()=>{World.close&&World.close()}")
        try:
            pg.evaluate("(id)=>{S.seen.ch1_end=1;World.open();document.querySelector('.wm-spot[data-id='+id+']').click()}",sp);pg.wait_for_timeout(1500)
            pg.screenshot(path=f'/tmp/claude-0/rel_{sp}.png')
        except Exception as e: print(sp,'ERR',e)
        pg.evaluate("()=>{try{GhostStreet.close()}catch(e){};try{Graveyard.close()}catch(e){};try{Scare.close()}catch(e){};try{Scare.exit()}catch(e){}}")
    pg.wait_for_timeout(500)
    pg.evaluate("()=>{World.close();UI.open('battle')}");pg.wait_for_timeout(800);pg.screenshot(path='/tmp/claude-0/rel_battle.png')
    print('errs',errs[:5]);b.close()
