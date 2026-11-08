from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':420,'height':1300}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/GuardDemo.html'); pg.wait_for_timeout(1500)
    pg.query_selector_all('canvas')[-1].screenshot(path='/tmp/claude-0/gd.png'); print(errs); b.close()
