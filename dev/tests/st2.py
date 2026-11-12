from playwright.sync_api import sync_playwright
import http.server, threading, functools
H=functools.partial(http.server.SimpleHTTPRequestHandler, directory='/tmp/claude-0/old')
srv=http.server.ThreadingHTTPServer(('127.0.0.1',8829),H); threading.Thread(target=srv.serve_forever,daemon=True).start()
with sync_playwright() as p:
    b=p.chromium.launch(); ctx=b.new_context(viewport={'width':390,'height':844},has_touch=True,is_mobile=True,device_scale_factor=2); pg=ctx.new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:200]))
    pg.goto('http://127.0.0.1:8829/new.html'); pg.wait_for_timeout(6000)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_station=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Street.open()}"); pg.wait_for_timeout(2000)
    els=pg.query_selector_all('[data-site]'); print([e.get_attribute('data-site') for e in els][:8])
    pg.evaluate("()=>{const c=document.querySelector('[data-site=market]'); c&&c.click()}"); pg.wait_for_timeout(12000)
    pg.screenshot(path='sf1.png')
    print('errs',errs); b.close()
srv.shutdown()
