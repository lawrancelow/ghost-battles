from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':420,'height':1000},device_scale_factor=2); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/ChopDemo.html'); pg.wait_for_timeout(1500)
    pg.locator('#strip').screenshot(path='/tmp/claude-0/chop_strip.png')
    pg.evaluate("SLOW=0.0001"); 
    for i,tt in enumerate([0.75,0.88,0.93,1.0,1.12]):
        pg.evaluate(f"T={tt};trail.length=0"); pg.wait_for_timeout(80); pg.locator('#stage').screenshot(path=f'/tmp/claude-0/ch{i}.png')
    print(errs); b.close()
