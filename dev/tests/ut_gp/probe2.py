from playwright.sync_api import sync_playwright
code=open('/tmp/claude-0/save_code.txt').read().strip()
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_context(viewport={'width':390,'height':844}).new_page()
    pg.goto('http://127.0.0.1:8765/unit.html'); pg.wait_for_function("()=>typeof S!=='undefined'&&typeof GP!=='undefined'",timeout=60000); pg.wait_for_timeout(1500)
    print(pg.evaluate("(c)=>{var o=Web.dec(c); return [o.lv, (o.ghosts||[]).map(g=>[g.k,g.lv,g.st]), Object.keys(o).slice(0,40), JSON.stringify(o.drill||o.rework||'').slice(0,200)]}", code))
    b.close()
