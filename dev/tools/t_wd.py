from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':420,'height':900}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/WorkDailyDemo.html'); pg.wait_for_timeout(2500)
    pg.screenshot(path='/tmp/claude-0/wd1.png',full_page=False); print(errs); b.close()
