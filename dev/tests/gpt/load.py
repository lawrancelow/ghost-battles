# 共用：開頁＋導入補償存檔
from playwright.sync_api import sync_playwright
import json,sys
CODE=open('/tmp/claude-0/save_code.txt').read().strip()
def open_game(p, url='http://127.0.0.1:8765/new.html', save=True):
    b=p.chromium.launch(); pg=b.new_context(viewport={'width':390,'height':844},is_mobile=True,has_touch=True).new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:300])); pg.on('console',lambda m: errs.append('c:'+m.text[:300]) if m.type=='error' else None)
    pg.goto(url); pg.wait_for_timeout(5000)
    if save:
        pg.evaluate("(c)=>{var o=Web.dec(c); o.last=Date.now(); window.removeEventListener('beforeunload', save); localStorage.setItem(SAVE_KEY, JSON.stringify(o)); window.__NOSAVE=1;}", CODE)
        pg.reload(); pg.wait_for_timeout(5000)
        pg.evaluate("()=>{var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}}")
    return b,pg,errs
