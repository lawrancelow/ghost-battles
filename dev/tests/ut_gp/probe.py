from playwright.sync_api import sync_playwright
code=open('/tmp/claude-0/save_code.txt').read().strip()
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_context(viewport={'width':390,'height':844}).new_page()
    errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:300]))
    pg.goto('http://127.0.0.1:8765/unit.html'); pg.wait_for_function("()=>typeof S!=='undefined'&&typeof GP!=='undefined'",timeout=60000); pg.wait_for_timeout(1500)
    print('fresh', pg.evaluate("()=>S.ghosts.map(g=>g.k+':'+g.lv)"))
    pg.evaluate("(c)=>{var o=Web.dec(c); o.last=Date.now(); window.removeEventListener('beforeunload', save); localStorage.setItem(SAVE_KEY, JSON.stringify(o));}", code)
    pg.reload(); pg.wait_for_function("()=>typeof S!=='undefined'&&typeof GP!=='undefined'",timeout=60000); pg.wait_for_timeout(1500)
    print('save lv',pg.evaluate("()=>S.lv"), pg.evaluate("()=>S.ghosts.map(g=>[g.k,g.q,F.glv(g),GP.pow(g),+GP.mul(g).toFixed(2), Rework.drillLv(g.k)])"))
    for k in ['eguiking','toyol','tianhua']:
        print(k,'kp',pg.evaluate("(k)=>[GP.kindPow(k),GP.kindMul(k)]",k))
    # 假設 lv 不同
    print(pg.evaluate("""()=>{ const out={}; for (const k of ['eguiking','toyol','tianhua']){ const d=GHOSTS[k]; out[k]=[1,10,17,20,30,40].map(lv=>{ const g={k:k,lv:lv,st:d.base.slice()}; return lv+':'+GP.pow(g)+'/'+GP.mul(g).toFixed(2); }); } return out; }"""))
    print('cap',pg.evaluate("()=>F.ghostCap()"))
    print(errs); b.close()
