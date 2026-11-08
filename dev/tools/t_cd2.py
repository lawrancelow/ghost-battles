from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':390,'height':900},device_scale_factor=2); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/CombatDemo.html'); pg.wait_for_timeout(200)
    pg.evaluate("SLOW=0.25;T0=performance.now()/1000")
    for i,tt in enumerate([0.6,0.86,0.97,1.05,1.15,1.4]):
        pg.evaluate(f"T0=performance.now()/1000-{tt}/SLOW"); pg.wait_for_timeout(30)
        pg.locator('#stage').screenshot(path=f'/tmp/claude-0/f{i}.png')
    print(errs); b.close()
