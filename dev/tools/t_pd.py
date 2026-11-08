from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    b=p.chromium.launch(); pg=b.new_page(viewport={'width':420,'height':900}); errs=[]
    pg.on('pageerror',lambda e:errs.append(str(e)))
    pg.goto('file:///tmp/claude-0/demo/PlazaDailyDemo.html'); pg.wait_for_timeout(3000)
    btn=pg.query_selector('button:has-text("全場")')
    if btn: btn.click(); pg.wait_for_timeout(4000)
    cs=pg.query_selector_all('canvas'); cs[0].screenshot(path='/tmp/claude-0/pd.png'); print(errs,len(cs)); b.close()
