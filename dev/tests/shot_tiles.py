import sys, json
from playwright.sync_api import sync_playwright
page=sys.argv[1]; tag=sys.argv[2]
out='/tmp/claude-0/out/'
with sync_playwright() as p:
    b=p.chromium.launch(); 
    def run(lv, vw, vh, shots):
        ctx=b.new_context(viewport={'width':vw,'height':vh},has_touch=True,is_mobile=True,device_scale_factor=2); pg=ctx.new_page()
        errs=[]; pg.on('pageerror',lambda e:errs.append(str(e)[:300])); pg.on('console',lambda m: errs.append('console:'+m.text[:300]) if m.type in ('error','log') and ('LIFT' in m.text or m.type=='error') else None)
        pg.goto('http://127.0.0.1:8765/'+page); pg.wait_for_timeout(5000)
        pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Tower.open(); setInterval(function(){ ['st-street','pol-tip'].forEach(function(i){ var e=document.getElementById(i); if(e) e.style.display='none'; }); },100);}"); pg.wait_for_timeout(3000)
        pg.evaluate("(lv)=>{TW.press('lv_'+lv)}",lv); pg.wait_for_timeout(2500)
        pg.evaluate("()=>{ var G=TW.G; G.units.forEach(function(u){u.seen=true;}); }")
        for nm,js,wait in shots:
            pg.evaluate("()=>{"+js+"}"); pg.wait_for_timeout(wait)
            pg.screenshot(path=out+'tiles_%s_%s_%s.png'%(tag,lv,nm))
        if tag!='base':
            d=pg.evaluate("()=>window.TW8?TW8.bakeURL():null")
            if d:
                import base64; open(out+'tiles_%s_%s_full.png'%(tag,lv),'wb').write(base64.b64decode(d.split(',')[1]))
        print(lv,'errs',errs); ctx.close()
    for lv in sys.argv[3].split(','):
        shots=json.loads(open(sys.argv[4]).read())[lv] if len(sys.argv)>4 else [('def','',800),('z05','TW.zoom(0.5)',1500)]
        vw,vh=(390,844)
        if len(sys.argv)>5: vw,vh=map(int,sys.argv[5].split('x'))
        run(lv,vw,vh,shots)
    b.close()
