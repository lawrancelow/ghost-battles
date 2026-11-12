# 老闆存檔（主角 18 級、6 隻 17 級鬼）導入非測試版頁面：睇樓裡有鬼揀樓畫面／開局數值
from playwright.sync_api import sync_playwright
import json
code=open('/tmp/claude-0/save_code.txt').read().strip()
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_context(viewport={'width':390,'height':844},is_mobile=True,has_touch=True,device_scale_factor=2).new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:300])); pg.on('console',lambda m: errs.append('c:'+m.text[:300]) if m.type=='error' else None)
    pg.goto('http://127.0.0.1:8765/gp_live.html'); pg.wait_for_function("()=>typeof S!=='undefined'&&typeof GP!=='undefined'&&typeof Tower!=='undefined'",timeout=90000); pg.wait_for_timeout(2500)
    pg.evaluate("(c)=>{var o=Web.dec(c); o.last=Date.now(); window.removeEventListener('beforeunload', save); localStorage.setItem(SAVE_KEY, JSON.stringify(o)); window.__NOSAVE=1;}", code)
    pg.reload(); pg.wait_for_function("()=>typeof S!=='undefined'&&typeof GP!=='undefined'&&typeof Tower!=='undefined'",timeout=90000); pg.wait_for_timeout(2500)
    print('save', pg.evaluate("()=>[S.lv, S.ghosts.map(g=>g.k+':'+F.glv(g)+':'+GP.pow(g)), JSON.stringify(S.tower||null)]"))
    pg.evaluate("()=>{ var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; document.querySelectorAll('#pol-tip,#pol-ov').forEach(e=>e.remove()); Tower.open(); }"); pg.wait_for_timeout(1500)
    pg.screenshot(path='/tmp/claude-0/out/gptw_save_title.png')
    bt=pg.evaluate("()=>TW.btns().find(b=>b.id==='lv_flat')"); pg.touchscreen.tap(bt['x']+bt['w']/2,bt['y']+bt['h']/2); pg.wait_for_timeout(1500)
    print('gp', json.dumps(pg.evaluate("()=>TW.gp()")))
    pg.evaluate("()=>{ TW.G.t=5.7; }"); pg.wait_for_timeout(600); print('toast', pg.evaluate("()=>TW.G.toast"))
    pg.screenshot(path='/tmp/claude-0/out/gptw_save_play.png')
    print('errs',errs); b.close()
