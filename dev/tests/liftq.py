from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); ctx=b.new_context(viewport={'width':390,'height':844},has_touch=True,is_mobile=True,device_scale_factor=2); pg=ctx.new_page()
    pg.goto('http://127.0.0.1:8765/tiles.html'); pg.wait_for_timeout(5000)
    pg.evaluate("()=>{S.seen.ch1_end=true;S.seen.policy_v1=1;S.seen.policy_tower=1;save();var t=document.getElementById('title'); if(t){t.classList.remove('on');t.style.display='none'}; Tower.open(); setInterval(function(){ ['st-street','pol-tip'].forEach(function(i){ var e=document.getElementById(i); if(e) e.style.display='none'; }); },100);}"); pg.wait_for_timeout(3000)
    pg.evaluate("()=>{TW.press('lv_flat')}"); pg.wait_for_timeout(2500)
    pg.evaluate("()=>{TW.zoom(0.5)}"); pg.wait_for_timeout(1200)
    pg.evaluate("()=>{ var n=TW.G.nodes['f6_l']; TW8.camTo(n.x,n.y+150); }"); pg.wait_for_timeout(1500)
    pg.screenshot(path='/tmp/claude-0/out/liftfix.png')
    b.close()
