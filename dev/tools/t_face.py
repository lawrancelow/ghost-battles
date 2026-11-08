from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':900,'height':520})
    pg.goto('file:///home/claude/gb/GhostBattles.html?local'); pg.wait_for_timeout(2500)
    pg.evaluate("""()=>{const c=document.createElement('canvas');c.width=900;c.height=520;c.style.cssText='position:fixed;left:0;top:0;z-index:99999;background:#5d5560';document.body.appendChild(c);const x=c.getContext('2d');x.fillStyle='#fff';x.font='13px sans-serif';
    const pairs=[['afu','laojiang'],['eguiking','xiaogui'],['shuigui','zombie']];
    pairs.forEach(([a,b],r)=>{[['windup',1],['strike',1],['follow',1]].forEach(([ps,pt],i)=>{const cx=70+i*300,cy=150+r*170;
      ART.drawChar(x,a,cx,cy,2.0,{t:0.5,pose:ps,pt,flip:false});ART.drawChar(x,b,cx+150,cy,2.0,{t:0.5,pose:'idle',flip:true});x.fillText(a+' '+ps+' → '+b,cx-50,cy+16);});});}""")
    pg.screenshot(path='/tmp/claude-0/face2.png'); b.close()
