from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':390,'height':1500},device_scale_factor=2); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/MeshDemo.html'); pg.wait_for_timeout(1200)
    for a in ['idle','attack','scared']:
        pg.evaluate(f"act='{a}';sync()"); pg.wait_for_timeout(500 if a!='attack' else 680)
        pg.screenshot(path=f'/tmp/claude-0/demo_{a}.png')
    print(errs); b.close()
