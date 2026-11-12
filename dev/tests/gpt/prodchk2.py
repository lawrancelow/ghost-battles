from playwright.sync_api import sync_playwright
import http.server, threading, functools, sys
H=functools.partial(http.server.SimpleHTTPRequestHandler, directory='/tmp/claude-0/old')
srv=http.server.ThreadingHTTPServer(('127.0.0.1',8826),H); threading.Thread(target=srv.serve_forever,daemon=True).start()
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':390,'height':844})
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:200]))
    pg.goto('http://127.0.0.1:8826/old.html' if False else 'http://127.0.0.1:8826/index.html'); pg.wait_for_timeout(12000)
    pg.evaluate("()=>{S.lv=18;S.seen.ch1_end=true;save();}")
    pg.goto('http://127.0.0.1:8826/new.html'); pg.wait_for_timeout(6000)
    pg.evaluate("()=>{var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; World.open()}"); pg.wait_for_timeout(2500)
    pg.screenshot(path='p1.png')
    for i in range(60): pg.mouse.click(195,760); pg.wait_for_timeout(300)
    pg.evaluate("()=>{document.querySelectorAll('#pol-tip').forEach(e=>e.remove()); Street.open()}"); pg.wait_for_timeout(3000); pg.screenshot(path='p2.png')
    pg.evaluate("()=>{Street.close&&Street.close(); World.open(); Tower.open()}"); pg.wait_for_timeout(3000); pg.screenshot(path='p3.png')
    print('lv',pg.evaluate("()=>S.lv"),'errs',errs)
    b.close()
srv.shutdown()
