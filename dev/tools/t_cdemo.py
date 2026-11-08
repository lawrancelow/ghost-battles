from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':390,'height':900},device_scale_factor=2); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/CombatDemo.html'); pg.wait_for_timeout(300)
    for i,ms in enumerate([700,330,500,1500,700,1000,2400]):
        pg.wait_for_timeout(ms); pg.screenshot(path=f'/tmp/claude-0/cd{i}.png',clip={'x':0,'y':150,'width':390,'height':240})
    print(errs); b.close()
