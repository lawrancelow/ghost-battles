from playwright.sync_api import sync_playwright
import http.server, threading, functools
H=functools.partial(http.server.SimpleHTTPRequestHandler, directory='/tmp/claude-0/old')
srv=http.server.ThreadingHTTPServer(('127.0.0.1',8822),H); threading.Thread(target=srv.serve_forever,daemon=True).start()
with sync_playwright() as p:
    b=p.chromium.launch(); ctx=b.new_context(viewport={'width':390,'height':844}); pg=ctx.new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:200]))
    pg.goto('http://127.0.0.1:8822/index.html'); pg.wait_for_timeout(6000)
    pg.evaluate("()=>{S.lv=18; S.res.coins=5000; S.seen.ch1_end=true; save();}")
    print('old saved', pg.evaluate("()=>JSON.parse(localStorage.getItem('ghostBattles_v1')).lv"), errs)
    pg.goto('http://127.0.0.1:8822/new.html'); pg.wait_for_timeout(7000)
    print('new lv', pg.evaluate("()=>[S&&S.lv, localStorage.getItem('ghostBattles_v1').slice(0,60)]"), errs)
    pg.reload(); pg.wait_for_timeout(6000)
    print('after reload', pg.evaluate("()=>[S&&S.lv, JSON.parse(localStorage.getItem('ghostBattles_v1')).lv]"), errs)
    b.close()
srv.shutdown()
